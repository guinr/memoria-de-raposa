extends Control

onready var CARD_SPRITE = $AnimatedSprite
onready var CARD = 0
onready var flipped = false
onready var lockFlipped = false
onready var matched = false

signal flipped(flipUp)

func _ready():
	if connect("gui_input", self, "cardFlip") != OK:
		print_debug("Cannot connect to gui_input")

func setCard(cardIndex: int):
	CARD = cardIndex

func getCard():
	return CARD

func cardFlip(event: InputEventMouseButton):
	if event != null && !event.is_pressed() && Globals.isPlayerTurn() && !matched:
		tryFlip()

func tryFlip():
	if lockFlipped || (Globals.getFlippedCardCount() == 2 && flipped == false):
		return
	else:
		flip()

func flip():
	if !flipped:
		$AudioStreamPlayer.play()
	changeCardSprite()
	emit_signal("flipped", flipped)

func changeCardSprite():
	if flipped:
		CARD_SPRITE.frame = 0
		flipped = false
	else:
		CARD_SPRITE.frame = CARD
		flipped = true

func isFlipped():
	return flipped

func setMatched():
	matched = true

func isMatched():
	return matched
