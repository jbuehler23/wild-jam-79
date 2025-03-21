extends CanvasLayer

func _ready() -> void:
	visible = false

func _on_cutting_board_start_game() -> void:
	visible = true


func _on_quick_slice_minigame_finished(result: Variant) -> void:
	visible = false
