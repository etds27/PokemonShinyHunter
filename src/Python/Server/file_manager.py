import csv
import json
import logging
import os

DATA_PATH = os.path.join(os.environ.get("PSH_ROOT", "..\\..\\"), "BotData")
if not os.path.exists(DATA_PATH):
    logging.info(f"Data path did not exist. Created dir: {DATA_PATH}")
    os.mkdir(DATA_PATH, mode=0o777)
    os.mkdir(os.path.join(DATA_PATH, "phase_encounters"), mode=0o777)

def load_file(bot_id, filename):
    dest_dir = os.path.join(DATA_PATH, bot_id)
    filepath = os.path.join(dest_dir, filename)

    if not os.path.exists(filepath):
        logging.warning(f"File path: '{filepath}' does not exist. Returning empty directory")
        return {}
    
    with open(filepath, "r") as f:
        data = json.load(f)
    return data

def get_full_file_path(bot_id, filename, subdirs=[]):
    filepath = os.path.join(DATA_PATH, bot_id, *subdirs, filename)
    return filepath

def save_file(bot_id, filename, data: dict, subdirs=[]):
    filepath = get_full_file_path(bot_id=bot_id, filename=filename, subdirs=subdirs)
    dest_dir = os.path.dirname(filepath)
    
    if not os.path.exists(dest_dir):
        logging.info(f"Data path did not exist. Created dir: {dest_dir}")
        os.mkdir(dest_dir, mode=0o777)
    
    with open(filepath, "w") as f:
        json.dump(data, f)

def append_row_to_csv_filepath(filepath, data):
    dest_dir = os.path.dirname(filepath)
    if not os.path.exists(dest_dir):
        logging.info(f"Data path did not exist. Created dir: {dest_dir}")
        os.mkdir(dest_dir, mode=0o777)

    with open(filepath, "a", newline='') as f:
        writer = csv.writer(f)
        writer.writerow(data)

def append_row_to_csv_file(bot_id, filename, data, subdirs=[]):
    filepath = get_full_file_path(bot_id=bot_id, filename=filename, subdirs=subdirs)
    append_row_to_csv_filepath(filepath=filepath, data=data)

def get_phase_encounter_file(bot_id, phase_number):
    return get_full_file_path(bot_id=bot_id, filename=f"phase_{phase_number}_encounters.csv", subdirs=["phase_encounters"])