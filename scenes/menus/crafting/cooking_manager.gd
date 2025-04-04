extends PanelContainer
@onready var grid_container: GridContainer = %GridContainer
@onready var recipe_slot: RecipeSlot = %RecipeSlot
@onready var score_multiplier_label: Label = %ScoreMultiplierLabel



var inventory_slots: Array[IngredientSlot]

var selected_index: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if inventory_slots.is_empty():
		for child in grid_container.get_children():
			if child is IngredientSlot:
				inventory_slots.append(child as IngredientSlot)
		
func _input(event: InputEvent) -> void:
	var prev_index = selected_index
	
	if event.is_action_pressed("move_right"):
		selected_index = min(selected_index + 1, inventory_slots.size())
	elif event.is_action_pressed("move_left"):
		selected_index = max(selected_index - 1, 0)
	elif event.is_action_pressed("move_down"):
		selected_index = min(selected_index + grid_container.columns, inventory_slots.size())
	elif event.is_action_pressed("move_up"):
		selected_index = max(selected_index - grid_container.columns, 0)
	elif event.is_action_pressed("interact"):
		var current_ingredient = inventory_slots[selected_index]
		if (current_ingredient.get_is_selected()):
			recipe_slot.remove_ingredient(current_ingredient)
		else:
			recipe_slot.add_ingredient(current_ingredient)
		inventory_slots[selected_index].toggle_selection()
		
		if recipe_slot.get_current_recipe() != null:
			score_multiplier_label.text = "Score Multiplier: " + str(recipe_slot.get_current_recipe().score_multiplier)
		
	if selected_index != prev_index:
		update_visuals()
	
func update_visuals():
	for i in range(inventory_slots.size()):
		inventory_slots[i].set_highlight(i == selected_index)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
