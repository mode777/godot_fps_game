extends RayCast3D

var pickup: RigidBody3D = null
var pickup_damp = 0.0
var pickup_inertia = Vector3.ZERO
var pickup_rotation = Vector3.ZERO
var count_dist = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if pickup:
		var global_target = to_global(target_position)
		var diff = (global_target - pickup.global_position)
		var dist = diff.distance_squared_to(Vector3.ZERO)
		
		# object got stuck, count frames before dropping
		if dist > 30:
			count_dist += 1
			print(count_dist)
		else:
			count_dist = 0
		
		# drop object
		if count_dist > 20 or !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			pickup.linear_damp = pickup_damp
			pickup.inertia = pickup_inertia
			count_dist = 0
			pickup.angular_velocity = Vector3.ZERO
			pickup.linear_velocity = Vector3.ZERO			
			pickup = null
		else:
			var dir = diff.normalized()
			pickup.apply_force(dir * dist * 30)
			pickup.angular_velocity *= 0.5
			#var rotDiff = pickup_rotation - pickup.rotation
			#var rotDist = rotDiff.distance_squared_to(Vector3.ZERO)
			#print(rotDiff)
			##pickup.apply_torque(rotDiff * 500 * rotDist)
	else:
		var c = get_collider() as RigidBody3D
		if c and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			pickup = c
			pickup_damp = pickup.linear_damp
			pickup_inertia = pickup.inertia
			pickup.linear_damp = 10
			pickup.inertia = Vector3.ONE
			pickup_rotation = pickup.rotation
