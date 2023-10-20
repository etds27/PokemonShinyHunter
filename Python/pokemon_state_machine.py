import bot_mmap
import cv2
import numpy
import screenshot
import time
from PIL import Image

FPS = 10  # Perform a state determination 3 times a second
SPF = 1.0 / FPS * 1000
THRESHOLD = 0.999

request_counter = 0

IMAGE_ANCHORS = {
    # Bag Anchors
    "bag": {
        "bag_menu_balls": cv2.imread("Resources/ImageAnchors/bag_menu_balls.png"),
        "bag_menu_items": cv2.imread("Resources/ImageAnchors/bag_menu_items.png"),
        "bag_menu_keyitems": cv2.imread("Resources/ImageAnchors/bag_menu_keyitems.png"),
        "bag_menu_tmhm": cv2.imread("Resources/ImageAnchors/bag_menu_tmhm.png"),
    },
    # Battle Anchors
    "battle": {
        "battle_menu_fight": cv2.imread("Resources/ImageAnchors/battle_menu_fight.png"),
        "battle_menu_pkmn": cv2.imread("Resources/ImageAnchors/battle_menu_pkmn.png"),
        "battle_menu_run": cv2.imread("Resources/ImageAnchors/battle_menu_run.png"),
        "battle_menu_pack": cv2.imread("Resources/ImageAnchors/battle_menu_pack.png"),
        "fight_menu": cv2.imread("Resources/ImageAnchors/fight_menu.png"),
    },
    "top_menu": {
        "top_menu_pokedex": cv2.imread("Resources/ImageAnchors/top_menu_pokedex.png"),
        "top_menu_pokemon": cv2.imread("Resources/ImageAnchors/top_menu_pokemon.png"),
        "top_menu_pack": cv2.imread("Resources/ImageAnchors/top_menu_pack.png"),
        "top_menu_pokegear": cv2.imread("Resources/ImageAnchors/top_menu_pokegear.png"),
        "top_menu_save": cv2.imread("Resources/ImageAnchors/top_menu_save.png"),
        "top_menu_option": cv2.imread("Resources/ImageAnchors/top_menu_option.png"),
        "top_menu_exit": cv2.imread("Resources/ImageAnchors/top_menu_exit.png"),
    },
    "pokemon_menu": {
        "pokemon_menu": cv2.imread("Resources/ImageAnchors/pokemon_menu.png"),
    }
}

def get_current_request():
    game_request_data = bot_mmap.load_mmap(map_key="pokemon-bot-request")
    request_no, keys = game_request_data
    return request_no, keys
    



def get_current_game_state(search_keys=["all"]):
    # Handle "all" keys parameter
    search_keys = IMAGE_ANCHORS.keys() if "all" in search_keys else search_keys

    # Grab current emulator screenshot from shared memory
    image = screenshot.get_screenshot_from_mmap()
    found = False
    for search_group in search_keys:
        for anchor_key, anchor_image in IMAGE_ANCHORS[search_group].items():
            # Compare screenshot with the current anchor image
            result = cv2.matchTemplate(image, anchor_image,
                                        cv2.TM_CCORR_NORMED) 
            _, max_val, _, max_loc = cv2.minMaxLoc(result)

            if max_val > THRESHOLD:
                image = cv2.rectangle(image, 
                                    (max_loc[0], max_loc[1]), 
                                    (max_loc[0] + anchor_image.shape[1], max_loc[1] + anchor_image.shape[0]),
                                    255,
                                    2)
                image = cv2.putText(image, anchor_key, (2, 15), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 0),
                            2, cv2.LINE_AA)
                found = True
                return anchor_key, image
        if found:
            break
    return None, image

def set_current_game_state(game_state):
    if isinstance(game_state, str):
        game_state = [game_state]

    bot_mmap.write_mmap("pokemon-bot-game-state", game_state)

if __name__ == "__main__":
    while True:
        try:
            request_no, keys = get_current_request()
        except:
            request_no = -1

        print(request_no)

        # If these arent equal, then the lua script has made a new request
        if request_no != request_counter:
            print(f"Received new request: {request_no}")
            game_state, image = get_current_game_state(keys)
            print(game_state)

            set_current_game_state(game_state=game_state)

            # cv2.imshow("Game", image)
            request_counter = request_no

        # if cv2.waitKey(FPS) & 0xFF == ord('q'):
        #    break
        # time.sleep(0.1)
            
