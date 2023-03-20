extends Node

onready var inn := $Inn
onready var dialog:Node =  preload("res://DialogScene.tscn").instance()
onready var skills: = preload("res://Skills.tscn").instance()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialog.connect("dialog_finished", self, "on_dialog_finished")
	skills.connect("back_to_inn", self, "_on_back_to_inn")
	inn.connect("made_ale", self, "_on_made_ale")

func _on_made_ale():
	skills.ale_making._skill_up()

func _on_back_to_inn():
	remove_child(skills)
	inn.ale_batch = skills.ale_making.level + 10
	add_child(inn)

func _on_SkillsBtn_pressed():
	remove_child(inn)
	add_child(skills)
	
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
	add_child(dialog)
	dialog.request_ready()
	

	
