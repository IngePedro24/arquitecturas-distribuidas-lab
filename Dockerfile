FROM python:3.12-slim

# Evitar bytecode y hacer stdout sin buffer
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Instalar dependencias
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el proyecto
COPY . .

# Variables de entorno útiles
ENV DJANGO_SETTINGS_MODULE=gestion_emprendedores.settings

# (Opcional) colecta estáticos; ignora si falla en laboratorio
RUN python manage.py collectstatic --noinput || true

# Exponer puerto de Django
EXPOSE 8000

# Ejecutar con gunicorn
CMD ["gunicorn","-b","0.0.0.0:8000","gestion_emprendedores.wsgi:application"]
