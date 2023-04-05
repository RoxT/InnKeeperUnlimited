extends Control

var debug_dialogs = [
	"HEllo I' a text\n[b]HEllo I' a text[/b]\n[i]HEllo I' a text[/i]",
	"I'm text too\n[b]I'm text too[/b]\n[i]I'm text too[/i]"
]

var guild_name = "Inn Keeper Unlimited"

var events := {
	S.events.OPENING: ["Welcome to the cooperative " + guild_name + ", your daily tasks mainly involve brewing ale to sell in your bar. Every day you can choose one action to take. For now you can only brew ale but new options will open later. It will cost you two coins to make 10 mugs of ale and each one sells for one coin. Every day patrons will visit the bar and buy some number of mugs. The more patrons, the more drinks likely to be sold. You can see your current stock of coins and ale at the top, and the day's happening including how much you made under 'Today'.\n\nUnlocked:\nStock: Ale\nAction: Make Ale\nDaily Happenings:Patrons, Ale Bought"],
	S.events.REST: ["You are tired from making ale every day. You can now take the action to Rest. Every day you take an action, it will drain some HP (hospitality points). You can spend the day resting to recover your HP to it's maximum. If you rest two days in a row you will get an extra HP (maximum one).\n\nUnlocked:\nHP\nAction:Rest"],
	S.events.REWARDS: ["You built the bar, but no one's coming! Spending you days chatting with the few who pass by, you hear tales of slime attacks in the fields on the way into town. Travelers have started to avoid this dangerous route. You ask Geoff, a passing merchant, 'What about the adventurers, don't they usually love killing monsters and such?' you ask. 'Well', he tells you, 'slimes don't drop loot'", 
	"The guild discusses the problem. Being the local inn keepers, maybe you should be offering quests! Where else do adventurers look for work. You offer a reward - two coins for one slime vanquished. Enough for a couple ales.\n\nUnlocked:\nDaily Happenings: Slimes brought in", "Almost immediately, an adventurer enters and drops a giant globule on the bar. 'I'm Spike and I'm here for the slime bounty! Slimes don't have tails.... or anything to cut off... so I brought the whole thing, haha!' The studded warrior laughs, accepting the coins."],
	S.events.POTIONS: ["It's working! More patrons are coming in now that it's safer. But now you have so many slimes now. They fill the store houses, guild members leave them strewn in their backyards exposed to the elements. They are annoyingly shelf stable.",
	"Once again your chatty patrons have the answer. An old apothicarist with stringy grey hair and bony fingers comes through and asks you about the source of your troubles - she's seen them everywhere around town. 'An expert alchemist such as myself can solve your problem' she says confidently 'You may have noticed they last a long time, but that isn't their only amazing talent. They'll preserve you too! When a slime is carfully reduced to a small vial of liquid, one may drink a slime and feel their wounds close and bruises shrink. It doesn't last forever, just long enough to make it to the nearest place to rest", 
	"Before you can say 'I've got to talk to the others', she's commandeered a table in the bar and set up her bag of supplies in the back. I guess your innkeepers guild, " + guild_name + ", has a resident apothicary now! Welcome Hilda", "The young adventurers coming in have been looking pretty defeated by these slimes, you're sure they'll buy your potions back, one potion for one coins.\n\nUnlocked:\nStock: Potions\nActions: Make Potions\nDaily Happenings: Potions sold"],
	S.events.END: ["That's all, folks!"]
}

var page := 0
onready var current:int = S.current_event

onready var default:RichTextLabel = $MarginContainer/VBoxContainer/RichTextLabelDefault
onready var tiny:RichTextLabel = $MarginContainer/VBoxContainer/RichTextLabelTiny
onready var labels = [default, tiny]

signal dialog_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default.bbcode_enabled = true
	tiny.bbcode_enabled = true
	show_text()

func show_text():
	var label = tiny as RichTextLabel
	label.bbcode_text = (events[S.current_event][page])


func show_debug_text():
	for label in labels:
		label = label as RichTextLabel
		label.bbcode_text = (debug_dialogs[page])

func _on_Next_pressed() -> void:
	page += 1
	if page < events[S.current_event].size():
		show_text()
	else:
		page = 0
		S.current_event += 1
		emit_signal("dialog_finished")
