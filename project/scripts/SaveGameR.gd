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
export var turns := 1
export var brewers := 1
export(float, 1.0) var slime_density := 1.0 setget set_slime_density
export var active_posts := []
export(Array, Resource) var festivals_this_month

static func new_game():
	return load("res://resources/new_game.tres").duplicate()

func save_game():
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

func store_festival_supplies(festival_id:int, supply:String, amount:int):
	var found = false
	for f in festivals_this_month:
		f = f as FestivalR
		if f.id == festival_id:
			f.add_amount(supply, amount)
			found = true
			break
	assert(found, str(festival_id) + " not found after " + get_date().get_date_string())
	change_thing_count(supply, -amount)

func remove_festival(f:FestivalR):
	festivals_this_month.erase(f)
	

func reset_festival_supplies(festival_id:int):
	for f in festivals_this_month:
		if f.id == festival_id:
			f = f as FestivalR
			for s in f.supplies:
				change_thing_count(S.thing(s), f.amounts_saved[S.thing(s)])
			f.reset()

# supply:String : {amount:int}
func get_festival_supplies(festival_id:int)->Dictionary:
	for f in festivals_this_month:
		if f.id == festival_id:
			return f.amounts_saved
	assert(false, str(festival_id) + " not found after " + get_date().get_date_string())
	return {}

func get_date()->DATE:
	return DATE.new(turns)
	
class DATE:
	var season:int
	var day:int
	var year:int
	const DAYS_PER_SEASON := 10
	func _init(turn:int):
		var turn_of_year = turn % (DAYS_PER_SEASON*4)
		if turn_of_year+1 <= DAYS_PER_SEASON:
			season = S.seasons.WINTER
		elif turn_of_year+1 <= (DAYS_PER_SEASON*2):
			season = S.seasons.SPRING
		elif turn_of_year+1 <= (DAYS_PER_SEASON*3):
			season = S.seasons.SUMMER
		elif turn_of_year+1 <= (DAYS_PER_SEASON*4):
			season = S.seasons.FALL
		day = turn_of_year % DAYS_PER_SEASON + 1
		year = 700 + int(turn/(DAYS_PER_SEASON*4))

	func get_date_string()->String:
		var string := str(day) + " of " + tr(get_season_label()) + ", " + str(year)
		return string
		
	func get_season_label()->String:
		return S.seasons.keys()[season]
		
func get_todays_festival()->FestivalR:
	for f in festivals_this_month:
		if f.day == get_date().day:
			return f
	return null
				
	
