extends Node2D
class_name _Doomer_Coin_Box

@export var doomer : _Doomer
@export var container : CanvasItem
@export var viewport : SubViewport
@export var holder : _Doomer.Opponents:
	set(v):
		holder = v
		if is_node_ready():
			_on_holder_assignment()
		
@onready var coins : Node2D = find_child("Coins")
@onready var spawner : Area2D =  find_child("Spawner")



@onready var gravity_area : Area2D = find_children("Area2D Gravity")[0]
@onready var gravity_vector : Vector2:
	set(v):
		gravity_vector = v
		gravity_area.gravity_direction = gravity_vector
		
var spawn_point_randomness = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_holder_assignment()
	add_coins(100)
	
func _on_holder_assignment():
	rotation = PI if holder == _Doomer.Opponents.Enemy else 0.0
	gravity_vector = Vector2(0, -1) if  holder == _Doomer.Opponents.Enemy else Vector2(0, 1)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
		coins.add_child(coin)
	
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
