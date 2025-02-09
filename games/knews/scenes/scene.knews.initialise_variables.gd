extends GDScript
# TODO


enum lTags {presenter_introduction, presenter, scene,  Stage, Presenter, Contestant_A, Contestant_B, Contestant_C, lMonitor, lMonitorAnimator, AutoPlayer}
enum lCharacters {A, B, Presenter, lMonitor, lStage}

var ENABLE_LOOP = true

# var SCENE = "SCENE"
var PRESENTER_INTRODUCTION = "PRESENTER_INTRODUCTION"
var PRESENTER = "PRESENTER"
var STAGE = "STAGE"

var Contestant_A = "Contestant_A"
var Contestant_B = "Contestant_B"
var Presenter = "Presenter"

var lPortraits = {
	lCharacters.A: "res://games/knews/portraits/pallet.contestant.A.animated.tscn",
	lCharacters.B: "res://games/knews/portraits/pallet.contestant.A.animated.tscn",
	lCharacters.Presenter: "res://games/knews/portraits/pallet.presenter.animated.tscn"
	
	}
	
var lID = {
	lTags.Stage: Variables.generate_uuid(), lTags.AutoPlayer: Variables.generate_uuid(), 
	lTags.lMonitor: "monitor_%s" % Variables.generate_uuid(), 
	lTags.lMonitorAnimator: "monitor_animator_%s" % Variables.generate_uuid()
	}

var lPositions = {
	lCharacters.A: Vector2(192, -90),
	lCharacters.B: Vector2(192, -90),
	lCharacters.Presenter: Vector2(-182, -100), # Vector2(0, -15),
	}

var DEBUG = true

var utilities = preload("res://games/knews/scenes/utilities.knews.gd")
var common_events_1 = preload("res://games/knews/scenes/common.knews.gd")
