extends Control

var debug_dialogs = [
	"HEllo I' a text\n[b]HEllo I' a text[/b]\n[i]HEllo I' a text[/i]",
	"I'm text too\n[b]I'm text too[/b]\n[i]I'm text too[/i]"
]

var guild_name = "Inn Keeper Unlimited"

var events := {
	S.events.OPENING: ["Welcome to the cooperative " + guild_name + ", your daily tasks mainly involve brewing ale to sell in your bar. Every day you can choose one action to take. For now you can only brew ale but new options will open later. It will cost you two coins to make 10 mugs of ale. Every day patrons will visit the bar and buy some number of mugs. The more patrons, the more drinks likely to be sold. You can see your current stock of coins and ale at the top, and the day's happening including how much you made under 'Today'."],
	S.events.REST: ["You are tired from making ale every day. You can now take the action to Rest. Every day you take an action, it will drain some HP (hospitality points). You can spend the day resting to recover your HP to it's maximum. If you rest two days in a row you will get an extra HP (maximum one)"]
}

var page := 0
onready var current:int = S.current_event

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
	var label = tiny as RichTextLabel
	label.bbcode_text = (events[current][page])


func show_debug_text():
	for label in labels:
		label = label as RichTextLabel
		label.bbcode_text = (debug_dialogs[page])

func _on_Next_pressed() -> void:
	page += 1
	if page < events[current].size():
		show_text()
	else:
		S.current_event += 1
		emit_signal("dialog_finished")
