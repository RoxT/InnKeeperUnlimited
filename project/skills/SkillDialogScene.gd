extends Control


var skill:String
var level:int

onready var label:RichTextLabel = $MarginContainer/VBoxContainer/RichTextLabelTiny


signal dialog_finished (key)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func show_text(skill:Skill):
	label.text = ""
	label.add_text(tr(skill.label + str(skill.level)))
	label.newline()
	label.newline()
	label.add_text("New batch size: " + str(skill.batch_size) + " " + skill.plural)

func _on_Back_pressed() -> void:
	queue_free()

