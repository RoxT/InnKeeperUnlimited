extends VBoxContainer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



var festivals = {
	S.seasons.WINTER: [
		festival.new("Gladiator Games", 15, [S.things.ALE, S.things.POTIONS])
	],
	S.seasons.SPRING: [
		festival.new("Gladiator Games", 15, [S.things.ALE, S.things.POTIONS])
	],
	S.seasons.SUMMER: [
		festival.new("Gladiator Games", 15, [S.things.ALE, S.things.POTIONS])
	],
	S.seasons.FALL: [
		festival.new("Gladiator Games", 15, [S.things.ALE, S.things.POTIONS])
	],
}

class festival:
	var title:String
	var day:int
	var supplies:Array
	
	func _init(new_title, new_day, new_supplies:Array):
		title=new_title
		day=new_day
		supplies=new_supplies
