from fastapi import FastAPI, Request, Depends
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session
from pydantic import BaseModel
from controllers import categorias_controller  # <-- NUEVO: Necesario para leer el texto del chat
import os

# Importamos los archivos que creamos antes
from database import get_db
from controllers import home_controller, ia_controller  # <-- NUEVO: Importamos el controlador de IA

# Inicializamos la APP (esto quita el error de "app" is not defined)
app = FastAPI(debug=True, title="Sistema de Tienda")

# Configuramos Jinja2 (esto quita el error de "templates" is not defined)
templates = Jinja2Templates(directory="templates")

# Montamos estáticos
app.mount("/static", StaticFiles(directory="static"), name="static")

# =================================================================
# MODELOS DE DATOS DE LA API (PYDANTIC)
# =================================================================
# Esto le dice a FastAPI qué formato de datos esperar del chat en JavaScript
class MensajeUsuario(BaseModel):
    mensaje: str

# =================================================================
# RUTAS DEL SISTEMA
# =================================================================

# --- 1. Pantalla Principal (Inventario) ---
@app.get("/")
async def ruta_home(request: Request, db: Session = Depends(get_db)):
    # Llamamos al controlador pasándole request y db
    datos = await home_controller.procesar_datos_home(request, db)
    
    # Renderizamos (usando la variable templates definida arriba)
    return templates.TemplateResponse("index.html", datos)

# --- 2. Pantalla del Asistente IA ---
@app.get("/ia")
async def ruta_ia(request: Request):
    # Preparamos los títulos y el contexto para la pantalla del chat
    datos = await ia_controller.renderizar_pantalla(request)
    return templates.TemplateResponse("chat_ia.html", datos)

# --- 3. Ruta API Interna (El "Cerebro" del Chat) ---
@app.post("/api/ia/chat")
async def api_chat_ia(datos_usuario: MensajeUsuario, db: Session = Depends(get_db)):
    # Extraemos el texto que escribió el usuario y se lo pasamos al controlador
    respuesta = await ia_controller.generar_respuesta_ia(datos_usuario.mensaje, db)
    return respuesta
app.include_router(categorias_controller.router)