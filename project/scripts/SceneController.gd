extends Node

onready var inn := $Inn
onready var dialog:Node =  preload("res://DialogScene.tscn").instance()
onready var skills := preload("res://Skills.tscn").instance()
onready var office := preload("res://Office.tscn").instance()

var active_scene:Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialog.connect("dialog_finished", self, "on_dialog_finished")
	skills.connect("back_to_inn", self, "_on_back_to_inn")
	office.connect("back_to_inn", self, "_on_back_to_inn")
	inn.connect("made_ale", self, "_on_made_ale")
	inn.connect("time_passed", self, "_on_time_passed")
	inn.connect("no_ale", self, "on_no_ale")

func _on_made_ale():
	skills.ale_making._skill_up()
	
func _on_time_passed():
	S.ale_penalty = (S.ale_penalty-1) or 0
	
func on_no_ale():
	S.ale_penalty = 10

func _on_back_to_inn():
	remove_child(active_scene)
	inn.ale_batch = skills.ale_making.level + 10
	add_child(inn)

func _on_SkillsBtn_pressed():
	remove_child(inn)
	active_scene = skills
	add_child(skills)
	
func _on_OfficeBtn_pressed() -> void:
	remove_child(inn)
	active_scene = office
	add_child(office)
	
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
	dialog.show_text()

