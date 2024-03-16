@tool
extends EditorScript

# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	# Get directory to iterate over textures
	var dir_path = "./textures/polyhaven"
	
	# Open directory
	var directory = DirAccess.open(dir_path)
	directory.list_dir_begin()
	# Iterate over files
	var file = directory.get_next()
	while file != null:
		if directory.current_is_dir() or file.get_extension() != "png":
			file = directory.get_next()
			continue
			
		var file_path = dir_path + "/" + file
		print("Processing %s" % file_path)
		# Load texture
		var texture = Image.load_from_file(file_path)
		
		# Resize texture
		if texture.get_width() > 128:
			texture.resize(texture.get_width() / 8, texture.get_height() / 8)
		
		# Save resized texture
		texture.save_png(file_path)
		
		# Clean up
		texture.unreference()
		file = directory.get_next()
	
	# Close directory
	directory.close()
