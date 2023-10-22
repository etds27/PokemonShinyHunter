import json
import logging
import os

DATA_PATH = "Data\\"
if not os.path.exists(DATA_PATH):
    logging.info(f"Data path did not exist. Created dir: {DATA_PATH}")
    os.mkdir(DATA_PATH, mode = 0o777)

def load_file(filename):
    filepath = os.path.join(DATA_PATH, filename)

    if not os.path.exists(filepath):
        logging.warning(f"File path: '{filepath}' does not exist. Returning empty directory")
        return {}
    
    with open(filepath, "r") as f:
        data = json.load(f)
    return data

def save_file(filename, data: dict):
    filepath = os.path.join(DATA_PATH, filename)

    with open(filepath, "w") as f:
        json.dump(data, f)