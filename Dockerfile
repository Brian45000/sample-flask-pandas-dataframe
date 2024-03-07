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
