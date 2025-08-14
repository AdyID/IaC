from fastapi import FastAPI
from app.routes import status, content

app = FastAPI(title="Phase Science Facts & Puns")

app.include_router(status.router)
app.include_router(content.router)