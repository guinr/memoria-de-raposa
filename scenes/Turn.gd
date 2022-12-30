extends RichTextLabel

func _ready():
	if Globals.connect("changeTurn", self, "changeTurnLabel") != OK:
		print_debug("Cannot connect to changeTurn")
		
func changeTurnLabel(isPlayerTurn):
	if isPlayerTurn:
		bbcode_text = "[center]Turno\n Jogador[/center]"
	else:
		bbcode_text = "[center]Turno\n Adversário[/center]"
