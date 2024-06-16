import datetime
import json
from functools import lru_cache
from subprocess import Popen
from pprint import pprint
import copy

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.httpsredirect import HTTPSRedirectMiddleware

import uvicorn

from bd import cur, conn
from api_post_data import Passenger, Order
import graph

app = FastAPI()
origins = ['http://176.109.105.12:3123',
           'https://176.109.105.12:3123',
           "http://localhost",
            "http://localhost:8080",
            "*"
            ]

# origins = ["*"]
# app.add_middleware(HTTPSRedirectMiddleware)
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

cache_graph = {'last_update': datetime.datetime.now(),
               'station_name': None,
               'station_line': None,
               'graph': None}

passenger_types = []

def union_date_time(ddate: datetime.datetime, dtime: list[datetime.time]):
    res = ddate
    for d in dtime:
        res = res + (datetime.datetime.combine(datetime.date.min, d) - datetime.datetime.min)
    return res

def union_date_time_sub(ddate: datetime.datetime, dtime: list[datetime.time]):
    res = ddate
    for d in dtime:
        res = res - (datetime.datetime.combine(datetime.date.min, d) - datetime.datetime.min)
    return res

async def test():
    global cache_graph
    
    if cache_graph.get('data') is None or (datetime.datetime.now() - cache_graph.get('last_update')).total_seconds() > 60*15:
        cur.execute('SELECT * FROM "transfer_times"')
        transfer = cur.fetchall()
        conn.commit()

        cur.execute('SELECT * FROM "travel_times"')
        stations = cur.fetchall()
        conn.commit()
    
        full_graph = await graph.get_graph_from_bd(transfer, stations)
        
        cur.execute('SELECT * FROM "stations"')
        station_name = cur.fetchall()
        conn.commit()
        station_name = dict((k, v) for k,v in station_name)
        
        cur.execute('SELECT * FROM "station_with_line"')
        station_line = cur.fetchall()
        conn.commit()
        station_line = dict((v[0], v[2]) for v in station_line)
        
        cache_graph = {'last_update': datetime.datetime.now(),
                       'station_name': station_name,
                    #    'station_line': station_line,
                       'graph': full_graph}
    else:
        full_graph = cache_graph.get('graph')
        station_name = cache_graph.get('station_name')
    
    time_to_lunch = datetime.time(minute=45)
    time_to_start_lunch = datetime.time(hour=3)
    time_to_end_lunch = datetime.time(hour=2)
    
    cur.execute('SELECT * FROM "bids"')
    temp = cur.fetchall()
    conn.commit()
    
    bids = dict((t[0], {'type': t[3], 'start_station': t[7], 'end_station': t[9], 
                        'time_start': t[11], 'end_time': union_date_time(t[11], [t[18]]), 'count': t[15:18], 
                        'evaluate_time': t[18], 'time_create': t[20]}) for t in temp if (t[11] < datetime.datetime.strptime('2024-04-25', '%Y-%m-%d')))
    # pprint(bids)
    queue_bids = list([k, v['time_create']] for k, v in bids.items())
    queue_bids.sort(key=lambda x: x[1])
    
    cur.execute('SELECT * FROM "working_day_employees"')
    temp = cur.fetchall()
    conn.commit()
    
    employee = dict((t[1], {'start_time': t[3], 'end_time': t[4], 'sex': int(t[2]), 
                            'isLunch': None, 'lunch_start': None, 'lunch_end': None,
                            'bids_in_run': []}) for t in temp)
    employee_iter2 = copy.deepcopy(employee)
    # pprint(employee)
    
    result_uter1 = []
    
    for qb in queue_bids:
        # Составляем очередь из всех сотрудников
        queue = []
        for k, v in employee.items(): 
            if (v['start_time'] < bids[qb[0]]['time_start']) and \
                (v['end_time'] > bids[qb[0]]['end_time']):
                    for rb in v['bids_in_run']:
                        time_to_lstart_station = await graph.get_path_time(cache_graph.get('graph'), bids[rb]['end_station'], bids[qb[0]]['start_station'])
                        time_to_rstart_station = await graph.get_path_time(cache_graph.get('graph'), bids[qb[0]]['end_station'], bids[rb]['start_station'])
                        
                        if (bids[qb[0]]['time_start'] <= union_date_time(bids[rb]['end_time'], [time_to_lstart_station])) or \
                            (union_date_time(bids[qb[0]]['end_time'], [time_to_rstart_station]) >= bids[rb]['time_start']) :
                                break
                    else:
                        if employee[k]['isLunch'] is None:
                            queue.append(k)
                        else:
                            if (bids[qb[0]]['time_start'] > v['lunch_end']) or (bids[qb[0]]['end_time'] < v['lunch_start']):
                                queue.append(k)
        
        # Проверяем на обед
        onbit = []
        count_all, count_male, count_female = bids[qb[0]]['count']
        count_all -= (count_female + count_male)
        while (count_all or count_male or count_female) and len(queue):
            item = queue.pop(0)
            sex = employee[item]['sex']
            if count_male and sex == 1:
                onbit.append(item)
                count_male -= 1
                continue
            
            if count_female and sex == 0:
                onbit.append(item)
                count_female -= 1
                continue
            
            if count_all:
                onbit.append(item)
                count_all -= 1
                
        if (count_male, count_female, count_all) == (0, 0, 0):
            result_uter1.append(qb[0])
            for item in onbit:
                employee[item]['bids_in_run'].append(qb[0])
                
                # Пробуем поставить обед
                # Проверяем после текущей заявки
                if employee[item]['isLunch'] is None:
                    if bids[qb[0]]['end_time'] > union_date_time(employee[item]['start_time'], [time_to_start_lunch]) and \
                        bids[qb[0]]['end_time'] < union_date_time_sub(employee[item]['end_time'], [time_to_end_lunch]):
                            
                            ttime = list((rb, ttime) for rb in employee[item]['bids_in_run'] if (ttime := (bids[rb]['time_start'] - bids[qb[0]]['end_time'])).total_seconds() > 0)
                            if not len(ttime):
                                employee[item]['isLunch'] = True
                                employee[item]['lunch_start'] = bids[qb[0]]['end_time']
                                employee[item]['lunch_end'] = union_date_time(bids[qb[0]]['end_time'], [time_to_lunch])
                            else:
                                next_id_bid = min(ttime, key=lambda x: x[1])
                                time_to_station = await graph.get_path_time(cache_graph.get('graph'), bids[qb[0]]['end_station'], bids[next_id_bid[0]]['start_station'])
                                
                                if union_date_time(bids[qb[0]]['end_time'], [time_to_station, time_to_lunch]) < bids[next_id_bid[0]]['time_start']:
                                    employee[item]['isLunch'] = True
                                    employee[item]['lunch_start'] = bids[qb[0]]['end_time']
                                    employee[item]['lunch_end'] = union_date_time(bids[qb[0]]['end_time'], [time_to_lunch])
                                    
                # Проверяем до текущей заявки
                if employee[item]['isLunch'] is None:
                    if bids[qb[0]]['time_start'] > union_date_time(employee[item]['start_time'], [time_to_start_lunch, time_to_lunch]) and \
                        bids[qb[0]]['time_start'] < union_date_time_sub(employee[item]['end_time'], [time_to_end_lunch]):
                        ttime = list((rb, ttime) for rb in employee[item]['bids_in_run'] if (ttime := (bids[rb]['time_start'] - bids[qb[0]]['end_time'])).total_seconds() < 0)
                        
                        if not len(ttime):
                            employee[item]['isLunch'] = True
                            employee[item]['lunch_start'] = union_date_time_sub(bids[qb[0]]['time_start'], [time_to_lunch])
                            employee[item]['lunch_end'] = bids[qb[0]]['time_start']
                        else:
                            next_id_bid = max(ttime, key=lambda x: x[1])
                            time_to_station = await graph.get_path_time(cache_graph.get('graph'), bids[next_id_bid[0]]['end_station'], bids[qb[0]]['start_station'])
                            
                            if union_date_time_sub(bids[qb[0]]['time_start'], [time_to_station, time_to_lunch]) > bids[next_id_bid[0]]['end_time']:
                                employee[item]['isLunch'] = True
                                employee[item]['lunch_start'] = bids[next_id_bid[0]]['end_time']
                                employee[item]['lunch_end'] = union_date_time(bids[next_id_bid[0]]['end_time'], [time_to_lunch])
                                
    # Оптимизация распределения сотрудников
    bid_not_closed = set()
    queue_bids = copy.deepcopy(result_uter1)
    temp = copy.deepcopy(queue_bids)
    temp.sort(key = lambda x: bids[x]['time_start'])
    bids_info = dict((i, {'empls': []}) for i in temp)
    
    for i, empl in enumerate(employee_iter2.keys()):
        employee_iter2[empl]['work_end'] = None
        employee_iter2[empl]['last_station'] = None
        
        for qb in temp:
            if employee_iter2[empl]['work_end'] is None:
                if bids[qb]['time_start'] >= employee_iter2[empl]['start_time']:
                    if employee_iter2[empl]['sex']:
                        if bids[qb]['count'][1] - 1 > 0:
                            bids_info[qb]['count'] = (bids[qb]['count'][0] - 1, bids[qb]['count'][1] - 1, bids[qb]['count'][2])
                            bids_info[qb]['empls'].append(empl)
                            employee_iter2[empl]['work_end'] = bids[qb]['end_time']
                            employee_iter2[empl]['last_station'] = bids[qb]['end_station']
                            if bids_info[qb]['count'] == (0, 0, 0):
                                bid_not_closed.remove(qb)
                        elif bids[qb]['count'][0] - bids[qb]['count'][2] - 1:
                            bids_info[qb]['count'] = (bids[qb]['count'][0] - 1, bids[qb]['count'][1], bids[qb]['count'][2])
                            bids_info[qb]['empls'].append(empl)
                            employee_iter2[empl]['work_end'] = bids[qb]['end_time']
                            employee_iter2[empl]['last_station'] = bids[qb]['end_station']
                            if bids_info[qb]['count'] == (0, 0, 0):
                                bid_not_closed.remove(qb)
                            
                    else:
                        if bids[qb]['count'][2] - 1 > 0:
                            bids_info[qb]['count'] = (bids[qb]['count'][0] - 1, bids[qb]['count'][1], bids[qb]['count'][2] - 1)
                            bids_info[qb]['empls'].append(empl)
                            employee_iter2[empl]['work_end'] = bids[qb]['end_time']
                            employee_iter2[empl]['last_station'] = bids[qb]['end_station']
                            if bids_info[qb]['count'] == (0, 0, 0):
                                bid_not_closed.remove(qb)
                        elif bids[qb]['count'][0] - bids[qb]['count'][1] - 1:
                            bids_info[qb]['count'] = (bids[qb]['count'][0] - 1, bids[qb]['count'][1], bids[qb]['count'][2])
                            bids_info[qb]['empls'].append(empl)
                            employee_iter2[empl]['work_end'] = bids[qb]['end_time']
                            employee_iter2[empl]['last_station'] = bids[qb]['end_station']
                            if bids_info[qb]['count'] == (0, 0, 0):
                                bid_not_closed.remove(qb)
                    
                    if employee_iter2[empl]['work_end'] is not None:
                        if employee_iter2[empl]['work_end'] > union_date_time(employee_iter2[empl]['start_time'], [time_to_start_lunch]):
                            employee_iter2[empl]['isLunch'] = True
                            employee_iter2[empl]['lunch_start'] = bids[qb]['end_time']
                            employee_iter2[empl]['lunch_end'] = union_date_time(employee_iter2[empl]['work_end'], [time_to_lunch])
                            employee_iter2[empl]['work_end'] = employee_iter2[empl]['lunch_end']
            else:
                flag = False
                if employee_iter2[empl]['work_end'] < bids[qb]['time_start']:
                    time_to_station = await graph.get_path_time(cache_graph.get('graph'), employee_iter2[empl]['last_station'], bids[qb]['start_station'])
                    
                    if bids[qb]['time_start'] > union_date_time(employee_iter2[empl]['work_end'], [time_to_station]) and \
                    bids[qb]['end_time'] < employee_iter2[empl]['end_time']:
                        if employee_iter2[empl]['sex']:
                            if bids[qb]['count'][1] - 1 > 0:
                                bids_info[qb]['count'] = (bids[qb]['count'][0] - 1, bids[qb]['count'][1] - 1, bids[qb]['count'][2])
                                bids_info[qb]['empls'].append(empl)
                                employee_iter2[empl]['work_end'] = bids[qb]['end_time']
                                employee_iter2[empl]['last_station'] = bids[qb]['end_station']
                                flag = True
                                if bids_info[qb]['count'] == (0, 0, 0):
                                    bid_not_closed.remove(qb)
                                    
                            elif bids[qb]['count'][0] - bids[qb]['count'][2] - 1:
                                bids_info[qb]['count'] = (bids[qb]['count'][0] - 1, bids[qb]['count'][1], bids[qb]['count'][2])
                                bids_info[qb]['empls'].append(empl)
                                employee_iter2[empl]['work_end'] = bids[qb]['end_time']
                                employee_iter2[empl]['last_station'] = bids[qb]['end_station']
                                flag = True
                                if bids_info[qb]['count'] == (0, 0, 0):
                                    bid_not_closed.remove(qb)
                                
                        else:
                            if bids[qb]['count'][2] - 1 > 0:
                                bids_info[qb]['count'] = (bids[qb]['count'][0] - 1, bids[qb]['count'][1], bids[qb]['count'][2] - 1)
                                bids_info[qb]['empls'].append(empl)
                                employee_iter2[empl]['work_end'] = bids[qb]['end_time']
                                employee_iter2[empl]['last_station'] = bids[qb]['end_station']
                                flag = True
                                if bids_info[qb]['count'] == (0, 0, 0):
                                    bid_not_closed.remove(qb)
                                    
                            elif bids[qb]['count'][0] - bids[qb]['count'][1] - 1:
                                bids_info[qb]['count'] = (bids[qb]['count'][0] - 1, bids[qb]['count'][1], bids[qb]['count'][2])
                                bids_info[qb]['empls'].append(empl)
                                employee_iter2[empl]['work_end'] = bids[qb]['end_time']
                                employee_iter2[empl]['last_station'] = bids[qb]['end_station']
                                flag = True
                                if bids_info[qb]['count'] == (0, 0, 0):
                                    bid_not_closed.remove(qb)
                
                if not employee_iter2[empl]['isLunch'] and flag:
                    if employee_iter2[empl]['work_end'] > union_date_time(employee_iter2[empl]['start_time'], [time_to_start_lunch]):
                        employee_iter2[empl]['isLunch'] = True
                        employee_iter2[empl]['lunch_start'] = bids[qb]['end_time']
                        employee_iter2[empl]['lunch_end'] = union_date_time(employee_iter2[empl]['work_end'], [time_to_lunch])
                        employee_iter2[empl]['work_end'] = employee_iter2[empl]['lunch_end']
    
    return result_uter1, employee, bids_info, bid_not_closed

