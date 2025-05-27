extends CharacterBody2D
class_name EnemyCharacter

signal dead_enemy
signal taking_dmg
var damaged: bool


@export var debug_line: Line2D
@export var stats: Stats: set = set_stats
@export var damage_label: PackedScene
@export var hurtbox: Area2D
@export var knockback_mod: float = 0.1
@export var stateMachine: Node
@export var nav_agent: NavigationAgent2D
@export var player_detect: Area2D

#@export var targ_pos: Marker2D

var target
var tilemap: TileMap
var astar_grid = AStarGrid2D.new()
var current_path: Array[Vector2i]
#var home_pos: Vector2i

signal player_found

func _ready():
	$Sprite2D.texture = stats.art
	knockback_mod = stats.knockbak_mod
	
	astar_grid.region = tilemap.get_used_rect()
	astar_grid.cell_size = Vector2(tilemap.TILESIZE,tilemap.TILESIZE)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.update()
	
	
	for cell in tilemap.get_used_cells_by_id(0,1):
		astar_grid.set_point_solid(cell, true)
	
	
func get_point_path():
	current_path = astar_grid.get_id_path(tilemap.local_to_map(global_position), tilemap.local_to_map(target.global_position))
	
func set_stats(value: Stats) -> void:
	stats = value.create_instance()
	stateMachine.actor = self
	stateMachine.states = stats.states
	update_monster()



func update_monster() -> void:
	if stats is not Stats:
		return
	if not is_inside_tree():
		await ready	


func take_damage(amount):
	emit_signal("taking_dmg")
	stats.take_damage(amount)
	damaged = true
	var damage = damage_label.instantiate()
	
	damage.find_child("Label").text = str(amount)
	damage.position = position
	get_tree().current_scene.add_child(damage)
	damaged = false


func _process(_delta):
	
	#debug_line.points = nav_agent.get_current_navigation_path()
	if stats.health == 0:
		emit_signal("dead_enemy")
		
	if velocity.x < 0: ## flips sprite based on direction
			$Sprite2D.flip_h = true

	elif velocity.x > 0:
			$Sprite2D.flip_h = false

func _physics_process(delta: float) -> void:

	move_and_collide(velocity * delta)

func _on_dead_enemy() -> void:
	visible = false
	queue_free()


func knockback(dmg_source_pos: Vector2, received_dmg: float):
	var knockback_dir = dmg_source_pos.direction_to(self.global_position)
	var knockback_strng = received_dmg * knockback_mod
	var knckback = knockback_dir * knockback_strng
	
	self.global_position += knckback

	
func _on_hurtbox_area_entered(hitbox: Area2D) -> void:
	if hitbox.get_parent().is_in_group("Weapon"):
		knockback(hitbox.get_parent().global_position, hitbox.get_parent().hitbox.damage)


func _on_player_detection_area_entered(targ_d: Area2D) -> void:
	if targ_d.get_parent().is_in_group("Player"):
		target = targ_d.get_parent()
		get_point_path()
		player_found.emit()
		
		print("entered: ", target)
		


func _on_player_detection_area_exited(targ_d: Area2D) -> void:
	if targ_d.get_parent().is_in_group("Player"):
		target = null
		current_path.clear()
		print("exited: ", target)
