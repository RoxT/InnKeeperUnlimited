extends VBoxContainer

export var save_game_override:Resource
var game:SaveGame

onready var dialog := $Dialog_VBox
onready var arrow := $OfficeAction/Arrow
onready var go_button := $OfficeAction
onready var ale100 := $Dialog_VBox/Options/Ale100Btn
onready var coin100 := $Dialog_VBox/Options/Coin100Btn

signal buy_action (cost_amount, cost_type, action_type)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not game: game = save_game_override if save_game_override else SaveGame.new_game()
	_button_toggled(false)
	ale100.connect("pressed", self, "_on_Ale100Btn_pressed")
	coin100.connect("pressed", self, "_on_Coin100Btn_pressed")

func _button_toggled(button_pressed:bool):
	if button_pressed:
		dialog.show()
		arrow.flip_h = true
		go_button.pressed = true
		ale100.disabled = game.ale < 100
		coin100.disabled = game.coins < 100
		
	else:
		dialog.hide()
		arrow.flip_h = false
		go_button.pressed = false

func _exit_tree() -> void:
	_button_toggled(false)

func _on_Ale100Btn_pressed() -> void:
	emit_signal("buy_action", 100, S.things.ALE, S.actions.BREWER)
	game.ale -= 100
	game.brewers += 1
	_button_toggled(false)

func _on_Coin100Btn_pressed() -> void:
	emit_signal("buy_action", 100, S.things.COINS, S.actions.BREWER)
	game.coins -= 100
	game.brewers += 1
	_button_toggled(false)


func _on_OfficeAction_toggled(button_pressed: bool) -> void:
	_button_toggled(button_pressed)