# @lru_cache(maxsize=1)
@app.get("/api/orders_autocomplete")
async def orders_autocomplete():
    
    res1, employee, bids, not_bids = await test()
    
    import pickle
    with open('test.pickle', 'wb') as handler:
        pickle.dump([res1, employee, bids, not_bids], handler)
    
    # with open('test.pickle', 'rb') as handler:
    #     res, employee, bids, not_bids = pickle.load(handler)
    
    return {'message': 'Done!',
            'result_iter1': res1,
            'result_iter2': bids,
            'not_bids': list(not_bids),
            'timestamp': datetime.datetime.now().__str__()}


@app.post("/api/change_order_by_id")
async def change_order_by_id(body: Order):
    data = dict(body)
    
    date = datetime.datetime.strptime(f'{data["date"]} {data["hour"]}:{data["minute"]}', '%Y-%m-%d %H:%M')
    eval_time = datetime.time(hour=data['evaluate_time']//60, minute=data['evaluate_time']%60)
    
    if data['id']:
        cur.callproc('public.edit_bid', (1, data['id'], data['status'],
                                                data['count_passenger'], data['type'], date,
                                                data['station_start'], data['station_end'], eval_time,
                                                data['count_all'], data['get_order_type'], data['help'],
                                                [], str(data['luggage_type']), str(data['luggage_weight']),
                                                str(data['place_meeting']), str(data['place_destination']), data['count_male'],
                                                data['count_female']
                                                )
                     )
    else:
        cur.callproc('public.add_bid', (1, data['status'], data['passenger_id'],
                                                data['count_passenger'], data['type'], date,
                                                data['station_start'], data['station_end'], eval_time,
                                                data['count_all'], data['get_order_type'], data['help'],
                                                [], str(data['luggage_type']), str(data['luggage_weight']),
                                                str(data['place_meeting']), str(data['place_destination']), data['count_male'],
                                                data['count_female']
                                                )
                    )
    conn.commit()
        
    return {'message': 'Done!',
            'timestamp': datetime.datetime.now().__str__()}

# @lru_cache(maxsize=1)
@app.post("/api/change_passenge_by_id")
async def change_passenge_by_id(body: Passenger):
    data = dict(body)
    
    if data['id']:
        cur.callproc('public.edit_passengers', (1, data['id'], data['firstName'],
                                                data['lastName'], data['sex'], data['type'],
                                                data['ecs'], data['secondName'], str(data['phone']),
                                                data['info']))
    else:
        cur.callproc('public.create_passengers', (1, data['firstName'],
                                                data['lastName'], data['sex'], data['type'],
                                                data['ecs'], data['secondName'], str(data['phone']),
                                                data['info']))
    
    conn.commit()
        
    return {'message': 'Done!',
            'timestamp': datetime.datetime.now().__str__()}
    
# @lru_cache(maxsize=1)
@app.get("/api/get_order_by_id")
async def get_order_by_id(id: int):
    cur.execute(f'SELECT * FROM "form_view_bid" WHERE number = {id}')
    temp = cur.fetchall()
    conn.commit()
    
    order_data = [*temp[0]]
    return {'message': 'Done!',
            'order_data': order_data,
            'timestamp': datetime.datetime.now().__str__()}
    
# @lru_cache(maxsize=1)
@app.get("/api/get_orders_for_table")
async def get_orders_for_table():
    cur.execute('SELECT * FROM "form_main_bid"')
    temp = cur.fetchall()
    conn.commit()
    
    colors = {'не подтверждена': 'text-bg-secondary',
              'в рассмотрении': 'text-bg-secondary',
              'принята': 'text-bg-primary',
              'инспектор выехал': 'text-bg-info2',
              'инспектор на месте': 'text-bg-info2',
              'поездка': 'text-bg-info2',
              'заявка закончена': 'text-bg-success',
              'выявление': 'text-bg-primary',
              'лист ожидания': 'text-bg-warning',
              'отмена': 'text-bg-secondary',
              'отказ': 'text-bg-secondary',
              'пассажир опаздывает': 'text-bg-danger',
              'инспектор опаздывает': 'text-bg-danger',
              }
    
    orders = list([t[0], t[1].strftime('%d.%m.%y <b>%H:%M</b>'), *t[2:], colors.get(t[-1].lower(), 'text-bg-secondary')] for t in temp)
    orders.sort(key = lambda x: (x[1]))
    
    temp[0][1].strftime('%d.%m.%y <b>%H:%M</b>')
    
    return {'message': 'Done!',
            'orders': orders,
            'timestamp': datetime.datetime.now().__str__()}
    

# @lru_cache(maxsize=1)
@app.get("/api/get_passenger_for_table")
async def get_passenger_for_table():
    cur.execute('SELECT * FROM "form_main_passenger"')
    temp = cur.fetchall()
    conn.commit()
    
    passenger = list([*t[:4], '' if t[4] is None else t[4], *t[5:7], 'Есть' if '1' == t[7] else 'Нет', '' if t[8] is None else t[8]] for t in temp)
    passenger.sort(key = lambda x: (x[1], x[2], x[3]))
    
    return {'message': 'Done!',
            'passenger': passenger,
            'timestamp': datetime.datetime.now().__str__()}

# @lru_cache(maxsize=1)
@app.get("/api/get_employee_info")
async def get_employee_info():
    cur.execute('SELECT * FROM "form_select_employee_in_bid"')
    temp = cur.fetchall()
    conn.commit()
    
    employee = list([t[0], f'{t[1]} {t[2][0]}.{t[3][0]}. ({t[4]}, {t[5]})'] for t in temp)
    employee.sort(key = lambda x: x[1])
    
    return {'message': 'Done!',
            'employee': employee,
            'timestamp': datetime.datetime.now().__str__()}

# @lru_cache(maxsize=1)
@app.get("/api/get_stations")
async def get_stations():
    cur.execute('SELECT * FROM "station_with_line"')
    temp = cur.fetchall()
    conn.commit()
    
    stations = list([t[0], f'{t[1]} ({t[2]})'] for t in temp)
    stations.sort(key = lambda x: x[1])
    
    return {'message': 'Done!',
            'stations': stations,
            'timestamp': datetime.datetime.now().__str__()}

# @lru_cache(maxsize=1)
@app.get("/api/get_order_status")
async def get_order_status():
    cur.execute('SELECT * FROM "statuses"')
    temp = cur.fetchall()
    conn.commit()
    
    order_status = list([t[0], t[1]] for t in temp)
    
    return {'message': 'Done!',
            'order_status': order_status,
            'timestamp': datetime.datetime.now().__str__()}

# @lru_cache(maxsize=1)
@app.get("/api/get_passenger_types")
async def get_passenger_types():
    global passenger_types
    
    cur.execute('SELECT * FROM "categories"')
    temp = cur.fetchall()
    conn.commit()
    
    # cur.execute("SELECT public.create_role('TEST2', 1)")
    # cur.callproc('public.create_role', ('TEST3', 1))
    # conn.commit()
    
    passenger_types = list([t[0], t[1]] for t in temp)
    
    return {'message': 'Done!',
            'passenger_types': passenger_types,
            'timestamp': datetime.datetime.now().__str__()}
    

@lru_cache(maxsize=24)
@app.get("/api/get_path")
async def get_path(start_id: int, end_id: int):
    global cache_graph
    
    if cache_graph.get('data') is None or (datetime.datetime.now() - cache_graph.get('last_update')).total_seconds() > 60*15:
        cur.execute('SELECT * FROM "transfer_times"')
        transfer = cur.fetchall()
        conn.commit()

        cur.execute('SELECT * FROM "travel_times"')
        stations = cur.fetchall()
        conn.commit()
    
        full_graph = await graph.get_graph_from_bd(transfer, stations)
        
        cur.execute('SELECT * FROM "stations"')
        station_name = cur.fetchall()
        conn.commit()
        station_name = dict((k, v) for k,v in station_name)
        
        cur.execute('SELECT * FROM "station_with_line"')
        station_line = cur.fetchall()
        conn.commit()
        station_line = dict((v[0], v[2]) for v in station_line)
        
        cache_graph = {'last_update': datetime.datetime.now(),
                       'station_name': station_name,
                    #    'station_line': station_line,
                       'graph': full_graph}
    else:
        full_graph = cache_graph.get('graph')
        station_name = cache_graph.get('station_name')
        
    path, path_time = await graph.find_path(full_graph, start_id, end_id)
    conn.commit()
    
    transfer = []
    l_prev = station_line.get(path[0])
    for p in path[1:]:
        if station_line.get(p) != l_prev:
            transfer.append([p, f'{station_name.get(p)} ({station_line.get(p)})'])
            l_prev = station_line.get(p)
    
    return {'message': 'Done!',
            'path': ' -> '.join(f'{p}' for p in path),
            'path_name': ' -> '.join(f'{station_name.get(p)} ({station_line.get(p)})' for p in path),
            # 'path_name': ' -> '.join(f'{station_name.get(p)}' for p in path),
            'path_time': path_time.hour * 60 + path_time.minute,
            'time': path_time.__str__(),
            'transfer_station': transfer,
            'timestamp': datetime.datetime.now().__str__()}

@app.get("/api/")
async def root():
    return {'message': 'Running!',
            'timestamp': datetime.datetime.now().__str__()}

if __name__ == '__main__':
    Popen(['python3', '-m', 'https_redirect'])
    uvicorn.run(app, host='0.0.0.0',
                port=3123,
                # ssl_keyfile='/etc/ssl/private/и-так-сойдет.рф.key',
                # ssl_certfile='/etc/ssl/certs/и-так-сойдет.рф.crt'
                )