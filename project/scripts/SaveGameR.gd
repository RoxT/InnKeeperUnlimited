class_name SaveGame
extends Resource

const PATH := "user://save1.tres"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

export var coins:int = 10
export var ale := 0
export var slimes := 0
export var potions = 0
export var hp := 0
export var patrons := 3
export var turns := 0 setget set_turns

static func new_game():
	return load("res://resources/new_game.tres").duplicate()

func set_turns(value:int):
	turns = value
	var err := ResourceSaver.save(PATH, self)
	if err != OK:
		push_error("Error saving to : " + PATH + " error code: " +str(err))
