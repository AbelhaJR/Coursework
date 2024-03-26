import os # this module provides a portable way of using operating system dependent functionality
import sqlite3 # this library provided a lightweight disk-based database that doesn´t require a separate server process


from flask import Flask , request , jsonify # Flask is a small and lightweight Python web framework that provides useful tools and features

use_sqlite = os.getenv("sqlite","false") in ("true","1") # Verify if the environment variable is set to determine the storage type


database = "cells.db"

cells ={}
# Function to interact with SQLite database
def setup_database():
  conn = sqlite3.connect(database)
  cursor = conn.cursor()
  cursor.execute('''CREATE TABLE IF NOT EXISTS cells(id TEXT PRIMARY KEY,formula TEXT)''')
  conn.commit()
  conn.close()

# Function to store cell in SQLite database 
def database_query(query,args=()):
  conn = sqlite3.connect(database)
  cursor = conn.cursor()
  cursor.execute(query,args)
  conn.commit()
  result = cursor.fetchall()
  conn.close()
  return result

# Function to store cell in SQLite database
def store_cell_in_db(cell_id, formula):
    database_query("INSERT OR REPLACE INTO cells (id, formula) VALUES (?, ?)", (cell_id, formula))

# Function to retrieve cell from SQLite database
def retrieve_cell_from_db(cell_id):
    result = database_query("SELECT formula FROM cells WHERE id=?", (cell_id,))
    if result:
        return result[0][0]
    else:
        return None

# Create SQLite database if USE_SQLITE flag is set
if use_sqlite:
    setup_database()
@app.route('/cells', methods=['PUT'])
def create_or_update_cell():
    data = request.json
    if not data or 'id' not in data or 'formula' not in data:
        return jsonify({'error': 'Invalid request body'}), 400
    
    cell_id = data['id']
    formula = data['formula']
    
    if not isinstance(cell_id, str) or not isinstance(formula, str):
        return jsonify({'error': 'Cell ID and formula must be strings'}), 400
    
    # Store cell in database
    if use_sqlite:
        store_cell_in_db(cell_id, formula)
    else:
        cells[cell_id] = formula
    
    return '', 201 if retrieve_cell_from_db(cell_id) is None else 204

@app.route('/cells/<cell_id>', methods=['GET'])
def read_cell(cell_id):
    if use_sqlite:
        formula = retrieve_cell_from_db(cell_id)
    else:
        formula = cells.get(cell_id)
    
    if formula is None:
        return jsonify({'error': 'Cell not found'}), 404
    
    try:
        result = eval(formula)
        return jsonify({'id': cell_id, 'value': result}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/cells', methods=['GET'])
def list_cells():
    if use_sqlite:
        result = database_query("SELECT id FROM cells")
        return jsonify([row[0] for row in result]), 200
    else:
        return jsonify(list(cells.keys())), 200

if __name__ == '__main__':
    app.run(port=3000, debug=True)


