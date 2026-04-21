from fastapi import Request
from sqlalchemy.orm import Session
import google.generativeai as genai
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from models import Producto

# 1. Configuramos tu API Key
API_KEY = os.getenv("GEMINI_API_KEY", "")
genai.configure(api_key=API_KEY)

# 2. AUTO-DESCUBRIMIENTO DEL MODELO MÁS RÁPIDO
modelo_elegido = None

# Recorremos la lista de modelos que Google le permite usar a tu API Key
for m in genai.list_models():
    if 'generateContent' in m.supported_generation_methods:
        modelo_elegido = m.name
        # Si encuentra uno que se llame "flash" (son los más rápidos), lo elige de inmediato
        if 'flash' in m.name.lower():
            break

# Si por alguna razón extraña no encontró ninguno, forzamos un nombre por defecto
if not modelo_elegido:
    modelo_elegido = 'gemini-1.5-flash'

print(f"🤖 IA Conectada exitosamente usando el modelo: {modelo_elegido}")

# Inicializamos el modelo descubierto
modelo_ia = genai.GenerativeModel(modelo_elegido)


# ==========================================================
# RUTAS DEL CONTROLADOR
# ==========================================================

async def renderizar_pantalla(request: Request):
    return {"request": request, "titulo": "Asistente Predictivo IA"}

async def generar_respuesta_ia(mensaje: str, db: Session):
    try:
        # A. Extraemos todos los productos de tu base de datos MySQL
        productos = db.query(Producto).all()
        
        # B. Convertimos los datos a texto
        if not productos:
            inventario_texto = "El inventario está vacío."
        else:
            inventario_texto = "Lista actual de productos:\n"
            for p in productos:
                fecha = p.fecha_caducidad.strftime('%Y-%m-%d') if p.fecha_caducidad else 'Sin fecha'
                inventario_texto += f"- {p.nombre} (Stock: {p.stock}, Precio: ${p.precio}, Vence: {fecha})\n"

        # C. Creamos el Prompt
        prompt = f"""
        Eres el asistente de inventario de mi tienda. Responde usando SOLO estos datos:
        {inventario_texto}
        
        Pregunta: "{mensaje}"
        """

        # D. Enviamos a Gemini
        respuesta_gemini = modelo_ia.generate_content(prompt)
        return {"respuesta": respuesta_gemini.text}

    except Exception as e:
        print(f"Error de IA: {e}")
        return {"respuesta": f"Lo siento, ocurrió un error: {e}"}