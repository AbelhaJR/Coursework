import os
import firebase_admin
from firebase_admin import credentials, db
from flask import Flask, request, jsonify

app = Flask(__name__)

# Check if the flag is set to use Firebase Realtime Database
use_firebase = os.getenv("USE_FIREBASE", "false").lower() in ("true", "1")

# Initialize Firebase Realtime Database if the flag is set
if use_firebase:
    # Set up Firebase credentials
    cred = credentials.Certificate("path/to/serviceAccountKey.json")
    firebase_admin.initialize_app(cred, {
        'databaseURL': 'https://your-project-id.firebaseio.com',
    })

@app.route('/cells', methods=['PUT'])
def create_or_update_cell():
    data = request.json
    if not data or 'id' not in data or 'formula' not in data:
        return jsonify({'error': 'Invalid request body'}), 400
    
    cell_id = data['id']
    formula = data['formula']
    
    if not isinstance(cell_id, str) or not isinstance(formula, str):
        return jsonify({'error': 'Cell ID and formula must be strings'}), 400
    
    # Store cell in Firebase Realtime Database
    if use_firebase:
        db.reference('/cells').child(cell_id).set(formula)
    else:
        # Handle on-premises storage or other storage options
        pass
    
    return '', 201

@app.route('/cells/<cell_id>', methods=['GET'])
def read_cell(cell_id):
    if use_firebase:
        formula = db.reference('/cells').child(cell_id).get()
    else:
        # Handle on-premises storage or other storage options
        pass
    
    if formula is None:
        return jsonify({'error': 'Cell not found'}), 404
    
    try:
        result = eval(formula)
        return jsonify({'id': cell_id, 'value': result}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/cells', methods=['GET'])
def list_cells():
    if use_firebase:
        cell_ids = db.reference('/cells').get().keys()
    else:
        # Handle on-premises storage or other storage options
        pass
    
    return jsonify(list(cell_ids)), 200

if __name__ == '__main__':
    app.run(port=3000, debug=True)
