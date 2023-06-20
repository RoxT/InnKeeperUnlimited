extends VBoxContainer

var game:SaveGame

export var title:String
export(String, FILE, "*.png") var icon
export var season:String
export var day:int
export var description:String
const help_notes := "FESTIVAL_HELP_NOTES"
export(Array, S.things) var supplies
export var amount := 10
var id:int
var festival:FestivalR

onready var options := $Dialog_VBox/Options
onready var dialog := $Dialog_VBox
onready var arrow := $OfficeAction/Arrow
onready var togo := $Dialog_VBox/ToGo
onready var reset := $Dialog_VBox/Options/Reset

signal changed

func init(f, season:String):
	id = f.id
	title = f.title
	self.season = season
	day = f.day
	description = f.title
	supplies = f.supplies
	icon = f.icon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in options.get_children():
		c.queue_free()
	reset = Button.new()
	reset.text = "Remove All"
	reset.connect("pressed", self, "on_reset_btn_pressed")
	for supply in supplies:
		var name_str:String = S.things.keys()[supply]
		var btn := Button.new()
		btn.text = "Add " + str(amount) + " " + name_str.capitalize()
		btn.name = S.things.keys()[supply]
		options.add_child(btn, true)
		var err := btn.connect("pressed", self, "_on_button_pressed", [name_str])
		if err != OK: push_error("connect err: " + str(err))
	refresh()
	dialog.hide()
		
func refresh():
	var shipped := day == game.get_date().day - 1
	reset.disabled = shipped
	for c in options.get_children():
		if S.things.has(c.name):
			var count := game.get_thing_count(c.name)
			c.disabled = count < amount
	togo.text = "To go"
	if shipped: togo.text += " (shipped)"
	togo.text += ": "
	var shipping := game.get_festival_supplies(id) # supply:String : {amount:int}
	var thing := S.thing(supplies[0])
	togo.text += str(shipping[thing]) + " " + thing
	if supplies.size() == 2:
		thing = S.thing(supplies[1])
		togo.text += " and " + str(shipping[thing]) + " " + thing
		
	
func on_reset_btn_pressed():
	game.reset_festival_supplies(id)
	refresh()
	emit_signal("changed")

func _on_button_pressed(supply:String):
	game.store_festival_supplies(id, supply, amount)
	refresh()
	emit_signal("changed")


func _on_OfficeAction_toggled(button_pressed: bool) -> void:
	dialog.visible = button_pressed
	arrow.flip_h = !button_pressed
