class_name IngredientSlot
extends Panel

@onready var texture_rect: TextureRect = %TextureRect
@export var ingredient: Ingredient

var is_selected: bool = false
var is_highlighted: bool = false

var base_modulate = null

func _ready() -> void:
	texture_rect.texture = ingredient.texture
	base_modulate = self.modulate

func get_is_selected() -> bool:
	return is_selected
	
func toggle_selection():
	is_selected = !is_selected
	update_visuals()

func set_highlight(highlight: bool):
	is_highlighted = highlight
	update_visuals()
	
func update_visuals():
	if is_selected:
		modulate = Color(0.5, 1.0, 0.5)
		if is_highlighted:
			modulate.a = 0.5
	elif is_highlighted:
		modulate.a = 0.5
	else:
		modulate = base_modulate


func set_ingredient(new_ingredient : Ingredient) -> void:
	ingredient = new_ingredient
	texture_rect.texture = ingredient.texture
