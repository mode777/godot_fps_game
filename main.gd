extends Node3D


#-----------------SCENE--SCRIPT------------------#
#    Close your game faster by clicking 'Esc'    #
#   Change mouse mode by clicking 'Shift + F1'   #
#------------------------------------------------#

@export var fast_close := true
@export var default_map: String = "maya"
@export var editor_game_dir: String = "./build"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if !OS.is_debug_build():
		fast_close = false
	
	if fast_close:
		print("** Fast Close enabled in the 'L_Main.gd' script **")
		print("** 'Esc' to close 'Shift + F1' to release mouse **")
	
	set_process_input(fast_close)
	var usr_args = OS.get_cmdline_user_args()
	Events.debug.emit("usr_args", usr_args)
		
	var map = default_map
	var game_dir = editor_game_dir if OS.has_feature('editor') else "."
	
	if(usr_args.size() > 0):
		map = usr_args[0]
	Events.debug.emit("map", map)
	for ext in ["scn", "tscn", "map"]:
		var map_path = "%s/maps/%s.%s" % [ game_dir, map, ext ]
		var res_path = "res://maps/%s.%s" % [ map, ext ]
		print("Testing %s.%s" % [map,ext])
		if (ext == "scn" or ext == "tscn") and ResourceLoader.exists(res_path):
			Level.load_scn(self, res_path)
			return
		elif FileAccess.file_exists(map_path):
			Level.load_map(self, map_path, "%s/textures" % game_dir)
			return

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		get_tree().quit() # Quits the game
		
	if event.is_action_pressed(&"maximize"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	
	if event.is_action_pressed(&"change_mouse_input"):
		match Input.get_mouse_mode():
			Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Capture mouse if clicked on the game, needed for HTML5
# Called when an InputEvent hasn't been consumed by _input() or any GUI item
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
