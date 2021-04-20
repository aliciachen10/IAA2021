FROM python:3.8-slim-buster

MAINTAINER alicia <aliciachen10@gmail.com>

#set the working directory
WORKDIR C:/Users/Alicia/Documents/python-docker

RUN apt-get update -y && \  
   apt-get install -y python-pip python-dev

RUN pip install requests --user
RUN pip install pyjokes

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .
ENTRYPOINT ["python"]
CMD ["python_joke.py"]
