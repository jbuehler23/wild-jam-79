extends CanvasLayer

func _ready() -> void:
	visible = false


func _on_cutting_board_start_game() -> void:
	visible = true
