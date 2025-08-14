from pydantic import BaseModel
from typing import Dict, Literal


Status = Literal['ok', 'error']


class HealthSummary(BaseModel):
    status: Status
    checks: Dict[str, Status]
    env: str
    version: str
    uptime_seconds: float

  
class VersionResponse(BaseModel):
    version: str


class GreetResponse(BaseModel):
    message: str


class PunResponse(BaseModel):
    pun: str


class FactResponse(BaseModel):
    fact: str