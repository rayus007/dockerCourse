FROM python:3.8-alpine AS build
COPY requirements.txt /tmp
COPY . /home/src

FROM python:alpine3.16 AS prod
EXPOSE 5000
COPY --from=build /tmp /tmp
WORKDIR /tmp
RUN pip3 install -r requirements.txt
COPY --from=build /home/src /home/src
WORKDIR /home/src
CMD ["flask", "run", "--port=5000", "--host=0.0.0.0"]
RUN python3 -m pytest test.py >testsOutput.log
