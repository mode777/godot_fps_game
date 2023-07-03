@tool
class_name QodotFGDSolidClass
extends QodotFGDClass

enum SpawnType {
	WORLDSPAWN = 0, ## Is worldspawn
	MERGE_WORLDSPAWN = 1, ## Should be combined with worldspawn
	ENTITY = 2, ## Is its own separate entity
	GROUP = 3 ## Is a group
}

enum CollisionShapeType {
	NONE, ## Should have no collision shape
	CONVEX, ## Should have a convex collision shape
	CONCAVE ## Should have a concave collision shape
}

@export var spawn : String = QodotUtil.CATEGORY_STRING
## Controls whether a given SolidClass is the worldspawn, is combined with the worldspawn, or is spawned as its own free-standing entity
@export var spawn_type: SpawnType = SpawnType.ENTITY

@export var visual_build: String = QodotUtil.CATEGORY_STRING
## Controls whether a visual mesh is built for this SolidClass
@export var build_visuals := true

@export var collision_build : String = QodotUtil.CATEGORY_STRING
## Controls how collisions are built for this SolidClass
@export var collision_shape_type: CollisionShapeType = CollisionShapeType.CONVEX

@export var scripting: String = QodotUtil.CATEGORY_STRING
## The script file to associate with this SolidClass
## On building the map, this will be attached to any brush entities created via this classname
@export var script_class: Script

func _init():
	prefix = "@SolidClass"

func build_def_text() -> String:
	# Class prefix
	var res : String = prefix

	# Meta properties
	var base_str = ""
	var meta_props = meta_properties.duplicate()

	for base_class in base_classes:
		if not 'classname' in base_class:
			continue

		base_str += base_class.classname

		if base_class != base_classes.back():
			base_str += ", "

	if base_str != "":
		meta_props['base'] = base_str

	for prop in meta_props:
		var value = meta_props[prop]
		res += " " + prop + "("

		if value is AABB:
			res += "%s %s %s, %s %s %s" % [
				value.position.x,
				value.position.y,
				value.position.z,
				value.size.x,
				value.size.y,
				value.size.z
			]
		elif value is Color:
			res += "%s %s %s" % [
				value.r8,
				value.g8,
				value.b8
			]
		elif value is String:
			res += value

		res += ")"

	res += " = " + classname

	var normalized_description = description.replace("\n", " ").strip_edges()
	if normalized_description != "":
		res += " : \"%s\" " % [normalized_description]

	res += "[" + QodotUtil.newline()

	# Class properties
	for prop in class_properties:
		var value = class_properties[prop]

		var prop_val = null
		var prop_type := ""
		var prop_description: String = class_property_descriptions[prop] if prop in class_property_descriptions else ""

		if value is int:
			prop_type = "integer"
			prop_val = str(value)
		elif value is float:
			prop_type = "float"
			prop_val = "\"" + str(value) + "\""
		elif value is String:
			prop_type = "string"
			prop_val = "\"" + value + "\""
		elif value is Vector3:
			prop_type = "string"
			prop_val = "\"%s %s %s\"" % [
				value.x,
				value.y,
				value.z
			]
		elif value is Color:
			prop_type = "color255"
			prop_val = "\"%s %s %s\"" % [
				value.r8,
				value.g8,
				value.b8
			]
		elif value is Dictionary:
			prop_type = "choices"
			prop_val = "[" + "\n"
			for choice in value:
				var choice_val = value[choice]
				prop_val += "\t\t" + str(choice_val) + " : \"" + choice + "\"\n"
			prop_val += "\t]"
		elif value is Array:
			prop_type = "flags"
			prop_val = "[" + "\n"
			for arr_val in value:
				prop_val += "\t\t" + str(arr_val[1]) + " : \"" + str(arr_val[0]) + "\" : " + ("1" if arr_val[2] else "0") + "\n"
			prop_val += "\t]"
		elif value is NodePath:
			prop_type = "target_destination"
		elif value is Object:
			prop_type = "target_source"

		if(prop_val):
			res += "\t"
			res += prop
			res += "("
			res += prop_type
			res += ")"

			if not value is Array:
				res += " : \""
				res += prop_description
				res += "\" "

			if value is Dictionary or value is Array:
				res += " = "
			else:
				res += " : "

			res += prop_val
			res += QodotUtil.newline()

	res += "]" + QodotUtil.newline()

	return res
