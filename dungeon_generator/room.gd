extends RigidBody2D

var size
@onready var collision: CollisionShape2D = $CollisionShape2D

func make_room(_pos, _size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.custom_solver_bias = .5
	s.extents = size
	$CollisionShape2D.shape = s
