@tool
extends Node2D
class_name VisualNode

@export_enum("Blue", "Red", "Green") var color: int = 0: set = _set_color
@export var sprite: Sprite2D

const COLORS = {
	0: Color.LIGHT_SKY_BLUE,
	1: Color.INDIAN_RED,
	2: Color.SEA_GREEN,
}

## The sprite of the visualnode.



func _set_color(new_value: int) -> void:
	color = new_value
	if sprite:

		sprite.modulate = COLORS[color]
