class_name RecipeSlot
extends Panel

@onready var texture_rect: TextureRect = %TextureRect
var spoiled_food = preload("res://resources/cooking/recipes/spoiled_food.tres")

@export var known_recipes: Array[Recipe]

var selected_ingredients: Array[Ingredient]
var current_recipe: Recipe = null

func add_ingredient(ingredient_slot: IngredientSlot):
	selected_ingredients.append(ingredient_slot.ingredient)
	check_for_valid_recipe()

func remove_ingredient(ingredient_slot: IngredientSlot):
	selected_ingredients.erase(ingredient_slot.ingredient)
	check_for_valid_recipe()
	
func check_for_valid_recipe():
	for recipe in known_recipes:
		if check_name(selected_ingredients, recipe.ingredients):
			current_recipe = recipe
			texture_rect.texture = recipe.texture
		else:
			texture_rect.texture = spoiled_food

func check_name(arr1: Array[Ingredient], arr2: Array[Ingredient]) -> bool:
	if arr1.size() != arr2.size():
		return false
	for element in arr1:
		if !arr2.has(element):
			return false
	return true

func get_current_recipe() -> Recipe:
	return current_recipe
