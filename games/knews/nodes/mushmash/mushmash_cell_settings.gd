extends Node
class_name MushMashCellSettings


enum AvailableStates {Idle, Excited, ReadyForAction}
enum CellTypes {Player, Oponnent, Immovable}

var height: int = 100
var width: int = 100
var state: int = AvailableStates.Idle
var uuid: String

var type: int = CellTypes.Immovable

var x
var y
var new_x
var new_y
var new_position: Vector2

var is_enemy: bool = false
var is_player: bool = false
var is_movable: bool = false
var can_move_now: bool = false
