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
	BREWER
}

enum postings {
	SLIMES_WANTED,
	ESCORTS_WANTED
}

enum seasons {
	WINTER,
	SPRING,
	FALL
	SUMMER
}

var staff = {
	actions.BREWER: 1
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

var festivals = {
	seasons.WINTER: [
		festival.new("Gladiator Games", 15, {things.ALE: 2, things.POTIONS: 2})
	],
	seasons.SPRING: [
		festival.new("Gladiator Games", 15, {things.ALE: 2, things.POTIONS: 2})
	],
	seasons.SUMMER: [
		festival.new("Gladiator Games", 15, {things.ALE: 2, things.POTIONS: 2})
	],
	seasons.FALL: [
		festival.new("Gladiator Games", 15, {things.ALE: 2, things.POTIONS: 2})
	],
}

class festival:
	var title:String
	var day:int
	var supplies:Dictionary
	
	func _init(new_title, new_day, new_supplies):
		title=new_title
		day=new_day
		supplies=new_supplies

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
