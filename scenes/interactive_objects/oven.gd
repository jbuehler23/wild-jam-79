extends StaticBody2D

signal start_game()

func interact():
	start_game.emit()
