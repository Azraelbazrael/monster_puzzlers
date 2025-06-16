class_name PlayerCharacter
extends CharacterBody2D
signal player_dead
signal player_hit
signal player_hit_stop
signal player_hurt
signal player_unhurt

@onready var Camera: Camera2D = $Camera2D
@onready var hud_ui: VBoxContainer = $CanvasLayer/HUD_elements as Hud_UI
@onready var StateMachine: Node = $StateMachine as FiniteStateMachine

@export var speed = 350
@export var damage_label: PackedScene

@export var current_item: Item_resource:
	set(value):
		current_item = value
		if current_item != null:
			set_held_item(value)
		else:
			pass
		#	set_damage(1)
			
@export var character_stats: Character_stats: set = set_character_stats
#@export var s_timer := 1.5

var hurt_by
var target
var current_weapon
var stamina_cooldown := 1.5
var can_regen: bool
var can_start_timer: bool
var damage

func _ready() -> void:
	StateMachine.states = character_stats.states
	print(StateMachine.states)

func set_character_stats(value: Character_stats) -> void:
	character_stats = value.create_instance()
	update_character()
	
func update_character() -> void:
	if character_stats is not Character_stats:
		return
	if not is_inside_tree():
		await ready	
	update_stats()


func set_held_item(value: Item_resource) -> void:
	$Weapon/Weapon.weapon = current_item
	$Weapon/Weapon.texture = current_item.art
	$Weapon/Weapon.position = $Weapon/right_pos.position
	Global.emit_signal("weapon_changed")
	
	
	
func update_item() -> void:
	if current_item is not Item_resource:
		return
	if not is_inside_tree():
		await ready


func update_stats() -> void:
	hud_ui.update_stats(character_stats)
	

func _input(event):
	if event.is_action_pressed('scroll_up'):
		Camera.zoom = Camera.zoom + Vector2(0.1, 0.1)
	if event.is_action_pressed('scroll_down'):
		Camera.zoom = Camera.zoom - Vector2(0.1, 0.1)
	if event.is_action_pressed('E'):
		if current_item != null:
			emit_signal("player_hit")

func start(_position, _direction):
	
	rotation = _direction
	position = _position
	velocity = Vector2.ZERO
	

	
func _process(delta: float) -> void:
	
	if character_stats.health == 0:
		Global.emit_signal("player_died")	
		var screenlayer = get_tree().current_scene.get_node("ScreenLayers")
		if screenlayer:
			screenlayer.show()
	
	#print(current_item)
	update_stats()



		
			
func _physics_process(delta):
	
	var input_vector: Vector2 = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		 Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	velocity = input_vector*15000*delta
	move_and_slide()
	
	if velocity.x < 0:
			$Sprite2D.flip_h = true
			if current_item !=null:
				$Weapon/Weapon.position = $Weapon/left_pos.position
				$Weapon/Weapon.scale.x = -1
	elif velocity.x > 0:
			$Sprite2D.flip_h = false
			if current_item !=null:
				$Weapon/Weapon.position = $Weapon/right_pos.position
				$Weapon/Weapon.scale.x = 1

			
#func set_damage(amount):
#	if current_item != null:
	#	$Weapon/Weapon/Hitbox.damage = amount
	#else:
	#	pass 

		
func add_item(item):
	var inventory = $CanvasLayer/HUD_elements/BottomContainer/VboxContainer/MarginContainer/Inventory/Slot_Container/Inventory_Slots
	
	if inventory:
		inventory.add_item(item)


func _check_hurtbox(area: Area2D) -> void:
	
	if area.get_parent().is_in_group("Enemy"):
		hurt_by = area.get_parent()
		emit_signal("player_hurt")
		
	elif area.get_parent().is_in_group("Projectile"):
		hurt_by = area.get_parent()
		emit_signal("player_hurt")

func _on_hurtbox_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("Enemy"):
		hurt_by = null
		emit_signal("player_unhurt")

func _add_dmg_label():	
	damage = damage_label.instantiate()
	add_child(damage)
	damage.position = $text_pos.position
	damage.find_child("Label").text = str(hurt_by.stats.damage)


func _on_hitbox_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Enemy"):
		target = area.get_parent()
	if area.get_parent().is_in_group("Rock"):
		target = area.get_parent()
		#print("HURTING", target)

func _on_hitbox_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("Enemy"):
		target = null
	if area.get_parent().is_in_group("Rock"):
		target = null
