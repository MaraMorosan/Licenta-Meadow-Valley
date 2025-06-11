extends Node

var coins: int = 0
signal coins_changed(new_coins: int)

func add_coins(amount: int) -> void:
	coins += amount
	emit_signal("coins_changed", coins)
