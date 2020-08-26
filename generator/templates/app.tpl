from flask import Flask
from apis import api
from apis.db_utils import DbInstance

db = DbInstance.getInstance()

app = Flask("{{name}}")
app.config['SERVER_NAME'] = 'localhost:8000'
api.init_app(app)

db.Base.metadata.create_all(db.engine)

if __name__ == "__main__":
  app.run()

