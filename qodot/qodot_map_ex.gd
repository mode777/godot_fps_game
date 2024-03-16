@tool
class_name QodotMapEx
extends QodotMap

@export var export: bool:
	get:
		return false
	set(v):
		print("test")
		export_map() 
		
@export var export_folder: String = "res://maps"
var export_path: String = "res://exported.scn"

var game_dir: String = "."
	
var enable_compression: bool = true
var config: ConfigFile = null

# Called when the node enters the scene tree for the first time.
func _ready():
	connect(&"build_complete", post_process)
	
func post_process():
	walk_tree(self)
	#unwrap_uv2()
	
func process_node(n: Node):
	if n is MeshInstance3D:
		process_mesh(n)
	if n is PhysicsEntity:
		process_physics(n)
		
func walk_tree(n: Node):
	for child in n.get_children():
		process_node(child)
		walk_tree(child)

func process_mesh(mesh: MeshInstance3D):
	pass
	#for i in range(0, mesh.mesh.get_surface_count()):
		#var mat := mesh.mesh.surface_get_material(i) as StandardMaterial3D
		#if(mat):
			#mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS_ANISOTROPIC

func process_physics(p: PhysicsEntity):
	var child = p.get_child(0) as MeshInstance3D
	if child:
		child.gi_mode = GeometryInstance3D.GI_MODE_DYNAMIC

func init_texture_loader() -> QodotTextureLoader:
	var tex_ldr := QodotTextureLoaderEx.new(
		base_texture_dir,
		texture_file_extensions,
		texture_wads
	)
	tex_ldr.enable_compression = config.get_value("Textures", "enable_compression", true)
	print("Texture compression enabled: %s"%tex_ldr.enable_compression)
	var mat = default_material as StandardMaterial3D
	var tex_filter = config.get_value("Textures", "filter", 5)
	mat.texture_filter = tex_filter
	print("Texture filter: %s"%mat.texture_filter)
	tex_ldr.unshaded = unshaded
	return tex_ldr

func update_tree(n: Node, owner: Node):
	if n.owner == null:
		n.owner = owner
	for c in n.get_children():
		update_tree(c, owner)

func export_map():
	export_path = "%s/%s.scn" % [export_folder, map_file.get_basename().get_file()]
	qodot = preload("res://addons/qodot/src/core/qodot.gd").new()
	build_map()
	await build_complete
	unwrap_uv2()
	#await unwrap_uv2_complete
	
	#var n = Node3D.new()
	#n.name = "map"
	#for child in get_children():
		#child.reparent(n)
		#update_tree(child, n)
		
	var lm = LightmapGI.new()
	add_child(lm)
	lm.owner = self
		
	#await get_tree().process_frame
	var packed = PackedScene.new()
	packed.pack(self)
	print("Exporting scene to %s..." % export_path)
	if ResourceSaver.save(packed, export_path) == Error.OK:
		print("Export successful!")
	#reset_build_context()
	
	remove_children()
