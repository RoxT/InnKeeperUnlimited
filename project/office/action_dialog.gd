extends VBoxContainer

onready var dialog := $Dialog_VBox
onready var arrow := $OfficeAction/Arrow
onready var go_button := $OfficeAction


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_button_toggled(false)
	$Dialog_VBox/Options/Ale100Btn.connect("pressed", self, "_on_Ale100Btn_pressed")
	$Dialog_VBox/Options/Coin100Btn.connect("pressed", self, "_on_Coin100Btn_pressed")

signal buy_action (cost_amount, cost_type, action_type)

func _button_toggled(button_pressed:bool):
	if button_pressed:
		dialog.show()
		arrow.flip_h = true
		go_button.pressed = true
	else:
		dialog.hide()
		arrow.flip_h = false
		go_button.pressed = false

func _on_Ale100Btn_pressed() -> void:
	emit_signal("buy_action", 100, S.things.ALE, S.actions.BREWER)
	_button_toggled(false)


func _on_Coin100Btn_pressed() -> void:
	emit_signal("buy_action", 100, S.things.COINS, S.actions.BREWER)
	_button_toggled(false)


func _on_OfficeAction_toggled(button_pressed: bool) -> void:
	_button_toggled(button_pressed)
