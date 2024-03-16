@tool
class_name PlayerEntity
extends QodotEntity

var player_node: MovementController = null

func update_properties():
		
	var scene = load(&"res://player/Player.tscn") as PackedScene
	player_node = scene.instantiate() as Node3D
		
	if &'angle' in properties:
		player_node.rotate(Vector3.UP, deg_to_rad(180 + properties[&"angle"]))
		
	player_node.transform = transform
	player_node.name = name
	get_parent().add_child(player_node)
	
	if is_inside_tree():
		var tree = get_tree()
		if tree:
			var edited_scene_root = tree.get_edited_scene_root()
			if edited_scene_root:
				player_node.set_owner(edited_scene_root)
