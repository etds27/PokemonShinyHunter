import json
import logging
import os

DATA_PATH = os.path.join(os.environ.get("PSH_ROOT", "..\\..\\"), "DATA")
if not os.path.exists(DATA_PATH):
    logging.info(f"Data path did not exist. Created dir: {DATA_PATH}")
    os.mkdir(DATA_PATH, mode=0o777)

def load_file(bot_id, filename):
    dest_dir = os.path.join(DATA_PATH, bot_id)
    filepath = os.path.join(dest_dir, filename)

    if not os.path.exists(filepath):
        logging.warning(f"File path: '{filepath}' does not exist. Returning empty directory")
        return {}
    
    with open(filepath, "r") as f:
        data = json.load(f)
    return data

def save_file(bot_id, filename, data: dict):
    dest_dir = os.path.join(DATA_PATH, bot_id)
    filepath = os.path.join(dest_dir, filename)
    
    if not os.path.exists(dest_dir):
        logging.info(f"Data path did not exist. Created dir: {dest_dir}")
        os.mkdir(dest_dir, mode=0o777)
    
    with open(filepath, "w") as f:
        json.dump(data, f)