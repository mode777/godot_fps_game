@tool
class_name LightEnvironmentEntity
extends QodotEntity

var node: DirectionalLight3D = null

func update_properties():
		
	node = DirectionalLight3D.new()
	node.transform = transform
	var _name = name
	name = "%s_" % _name
	node.name = _name
	
	node.shadow_enabled = true

	if &'pitch' in properties:
		node.rotate(Vector3.RIGHT, deg_to_rad(properties[&'pitch']))
		
	if &'angle' in properties:
		node.rotate(Vector3.UP, deg_to_rad(properties[&"angle"]+180))
		
	if &'energy' in properties:
		node.light_energy = properties[&'energy']
	
	get_parent().add_child(node)
	
	if is_inside_tree():
		var tree = get_tree()
		if tree:
			var edited_scene_root = tree.get_edited_scene_root()
			if edited_scene_root:
				node.set_owner(edited_scene_root)
