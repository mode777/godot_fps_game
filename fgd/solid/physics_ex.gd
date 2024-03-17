@tool
extends PhysicsEntity
class_name PhysicsEntityEx

var frozen_velocity = Vector3.ZERO
var frozen_avelocity = Vector3.ZERO

enum { OPTIONS_FREEZE = 1 }

func _ready():
	connect("body_entered", on_collide)
	
func on_collide(node: Node):
	print(node)

func update_properties():
	if 'options' in properties:
		freeze = properties['options'] & OPTIONS_FREEZE > 0
		
	if 'velocity' in properties:
		if freeze:
			frozen_velocity = properties['velocity']
		else:  
			linear_velocity = properties['velocity'] 

	if 'mass' in properties:
		mass = properties.mass
		
	if 'avelocity' in properties:
		if freeze:
			frozen_avelocity = properties['avelocity']
		else:  
			angular_velocity = properties['avelocity']

func use():
	angular_velocity = frozen_avelocity
	linear_velocity = frozen_velocity
	freeze = false
