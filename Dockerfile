FROM python:3.9-slim

# mkdir and cd into it
WORKDIR /app 

COPY './requirements.txt' .

RUN pip install --upgrade pip

RUN pip install -r requirements.txt

# Copy all files from current folder to app folder inside the container
COPY . . 

CMD gunicorn --bind 0.0.0.0:5000 wsgi:app