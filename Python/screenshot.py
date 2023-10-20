import bot_mmap
import io
import json

import cv2
import numpy
from PIL import Image, ImageFile

def get_screenshot_from_mmap() -> Image:
    screenshot = Image.open(
        io.BytesIO(bot_mmap.load_mmap("pokemon-bot-screenshot", convert_json=False))
        )
    screenshot = cv2.cvtColor(numpy.array(screenshot), cv2.COLOR_BGR2RGB)
    return screenshot

if __name__ == "__main__":
    #      x    y   w   h
    box = [0, 90, 40, 50]
    while True:
        image = get_screenshot_from_mmap()
        print(image.shape)
        image = image[box[1]:box[1] + box[3], box[0]:box[0] + box[2]]
        cv2.imshow("screenshot", image)
        if cv2.waitKey(25) & 0xFF == ord('q'):
            break

    result = Image.fromarray(image)
    result.save("Resources/ImageAnchors/fight_menu.png")
    print(image)