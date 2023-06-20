extends Node2D


var batch:S.Batch
var game:SaveGame

var rng = RandomNumberGenerator.new()
var coin:Texture = load("res://textures/coin.png")
var coin_minus:Texture = load("res://textures/coin_minus.png")
var slime:Texture = load("res://textures/slime.png")
onready var made_today := $today/MadeToday

#stats
var total_ale := 0.0
var total_slimes := 0.0
var total_potions := 0.0


signal made_ale
signal made_potions
signal rested
signal time_passed
signal no_ale
signal event_happened (key)

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
	var ale_drank = 0
	var potions_bought = 0
	var slimes_brought = 0
	var patrons_delta = 0
	var direction = 0

	if S.road_quality > 0:
		#Random number of new patrons, most likely 1 if # is lower than road quality
		#Affected by penalties and boons
		if S.ale_penalty > 0: 
			direction -= 1
		else:
			if game.patrons <= S.road_quality: 
				direction += 1
		patrons_delta = round (rng.randfn(direction, 3))
		game.patrons = max(game.patrons + patrons_delta, 0)
		$today/Patrons.text = "Patrons: " + str(game.patrons)

	if S.has_ale:
		#Random int of ale drank most likely the number of patrons, min 0
		var ale_desired := 0
		var current_ale := game.ale
		if game.patrons == 0:
			ale_drank = 0
		else:
			ale_desired = round (rng.randfn(game.patrons, 3))
			if ale_desired > current_ale: emit_signal("no_ale")
			ale_drank = clamp(ale_desired, 0, current_ale)
		game.ale -= ale_drank
		game.coins += ale_drank
		$today/Ale.text = "Ale drank: " + str(ale_drank)
		adjust_children(ale_drank, $today/Ale/Pos, coin)
		total_ale += ale_drank
		
		if !S.has_rest && game.ale > 30:
			$DialogBtn.visible = true
			emit_signal("event_happened", S.events.REST)
		elif !S.has_slimes && game.ale > 70:
			$DialogBtn.visible = true
			emit_signal("event_happened", S.events.REWARDS)
	
	if S.has_potions:
		#Random int of potions bought most likely 1/4 number of patrons, min 0
		potions_bought = clamp(round (rng.randfn(round(game.patrons/4.0), 3)), 0, game.potions)
		game.potions -= potions_bought
		game.coins += potions_bought
		$today/Potions.text = "Potions bought: " + str(potions_bought)
		adjust_children(potions_bought, $today/Potions/Pos, coin)
		total_potions += potions_bought
		$stock/potions.text = "Potions: " + str(game.potions)
		if game.potions > 30:
			$DialogBtn.visible = true
			emit_signal("event_happened", S.events.END)

	if S.has_slimes:
		# Random int of slimes returned most likely a quarter of the number of patrons
		# min 0. max by coins
		# multiplied by pop factor
		slimes_brought = game.patrons/4.0
		slimes_brought = round(rng.randfn(slimes_brought, 3) * game.slime_density)
		slimes_brought = clamp(slimes_brought, 0, game.coins/2)
		game.coins -= slimes_brought*2
		game.slimes += slimes_brought
		$today/Slimes.text = "Slimes returned: " + str(slimes_brought)
		adjust_children(slimes_brought*2, $today/Slimes/Pos_Coins, coin_minus)
		adjust_children(slimes_brought, $today/Slimes/Pos_Slimes, slime)
		total_slimes += slimes_brought
		S.road_quality = min(S.road_quality + slimes_brought, 25)
		game.slime_density += 0.05
		$stock/slimes.text = "Slimes: " + str(game.slimes)
		if !S.has_potions && game.slimes > 70 && game.patrons >= 30:
			$DialogBtn.visible = true
			emit_signal("event_happened", S.events.POTIONS)
	
	if S.has_rest:
		game.hp -= 1
		$stock/hp.text = "HP: " + str(game.hp)
		

	
	#print("average ale: " + str(round(total_ale/game.turns+1)) + " potions: " + str(round(total_potions/game.turns+1)) + " slimes: " + str(round(total_slimes/game.turns+1)) + " patrons_delta: " + str(patrons_delta) + " popularity: " + str(direction))
	
	emit_signal("time_passed")
	
func update_stock():
	$buttons/ale.disabled = game.coins < 2 || (S.has_rest && game.hp <= 0)
	$buttons/potion.disabled = game.coins < 2 || game.slimes <= 1 || game.hp <= 0
	$stock/coins.text = "Coins: " + str(game.coins)
	$stock/ale.text = "Ale: " + str(game.ale)
	var date := game.DATE.new(game.turns)
	$Date.text = date.get_date_string()
	var festival = game.get_todays_festival()
	if festival:
		$Date/FestivalSprite.texture = load(festival.icon)
		$Date/FestivalSprite.show()
	else:
		$Date/FestivalSprite.hide()
		
	$Date/Sprite.frame = date.season

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

func set_ready_to_level_up(b:bool):
	$buttons/SkillsBtn/ColorRect.visible = b

func _on_ale_pressed():
	game.coins -= 2
	var made := batch.ale * game.brewers
	game.ale += made
	emit_signal("made_ale")
	made_today.text = "Made " + str(made) + " ales"
	pass_time()

func _on_potion_pressed():
	var desired_potions := batch.potion
	desired_potions = min(batch.potion, game.slimes)
	game.coins -= 2
	game.slimes -= desired_potions
	game.potions += desired_potions
	made_today.text = "Made %s potions" % desired_potions
	emit_signal("made_potions")
	pass_time()

func _on_rest_pressed():
	if game.hp >= batch.rest: 
		game.hp = batch.rest + 2 
	else: 
		game.hp = batch.rest + 1
	made_today.text = "Rested"
	emit_signal("rested")
	pass_time()

