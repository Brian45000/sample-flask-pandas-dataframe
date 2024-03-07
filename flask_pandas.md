## SANS DOCKER
```shell
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
```
## AVEC DOCKER

```Dockerfile
FROM python:3.10.1-slim-buster

RUN apt-get update && apt-get install -y netcat

WORKDIR /sample-flask-pandas-dataframe
COPY . /sample-flask-pandas-dataframe

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Flask var
ENV FLASK_APP=app.py

# make sh script executable
RUN chmod +x script_flash.sh
RUN /bin/sh script_flash.sh

EXPOSE 5000
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000", "--debug"]
```
et le script_flash.sh : 
```shell
#!/bin/bash

flask shell << EOF
from app import db
db.create_all()
quit()
EOF

flask load-data titanic-min.csv
```