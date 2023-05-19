extends VBoxContainer


onready var PostScene := preload("res://office/slimes_wanted.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_list(list:Array, target:Node, game:SaveGame):
	for c in get_children():
		c.queue_free()
		
	if list.empty():
		var label := Label.new()
		label.text = "None"
		add_child(label)

	for p in list:
		var post := PostScene.instance()
		post.post = p
		post.game = game
		var err := post.connect("post_action", target, "_on_post_action")
		if err != OK: push_error("error connecting: " + str(err))
		add_child(post)
