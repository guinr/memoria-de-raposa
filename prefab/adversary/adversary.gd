extends Node2D

onready var EYES = $eyes;
var actualStateIndex = 0;
var STATES = [
	"idle",
	"look-right",
	"look-left",
	"suspecting",
	"discovered"
];

func _ready():
	if EYES.connect("animation_finished", self, "changeState") != OK:
		print_debug("Cannot connect to animation_finished")

func isLooking():
	return STATES[actualStateIndex] == "idle" || STATES[actualStateIndex] == "suspecting" || STATES[actualStateIndex] == "discovered"

func changeState():
	yield(get_tree().create_timer(0.5), "timeout")
	randomize()
	var index = 0
	if Globals.isPlayerTurn() && !Globals.getFlippedCardCount() == 2:
		index = randi()  % (STATES.size() - 1)
	actualStateIndex = index
	EYES.animation = STATES[index]
	if isLooking():
		Globals.setAdversaryLooking(true)
	else:
		Globals.setAdversaryLooking(false)
