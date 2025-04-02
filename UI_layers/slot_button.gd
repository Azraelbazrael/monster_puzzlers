extends Slot

#func get_preview():
	#print("test: ", item)
	#var preview_texture = TextureRect.new()
	#preview_texture.texture = texture_rect.texture
	#preview_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	#preview_texture.custom_minimum_size = Vector2(20,20)
 
	#var preview = Control.new()
	#preview.add_child(preview_texture)
	#preview_texture.position = -0.5 * Vector2(20,20)
 
	#return preview

#func _on_button_pressed() -> void:
#	recipe_handler.item = item


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed('click'):
		var grid = $"../../../../RecipeContainers/MarginContainer/Craft_grid"
		grid.item = item
