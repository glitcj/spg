extends Node3D


func fire(): 
	%AnimationPlayer.play("fire")
	await %AnimationPlayer.animation_finished
	%AnimationPlayer.play("idle")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%AnimationPlayer.play("idle")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
