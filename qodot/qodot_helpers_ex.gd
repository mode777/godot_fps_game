@tool
extends RefCounted
class_name QodotHelpersEx

static func get_map(node: Node) -> QodotMapEx:
	if node is QodotMapEx:
		return node as QodotMapEx
	else:
		return get_map(node.get_parent())
