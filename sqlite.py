import model
import sqlite3

class Repository:
  def __init__(self,name):
    self.database = name + ".db" 
    with sqlite3.connect(self.database) as connection:
      cursor = connection.cursor()
      cursor.execute(
        "CREATE TABLE IF NOT EXISTS cells " +
        "(id TEXT PRIMARY KEY, formula TEXT)"
      )
      connection.commit()

  def update(self,cell):
    with sqlite3.connect(self.database) as connection:
      cursor = connection.cursor()
      cursor.execute(
        "UPDATE cells SET formula=? WHERE id=?",
        (cell.formula,cell.id)
      )
      connection.commit()
      return cursor.rowcount

  def insert(self,cell):
    with sqlite3.connect(self.database) as connection:
      cursor = connection.cursor()
      cursor.execute(
        "INSERT INTO cells (id,formula) VALUES (?,?)",
        (cell.id,cell.formula)
      )
      connection.commit()
      return cursor.rowcount

  def lookup(self,id):
    with sqlite3.connect(self.database) as connection:
      cursor = connection.cursor()
      cursor.execute(
        "SELECT id, formula FROM cells WHERE id=?",
        (id,)
      )
      row = cursor.fetchone()
      if row: return model.Cell(row[0],row[1])
      else: return None

  def delete(self,id):
    with sqlite3.connect(self.database) as connection:
      cursor = connection.cursor()
      cursor.execute(
        "DELETE FROM cells WHERE id=?",
        (id,)
      )
      connection.commit()
      return cursor.rowcount > 0        

  def list(self):
    with sqlite3.connect(self.database) as connection:
      cursor = connection.cursor()
      cursor.execute("SELECT * FROM cells")
      return [row[0] for row in cursor.fetchall()]
