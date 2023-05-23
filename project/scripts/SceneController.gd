extends Node

onready var inn := $Inn
onready var season := $Season
onready var dialog:Node =  preload("res://DialogScene.tscn").instance()
onready var skills := preload("res://skills/UISkills.tscn").instance()
onready var office := preload("res://Office.tscn").instance()

var active_scene:Node
var event_queue := [S.events.OPENING]

var save_game:SaveGame

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()
	var errs = []
	errs.append(dialog.connect("dialog_finished", self, "_on_dialog_finished"))
	errs.append(skills.connect("back_to_inn", self, "_on_back_to_inn"))
	errs.append(office.connect("back_to_inn", self, "_on_back_to_inn"))
	errs.append(inn.connect("made_ale", self, "_on_made_ale"))
	errs.append(inn.connect("made_potions", self, "_on_made_potions"))
	errs.append(inn.connect("rested", self, "_on_rested"))
	errs.append(inn.connect("time_passed", self, "_on_time_passed"))
	errs.append(inn.connect("no_ale", self, "on_no_ale"))
	errs.append(inn.connect("event_happened", self, "_on_event_happened"))
	for err in errs:
		if err != OK:
			push_error(str(err))
	inn.batch = skills.get_batch_sizes()
	inn.game = save_game
	inn.update_stock()
	office.game = save_game
	
func new_game():
 save_game = SaveGame.new_game()

func _on_back_to_inn():
	remove_child(active_scene)
	#inn.ale_batch = skills.ale_making.level + 10
	add_child(inn)
	inn.batch = skills.get_batch_sizes()
	inn.update_stock()
	inn.set_ready_to_level_up(skills.any_ready())
	

func _on_made_ale():
	if skills.skill_up(SkillSet.names.ALE):
		inn.get_node("buttons/SkillsBtn/ColorRect").show()
	
func _on_made_potions():
	if skills.skill_up(SkillSet.names.POTION):
		inn.get_node("buttons/SkillsBtn/ColorRect").show()
	
func _on_rested():
	if skills.skill_up(SkillSet.names.REST):
		inn.get_node("buttons/SkillsBtn/ColorRect").show()
	
func _on_time_passed():
	if S.ale_penalty > 0: S.ale_penalty -= 1
	office.pass_time()
	
	var date := save_game.DATE.new(save_game.turns)
	if date.day == 1:
		season.get_node("Panel").theme_type_variation = date.get_season_label()
		season.get_node("Label").text = tr(date.get_season_label())
		season.get_node("SeasonPlayer").play("wipe")
	
func on_no_ale():
	S.ale_penalty = 10
	
func _on_event_happened(key:int):
	if !event_queue.has(key):
		event_queue.push_back(key)


func _on_SkillsBtn_pressed():
	remove_child(inn)
	active_scene = skills
	add_child(skills)
	
func _on_OfficeBtn_pressed() -> void:
	remove_child(inn)
	active_scene = office
	add_child(office)
	
func _on_dialog_finished(key:int):
	remove_child(dialog)
	S.update_visible(key)
	add_child(inn)
	
func _on_DialogBtn_pressed() -> void:
	if event_queue[0] == S.events.REST:
		save_game.hp = 0
		inn.get_node("buttons/ale").disabled = true
	if event_queue.size() == 1:
		inn.get_node("DialogBtn").visible = false
	remove_child(inn)
	add_child(dialog)
	dialog.show_text(event_queue.pop_front())

