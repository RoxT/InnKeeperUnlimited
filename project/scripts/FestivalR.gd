class_name FestivalR
extends Resource

export(S.festivals) var id
export(Array, S.things) var supplies
export(Dictionary) var amounts_saved # supply:String : {amount:int}
export(int) var day
export(String, FILE, "*.png") var icon

func _init(p_id, p_supplies, p_day, p_icon):
	id = p_id
	supplies = p_supplies
	day = p_day
	icon = p_icon
	reset()

func add_amount(supply:String, amount:int):
	amounts_saved[supply] += amount

func reset():
	for s in supplies:
		amounts_saved[S.things.keys()[s]] = 0
