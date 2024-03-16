@tool
extends EditorScript

var game_path = "./build"
var map_name = "maya"

func export_map():
	EditorInterface.open_scene_from_path("res://test.tscn")
	var map = EditorInterface.get_edited_scene_root() as QodotMapEx
	map.export_map()

# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	export_map()
