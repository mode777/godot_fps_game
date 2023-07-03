@tool
class_name LightEnvironmentEntity
extends QodotEntity

var node: DirectionalLight3D = null

func update_properties():
	if not Engine.is_editor_hint():
		return

	for child in get_children():
		remove_child(child)
		child.queue_free()
		
	node = DirectionalLight3D.new()
	node.shadow_enabled = true
		
	if &'pitch' in properties:
		node.rotate(Vector3.RIGHT, deg_to_rad(properties[&'pitch']))
		
	if &'angle' in properties:
		node.rotate(Vector3.UP, deg_to_rad(180 + properties[&"angle"]))
	
	add_child(node)
	
	if is_inside_tree():
		var tree = get_tree()
		if tree:
			var edited_scene_root = tree.get_edited_scene_root()
			if edited_scene_root:
				node.set_owner(edited_scene_root)
