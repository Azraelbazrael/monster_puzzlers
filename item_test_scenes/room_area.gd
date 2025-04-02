extends Area2D
signal placed(object)
@onready var collision_shape = $CollisionShape2D


func _input(event):

	if event.is_action_pressed('ui_select'): ## space_bar
		emit_signal("placed", self)
