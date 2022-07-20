FROM python:3.8-alpine AS build
EXPOSE 4000
COPY requirements.txt /tmp
WORKDIR /tmp
RUN pip3 install -r requirements.txt
COPY . /home/src
WORKDIR /home/src
CMD ["flask", "run", "--port=4000", "--host=0.0.0.0"]

FROM python:alpine3.16 AS prod
EXPOSE 5000
COPY --from=build /tmp /tmp
WORKDIR /tmp
RUN pip3 install -r requirements.txt
COPY --from=build /home/src /home/src
WORKDIR /home/src
CMD ["flask", "run", "--port=5000", "--host=0.0.0.0"]
