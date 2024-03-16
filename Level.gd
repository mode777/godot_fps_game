extends Node

static var is_precompiled: bool = false

func load_map(parent: Node3D, file: String, texture_dir: String) -> Node3D:
	Events.start_loading.emit()
	var map = QodotMapEx.new()
	map.map_file = file
	map.entity_fgd = preload("res://fgd/my_fgd.tres")
	map.texture_file_extensions = PackedStringArray(["png","jpg","jpeg","exr"])
	map.base_texture_dir = texture_dir 
	map.brush_clip_texture = "proto/CLIP"
	map.qodot = preload("res://addons/qodot/src/core/qodot.gd").new()
	is_precompiled = false
	parent.add_child(map)
	map.build_map()
	await map.build_complete
	Events.end_loading.emit()
	return map
	
func load_scn(parent: Node3D, file: String) -> Node3D:
	print("Loading %s" % file)
	Events.start_loading.emit()	
	var scene = load(file).instantiate()
	is_precompiled = true
	parent.add_child(scene)
	Events.end_loading.emit()
	return scene	

	
