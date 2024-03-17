extends CharacterBody3D

@export var properties: Dictionary :
	get:
		return properties # TODOConverter40 Non existent get function 
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()

var base_transform: Transform3D
var offset_transform: Transform3D
var target_transform: Transform3D
var is_reverse = false

var speed := 1.0

func update_properties() -> void:
	var map = QodotHelpersEx.get_map(self)
	
	if 'translation' in properties:
		offset_transform.origin = ((properties.translation as Vector3)/map.inverse_scale_factor).rotated(Vector3.UP, deg_to_rad(-90))

	if 'rotation' in properties:
		offset_transform.basis = offset_transform.basis.rotated(Vector3.RIGHT, deg_to_rad(properties.rotation.x))
		offset_transform.basis = offset_transform.basis.rotated(Vector3.UP, deg_to_rad(properties.rotation.y))
		offset_transform.basis = offset_transform.basis.rotated(Vector3.FORWARD, deg_to_rad(properties.rotation.z))

	if 'scale' in properties:
		offset_transform.basis = offset_transform.basis.scaled(properties.scale)

	if 'speed' in properties:
		speed = properties.speed

func _process(delta: float) -> void:
	transform = transform.interpolate_with(target_transform, speed * delta)

func _ready() -> void:
	base_transform = transform
	target_transform = base_transform

func use() -> void:
	if not is_reverse:
		play_motion()
	else:
		reverse_motion()
	is_reverse = not is_reverse

func play_motion() -> void:
	target_transform = base_transform * offset_transform

func reverse_motion() -> void:
	target_transform = base_transform
