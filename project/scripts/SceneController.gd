extends Node

onready var DialogScene = preload("res://DialogScene.tscn")
onready var inn := $Inn
onready var dialog:Node = DialogScene.instance()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
	
func on_dialog_finished():
	remove_child(dialog)
	S.update_visible()
	add_child(inn)

func _on_DialogBtn_pressed() -> void:
	if !S.has_rest && S.has_ale:
		inn.hp = 0
		inn.get_node("buttons/ale").disabled = true
	inn.get_node("DialogBtn").visible = false
	remove_child(inn)
	dialog = DialogScene.instance()
	add_child(dialog)
	dialog.connect("dialog_finished", self, "on_dialog_finished")
