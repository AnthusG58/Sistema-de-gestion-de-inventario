from fastapi import APIRouter, Request, Depends
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session
import sys
import os

# Configuramos las rutas para que Python encuentre tus modelos
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from models import Producto, Categoria
from database import get_db

router = APIRouter()

# 🔥 LA LÍNEA CORREGIDA: Apuntando a la carpeta exacta dentro de Docker
templates = Jinja2Templates(directory="templates")

# 1. Muestra la pantalla HTML principal
@router.get("/categorias", response_class=HTMLResponse)
async def vista_categorias(request: Request):
    return templates.TemplateResponse("categorias.html", {"request": request})

# 2. Envía la lista de categorías (para el menú desplegable)
@router.get("/api/categorias/lista")
def obtener_categorias(db: Session = Depends(get_db)):
    return db.query(Categoria).all()

@router.get("/api/categorias/productos/{categoria_id}")
def productos_por_categoria(categoria_id: int, db: Session = Depends(get_db)):
    if categoria_id == 0:
        # Devuelve todo si la opción es "Todas"
        return db.query(Producto).all()
    
    # IMPORTANTE: Usamos id_categoria (que es el nombre en tu models.py)
    return db.query(Producto).filter(Producto.id_categoria == categoria_id).all()