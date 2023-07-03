@tool
class_name PlayerEntity
extends QodotEntity

var player_node: MovementController = null

func update_properties():
	if not Engine.is_editor_hint():
		return

	for child in get_children():
		remove_child(child)
		child.queue_free()
		
	var scene = load(&"res://player/Player.tscn") as PackedScene
	player_node = scene.instantiate()
		
	if &'angle' in properties:
		player_node.rotate(Vector3.UP, deg_to_rad(180 + properties[&"angle"]))
		
	print(player_node)
	add_child(player_node)
	
	if is_inside_tree():
		var tree = get_tree()
		if tree:
			var edited_scene_root = tree.get_edited_scene_root()
			if edited_scene_root:
				player_node.set_owner(edited_scene_root)
