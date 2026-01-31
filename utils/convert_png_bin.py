from PIL import Image

input_name = "gray4_640x480.png"
output_name = "stella.mem"

img = Image.open(input_name).convert("L")
pixels = img.load()

with open(output_name, "w") as f:
    for y in range(480):
        for x in range(640):
            val = pixels[x, y] >> 4  # 0–15
            f.write(f"{val:04b}\n")
