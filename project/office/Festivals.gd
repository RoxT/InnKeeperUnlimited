extends VBoxContainer

var Festival := preload("res://office/festival.tscn")
var loaded := false
var game:SaveGame
var season

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(game)
	refresh()
	loaded = true

func _enter_tree() -> void:
	if loaded:
		refresh()
		
func refresh():
	var date := game.get_date()
	if date.season != season:
		for c in get_children():
			c.queue_free()
		for f in festivals[date.season]:
			f = f as festival
			var post := Festival.instance()
			post.game = game
			post.init(f, tr("SEASONS" + str(season)))
			add_child(post)
		

var festivals = {
	S.seasons.WINTER: [
		festival.new(S.festivals.GLADIATOR, "Gladiator Games", 5, [S.things.ALE, S.things.POTIONS], "res://textures/event gladiator.png")
	],
	S.seasons.SPRING: [
		festival.new(S.festivals.GLADIATOR, "Gladiator Games", 5, [S.things.ALE, S.things.POTIONS], "res://textures/event gladiator.png")
	],
	S.seasons.SUMMER: [
		festival.new(S.festivals.GLADIATOR, "Gladiator Games", 5, [S.things.ALE, S.things.POTIONS], "res://textures/event gladiator.png")
	],
	S.seasons.FALL: [
		festival.new(S.festivals.GLADIATOR, "Gladiator Games", 5, [S.things.ALE, S.things.POTIONS], "res://textures/event gladiator.png")
	],
}

class festival:
	var id:int
	var title:String
	var day:int
	var supplies:Array
	var icon:String
	
	func _init(new_id:int, new_title, new_day, new_supplies:Array, new_icon:String):
		id = new_id
		title=new_title
		day=new_day
		supplies=new_supplies
		icon=new_icon
