FROM python:3.12-slim
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 TZ=Europe/Kyiv
RUN groupadd --system web && useradd --system --gid web web
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py calculator.py VERSION ./
COPY templates/ templates/
COPY static/ static/
USER web
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/health', timeout=2)"]
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "2", "app:app"]
