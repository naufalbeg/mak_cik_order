# Food illustrations

The 54 food pictures in `assets/images/foods/` are drawn in code (SVG) by these scripts.

- `prims.py` – shared pieces: plates, bowls, banana leaf, rice, noodles, prawns, chillies, herbs…
- `foods_a.py`, `foods_b.py`, `foods_c.py` – one function per food, named after the food id.

To change or add a dish, edit/add its function, then run (needs Python 3, `pip install playwright pillow`, `playwright install chromium`):

    python tool/food_art/render.py assets/images/foods food_sheet.png            # all foods
    python tool/food_art/render.py assets/images/foods food_sheet.png akok satay # only some

Each PNG is auto-cropped and saved at 256×256 with a transparent background.
A new food only needs a PNG named `<food id>.png` — the game picks it up automatically.

## Characters and backgrounds

- `characters.py` – Mak Cik (neutral / happy / worried) and 10 customers (neutral / happy / angry).
- `scenes.py` – one stall background per state plus the home-screen scene.

    python tool/food_art/render_art.py characters assets/images/characters
    python tool/food_art/render_art.py scenes     some_folder   # then save as JPG into assets/images/backgrounds/

Backgrounds are used as `bg_<stateId>.jpg`. A new state only needs its own `bg_<stateId>.jpg`.
