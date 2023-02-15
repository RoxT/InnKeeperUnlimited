extends Control

var dialogs = [
	"HEllo I' a text\n[b]HEllo I' a text[/b]\n[i]HEllo I' a text[/i]",
	"I'm text too\n[b]I'm text too[/b]\n[i]I'm text too[/i]"
]

var current := 0

onready var default:RichTextLabel = $RichTextLabelDefault
onready var tiny:RichTextLabel = $RichTextLabelTiny
onready var labels = [default, tiny]

signal dialog_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default.bbcode_enabled = true
	tiny.bbcode_enabled = true
	show_text()


func show_text():
	for label in labels:
		label = label as RichTextLabel
		label.bbcode_text = (dialogs[current])



func _on_Next_pressed() -> void:
	current += 1
	if current < dialogs.size():
		show_text()
	else:
		emit_signal("dialog_finished")
