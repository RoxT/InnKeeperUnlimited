extends Node2D

var game:SaveGame
export var save_game_override:Resource

onready var road_score := $MarginContainer/HBox/HBox/RoadScore
onready var no_ale_label := $MarginContainer/HBox/BuffsList/NoAleLabel
onready var list := $MarginContainer/HBox
onready var gossip_label := $MarginContainer/HBox/BarGossip
onready var posted_list := $MarginContainer/HBox/Posted
onready var unposted_list := $MarginContainer/HBox/Unposted

onready var hire_action := $MarginContainer/HBox/BrewerAction

const NO_ALE := "Ale was out recently. Days left in Penalty: "

var loaded := false

var gossips := {}

signal back_to_inn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent().name == "root":
		game = save_game_override if save_game_override else SaveGame.new_game()
	assert(game)
	init()
	loaded = true
	var err = hire_action.connect("buy_action", self, "_on_buy_action")
	if err != OK:push_error("Error connecting signal: " + str(err))
	hire_action.game = game

func _enter_tree() -> void:
	if loaded: init()
	
func _on_BackToInn_pressed() -> void:
	emit_signal("back_to_inn")

func init():
	road_score.text = str(S.road_quality)
	no_ale_label.visible = S.ale_penalty > 0
	no_ale_label.text = NO_ALE + str(S.ale_penalty)
	
	posted_list.set_list(game.active_posts, self, game)
	var unposted := []
	for v in S.postings.values():
		if !game.active_posts.has(v):
			unposted.append(v)
	unposted_list.set_list(unposted, self, game)
	
	for c in gossip_label.get_children():
		c.queue_free()
	if gossips.empty():
		var l := Label.new()
		l.text = tr( "RANDOM" + str(randi()%4) )
		l.autowrap = true
		gossip_label.add_child(l)
	else:
		for g in gossips.keys():
			var l := Label.new()
			l.text = tr(g)
			gossip_label.add_child(l)

func _on_post_action(is_active:bool, post_const:String):
	add_gossip(post_const, is_active)

func _on_buy_action(_cost_amount, _cost_type, action_type):
	if action_type == S.actions.BREWER:
		add_gossip("NEW_BREWER")

func pass_time():
	for key in gossips.keys():
		gossips[key] -= 1
		if gossips[key] <= 0:
			var _exists := gossips.erase(key)

func add_gossip(key:String, add:=true, days_left:=3):
	if add:
		gossips[key] = days_left
	else:
		var _exists := gossips.erase(key)
	init()	
