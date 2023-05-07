FROM python:3

RUN pip install pipenv

ADD ./ /opt/app/
WORKDIR /opt/app

RUN pipenv install

EXPOSE 8080

CMD ["pipenv", "run", "python3", "server.py"]
