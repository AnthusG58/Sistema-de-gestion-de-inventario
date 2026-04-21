from sqlalchemy import Column, Integer, String, DECIMAL, Text, Date, ForeignKey
from sqlalchemy.orm import declarative_base, relationship

Base = declarative_base()

# 1. LA NUEVA CLASE CATEGORÍA
class Categoria(Base):
    __tablename__ = "categorias"

    id_categoria = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), unique=True, nullable=False)
    
    # Relación bidireccional
    productos = relationship("Producto", back_populates="categoria")


# 2. TU CLASE PRODUCTO ACTUALIZADA
class Producto(Base):
    __tablename__ = "productos"

    id_producto = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(150), nullable=False)
    descripcion = Column(Text)
    precio = Column(DECIMAL(10, 2), nullable=False)
    stock = Column(Integer, default=0)
    fecha_caducidad = Column(Date)
    
    # Aquí convertimos tu id_categoria en una Llave Foránea real
    id_categoria = Column(Integer, ForeignKey("categorias.id_categoria"))
    
    # Esto le permite a FastAPI buscar la información completa de la categoría
    categoria = relationship("Categoria", back_populates="productos")