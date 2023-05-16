#Autoloaded Stats
extends Node

enum events {
	OPENING,
	REST,
	REWARDS,
	POTIONS,
	END
}

enum things {
	ALE,
	POTIONS, 
	REST,
	COINS
}

enum actions {
	TRAINEE
}

var has_rest := false
var has_ale := false
var has_slimes := false
var has_potions := false
var ale_penalty := 0
var ready_to_level := []

var road_quality := 0

class Batch:
	var ale :=0
	var potion :=0
	var rest := 0
	func init(ale_n, potion_n, rest_n):
		ale = ale_n
		potion = potion_n
		rest = rest_n

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func update_visible(key:int):
	match key:
		events.OPENING: has_ale = true
		events.REST: has_rest = true
		events.REWARDS: has_slimes = true
		events.POTIONS: has_potions = true
		var x: print("unknown event number: " + str(x))
