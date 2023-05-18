extends Node2D

var game:SaveGame

onready var road_score := $MarginContainer/HBox/HBox/RoadScore
onready var no_ale_label := $MarginContainer/HBox/BuffsList/NoAleLabel
onready var list := $MarginContainer/HBox
onready var gossip_label := $MarginContainer/HBox/BarGossip

onready var hire_action := $MarginContainer/HBox/OfficeAction

const NO_ALE := "Ale was out recently. Days left in Penalty: "

var loaded := false

var gossips := {}

signal back_to_inn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(game)
	init()
	loaded = true
	hire_action.connect("buy_action", self, "_on_buy_action")
	hire_action.game = game

func _enter_tree() -> void:
	if loaded: init()
	
func _on_BackToInn_pressed() -> void:
	emit_signal("back_to_inn")

func init():
	road_score.text = str(S.road_quality)
	no_ale_label.visible = S.ale_penalty > 0
	no_ale_label.text = NO_ALE + str(S.ale_penalty)
	update_gossip_labels()

func _on_buy_action(cost_amount, cost_type, action_type):
	if action_type == S.actions.BREWER:
		update_gossip("NEW_BREWER")

func pass_time():
	for key in gossips.keys():
		gossips[key] -= 1
		if gossips[key] <= 0:
			gossips.erase(key)

func update_gossip(key:String, days_left:=3, add:=true):
	if add:
		gossips[key] = days_left
	else:
		gossips.erase(key)
	update_gossip_labels()	

func update_gossip_labels():
	for c in gossip_label.get_children():
		c.queue_free()
	if gossips.empty():
		var l := Label.new()
		l.text = tr( "RANDOM" + str(randi()%4) )
		gossip_label.add_child(l)
	else:
		for g in gossips.keys():
			var l := Label.new()
			l.text = tr(g)
			gossip_label.add_child(l)
		
