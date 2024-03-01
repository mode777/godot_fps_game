@tool
extends EditorScript

# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	var image = Image.load_from_file("./../tiles01.png")
	image.compress(Image.COMPRESS_S3TC, Image.COMPRESS_SOURCE_SRGB)
	var tex = ImageTexture.create_from_image(image)
	print(ResourceSaver.save(tex, "./tiles.res", ResourceSaver.FLAG_NONE))
	#var resource = ResourceLoader.load("res://textures/env/floor/tiles01.png", "CompressedTexture2D", ResourceLoader.CACHE_MODE_IGNORE)
	print(tex)
	pass
