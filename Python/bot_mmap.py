import io
import json
import logging
import mmap

writable_mmaps = {
    "pokemon-bot-game-state": mmap.mmap(fileno=-1, length=4096, tagname="pokemon-bot-game-state", access=mmap.ACCESS_WRITE),
}

readable_map_info = {
    "pokemon-bot-screenshot": [24576, "pokemon-bot-screenshot"],
    "pokemon-bot-request": [1028, "pokemon-bot-gsrequest"]
}



def load_mmap(map_key: str, convert_json=True) -> dict:
    if map_key not in readable_map_info:
        logging.error(f"Unable to find mmap: '{map_key}'")
        exit()
    size, file = readable_map_info[map_key]
    current_mmap = mmap.mmap(fileno=0, length=size, tagname=file, access=mmap.ACCESS_READ)
    if current_mmap:
        if convert_json:
            return json.loads(io.BytesIO(current_mmap)
                            .read().decode("utf-8")
                            .split("\x00")[0])
        else:
            return current_mmap

def write_mmap(map_key: str, data, clear = True):
    if map_key not in writable_mmaps:
        logging.error(f"Unable to find mmap: '{map_key}'")
        exit()

    bytesData = bytes(json.dumps(data), encoding="utf-8")
    dataSize = len(bytesData)

    current_mmap = writable_mmaps[map_key]
    if clear:
        current_mmap.write(bytes())

    current_mmap.seek(0)
    current_mmap.write(bytes(json.dumps(data), encoding="utf-8"))
    print(current_mmap.tell())
    current_mmap[dataSize] = 0
