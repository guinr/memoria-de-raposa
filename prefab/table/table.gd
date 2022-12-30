extends ViewportContainer

signal gameResult(result)

onready var TABLE = $VBoxContainer
onready var CARD = preload("res://prefab/card/card.tscn")

var instancedCards = []
var flippedCards = 0

func _ready():
	if Globals.connect("adversaryLooking", self, "handleAdversaryLooking") != OK:
		print_debug("Unable to connect to adversaryLooking")
	setupTable()

func getSortedCards():
	randomize()
	var cards = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9]
	cards.shuffle()
	return cards

func setupTable():
	var cards = getSortedCards()
	for i in [0, 6, 12]:
		var hboxContainer = HBoxContainer.new()
		hboxContainer.alignment = BoxContainer.ALIGN_CENTER
		hboxContainer.set("custom_constants/separation", 8)
		hboxContainer.size_flags_horizontal += 2
		hboxContainer.size_flags_vertical += 2
		TABLE.add_child(hboxContainer)
		for j in [0, 1, 2, 3, 4, 5]:
			var arrayPos = i + j
			var card = CARD.instance()
			card.size_flags_horizontal += 2
			card.size_flags_vertical += 2
			card.rect_scale = Vector2(2, 2)
			hboxContainer.add_child(card)
			card.setCard(cards[arrayPos])
			card.connect("flipped", self, "onCardFlip")
			instancedCards.append(card)

func onCardFlip(flipUp):
	Globals.setFlippedCardCount(getFlippedCardCount())
	if flipUp && Globals.isAdversaryLooking():
		lockViewedFlippedCard()
	if Globals.isPlayerTurn():
		handlePassTurn()

func lockViewedFlippedCard():
	for i in instancedCards.size():
		if instancedCards[i].isFlipped():
			instancedCards[i].lockFlipped = true

func getFlippedCardCount():
	var flippedCardCount = 0
	for i in instancedCards.size():
		if instancedCards[i].isFlipped() && !instancedCards[i].isMatched():
			flippedCardCount += 1
	return flippedCardCount

func handleAdversaryLooking():
	Globals.setFlippedCardCount(getFlippedCardCount())
	if Globals.isAdversaryLooking():
		flippedCards = getFlippedCardCount()
		handlePassTurn()

func handlePassTurn():
	checkGameFinish()
	if flippedCards >= 2:
		checkFlippedCardsMatching()
		passTurn()

func passTurn():
	flippedCards = 0
	yield(get_tree().create_timer(1.0), "timeout")
	resetUnmatchedCards()
	if Globals.isPlayerTurn():
		Globals.setAdversaryTurn()
		handleAdversaryTurn(false)
	else:
		Globals.setPlayerTurn()

func resetUnmatchedCards():
	for i in instancedCards.size():
		if !instancedCards[i].isMatched() && instancedCards[i].isFlipped():
			instancedCards[i].lockFlipped = false
			instancedCards[i].flip()

func checkFlippedCardsMatching():
	var lastFlippedCard = -1
	for i in instancedCards.size():
		if instancedCards[i].isFlipped() && !instancedCards[i].isMatched():
			if lastFlippedCard == instancedCards[i].getCard():
				Globals.addPoint()
				setFlippedCardsAsMatched()
			if lastFlippedCard == -1:
				lastFlippedCard = instancedCards[i].getCard()

func setFlippedCardsAsMatched():
	for i in instancedCards.size():
		if instancedCards[i].isFlipped():
			instancedCards[i].setMatched()

func countLockedCards():
	var lockedCount = 0
	for i in instancedCards.size():
		if instancedCards[i].lockFlipped:
			lockedCount += 1
	return lockedCount

func countMatchedCards():
	var matchedCount = 0
	for i in instancedCards.size():
		if instancedCards[i].isMatched():
			matchedCount += 1
	return matchedCount

func checkGameFinish():
	if countMatchedCards() == 18:
		var playerPoint = Globals.getPlayerPoint()
		var adversaryPoint = Globals.getAdversaryPoint()
		if playerPoint == adversaryPoint:
			emit_signal("gameResult", "Empate")
		elif playerPoint > adversaryPoint:
			emit_signal("gameResult", "Vitória")
		else:
			emit_signal("gameResult", "Derrota")

#Adversary
func flipRandomCard():
	var unflippedAndUnmatchedCards = []
	for i in instancedCards.size():
		var card = instancedCards[i]
		if !card.isFlipped() && !card.isMatched():
			unflippedAndUnmatchedCards.append(card)
	if unflippedAndUnmatchedCards.size() > 0:
		var cardIndex = randi() % unflippedAndUnmatchedCards.size()
		unflippedAndUnmatchedCards[cardIndex].tryFlip()

func handleAdversaryTurn(_isPlayerTurn):
	if !Globals.isPlayerTurn():
		Globals.setFlippedCardCount(getFlippedCardCount())
		flipRandomCard()
		yield(get_tree().create_timer(0.5), "timeout")
		flipRandomCard()
		yield(get_tree().create_timer(0.5), "timeout")
		handlePassTurn()

func _on_Table_visibility_changed():
	handleAdversaryTurn(false)
