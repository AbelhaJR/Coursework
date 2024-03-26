import argparse
import calculate
import model
import firebase
import sqlite
from flask import Flask, request

app  = Flask(__name__)
repo = sqlite.Repository("cells")

@app.route("/cells/<string:id>",methods=["PUT"])
def create(id):
  js = request.get_json()
  id2 = js.get("id")
  formula = js.get("formula")
  if id2 != None and formula != None and id == id2:
    cell = model.Cell(id,formula)
    if repo.lookup(id) != None:
      if repo.update(cell):
        return "",204 # No Content 
      else:
        return "",500 # Internal Server Error 
    else:
      if repo.insert(cell):
        return "",201 # Created 
      else:
        return "",500 # Internal Server Error 
  else:
    return "",400 # Bad Request

@app.route("/cells/<string:id>",methods=["GET"])
def read(id):
  cell = repo.lookup(id)
  if cell != None :
    formula2 = calculate.calculate(repo,cell.formula)
    return {"id":cell.id,"formula":str(formula2)},200 # OK
  else :
    return "",404 # Not Found 

@app.route("/cells/<string:id>",methods=["DELETE"])
def delete(id):
  if repo.lookup(id) != None:
    if repo.delete(id):
      return "",204 # No Content 
    else:
      return "",500 # Internal Server Error 
  else:
    return "",404 # Bad Request

@app.route("/cells",methods=["GET"])
def list():
  ids = repo.list() 
  size = len(ids)
  js = "["
  for n,id in enumerate(ids) :
    js += "\"" + id + "\""
    if n < size - 1 : js += ","
  js += "]"
  return js,200 # OK

def launcher(): 
  global repo
  parser = argparse.ArgumentParser()
  parser.add_argument("-r",type=str,required=True) 
  args = parser.parse_args()
  if args.r == "firebase":
    repo = firebase.Repository("cells")
  else:
    repo = sqlite.Repository("cells")
  app.run(host="localhost",port=3000)

if __name__ == "__main__":
  launcher()
