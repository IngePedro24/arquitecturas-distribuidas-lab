FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Dependencias
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copia el código
COPY . .

# Variables útiles (ajusta el módulo a tu proyecto: donde está settings.py)
ENV DJANGO_SETTINGS_MODULE=gestion_emprendedores.settings
ENV PORT=8000

# Colecta estáticos (si usa collectstatic, ignora errores si no hay configuración)
RUN python manage.py collectstatic --noinput || true

EXPOSE 8000

# Healthcheck a /health (lo añadiremos en urls.py)
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD python - <<'PY' || exit 1
import urllib.request, sys
try:
    urllib.request.urlopen('http://localhost:8000/health', timeout=3)
except Exception:
    sys.exit(1)
PY

# Arranque con gunicorn (ajusta el módulo WSGI a tu proyecto)
CMD ["gunicorn","-b","0.0.0.0:8000","gestion_emprendedores.wsgi:application"]

