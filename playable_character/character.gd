class_name PlayerCharacter
extends CharacterBody2D
signal player_dead

@onready var Camera: Camera2D = $Camera2D
@onready var hud_ui: VBoxContainer = $CanvasLayer/HUD_elements as Hud_UI

@export var speed = 350
@export var damage_label: PackedScene

@export var current_item: Item_resource:
	set(value):
		current_item = value
		if current_item != null:
			set_held_item(value)
		else:
			set_damage(1)
			
@export var character_stats: Character_stats: set = set_character_stats
#@export var s_timer := 1.5


var current_weapon
var stamina_cooldown := 1.5
var can_regen: bool
var can_start_timer: bool

var can_be_damaged: bool
var can_attack: bool


func set_character_stats(value: Character_stats) -> void:
	character_stats = value.create_instance()
	can_be_damaged = true
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
	
func start(_position, _direction):
	
	rotation = _direction
	position = _position
	velocity = Vector2.ZERO
	

func get_input():
	var input_dir = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down') 
	velocity = input_dir * speed
	if Input.is_action_just_pressed('click'):
		if current_item != null:
			$Weapon/Weapon.use_weapon()
			current_item.use_cost(character_stats)

		
func _process(delta: float) -> void:
	
	if character_stats.health == 0:
		Global.emit_signal("player_died")	
		var screenlayer = get_tree().current_scene.get_node("ScreenLayers")
		if screenlayer:
			screenlayer.show()
				
	check_hitbox()
	update_stats()


	
func check_hitbox():
	#var hitbox_areas = $Hurtbox.get_overlapping_areas()
	var damage = damage_label.instantiate()
	
	#var amount: float
	#if hitbox_areas:
	#	var hitbox = hitbox_areas.front()
	#	if hitbox.get_parent() is EnemyCharacter:
		#	var enemy = hitbox.get_parent()
		#	amount = hitbox.get_parent().stats.damage
			#if can_be_damaged && !enemy.damaged:
			#	character_stats.take_damage(amount)	
			#	damage.find_child("Label").text = str(amount)
			#	damage.position = position
			#	get_tree().current_scene.add_child(damage)
				#take_damage_cooldown(1.5)

func take_damage_cooldown(wait_time):
	can_be_damaged = false
	await get_tree().create_timer(wait_time).timeout
	can_be_damaged = true
		
			
func _physics_process(delta):
	
	get_input()
	#
	move_and_collide(velocity * delta) 
	
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

			
func set_damage(amount):
	if current_item != null:
		$Weapon/Weapon/Hitbox.damage = amount
	else:
		pass 
		
func add_item(item):
	var inventory = $CanvasLayer/HUD_elements/BottomContainer/VboxContainer/MarginContainer/Inventory/Slot_Container/Inventory_Slots
	
	if inventory:
		inventory.add_item(item)
