extends PanelContainer

@onready var coin_label: Label = $MarginContainer/VBoxContainer/Coins/CoinLabel

func _ready() -> void:
	coin_label.text = str(CurrencyManager.coins)
	CurrencyManager.coins_changed.connect(on_coins_changed)

func on_coins_changed(new_coins: int) -> void:
	coin_label.text = str(new_coins)
