extends Node

func load(parent: Node3D, file: String) -> Node3D:
	Events.start_loading.emit()
	var myNode = null
	if(file.get_extension() == "map"):
		var map = QodotMapEx.new()
		map.map_file = file
		map.entity_fgd = preload("res://my_fgd.tres")
		map.texture_file_extensions = PackedStringArray(["png"])
		map.base_texture_dir = "res://textures"
		map.brush_clip_texture = "proto/CLIP"
		map.qodot = preload("res://addons/qodot/src/core/qodot.gd").new()
		parent.add_child(map)
		map.build_map()
		await map.build_complete
		print("COMPLETE")
		myNode = map
	else:
		var scene = load(file).instantiate()
		parent.add_child(scene)
		myNode = scene
	Events.end_loading.emit()
	return myNode
	
