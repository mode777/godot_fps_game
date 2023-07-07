extends Area3D

var target: RigidBody3D = null
@onready var head = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", on_collision)
	connect("body_exited", off_collision)
	
func on_collision(n: Node):
	if n is RigidBody3D:
		target = n as RigidBody3D
		print("enter:" + str(n))
		var direction = (target.global_position-head.global_position).normalized()		
		target.constant_force = direction * 50
		

func off_collision(n: Node):
	if n == target:
		target.constant_force = Vector3.ZERO
		target = null
		print("leave:" + str(n))
		

func _physics_process(delta):
	pass
	#if target != null and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#print()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
