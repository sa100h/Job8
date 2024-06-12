import datetime
import traceback
import asyncio
from pprint import pprint

from bd import cur


async def get_graph_from_bd(transfer: list[tuple], stations: list[tuple]) -> dict[dict[int, datetime.time]]:
    full_graph = {}
    for tt in transfer:
        if tt[0] in full_graph:
            full_graph[tt[0]].update({tt[1]: tt[-1]})
        else:
            full_graph[tt[0]] = {tt[1]: tt[-1]}
        if tt[1] in full_graph:
            full_graph[tt[1]].update({tt[0]: tt[-1]})
        else:
            full_graph[tt[1]] = {tt[0]: tt[-1]}

    for tt in stations:
        if tt[0] in full_graph:
            full_graph[tt[0]].update({tt[1]: tt[-1]})
        else:
            full_graph[tt[0]] = {tt[1]: tt[-1]}
        if tt[1] in full_graph:
            full_graph[tt[1]].update({tt[0]: tt[-1]})
        else:
            full_graph[tt[1]] = {tt[0]: tt[-1]}
            
    # pprint(full_graph)
    return full_graph


def time_addition(t1: datetime.time, t2: datetime.time):
    h, m, s = t1.hour + t2.hour, t1.minute + t2.minute, t1.second + t2.second
    
    step = s // 60
    s = s % 60
    
    m += step
    step = m // 60
    m = m % 60
    
    h += step
    
    return datetime.time(hour=h, minute=m, second=s)


async def find_path(stations: dict, start_node: int, end_node: int):
    weights = {start_node: datetime.time(0)}
    nodes = set(stations)
    pass_node = set()
    queue_node = [start_node]
    cur_node = start_node
    prev_node = {}
    path = []
    
    try:
        for _ in range(len(nodes)):
            
            for cur_node in queue_node:
                pass_node.add(cur_node)
                for cur in stations.get(cur_node, [0]):
                    if cur in pass_node or not cur:
                        continue
                    weights[cur] = min(weights.get(cur, datetime.time(23)), time_addition(weights.get(cur_node, datetime.time(0)), stations.get(cur_node).get(cur)))
                    prev_node[cur] = cur_node
                    
                # pprint(weights)
            if cur_node == end_node:
                break
            else:        
                temp = [(k,v) for k,v in weights.items() if k not in pass_node]
                temp.sort(key=lambda x: x[1])
                queue_node.extend(list(k for k,v in temp))
        
        pointer = end_node
        while pointer != start_node:
            path.append(pointer)
            pointer = prev_node.get(pointer)
        path.append(pointer)
        
        print(' -> '.join(f'{p}' for p in path[::-1]))
        
    except:
        traceback.print_exc()
        path = []
        weights = {end_node: None}
        
    finally:
        return path[::-1], weights.get(end_node)

if __name__ == '__main__':
    pass