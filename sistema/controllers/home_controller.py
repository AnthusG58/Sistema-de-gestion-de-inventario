from fastapi import Request
from sqlalchemy.orm import Session
import sys
import os

# Le decimos a Python que busque archivos un nivel más arriba (en la carpeta sistema)
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models import Producto

async def procesar_datos_home(request: Request, db: Session):
    # Hacemos un SELECT * FROM productos;
    lista_productos = db.query(Producto).all()
    
    return {
        "request": request,
        "productos": lista_productos,
        "titulo": "Inventario de Productos"
    }