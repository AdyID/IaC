import os
import time
import logging
from typing import Dict
from fastapi import APIRouter, Response, status as http_status

from app.config import APP_VERSION, ENV
from app.data.punFacts import PUNS, FACTS
from app.models import HealthSummary, VersionResponse, Status


logger = logging.getLogger(__name__)
router = APIRouter(tags=['status'])
START_TS = time.time()
REQUIRED_ENVS = ['LOG_LEVEL', 'GREETING_MESSAGE', 'APP_VERSION']


def _overall(checks: Dict[str, Status]) -> Status:
    return "ok" if all(v == "ok" for v in checks.values()) else "error"


@router.get('/health', response_model=HealthSummary)
def health():
    checks: Dict[str, Status] = {'process': 'ok'}
    missing = [k for k in REQUIRED_ENVS if not os.getenv(k)]
    checks['env_vars'] = 'ok' if not missing else 'error'

    try:
        checks['content_data'] = 'ok' if (bool(PUNS) and bool(FACTS)) else 'error'
    except Exception as e:
        logger.exception('content_data check failed: %s', e)
        checks['content_data'] = 'error'

    #Can be extended to include database check

    summary = HealthSummary(
        status=_overall(checks),
        checks=checks,
        env=ENV,
        version=APP_VERSION,
        uptime_seconds=time.time() - START_TS,
    )

    if summary.status != 'ok':
        return Response(
            content=summary.model_dump_json(),
            media_type='application/json',
            status_code=http_status.HTTP_503_SERVICE_UNAVAILABLE,
        )
    return summary


@router.get("/version", response_model=VersionResponse)
def version():
    return VersionResponse(version=APP_VERSION)