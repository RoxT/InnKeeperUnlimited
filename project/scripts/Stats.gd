extends Node


var current_event := 0

enum events {
	OPENING,
	REST,
	REWARDS,
	POTIONS,
	END
}

var has_rest := false
var has_ale := false
var has_slimes := false
var has_potions := false
var ale_penalty := 0
var ready_to_level := []

var road_quality := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func update_visible():
	match current_event-1:
		0: has_ale = true
		1: has_rest = true
		2: has_slimes = true
		3: has_potions = true
		var x: print("unknown event number: " + str(x))
