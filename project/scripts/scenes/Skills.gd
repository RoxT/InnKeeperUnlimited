extends Control

onready var ale_level
const BATCH := "Each batch has %s "

signal back_to_inn

class Skill:
	var level := 0
	var next := 5
	var ex := 0
	var batch_size := 10
	var text := ""
	
	func _init(plural_name:String, new_batch_size := 10):
		batch_size = new_batch_size
		text = BATCH + plural_name
	
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
	
var ale_making := Skill.new("ales")
var potion_brewing := Skill.new("potions")
var resting := Skill.new("hp", 3)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh()

func _enter_tree() -> void:
	if $MarginContainer/VBoxContainer/AleContainer == null : return
	refresh()

func _on_BackToInn_pressed() -> void:
	emit_signal("back_to_inn")
	
func refresh():
	refresh_skill($MarginContainer/VBoxContainer/AleContainer, ale_making)
	refresh_skill($MarginContainer/VBoxContainer/PotionContainer, potion_brewing)
	refresh_skill($MarginContainer/VBoxContainer/RestContainer, resting)
	
func refresh_skill(node:Node, skill:Skill):
	var btn:Button
	var texture_progress:TextureProgress = node.get_node("HBoxContainer/TextureProgress")
	for n in node.get_children():
		if n is Button: btn = n
	btn.disabled = !skill.is_ready()
	texture_progress.max_value = skill.next
	texture_progress.value = skill.ex
	node.get_node("BatchLabel").text = skill.text % (skill.level + skill.batch_size)

func _on_LevelUpAle_pressed() -> void:
	ale_making.level_up()
	refresh_skill($MarginContainer/VBoxContainer/AleContainer, ale_making)

func _on_LevelUpPotion_pressed() -> void:
	potion_brewing.level_up()
	refresh_skill($MarginContainer/VBoxContainer/PotionContainer, potion_brewing)

func _on_LevelUpRest_pressed() -> void:
	resting.level_up()
	refresh_skill($MarginContainer/VBoxContainer/RestContainer, resting)
