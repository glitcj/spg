extends Node
# class_name _Knews_Constants


enum lTags {presenter_introduction, presenter, scene,  Stage, Presenter, Contestant_A, Contestant_B, Contestant_C, lMonitor, lMonitorAnimator, AutoPlayer}
var lID: Dictionary



enum lCharacters {A, B, Presenter, lMonitor, lStage}
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
	
var lPositions = {
	lCharacters.A: Vector2(182, -125),
	lCharacters.B: Vector2(192, -125),
	lCharacters.Presenter: Vector2(-182, -125),
	}

var DEBUG = true
var ENABLE_LOOP = true

var stage_message_box_settings: MessageBoxSettings =  MessageBoxSettings.new()


func _ready():
	lID = {
	lTags.Stage: Variables.generate_uuid(), lTags.AutoPlayer: Variables.generate_uuid(), 
	lTags.lMonitor: "monitor_%s" % Variables.generate_uuid(), 
	lTags.lMonitorAnimator: "monitor_animator_%s" % Variables.generate_uuid()
	}


	# stage_message_box_settings.position = Vector2(0, 180)
	stage_message_box_settings.is_autoplay = true
	stage_message_box_settings.is_detached = false
	stage_message_box_settings.autoplay_wait_seconds = 1
	# stage_message_box_settings.parent_uuid = lID[lTags.Stage]
