extends VBoxContainer

export var save_game_override:Resource
var game:SaveGame
var loaded := false

export var title:String
export var icon:Texture
export var season:String
export var day:String
export var description:String
const help_notes := "FESTIVAL_HELP_NOTES"
export(Array, S.things) var supplies
export var amount := 10

onready var options := $Dialog_VBox/Options

signal supply_added

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in options.get_children():
		c.queue_free()
	for supply in supplies:
		var btn := Button.new()
		btn.text = "Add " + str(amount) + " " + S.things.keys()[supply].capitalize()
		btn.name = S.things.keys()[supply]
		options.add_child(btn, true)
		var err := btn.connect("pressed", self, "_on_button_pressed", [S.things.keys()[supply]])
		if err != OK: push_error("connect err: " + str(err))
	if !game: game = save_game_override
	refresh()
	loaded = true
		
func refresh():
	for c in options.get_children():
		if S.things.has(c.name):
			var count := game.get_thing_count(c.name)
			c.disabled = count < amount

func _on_button_pressed(supply:String):
	game.change_thing_count(supply, amount)
	refresh()
	emit_signal("supply_added")
