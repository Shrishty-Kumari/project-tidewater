FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    TMPDIR=/tmp

RUN groupadd --gid 10001 app && \
    useradd --uid 10001 --gid 10001 --create-home app && \
    mkdir -p /tmp && \
    chown 10001:10001 /tmp && \
    chmod 1777 /tmp

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY api ./api
COPY worker ./worker

RUN chown -R 10001:10001 /app

USER 10001:10001

EXPOSE 8000 9100

CMD ["gunicorn","-k","uvicorn.workers.UvicornWorker","-w","4","-b","0.0.0.0:8000","api.main:app"]
