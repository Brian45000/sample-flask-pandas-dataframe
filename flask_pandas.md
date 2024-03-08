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

Nous avons désormais nos 2 items pour notre projet flask-panda

## Commandes jenkins du docker run
![DOCKER RUN JENKINS](/media/screens/commande_docker.png)

Actuellement les commandes sont en echo et commentés car il y a un souci avec jenkins et docker.
Là pour l'exemple j'ai mis en echo quelques commandes.

## Shell du Jmeter
![SHELL JMETER](/media/screens/jmeter_shell.png)

Cette commande permet de lancer des tests pour X utilisateurs et d'un délai de Y secondes. Ici on a 1 utilisateur pour 1 seconde.
Le test va vérifier sur la page /data qu'il y a au moins 1 row de data.
Ci-dessous, voici à quoi ressemble le fichier test sur jmeter qu'on ajoute à notre github sous forme jmx.

## Tests JMETER
![TEST 1 JMETER](/media/screens/test_1_jmeter.png)
![TEST 2 JMETER](/media/screens/test_2_jmeter.png)

Ici je vérifie que sur la route /data il n'y a pas de texte comprenant la chaîne de caractères "Rows = 0"
Pour ceci, j'ai coché la case "Not" pour exclure "Rows = 0"
Ce test je le sauvegarde, le nomme "flask_panda_test_plan.jmx" et le met à la racine du projet
Ensuite, je fais un push du projet pour y intégrer ce test dans github.

## After build Jmeter
![AFTER BUILD JMETER](/media/screens/jmeter_after_build.png)

## Pipeline
![PIPELINE](/media/screens/pipeline.png)

Voici à quoi ressemble la pipeline.
Une fois que flask-panda-docker a terminé de build l'application, c'est au tour de flask-panda-jmeter de prendre le relai et de réaliser les tests.

## Webhook github
![WEBHOOK GITHUB](/media/screens/webhook.png)

Il faut crée un webhook sur le repository du github.
Il pointe sur notre adresse publique, le port 32500 (Jenkins) et sur /github-webhook/ 
et en Content-Type: application/json

## Goland
![GOLAND](/media/screens/goland_jenkins.png)

Sur goland, on met à jour jenkins pour avoir tous nos build.