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

# Mise en ligne de l'image sur docker hub
```shell
docker login -u brian45000
docker tag flask-panda:latest brian45000/flask-panda
docker push brian45000/flask-panda
```

## Mise en place flask-panda-docker
- Créer un nouvel item
- Saisir le nom "flash-panda-docker"
- Construire un projet free-style
- Dans gestion de code source, nous sélectionnons "Git" et ajoutons l'URL du repository github du projet
- Pour la branche, nous mettons */main
- Nous sélectionnons "GitHub hook trigger for GITScm polling"
- Etapes du build, on exécute un script shell
- Pour l'action à la suite du build, nous mettons "Construire d'autres projets (projets en aval)" et mettons flask-panda-jmeter que nous allons créer
- Ne pas oublier de sauvegarder

## Mise en place flask-panda-jmeter
- Créer un nouvel item
- Saisir le nom "flash-panda-docker"
- Construire un projet free-style
- Dans gestion de code source, nous sélectionnons "Git" et ajoutons l'URL du repository github du projet
- Pour la branche, nous mettons */main
- Cocher la case "Use secret text(s) or file(s)" pour l'environnements de buils
- On ajoute une étape shell
- On ajoute un "Console output (build log) parsing" pour l'action à la suite du build
- On coche "Mark build Failed on Error"
- On sélectionne "Use project rule"
- Ensuite, on ajoute un "Publish Performance test result report" avec comme source data files "testresult.jlt".

## Page d'accueil jenkins
![HOMEPAGE](/media/screens/homepage.png)

## Commandes jenkins du docker run
![DOCKER RUN JENKINS](/media/screens/commande_docker.png)

## Shell du Jmeter
![SHELL JMETER](/media/screens/jmeter_shell.png)

## After build Jmeter
![AFTER BUILD JMETER](/media/screens/jmeter_after_build.png)

## Pipeline
![PIPELINE](/media/screens/pipeline.png)

## Webhook github
![WEBHOOK GITHUB](/media/screens/webhook.png)

## Goland
![GOLAND](/media/screens/goland_jenkins.png)