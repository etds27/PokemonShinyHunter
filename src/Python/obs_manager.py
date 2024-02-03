import asyncio
import json
import os
import pprint
import re
import requests
import simpleobsws
import time
import uuid

# WEBSOCKET_HOST = "http://192.168.1.65"
WEBSOCKET_HOST = "ws://localhost"
WEBSOCKET_PORT = "4455"
WEBSOCKET_PASSWORD = "R2M4roiX9tOQebPz"



# Connect to the WebSocket server

# Create an IdentificationParameters object (optional for connecting)
parameters = simpleobsws.IdentificationParameters(ignoreNonFatalRequestChecks = False)

# Every possible argument has been passed, but none are required. See lib code for defaults.
ws = simpleobsws.WebSocketClient(url = f"{WEBSOCKET_HOST}:{WEBSOCKET_PORT}", password = WEBSOCKET_PASSWORD, identification_parameters = parameters)

async def make_request():
    await ws.connect() # Make the connection to obs-websocket
    await ws.wait_until_identified() # Wait for the identification handshake to complete

    request = simpleobsws.Request('GetSceneItemList', requestData={"sceneName": "Pokemon Bot"}) # Build a Request object

    ret = await ws.call(request) # Perform the request
    if ret.ok(): # Check if the request succeeded
        print("Request succeeded! Response data: {}".format(ret.responseData))

    time.sleep(10)
    await ws.disconnect() # Disconnect from the websocket server cleanly

loop = asyncio.get_event_loop()
loop.run_until_complete(make_request())
