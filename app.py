#! /usr/bin/python

import socket
from flask import Flask, jsonify, request
from datetime import datetime
from pytz import reference

app = Flask(__name__)

@app.route('/')
def mydate():
    today = datetime.now()
    localtime = reference.LocalTimezone()
    return jsonify({"Date ": today.strftime("%Y-%m-%d")
    , "Hour ": today.strftime("%H:%M:%S")
    , "Timezone ": localtime.tzname(today)
    , "Host IP Address ": request.remote_addr
    , "Container IP Address": socket.gethostbyname(socket.gethostname())
    , "Hostname ": socket.gethostname()
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0')

