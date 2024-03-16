@tool
class_name EnvironmentEntity
extends QodotEntity

func update_properties():
		
	var node = WorldEnvironment.new()
	#var env = Environment.new()
	#env.background_mode = Environment.BG_SKY
	#var sky = Sky.new()
	#sky.sky_material = ProceduralSkyMaterial.new()
	#env.sky = sky
	#node.environment = env
	
	node.environment = load("res://environment/presets/default.tres")
	get_parent().add_child(node)
	
	
	if is_inside_tree():
		var tree = get_tree()
		if tree:
			var edited_scene_root = tree.get_edited_scene_root()
			if edited_scene_root:
				node.set_owner(edited_scene_root)
