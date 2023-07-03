@tool
class_name QodotMapEx
extends QodotMap


# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready!!")
	connect(&"build_complete", fix_textures)
	
func fix_textures():
	print(material_dict.is_empty())
	var mesh: MeshInstance3D = get_node("entity_0_worldspawn/entity_0_mesh_instance")
	for i in range(0, mesh.mesh.get_surface_count()):
		var mat := mesh.mesh.surface_get_material(i) as StandardMaterial3D
		if(mat):
			mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS_ANISOTROPIC
	

