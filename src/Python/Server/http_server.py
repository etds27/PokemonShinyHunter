import flask
from flask_cors import CORS
import json
import logging
import os
import random
import requests
import sys
import time


from payload_aggregator import PayloadAggregator

def create_pokemon_flask_server(payload_aggregator: PayloadAggregator):
    app = flask.Flask(__name__)
    CORS(app)

    @app.route("/active_bots")
    def provideBotIds() -> dict:
        return payload_aggregator.get_bot_payload()

    @app.route("/encounters")
    def provideEncounters() -> dict:
        return payload_aggregator.get_encounter_payload()

    @app.route("/shiny_log")
    def provideShinyEncounters() -> list:
        return payload_aggregator.get_shiny_payload()

    @app.route("/phase_info")
    def providePhaseInfo() -> dict:
        return payload_aggregator.get_phase_payload()

    @app.route("/collection_info")
    def provideCollectionInfo() -> dict:
        return {}

    @app.route("/bot_data_receive", methods=["POST"])
    def update_bot_data():
        event = flask.request.form.to_dict()

        logging.info(f"data: {str(flask.request.form)}")
        event_handler.handle_event(event)

        return flask.Response("SUCCESS", status=200)

    return app