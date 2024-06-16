from typing import Union
from pydantic import BaseModel

class Passenger(BaseModel):
    id: int = None
    firstName: str
    lastName: str
    secondName: str
    sex: int
    phone: str
    type: int
    ecs: int
    info: str = None
    
class Order(BaseModel):
    id: Union[int, str, None] = None
    status: int
    passenger_id: int
    count_passenger: int
    type: int
    luggage_type: str
    luggage_weight: str
    help: int
    info: str
    date: str
    hour: int
    minute: int
    station_start: int
    station_end: int
    place_meeting: str
    place_destination: str
    evaluate_time: int
    count_all: int
    count_male: int
    count_female: int
    get_order_type: int