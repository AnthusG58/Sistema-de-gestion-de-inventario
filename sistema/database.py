import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Agregamos ?charset=utf8mb4 al final de la URL por defecto para soportar tildes y ñ
DATABASE_URL = os.getenv("DATABASE_URL", "mysql+pymysql://root:r00t_p4ssw0rd@db-sistema:3306/tienda_db?charset=utf8mb4")

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()