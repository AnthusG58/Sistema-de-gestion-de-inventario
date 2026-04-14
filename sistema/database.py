import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Tomamos la URL del docker-compose, si no existe usa una por defecto para evitar caídas
DATABASE_URL = os.getenv("DATABASE_URL", "mysql+pymysql://root:r00t_p4ssw0rd@db-sistema:3306/tienda_db")

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()