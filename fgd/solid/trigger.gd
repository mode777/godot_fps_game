extends Area3D
class_name Trigger

enum {TRIGGER_STATE_TOGGLE = 0, TRIGGER_STATE_ON = 1, TRIGGER_STATE_OFF = 2}
enum { OPTION_OFF_ON_EXIT = 1, OPTION_ONCE = 2 }

@export var properties: Dictionary :
	set(p):
		properties = p if properties.is_empty() else properties
		update_properties()

var delay: float = 0
var wait: float = 0
var triggerable = true
var once = false
var trigger_on_exit = false
var trigger_state = TRIGGER_STATE_TOGGLE

signal enter
signal exit

signal trigger()

func _ready():
	connect("body_entered", handle_body_entered)
	connect("body_exited", handle_body_exited)

func handle_body_entered(body: Node):
	if body is StaticBody3D:
		return	
	enter.emit({ "sender": self, "trigger_state": trigger_state })
	if not triggerable:
		#print("%s cannot be triggered"%name)
		return
	triggerable = false
	#print("triggered %s with delay of %s seconds"%[name,delay])
	await get_tree().create_timer(delay).timeout
	emit_signal("trigger", { "sender": self, "trigger_state": trigger_state })
	if not once:
		await get_tree().create_timer(wait).timeout	
		triggerable = true
	
func handle_body_exited(body: Node):
	if body is StaticBody3D:
		return
	exit.emit({ "sender": self, "trigger_state": trigger_state })	
	if trigger_on_exit:
		await get_tree().create_timer(delay).timeout
		emit_signal("trigger", { "sender": self, "trigger_state": TRIGGER_STATE_OFF })
	
func update_properties():
	if &'delay' in properties:
		delay = properties.delay
	if &'options' in properties:
		once = properties.options & OPTION_ONCE > 0
		trigger_on_exit = properties.options & OPTION_OFF_ON_EXIT > 0
	if &'wait' in properties:
		wait = properties.wait
	if &'triggerstate' in properties:
		trigger_state = properties.triggerstate
