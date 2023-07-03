@tool
class_name EnvironmentEntity
extends QodotEntity

func update_properties():
	if not Engine.is_editor_hint():
		return

	for child in get_children():
		remove_child(child)
		child.queue_free()
		
	if &'resource' in properties:
		var node = WorldEnvironment.new()
		node.environment = load(properties[&'resource'])
		
		add_child(node)
	
		if is_inside_tree():
			var tree = get_tree()
			if tree:
				var edited_scene_root = tree.get_edited_scene_root()
				if edited_scene_root:
					node.set_owner(edited_scene_root)
