"""
Gallo d'Oro — Database connection
"""

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import os

# Меняй только эту строку под свои данные
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres:0401@localhost:5432/gallodoro?client_encoding=utf8"
)

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def get_db():
    """Dependency для FastAPI"""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
