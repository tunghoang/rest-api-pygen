from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base

class DbInstance:
  __instance = None
  def __init__(self, conn_str):
    self.engine = create_engine(conn_str, echo=True, pool_pre_ping=True, pool_recycle=5)
    self.Base = declarative_base()
    self.Session = sessionmaker(bind=self.engine);
    self.__session = self.Session()

  @staticmethod
  def getInstance():
    if DbInstance.__instance is None:
      DbInstance.__instance = DbInstance('{{connection_string}}')
    return DbInstance.__instance

  def session(self):
    return self.__session

  def newSession(self):
    print('reset session')
    self.__session.close()
    self.__session =  self.Session()
