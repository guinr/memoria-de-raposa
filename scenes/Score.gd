extends RichTextLabel

onready var ADVERSARY_SCORE = $AdversaryScore
onready var PLAYER_SCORE = $PlayerScore

func _ready():
	if Globals.connect("addPoint", self, "changeScore") != OK:
		print_debug("Cannot connect to addPoint")

func changeScore():
	ADVERSARY_SCORE.bbcode_text = "[center]Adversário: " + str(Globals.getAdversaryPoint()) + "[/center]"
	PLAYER_SCORE.bbcode_text = "[center]Jogador: " + str(Globals.getPlayerPoint()) + "[/center]"
