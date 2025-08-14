import random
from fastapi import APIRouter
from app.models import GreetResponse, PunResponse, FactResponse
from app.config import GREETING_MESSAGE
from app.data.punFacts import PUNS, FACTS


router = APIRouter(tags=["public"])


@router.get("/", response_model=GreetResponse)
def greet():
    return GreetResponse(message=GREETING_MESSAGE)


@router.get("/pun", response_model=PunResponse)
def pun():
    idx = random.randrange(len(PUNS))
    return PunResponse(index=idx, pun=PUNS[idx])


@router.get("/fact", response_model=FactResponse)
def fact():
    idx = random.randrange(len(FACTS))
    return FactResponse(index=idx, fact=FACTS[idx])