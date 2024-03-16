@tool
class_name EnvironmentEntity
extends QodotEntity

func update_properties():
	var map = get_map_root()
	print("Game dir %s"%map.game_dir)
		
	var node = WorldEnvironment.new()
	var env = Environment.new()
	env.background_mode = Environment.BG_SKY
	env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	env.ambient_light_sky_contribution = properties["ambient_light"]
	env.ssao_enabled = false if properties["enable_ao"] == 0 else true
	var sky = Sky.new()
	var mat = PanoramaSkyMaterial.new()
	var loader = map.texture_loader as QodotTextureLoaderEx
	mat.panorama = loader.load_texture_from_file("%s/skies/%s.png"%[map.game_dir,properties["sky"]])
	mat.filter = false if properties["sky_filter"] == 0 else true
	
	sky.sky_material = mat
	env.sky = sky
	node.environment = env
	
	#node.environment = load("res://environment/presets/default.tres")
	get_parent().add_child(node)
	

		
	if is_inside_tree():
		var tree = get_tree()
		if tree:
			var edited_scene_root = tree.get_edited_scene_root()
			if edited_scene_root:
				node.set_owner(edited_scene_root)

func get_map_root(node: Node = self) -> QodotMapEx:
	if node is QodotMapEx:
		return node as QodotMapEx
	else:
		return get_map_root(node.get_parent())
