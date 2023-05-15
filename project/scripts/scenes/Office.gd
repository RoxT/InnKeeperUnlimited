extends Node2D

onready var road_score := $MarginContainer/HBoxContainer/HBoxContainer/RoadScore
onready var no_ale_label := $MarginContainer/HBoxContainer/BuffsList/NoAleLabel

const NO_ALE := "Ale was out recently. Days left in Penalty: "

var loaded := false

signal back_to_inn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init()
	loaded = true

func _enter_tree() -> void:
	if loaded: init()
	
func _on_BackToInn_pressed() -> void:
	emit_signal("back_to_inn")

func init():
	road_score.text = str(S.road_quality)
	no_ale_label.visible = S.ale_penalty > 0
	no_ale_label.text = NO_ALE + str(S.ale_penalty)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Control_pressed() -> void:
	pass # Replace with function body.
