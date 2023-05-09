class_name SkillSet
extends Resource

enum names {
	ALE,
	POTION,
	REST
}

export (Array, Resource) var skills setget set_skills, get_all

func set_skills(value:Array):
	for i in value:
		assert(i is Skill)
	skills = value

func get_all()->Array:
	return skills

func any_ready()->bool:
	for s in skills:
		if s.is_ready():
			return true
	return false
	
func skill_up(i: int)->bool:
	return skills[i].skill_up()
	
func get_batch_sizes()->S.Batch:
	var batch := S.Batch.new()
	batch.ale = skills[0].batch_size
	batch.potion = skills[1].batch_size
	batch.rest = skills[2].batch_size
	return batch
