extends Area3D

signal trigger()
signal pressed()
signal released()

enum { OPTION_OFF_ON_EXIT = 1, OPTION_ONCE = 2 }

@export var properties: Dictionary :
	get:
		return properties # TODOConverter40 Non existent get function 
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()

var is_pressed = false
var base_translation = Vector3.ZERO
var axis := Vector3.DOWN
var speed := 8.0
var depth := 0.8
var release_delay := 0.0
var trigger_signal_delay :=  0.0
var press_signal_delay :=  0.0
var release_signal_delay :=  0.0
var trigger_state = Trigger.TRIGGER_STATE_TOGGLE
var once = false
var trigger_on_exit = false

var overlaps := 0

func update_properties() -> void:
	if 'axis' in properties:
		axis = properties.axis.normalized()

	if 'speed' in properties:
		speed = properties.speed

	if 'depth' in properties:
		var map = QodotHelpersEx.get_map(self)
		depth = float(properties.depth) / map.inverse_scale_factor

	if 'release_delay' in properties:
		release_delay = properties.release_delay

	if 'trigger_signal_delay' in properties:
		trigger_signal_delay = properties.trigger_signal_delay

	if 'press_signal_delay' in properties:
		press_signal_delay = properties.press_signal_delay

	if 'release_signal_delay' in properties:
		release_signal_delay = properties.release_signal_delay

	if &'triggerstate' in properties:
		trigger_state = properties.triggerstate
		
	if &'options' in properties:
		once = properties.options & OPTION_ONCE > 0
		trigger_on_exit = properties.options & OPTION_OFF_ON_EXIT > 0

func _init() -> void:
	monitorable = true
	connect("body_shape_entered", body_shape_entered)
	connect("body_shape_exited", body_shape_exited)

func _enter_tree() -> void:
	base_translation = position

func _process(delta: float) -> void:
	var target_position = base_translation + (axis * (depth if is_pressed else 0.0))
	position = position.lerp(target_position, speed * delta)

func body_shape_entered(body_id, body: Node, body_shape_idx: int, self_shape_idx: int) -> void:
	if body is StaticBody3D:
		return

	if overlaps == 0:
		press()

	overlaps += 1

func body_shape_exited(body_id, body: Node, body_shape_idx: int, self_shape_idx: int) -> void:
	if body is StaticBody3D:
		return

	overlaps -= 1
	if overlaps == 0:
		if release_delay == 0:
			release()
		elif release_delay > 0:
			await get_tree().create_timer(release_delay).timeout
			release()

func press() -> void:
	if is_pressed:
		return

	is_pressed = true

	emit_trigger()
	emit_pressed()

func emit_trigger() -> void:
	await get_tree().create_timer(trigger_signal_delay).timeout
	trigger.emit({ "sender": self, "trigger_state": trigger_state })

func emit_pressed() -> void:
	await get_tree().create_timer(press_signal_delay).timeout
	pressed.emit({ "sender": self, "trigger_state": trigger_state })

func release() -> void:
	if not is_pressed:
		return

	is_pressed = false

	await get_tree().create_timer(release_delay).timeout
	if trigger_on_exit:
		trigger.emit({ "sender": self, "trigger_state": Trigger.TRIGGER_STATE_OFF })
	released.emit({ "sender": self, "trigger_state": trigger_state })
