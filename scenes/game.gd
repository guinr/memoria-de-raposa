extends ViewportContainer

onready var LEVEL1 = preload("res://levels/level1.tscn")

func _ready():
	var level1 = LEVEL1.instance()
	$Game.add_child(level1)
	if level1.get_child(1).connect("gameResult", self, "showGameResult") != OK:
		print_debug("Cannot connect to gameResult")

func showGameResult(result):
	$GameResult.visible = true
	if result == "Vitória":
		$GameResult/Result.bbcode_text = '[center]Parabéns, você realmente é impressionante, merecidamente alcançou o primeiro lugar![/center]'
	else:
		$GameResult/Result.bbcode_text = '[center]' + result + '[/center]'
		yield(get_tree().create_timer(3), "timeout")
		if get_tree().reload_current_scene() != OK:
			print_debug("Unable to reload_current_scene")

func _on_Button_pressed():
	$MainMenu.visible = false
	$History.visible = true

func _on_Button2_pressed():
	$MainMenu/MainMenuSound.playing = false
	$MainMenu/MainMenuSound.autoplay = false
	$History.visible = false
	$Game.visible = true
	$Game/Level1/GameSound.playing = true
	$Game/Level1/GameSound.autoplay = true
