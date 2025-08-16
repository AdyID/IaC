# FastAPI Application

A containerized FastAPI web service that provides science-themed content including puns and facts about phase transitions and matter states.

## Architecture Summary

### Technology Stack
- **Framework**: FastAPI (Python 3.12)
- **Containerization**: Docker with multi-stage builds
- **Configuration**: Environment-based configuration with dotenv
- **Logging**: Structured logging with configurable levels
- **API Documentation**: Auto-generated OpenAPI/Swagger docs

### Application Structure
```
app/
├── __init__.py          # Package initialization
├── main.py              # FastAPI application entry point
├── config.py            # Configuration management
├── models.py            # Pydantic data models
├── data/
│   ├── __init__.py      # Data package
│   └── punFacts.py      # Static content (puns and facts)
└── routes/
    ├── __init__.py      # Routes package
    ├── status.py        # Health checks and version endpoints
    └── content.py       # Content delivery endpoints
```

### Design Choices

1. **Modular Architecture**: Separate dedicated modules for routes, models, and data
2. **Environment Configuration**: Flexible configuration via environment variables
3. **Health Monitoring**: Health checks with detailed status reporting
4. **Static Content**: Pre-defined science content for consistent responses
5. **Type Safety**: Pydantic models for request/response validation
6. **Structured Logging**: Configurable logging levels for different environments

## Setup Instructions

### Prerequisites
- Python 3.12
- Docker (for containerized deployment)
- pip (Python package manager)

### Local Development Setup

1. **Create Virtual Environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. **Install Dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Environment Configuration**
   Create a `.env` file in the app directory:
   ```bash
   LOG_LEVEL=INFO
   GREETING_MESSAGE=Welcome to Phase Science API!
   APP_VERSION=1.0.0
   ENV=development
   ```

4. **Run Application**
   ```bash
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```

## Build Instructions

### Docker Build
```bash
# From project root directory
docker build -t iac-app:latest .

# With specific tag
docker build -t iac-app:1.0.0 .
```

## Deployment Instructions

### Production Deployment
The application is designed to be deployed via GitHub Actions to AWS ECS:

1. **Development**: Automatic deployment on push to `dev` branch
2. **Production**: Manual deployment with explicit image tag

### Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `LOG_LEVEL` | Yes | INFO | Logging level (DEBUG, INFO, WARNING, ERROR) |
| `GREETING_MESSAGE` | Yes | - | Welcome message for root endpoint |
| `APP_VERSION` | Yes | - | Application version for health checks |
| `ENV` | Yes | development | Environment name (dev, staging, prod) |

## Access Instructions

### API Endpoints

#### Health and Status
- `GET /health` - Comprehensive health check
- `GET /version` - Application version information

#### Content Endpoints
- `GET /` - Welcome message
- `GET /pun` - Random science pun
- `GET /fact` - Random science fact

### API Documentation
- **Swagger UI**: `http://localhost:8000/docs`

### Example Usage
```bash
# Health check
curl http://localhost:8000/health

# Get a science pun
curl http://localhost:8000/pun

# Get a science fact
curl http://localhost:8000/fact

# Welcome message
curl http://localhost:8000/
```

### Health Check Response
```json
{
  "status": "ok",
  "checks": {
    "process": "ok",
    "env_vars": "ok",
    "content_data": "ok"
  },
  "env": "development",
  "version": "1.0.0",
  "uptime_seconds": 123.45
}
```

## Cleanup Instructions

### Local Development
```bash
# Stop the application
Ctrl+C (if running with uvicorn)

# Deactivate virtual environment
deactivate

# Remove virtual environment
rm -rf venv/
```

### Docker Cleanup
```bash
# Stop running containers
docker stop $(docker ps -q --filter ancestor=iac-app)

# Remove containers
docker rm $(docker ps -aq --filter ancestor=iac-app)

# Remove images
docker rmi iac-app:latest

# Clean up unused resources
docker system prune -f
```

## Assumptions and Dependencies

### Application Assumptions
1. **Environment Variables**: All required environment variables must be set
2. **Content Availability**: Static content (puns/facts) is always available
3. **Network Access**: Application expects to be accessible on port 8000
4. **Health Checks**: External health checks will use the `/health` endpoint

### External Dependencies
- **Python Packages** (see requirements.txt):
  - FastAPI: Web framework
  - Uvicorn: ASGI server
  - Pydantic: Data validation
  - python-dotenv: Environment variable loading

### Security Considerations
- **Non-root User**: Container runs as non-root user
- **Environment Variables**: Sensitive data via environment variables
- **Health Checks**: Health monitoring
- **Logging**: Structured logging without sensitive data exposure

## Monitoring and Observability

### Health Checks
- **Process Health**: Application process status
- **Environment Variables**: Required configuration validation
- **Content Data**: Static content availability check
- **Uptime Tracking**: Application uptime monitoring

### Logging
- **Configurable Levels**: DEBUG, INFO, WARNING, ERROR
- **Structured Format**: JSON logging for production
- **CloudWatch Integration**: Centralized log aggregation

### Metrics
- **Response Times**: FastAPI automatic metrics
- **Error Rates**: Health check status tracking
- **Resource Usage**: Container resource monitoring

## Troubleshooting

### Common Issues

1. **Environment Variables Missing**
   ```
   Error: Required environment variables not set
   Solution: Ensure all required env vars are configured
   ```

2. **Port Already in Use**
   ```
   Error: Address already in use
   Solution: Change port or stop conflicting service
   ```

3. **Health Check Failures**
   ```
   Status: 503 Service Unavailable
   Solution: Check logs and environment configuration
   ```

### Debug Mode
```bash
# Enable debug logging
export LOG_LEVEL=DEBUG
uvicorn app.main:app --reload --log-level debug
```

### Log Analysis
```bash
# View application logs
docker logs <container_id>

# Follow logs in real-time
docker logs -f <container_id>
```
