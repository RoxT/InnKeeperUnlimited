extends VBoxContainer

onready var dialog := $Dialog_VBox
onready var arrow := $OfficeAction/Arrow


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_button_toggled(true)

signal buy_action (cost_amount, cost_type, action_type)

func _button_toggled(button_pressed:bool):
	if button_pressed:
		dialog.show()
		arrow.flip_h = true
	else:
		dialog.hide()
		arrow.flip_h = false

func _on_Ale100Btn_pressed() -> void:
	emit_signal("buy_action", 100, S.things.ALE, S.actions.TRAINEE)
	_button_toggled(false)


func _on_Coin100Btn_pressed() -> void:
	emit_signal("buy_action", 100, S.things.COINS, S.actions.TRAINEE)
	_button_toggled(false)


func _on_OfficeAction_toggled(button_pressed: bool) -> void:
	_button_toggled(button_pressed)
