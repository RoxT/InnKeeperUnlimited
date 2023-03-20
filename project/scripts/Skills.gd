extends Control

onready var batch_size := $MarginContainer/HBoxContainer/BatchSize
const BATCH := "Each batch has %s ales"

signal back_to_inn

class Skill:
	var level := 0
	var next := 5
	var ex := 0
	
	func _skill_up() -> bool:
		ex += 1
		return is_ready()
		
	func is_ready()->bool:
		if ex >= next:
			return true
		else: return false
	
	func level_up():
		level += 1
		ex = ex - next
		next += 1
		
	
var ale_making := Skill.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh()

func _enter_tree() -> void:
	if batch_size == null : return
	refresh()

func _on_BackToInn_pressed() -> void:
	emit_signal("back_to_inn")


func _on_LevelUp_pressed() -> void:
	ale_making.level_up()
	refresh()
	
func refresh():
	$MarginContainer/HBoxContainer/LevelUp.disabled = !ale_making.is_ready()
	$MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/TextureProgress.max_value = ale_making.next
	$MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/TextureProgress.value = ale_making.ex
	batch_size.text = BATCH % (ale_making.level + 10)
	
	
