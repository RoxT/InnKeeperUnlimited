class_name Skill
extends Resource

const PROD_SAVE_PATH := "user://skill_%s.tres"
const BATCH := "Each batch has %s %s"

export var title:String
export var plural:String
export var label:String

export var level := 1
export var next := 5
export var ex := 0
export var batch_size := 10


func skill_up() -> bool:
	ex += 1
	return is_ready()
	
func is_ready()->bool:
	if ex >= next:
		if S.ready_to_level.find(self) == -1: S.ready_to_level.push_back(self)
		return true
	else: return false

func level_up()->int:
	level += 1
	ex = ex - next
	next += 1
	batch_size += 1
	return level

func get_batch_text()->String:
	return BATCH % [batch_size, plural]



func get_filepath()->String:
	return PROD_SAVE_PATH % title.replace(" ", "_")

func write_skill() -> void:
	ResourceSaver.save(get_filepath(), self)

func load_skill() -> Resource:
	if ResourceLoader.exists(get_filepath()):
		return load(get_filepath())
	return null
