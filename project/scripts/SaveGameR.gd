class_name SaveGame
extends Resource

const PATH := "user://save1.tres"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

export var coins:int = 10
export var ale := 0
export var slimes := 0 setget set_slimes
export var potions = 0
export var hp := 0
export var patrons := 3
export var turns := 1 setget set_turns
export var brewers := 1
export(float, 1.0) var slime_density := 1.0 setget set_slime_density
export var active_posts := []

static func new_game():
	return load("res://resources/new_game.tres").duplicate()

func set_turns(value:int):
	turns = value
	var err := ResourceSaver.save(PATH, self)
	if err != OK:
		push_error("Error saving to : " + PATH + " error code: " +str(err))

func set_slimes(value:int):
	var diff := value - slimes
	set_slime_density(slime_density - diff*0.05)
	slimes = value
	
func set_slime_density(value:float):
	slime_density = clamp(slime_density, 0, 1.0)
	
func get_thing_count(thing:String)->int:
	match (S.things[thing]):
		S.things.ALE: return ale
		S.things.COINS: return coins
		S.things.POTIONS: return potions
		S.things.REST: return hp
		_: 
			push_error("Thing not found! " + thing)
			return -1

func change_thing_count(thing:String, amount:int):
	match (S.things[thing]):
		S.things.ALE: ale += amount
		S.things.COINS: coins += amount
		S.things.POTIONS: potions += amount
		S.things.REST: hp += amount
		_: 
			push_error("Thing not found! " + thing)
	
	
class DATE:
	var season:int
	var day:int
	var year:int
	const DAYS_PER_SEASON := 30
	func _init(turn:int):
		var date = turn % 40 + 1
		if date <= 10:
			season = S.seasons.WINTER
		elif date <= 20:
			season = S.seasons.SPRING
		elif date <= 30:
			season = S.seasons.SUMMER
		elif date <= 40:
			season = S.seasons.FALL
		day = turn % 40 % DAYS_PER_SEASON + 1
		year = 700 + int(turn/40)

	func get_date_string()->String:
		return str(day) + " of " + tr(get_season_label()) + ", " + str(year)
		
	func get_season_label()->String:
		return S.seasons.keys()[season]
		
				
	
