extends Control

onready var UISkill := preload("res://skills/UISkill.tscn")
onready var RSkillSet := preload("res://skills/RSkillSet.gd")
onready var RSkill := preload("res://skills/RSkill.gd")
onready var ui_skills := $Margin/VBox/Skills

export var skills_r:Resource setget set_skills
var skills:SkillSet

signal back_to_inn
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for s in skills.get_all():
		var ui_skill := UISkill.instance()
		ui_skill.skill_r = s
		ui_skills.add_child(ui_skill)
		
func set_skills(value:Resource):
	assert(value is SkillSet)
	skills = value

func _on_BackToInn_pressed() -> void:
	emit_signal("back_to_inn")

func any_ready()->bool:
	return skills.any_ready()
	
func skill_up(skill_name:int)->bool:
	return skills.skill_up(skill_name)
	
func get_batch_sizes()->S.Batch:
	return skills.get_batch_sizes()
