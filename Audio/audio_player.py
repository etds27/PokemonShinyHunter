from collections import deque
from pydub import AudioSegment
from pydub.utils import mediainfo
from pydub.playback import play
import argparse
import logging
import os
import pprint
import random
import re
import requests
import subprocess
import sys
import uuid

logging.basicConfig(level=logging.INFO)

DASHBOARD_DIR = os.environ.get("PSH_DASHBOARD_DIR", os.path.join(os.path.dirname(os.path.realpath(__file__))))
ALBUM_DEST_DIR = os.path.join(DASHBOARD_DIR, "static", "resources")

parser = argparse.ArgumentParser()
parser.add_argument("-p", "--port", nargs=1, default=8000, type=int)
parser.add_argument("--host", nargs=1, default="127.0.0.1", type=str)

args = parser.parse_args()

HOST = args.host
PORT = args.port
N_SONG_COOLDOWN = 5

cooldown_songs = deque()
song_list = []

def send_song_payload(song_path):
    album_cover = get_album_cover(song_path=song_path, overwrite=True)
    song_details = get_song_details(song_path=song_path)

    payload = {
        "album_cover_path": album_cover,
        "uuid": str(uuid.uuid4()),
        **song_details
    }

    ret = requests.post(f"http://{HOST}:{PORT}/current_song", json=payload)
    return ret.status_code == 200

def send_end_song():
    ret = requests.post(f"http://{HOST}:{PORT}/current_song", json={})
    return ret.status_code == 200

def get_album_cover(song_path: str, 
                    output_file: str = os.path.join(ALBUM_DEST_DIR, "album_cover.jpg"), 
                    overwrite: bool = False):
    """
    ffmpeg -i <input_file> [-y] -an -vcodec copy <output_file>.jpg
    """
    overwrite_arg = "-y" if overwrite else ""
    cmd = ["ffmpeg", "-i", song_path, overwrite_arg, "-an", "-vcodec", "copy", output_file]
    subprocess.run(cmd, stderr=subprocess.DEVNULL)
    return output_file

def get_song_details(song_path: str):
    """
    {
        "artist": str,
        "album": str,
        "title": str,
        "composer": str,
        "date": str,
        "filename": str,
        "duration": float
    }
    """
    if not os.path.exists(path=song_path):
        raise FileNotFoundError(song_path)
    
    song_meta_data = mediainfo(song_path)
    song_meta_data["TAG"] = {key.upper(): value for key, value in song_meta_data["TAG"].items()}
    song_tag_data = song_meta_data["TAG"]
    try:
        song_details = {
            "artist": song_tag_data["ARTIST"],
            "album": song_tag_data["ALBUM"],
            "title": song_tag_data["TITLE"],
            "composer": song_tag_data["COMPOSER"],
            "date": song_tag_data["DATE"],
            "filename": song_meta_data["filename"],
            "duration": float(song_meta_data["duration"])
        }
    except KeyError as e:
        print(e)
        print(song_meta_data)
        exit()

    return song_details



def create_song_list():
    temp_list = []
    for root, _, files in os.walk("C:\\Users\\etds2\\Programming\\PokemonLua\\Audio"):
        if len(files):
            for file in files:
                if not file.endswith('.flac'):
                    continue

                file_path = os.path.join(root, file)
                
                file = re.sub("é", "e", file)
                ascii_file_name = file.encode('ascii', errors='ignore').decode()

                if not ascii_file_name == file:
                    os.rename(os.path.join(root, file), os.path.join(root, ascii_file_name))
                    file_path = os.path.join(os.path.join(root, ascii_file_name))

                temp_list.append(file_path)
    return temp_list

def play_random_song():
    song_path = song_list.pop(random.randint(0, len(song_list) - 1))
    play_song(song_path=song_path)

def play_song(song_path: str):
    song = AudioSegment.from_file(song_path, format='flac')

    song_details = get_song_details(song_path=song_path)
    logging.info(song_details)
    song_title = song_details["title"]
    song_album = song_details["album"]
    sys.stdout.write(song_title + " - " + song_album + "\n")
    sys.stdout.flush()
    logging.debug(f"Song List: {song_list}")
    logging.debug(f"Cooldown List; {cooldown_songs}")

    send_song_payload(song_path=song_path)
    play(song)
    send_end_song()
    cooldown_songs.append(song_path)
    if len(cooldown_songs) > N_SONG_COOLDOWN:
        song_list.append(cooldown_songs.popleft())




if __name__ == "__main__":
    song_list = create_song_list()
    while True:
        play_random_song()