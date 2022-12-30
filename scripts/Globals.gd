extends Node

onready var playerPoint = 0
onready var adversaryPoint = 0
onready var flippedCardCount = 0
onready var playerTurn = false
onready var isLooking = true
signal changeTurn(isPlayerTurn)
signal adversaryLooking
signal addPoint

func setFlippedCardCount(flippedCount):
	flippedCardCount = flippedCount

func getFlippedCardCount():
	return flippedCardCount

func isPlayerTurn():
	return playerTurn

func setPlayerTurn():
	playerTurn = true
	emit_signal("changeTurn", playerTurn)

func setAdversaryTurn():
	playerTurn = false
	emit_signal("changeTurn", playerTurn)

func setAdversaryLooking(looking):
	isLooking = looking
	if isLooking:
		emit_signal("adversaryLooking")

func isAdversaryLooking():
	return isLooking

func addPoint():
	if playerTurn:
		playerPoint += 1
	else:
		adversaryPoint += 1
	emit_signal("addPoint")

func getPlayerPoint():
	return playerPoint

func getAdversaryPoint():
	return adversaryPoint
