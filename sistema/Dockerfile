# Usamos Python basado en Debian Bookworm (estable y compatible)
FROM python:3.12-bookworm

# Variables de entorno para optimizar Python en Docker
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Establecemos el directorio de trabajo dentro del contenedor
WORKDIR /app

# Instalamos Node.js y npm (Estrictamente necesario para compilar Tailwind CSS)
RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copiamos SOLO los archivos de dependencias primero. 
# Esto es un truco para que Docker use su caché y no reinstale todo 
# si solo cambiaste una línea de código en main.py.
COPY sistema/requirements.txt .
COPY sistema/package.json .

# Instalamos las librerías de Python
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Instalamos Tailwind CSS y dependencias de Node
RUN npm install

# Copiamos el resto del código de tu carpeta "sistema" al contenedor
COPY sistema/ .

# Exponemos el puerto de FastAPI
EXPOSE 8000

# NOTA: No ponemos el comando "CMD" aquí porque ya lo estás pasando 
# desde el docker-compose.yml con "command: uvicorn main:app ..."