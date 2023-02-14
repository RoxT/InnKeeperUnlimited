extends Node2D

var coins := 10
var ale := 10
var slimes := 0
var potions = 0

var patrons := 3
var turns := 0

var rng = RandomNumberGenerator.new()
var coin:Texture = load("res://textures/coin.png")
var coin_minus:Texture = load("res://textures/coin_minus.png")
var slime:Texture = load("res://textures/slime.png")

var total_ale := 0.0
var total_slimes := 0.0
var total_potions := 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func pass_time():
	turns += 1
	#Random int of ale drank most likely the number of patrons, min 0
	var ale_drank = max(0, round (rng.randfn(patrons, 3)))
	ale -= ale_drank
	coins += ale_drank
	$today/Ale.text = "Ale drank: " + str(ale_drank)
	adjust_children(ale_drank, $today/Ale/Pos, coin)
	#Random int of potions bought most likely half number of patrons, min 0
	var potions_bought = max(0, round (rng.randfn(round(patrons/2.0), 3)))
	potions -= potions_bought
	coins += potions_bought
	$today/Potions.text = "Potions bought: " + str(potions_bought)
	adjust_children(potions_bought, $today/Potions/Pos, coin)
	#Random int of slimes returned most likely a third of the number of patrons, min 0
	var slimes_brought = max(0, round (rng.randfn(round(patrons/3.0), 3)))
	coins -= slimes_brought*2
	slimes += slimes_brought
	$today/Slimes.text = "Slimes returned: " + str(slimes_brought)
	adjust_children(slimes_brought, $today/Slimes/Pos_Coins, coin_minus)
	adjust_children(slimes_brought, $today/Slimes/Pos_Slimes, slime)
	
	$stock/coins.text = "Coins: " + str(coins)
	$stock/slimes.text = "Slimes: " + str(slimes)
	$stock/ale.text = "Ale: " + str(ale)
	$stock/potions.text = "Potions: " + str(potions)
	
	total_ale += ale_drank
	total_potions += potions_bought
	total_slimes += slimes_brought
	print("average ale: " + str(round(total_ale/turns)) + " potions: " + str(round(total_potions/turns)) + " slimes: " + str(round(total_slimes/turns)))

func adjust_children(amt:int, node: Position2D, tex:Texture):
	var current := node.get_child_count()
	if amt > current:
		for i in amt-current:
			var sprite := Sprite.new()
			sprite.texture = tex
			node.add_child(sprite)
			sprite.position.x = -10 * (current + i)
			if tex == slime: sprite.scale = Vector2(0.7, 0.7)
	elif amt < current:
		for i in range(current, amt, -1):
			node.get_child(i-1).queue_free()

func _on_ale_pressed():
	coins -= 2
	ale += 10
	pass_time()


func _on_potion_pressed():
	coins -= 1
	slimes -= 2
	potions += 10
	pass_time()


func _on_rest_pressed():
	pass_time()
