extends VBoxContainer

export var save_game_override:Resource
var game:SaveGame
var loaded := false

onready var dialog := $Dialog_VBox
onready var arrow := $OfficeAction/Arrow
onready var take_down := $Dialog_VBox/Options/TakeDown
onready var post_button := $Dialog_VBox/Options/Post

onready var go_button := $OfficeAction
onready var title := $Dialog_VBox/Title
onready var desc := $Dialog_VBox/Desc

const TITLE = "title"
const DESC = "desc"

var posts := {
	S.postings.SLIMES_WANTED: {TITLE: "Slimes Wanted - 2 coins each", DESC: "Slimes killed and brought in, increasing road safety"},
	S.postings.ESCORTS_WANTED: {TITLE: "Escorts Wanted - 20 coins per day", DESC: "Greatly increases road saftey while active"}
	
}

export(S.postings) var post:= S.postings.SLIMES_WANTED setget set_post

signal post_action (is_active, post)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not game: game = save_game_override if save_game_override else SaveGame.new_game()
	_button_toggled(false)
	take_down.connect("pressed", self, "_on_TakeDown_pressed")
	post_button.connect("pressed", self, "_on_post_pressed")
	go_button.text = posts[post].title
	title.text = posts[post].title
	desc.text = posts[post].desc
	loaded = true
	
func _enter_tree() -> void:
	if loaded: init()
	
func init():
	if game.active_posts.find(post):
		post_button.hide()
		take_down.show()
	else:
		take_down.hide()
		post_button.show()

func _on_post_pressed():
	game.active_posts.erase(post)
	_button_toggled(false)
	emit_signal("post_action", true, S.postings.get(post))
		
func _on_TakeDown_pressed():
	game.active_posts.append(post)
	_button_toggled(false)
	emit_signal("post_action", false, S.postings.get(post))
		
	
func set_post(value:int):
	post = value
	if game:
		go_button.text = posts[post].title
		title.text = posts[post].title
		desc.text = posts[post].desc


func _button_toggled(button_pressed:bool):
	if button_pressed:
		dialog.show()
		arrow.flip_h = true
		go_button.pressed = true
		
	else:
		dialog.hide()
		arrow.flip_h = false
		go_button.pressed = false

func _exit_tree() -> void:
	_button_toggled(false)

func _on_OfficeAction_toggled(button_pressed: bool) -> void:
	_button_toggled(button_pressed)
	

