import pprint
from event_handler import EventHandler
import flask
from flask_cors import CORS
import json
import logging
from payload_aggregator import PayloadAggregator
import re
import signal
import argparse

BUF_SIZE = 1024

parser = argparse.ArgumentParser()

parser.add_argument("host", type=str, help="Enter host IP (usually 127.0.0.1)")
parser.add_argument("port", type=int, help='Port number for server')

args = parser.parse_args()
HOST = args.host  # Standard loopback interface address (localhost)
PORT = args.port  # Port to listen on (non-privileged ports are > 1023)

event_handler = EventHandler()
payload_aggregator = PayloadAggregator(event_handler=event_handler)

app = flask.Flask(__name__)
CORS(app)

@app.route("/active_bots")
def provide_bot_ids() -> dict:
    return payload_aggregator.get_bot_payload()

@app.route("/encounters")
def provide_encounters() -> dict:
    return payload_aggregator.get_encounter_payload()

@app.route("/shiny_log")
def provide_shiny_encounters() -> list:
    return payload_aggregator.get_shiny_payload()

@app.route("/phase_info")
def provide_phase_info() -> dict:
    return payload_aggregator.get_phase_payload()

@app.route("/collection_info")
def provide_collection_info() -> dict:
    return payload_aggregator.get_collection_payload()

@app.route("/game_stats")
def provide_game_stats_info():
    return payload_aggregator.get_game_stats_payload()

@app.route("/bot_data_receive", methods=["POST"])
def update_bot_data():
    event = flask.request.form.to_dict()
    event = json.loads(event["payload"])
    event_handler.handle_event(event)

    return flask.Response("SUCCESS", status=200)

app.run(host="127.0.0.1", port=8000)
