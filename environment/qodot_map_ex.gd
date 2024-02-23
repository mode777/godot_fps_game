@tool
class_name QodotMapEx
extends QodotMap

@export var is_precompiled: bool = false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready!!")
	connect(&"build_complete", post_process)
	
func post_process():
	walk_tree(self)
	unwrap_uv2()
	
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
	for i in range(0, mesh.mesh.get_surface_count()):
		var mat := mesh.mesh.surface_get_material(i) as StandardMaterial3D
		if(mat):
			mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS_ANISOTROPIC

func process_physics(p: PhysicsEntity):
	var child = p.get_child(0) as MeshInstance3D
	if child:
		child.gi_mode = GeometryInstance3D.GI_MODE_DYNAMIC
