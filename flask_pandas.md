# Activation venv
python3 -m venv venv  
source venv/bin/activate

# Installation des requirements
pip3 install -r requirements.txt

# Création BDD Flask
flask shell

>>> from app import db  
>>> db.create_all()     
>>> quit()

# Récupération des datas et insertion en BDD
flask load-data titanic-min.csv

# Set la variable d'environnement
export FLASK_APP=app.py

# Run flask
flask run --host=0.0.0.0 --port=31201