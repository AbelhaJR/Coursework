import model
import os
import requests 

FBASE = os.environ["FBASE"] 
FPATH = "https://" + FBASE + "-default-rtdb.europe-west1.firebasedatabase.app"

class Repository:
  def __init__(self,name):
    self.database = FPATH + "/" + name 

  def update(self,cell):
    js = {"id":cell.id,"formula":cell.formula}
    rsp = requests.put(self.database+"/"+cell.id+".json",json=js)
    if rsp.status_code == 200:
      return True
    else:
      return False

  def insert(self,cell):
    return self.update(cell)

  def lookup(self,id):
    rsp = requests.get(self.database+"/"+id+".json")
    if rsp.status_code == 200:
      js = rsp.json()
      if js != None :
        return model.Cell(js.get("id"), js.get("formula"))
      else :
        return None
    else:
      return None
        
  def delete(self,id):
    rsp = requests.delete(self.database+"/"+id+".json")
    if rsp.status_code == 200:
      return True
    else:
      return False 

  def list(self):
    rsp = requests.get(self.database+".json")
    if rsp.status_code == 200:
      js = rsp.json()
      if js != None:
        ids = []
        for id,_ in js.items():
          ids.append(id)
        return ids 
      else:
        return [] 
    else:
      return [] 
