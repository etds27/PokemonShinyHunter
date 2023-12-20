import re
import os

import requests
from bs4 import BeautifulSoup

SPRITE_ROOT_DIR = "..\\src\\Dashboard\\resources\\sprites\\"

battle_sprite_urls = {
    "gen_1": [
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen1/spr_green_gb",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen1/spr_green_supergb",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen1/spr_red-blue_gb",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen1/spr_red-blue_supergb",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen1/spr_yellow_gb",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen1/spr_yellow_supergb",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen1/spr_yellow_gbc",
    ],
    "gen_2": [
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen2/spr_gold",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen2/spr_silver",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen2/spr_crystal",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen2/spr_gold_shiny",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen2/spr_silver_shiny",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen2/spr_crystal_shiny"

    ],
    "gen_3": [
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen3/spr_ruby-sapphire",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen3/spr_emerald",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen3/spr_firered-leafgreen",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen3/spr_ruby-sapphire_shiny",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen3/spr_emerald_shiny",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen3/spr_firered-leafgreen_shiny",



    ],
    "gen_4": [
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen4/spr_diamond-pearl",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen4/spr_platinum",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen4/spr_hgss",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen4/spr_diamond-pearl_shiny",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen4/spr_platinum_shiny",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen4/spr_hgss_shiny",

    ],
    "gen_5": [
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen5/spr_black-white",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/gen5/spr_black-white_shiny"
    ],
    "gen_67": [
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/3ds/spr_3ds"
    ],
    "art": [
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/artworks/art_1-rb",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/artworks/art_2-gs",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/artworks/art-hd_anime",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/artworks/art_1-green",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/artworks/art_dream-world",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/artworks/art_global-link",
        "https://www.pokencyclopedia.info/en/index.php?id=sprites/artworks/ken-sugimori"
    ],
}

menu_sprite_urls = [
    "https://www.pokencyclopedia.info/en/index.php?id=sprites/menu-icons/ico-a_gb",
    "https://www.pokencyclopedia.info/en/index.php?id=sprites/menu-icons/ico-a_gbc",
    "https://www.pokencyclopedia.info/en/index.php?id=sprites/menu-icons/ico_old",
    "https://www.pokencyclopedia.info/en/index.php?id=sprites/menu-icons/ico_3ds",
    "https://www.pokencyclopedia.info/en/index.php?id=sprites/spin-off/ani_pinball",
    "https://www.pokencyclopedia.info/en/index.php?id=sprites/spin-off/ani_pinball-rs",
    "https://www.pokencyclopedia.info/en/index.php?id=sprites/overworlds/o_hgss",
]

gen_map = {"gen_1": {"menu": "ico-a_gb",
                     "battle": "spr_yellow_gbc"},
           "gen_2": {"menu": "ico-a_gbc",
                     "battle": "spr_crystal"},
           "gen_3": {"menu": "ico_old",
                     "battle": "spr_emerald"},
           "gen_4": {"menu": "ico_old",
                     "battle": "spr_platinum"},
           "gen_5": {"menu": "ico_old",
                     "battle": "spr_black-white"},
           }

pre_url = "https://www.pokencyclopedia.info"


def parse_name(name):
    pokemon_name = name.strip().lower()
    pokemon_name = re.sub(" ", "_", pokemon_name)
    pokemon_name = re.sub("[^0-9a-zA-Z_-]", "", pokemon_name)
    return pokemon_name


def download_battle_sprites_from_url(url,  overwrite=True):
    gen_key = os.path.basename(url)

    print("\tStarting %s" % gen_key)

    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')

    div = soup.find(id="spr_dump")
    tables = div.find_all("table")
    skip = True
    for table in tables:
        display_name = table.text.strip()
        pokemon_name = parse_name(table.text)

        if pokemon_name == "nidoran" and skip:
            skip = False
            print("Skipping nidoran")
            continue

        img = table.find("img")
        file_type = img["src"][-3:]
        url = "{}/{}".format(pre_url, img["src"])

        number = re.search("[0-9]{3}", os.path.basename(url)).group()

        poke_dir = os.path.join(SPRITE_ROOT_DIR, "%s_%s" % (number, pokemon_name))
        if not os.path.exists(poke_dir):
            os.mkdir(poke_dir)

        if not os.path.exists(os.path.join(poke_dir, "battle")):
            os.mkdir(os.path.join(poke_dir, "battle"))

        dest = os.path.join(poke_dir, "battle", gen_key + "." + file_type)

        if not overwrite and os.path.exists(dest):
            continue

        with open(dest, 'wb') as f:
            if 'http' not in url:
                # sometimes an image source can be relative
                # if it is provide the base url which also happens
                # to be the site variable atm.
                # url = '{}{}'.format(pre_url, url)
                pass

            response = requests.get(url)
            f.write(response.content)
        print("\t\tCreated %s_%s" % (number, pokemon_name))


def download_menu_sprites_from_url(url, overwrite=True):
    gen_key = os.path.basename(url)

    print("\tStarting %s" % gen_key)

    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')

    div = soup.find(id="spr_dump")
    tables = div.find_all("table")

    for table in tables:
        pokemon_name = parse_name(table.text)

        img = table.find("img")
        file_type = img["src"][-3:]
        url = "{}/{}".format(pre_url, img["src"])

        number = re.search("[0-9]{3}", os.path.basename(url))

        if not number:
            continue

        number = number.group()

        poke_dir = os.path.join(SPRITE_ROOT_DIR, "%s_%s" % (number, pokemon_name))
        if not os.path.exists(poke_dir):
            os.mkdir(poke_dir)

        if not os.path.exists(os.path.join(poke_dir, "menu")):
            os.mkdir(os.path.join(poke_dir, "menu"))

        dest = os.path.join(poke_dir, "menu", gen_key + "." + file_type)
        if not overwrite and os.path.exists(dest):
            continue

        with open(dest, 'wb') as f:
            if 'http' not in url:
                # sometimes an image source can be relative
                # if it is provide the base url which also happens
                # to be the site variable atm.
                # url = '{}{}'.format(pre_url, url)
                pass

            response = requests.get(url)
            f.write(response.content)
        print("\t\tCreated %s" % pokemon_name)


# Pulling battle sprites
for key, group in battle_sprite_urls.items():
    print("Starting %s" % key)

    for url in group:
        download_battle_sprites_from_url(url, overwrite=False)

for url in menu_sprite_urls:
    print("Starting %s" % url)

    download_menu_sprites_from_url(url, overwrite=False)

exit()

urls = []
for url in urls:
    filename = re.search(r'/([\w_-]+[.](jpg|gif|png))$', url)
    if not filename:
        print("Regex didn't match with the url: {}".format(url))
        continue
    # with open(os.path.join(image_folder, filename), 'wb') as f:
    #     if 'http' not in url:
    #         # sometimes an image source can be relative
    #         # if it is provide the base url which also happens
    #         # to be the site variable atm.
    #         url = '{}{}'.format(pre_url, url)
    #
    #     response = requests.get(url)
    #     f.write(response.content)
    # print(filename)
