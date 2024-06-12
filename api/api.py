import datetime
from functools import lru_cache

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

from bd import cur
import graph

app = FastAPI()
origins = ['176.109.105.12:3123', "*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

cache_graph = {'last_update': datetime.datetime.now(),
               'station_name': None,
               'graph': None}

@lru_cache(maxsize=24)
@app.get("/get_path")
async def get_path(start_id: int, end_id: int):
    global cache_graph
    
    if cache_graph.get('data') is None or (datetime.datetime.now() - cache_graph.get('last_update')).total_seconds() > 60*15:
        cur.execute('SELECT * FROM "transfer_times"')
        transfer = cur.fetchall()

        cur.execute('SELECT * FROM "travel_times"')
        stations = cur.fetchall()
    
        full_graph = await graph.get_graph_from_bd(transfer, stations)
        
        cur.execute('SELECT * FROM "stations"')
        station_name = cur.fetchall()
        station_name = dict((k, v) for k,v in station_name)
        
        cache_graph = {'last_update': datetime.datetime.now(),
                       'station_name': station_name,
                       'graph': full_graph}
    else:
        full_graph = cache_graph.get('graph')
        station_name = cache_graph.get('station_name')
        
    path, path_time = await graph.find_path(full_graph, start_id, end_id)
    
    return {'message': 'Done!',
            'path': ' -> '.join(f'{p}' for p in path),
            'path_name': ' -> '.join(f'{station_name.get(p)}' for p in path),
            'path_time': path_time.__str__(),
            'timestamp': datetime.datetime.now().__str__()}

@app.get("/")
async def root():
    return {'message': 'Running!',
            'timestamp': datetime.datetime.now().__str__()}

if __name__ == '__main__':
    uvicorn.run(app, host='0.0.0.0', port=3123)