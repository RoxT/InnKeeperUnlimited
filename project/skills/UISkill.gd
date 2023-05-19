tool
extends Control

const Skill := preload("res://skills/RSkill.gd")
export var skill_r:Resource setget set_skill
var skill:Skill

onready var SkillDialogScene := preload("res://skills/SkillDialogScene.tscn")
onready var title_label := $VBox/HBox/TitleLabel
onready var batch_label := $VBox/BatchLabel
onready var progress := $VBox/HBox/TextureProgress
onready var level_up_btn := $VBox/LevelUpBtn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(skill_r != null)
	skill = skill_r
	var err := level_up_btn.connect("pressed", self, "_on_level_up_btn_pressed")
	if err != OK: push_error(str(err))
	title_label.owner = self
	batch_label.owner = self
	progress.owner = self
	level_up_btn.owner = self
	update()
	
func _enter_tree() -> void:
	update()

func update():
	if !skill:
		return
	title_label.text = skill.title
	batch_label.text = skill.get_batch_text()
	var ex = skill.ex
	var next = skill.next
	progress.value = ex
	progress.max_value = next
	progress.get_node("Label").text = str(ex) + "/" + str(next)
	progress.get_node("Label").modulate = Color.white if ex*2 < next else Color.black
	level_up_btn.text = "Level up " + skill.title
	level_up_btn.disabled = !skill.is_ready()

func set_skill(value:Resource):
	assert(value is Skill)
	skill_r = value
	if skill:
		skill = value
		update()
	
func _on_level_up_btn_pressed():
	skill.level_up()
	var dialog = SkillDialogScene.instance()
	get_node("/root").add_child(dialog)
	dialog.show_text(skill)
	update()
	
