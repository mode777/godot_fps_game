extends RayCast3D

var pickup: RigidBody3D = null
var pickup_damp = 0.0
var pickup_inertia = Vector3.ZERO
var pickup_rotation = 0.0
var count_dist = 0
var pickup_offset = Vector3.ZERO;

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
			
			var rotDiff = pickup_rotation - (pickup.rotation.y - %Head.global_rotation.y)
			#print(rotDiff)
			pickup.apply_torque(Vector3(0,rotDiff*20,0))
			pickup.angular_velocity *= 0.9
	else:
		var collider = get_collider()
		Events.debug.emit("Raycast", collider)
		if collider != null:
			var p2 = get_viewport().get_camera_3d().unproject_position(collider.global_position)
			Events.show_cursor.emit(collider.name, p2)
		else:
			Events.show_cursor.emit('',Vector2.ZERO)			
		
		
		var c = collider as RigidBody3D
		if c:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				pickup_offset = get_collision_point() - c.global_position
				pickup = c as RigidBody3D
				pickup_damp = pickup.linear_damp
				pickup_inertia = pickup.inertia
				pickup.linear_damp = 10
				pickup.inertia = Vector3.ONE
				pickup_rotation = pickup.rotation.y - %Head.global_rotation.y
