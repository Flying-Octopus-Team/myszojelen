extends Node2D
class_name WorldObject

enum Type { PLAYER = 100, ENEMY = 101, OBSTACLE = 102, TREE = 0, EMPTY = -1 }
export(Type) var type
var tilemap_name: String = ""
