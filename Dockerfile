FROM python:latest
EXPOSE 5000
COPY requirements.txt /tmp
WORKDIR /tmp
RUN pip3 install -r requirements.txt
COPY . /home/src
WORKDIR /home/src
CMD ["flask", "run", "--port=5000", "--host=0.0.0.0"]