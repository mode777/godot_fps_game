@tool
extends PhysicsEntity
class_name PhysicsEntityEx

var frozen_velocity = Vector3.ZERO
var frozen_avelocity = Vector3.ZERO

func _ready():
	connect("body_entered", on_collide)
	
func on_collide(node: Node):
	print(node)

func update_properties():
	if 'freeze' in properties:
		freeze = false if properties['freeze'] == 0 else true
		
	if 'velocity' in properties:
		if freeze:
			frozen_velocity = properties['velocity']
		else:  
			linear_velocity = properties['velocity'] 

	if 'mass' in properties:
		mass = properties.mass
	
	if 'sleeping' in properties:
		sleeping = false if properties['sleeping'] == 0 else true
		
	if 'avelocity' in properties:
		if freeze:
			frozen_avelocity = properties['avelocity']
		else:  
			angular_velocity = properties['avelocity']

func use():
	angular_velocity = frozen_avelocity
	linear_velocity = frozen_velocity
	freeze = false
