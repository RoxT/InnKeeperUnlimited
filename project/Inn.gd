extends Node2D

var coins:int = 10
var ale := 0
var slimes := 0
var potions = 0
var hp := 0
var max_hp := 3

var patrons := 3
var turns := 0

var rng = RandomNumberGenerator.new()
var coin:Texture = load("res://textures/coin.png")
var coin_minus:Texture = load("res://textures/coin_minus.png")
var slime:Texture = load("res://textures/slime.png")
onready var made_today := $today/MadeToday

var total_ale := 0.0
var total_slimes := 0.0
var total_potions := 0.0

var ale_batch := 10

signal made_ale

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

func _enter_tree():
	$today/Patrons.visible = S.has_ale
	$buttons/ale.visible = S.has_ale
	$stock/ale.visible = S.has_ale
	$today/Ale.visible = S.has_ale
	$buttons/rest.visible = S.has_rest
	$stock/hp.visible = S.has_rest
	$stock/slimes.visible = S.has_slimes
	$today/Slimes.visible = S.has_slimes
	$buttons/potion.visible = S.has_potions
	$stock/potions.visible = S.has_potions
	$today/Potions.visible = S.has_potions
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func pass_time():
	turns += 1
	var ale_drank = 0
	var potions_bought = 0
	var slimes_brought = 0
	if S.has_ale:
		#Random int of ale drank most likely the number of patrons, min 0
		ale_drank = clamp(round (rng.randfn(patrons, 3)), 0, ale)
		ale -= ale_drank
		coins += ale_drank
		$today/Ale.text = "Ale drank: " + str(ale_drank)
		adjust_children(ale_drank, $today/Ale/Pos, coin)
		total_ale += ale_drank
		$stock/ale.text = "Ale: " + str(ale)
		if !S.has_rest && ale > 30:
			$DialogBtn.visible = true
		elif !S.has_slimes && ale > 50:
			$DialogBtn.visible = true
	
	if S.has_potions:
		#Random int of potions bought most likely half number of patrons, min 0
		potions_bought = clamp(round (rng.randfn(round(patrons/2.0), 3)), 0, potions)
		potions -= potions_bought
		coins += potions_bought
		$today/Potions.text = "Potions bought: " + str(potions_bought)
		adjust_children(potions_bought, $today/Potions/Pos, coin)
		total_potions += potions_bought
		$stock/potions.text = "Potions: " + str(potions)
		if potions > 30:
			$DialogBtn.visible = true

	if S.has_slimes:
		#Random int of slimes returned most likely a third of the number of patrons, min 0
		slimes_brought = clamp(round (rng.randfn(round(patrons/3.0), 3)), 0, coins/2)
		coins -= slimes_brought*2
		slimes += slimes_brought
		$today/Slimes.text = "Slimes returned: " + str(slimes_brought)
		adjust_children(slimes_brought*2, $today/Slimes/Pos_Coins, coin_minus)
		adjust_children(slimes_brought, $today/Slimes/Pos_Slimes, slime)
		total_slimes += slimes_brought
		$stock/slimes.text = "Slimes: " + str(slimes)
		if !S.has_potions && slimes > 70:
			$DialogBtn.visible = true
	
	if S.has_rest:
		hp -= 1
		$stock/hp.text = "HP: " + str(hp)
		
	$buttons/ale.disabled = coins <= 1 || (S.has_rest && hp <= 0)
	$buttons/potion.disabled = coins <= 0 || slimes <= 1 || hp <= 0
	$stock/coins.text = "Coins: " + str(coins)
	
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
	ale += ale_batch
	emit_signal("made_ale")
	made_today.text = "Made " + str(ale_batch) + " ales"
	pass_time()


func _on_potion_pressed():
	coins -= 1
	slimes -= 2
	potions += 10
	made_today.text = "Made 10 potions"
	pass_time()


func _on_rest_pressed():
	if hp >= max_hp: 
		hp =max_hp + 2 
	else: 
		hp = max_hp + 1
	made_today.text = "Rested"
	pass_time()

