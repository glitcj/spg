extends Node2D
class_name _Doomer_Coin_Box

@export var doomer : _Doomer
@export var container : CanvasItem
@export var viewport : SubViewport

@onready var resizer_sprite = $"Resizer Sprite"
@onready var spawner =  $"Spawner"

var spawn_point_randomness = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if doomer:
		# doomer.ready.connect(move_to_viewport)
		doomer.ready.connect(move_to_container)
		
		
	add_coins(100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func move_to_viewport():
	self.reparent(viewport)

func move_to_container():
	self.reparent(container)
	position = Vector2.ZERO

func add_coins(count : int = 1):
	var coin : RigidBody2D
	for i in range(count):
		coin = _Doomer_Templates.coin_box_coin.instantiate()
		
		# print("cccc %f %f %f" % [spawner.global_position.x, spawner.global_position.y,  (randi() % spawn_point_randomness - (float(spawn_point_randomness)/2))] )
		coin.position = spawner.position 
		coin.position.x += (randi() % spawn_point_randomness - (float(spawn_point_randomness)/2))
		
		
		# print("dddd %f %f %f" % [coin.global_position.x, coin.global_position.y,  (randi() % spawn_point_randomness - (float(spawn_point_randomness)/2))] )
		coin.position.y += (randi() % spawn_point_randomness - (float(spawn_point_randomness)/2))
		coin.sleeping = false
		$Coins.add_child(coin)
	
func remove_coins():
	pass
	
	
func _bet_coins():
	pass
	# Add Gun Gravity
	# Coin Box is the GAME BOARD
	# Enemy has ANTI GRAVITY coins
	# When a Bet is made with < >, the gun INCREASES gravity to pull the coins
	# Coins are blood
	# Game loop is reaching COIN/BLOOD OVERFLOW
	
	# Game Board has a below latch the lets coins flow to below off to the war chest offset screen
	
func _open_coin_box_latch():
	pass

func _on_container_rect_changed():
	CommonFunctions.move_node_to_container(self, container)

# This is not working correctly, always scales the nodes directly
func _set_absolute_size(desired_width := 50, desired_height := 50, keep_ratio := false) -> void:
	CommonFunctions.set_node_absolute_size_from_sprite_reference(resizer_sprite, self, desired_width, desired_height, keep_ratio)
