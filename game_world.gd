extends Node2D
class_name GameWorld

signal started
signal finished

enum Cell {OBSTACLE, GROUND, BORDER}

@export var inner_size : Vector2
@export var perimeter_size = Vector2(1, 1)
@export_range(0, 1) var ground_probability := 0.1
@export var tree_scene : PackedScene
@onready var _trees : Node2D = %Trees
@onready var _navigation_region_2d : NavigationRegion2D = $NavigationRegion2D


# public variables
var size
var cell_size:Vector2i

# private variables
@onready var _tile_map : TileMap = %TileMap
var _rng = RandomNumberGenerator.new()

func _ready():
	size = inner_size + 2 * perimeter_size
	cell_size = _tile_map.tile_set.tile_size
	_rng.randomize()
	setup()
	generate_map()

func setup():
#	var map_size_px = size * _tile_map.tile_set.tile_size.x
#	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
#	get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
#	get_tree().root.content_scale_size = map_size_px
#	get_tree().root.size = 2 * map_size_px
	pass
	
func can_spawn(spawn_position:Vector2i) ->bool:
	return true \
	if spawn_position.x > (global_position.x + perimeter_size.x * 3 * cell_size.x)\
	and spawn_position.x < (global_position.x + (size.x - perimeter_size.x * 3)*cell_size.x)\
	and spawn_position.y > (global_position.y + perimeter_size.y * 3 * cell_size.y)\
	and spawn_position.y < (global_position.y + (size.y - perimeter_size.y * 3)*cell_size.y)\
	else false
	
	
func generate_map():
	started.emit()
	_generate_perimeter()
	_generate_inner()
	finished.emit()
	_config_nav_region()
	

func _generate_perimeter():
	for x in [0, size.x - 1]:
		for y in range(0, size.y):
			_tile_map.set_cell(0, Vector2i(x, y), 0, _pick_tile(Cell.BORDER))
	for x in range (1, size.x - 1):
		for y in [0, size.y - 1]:
			_tile_map.set_cell(0, Vector2i(x, y), 0, _pick_tile(Cell.BORDER))
	pass
	
func _generate_inner():
	for x in range (1, size.x - 1):
		for y in range (1, size.y - 1):
			_tile_map.set_cell(0, Vector2i(x, y), 0, _get_inner_tile(ground_probability, Vector2i(x, y)))

func _get_inner_tile(probability:float, position:Vector2i):
	if	_rng.randf() < probability:
		var tree = tree_scene.instantiate()
		tree.global_position = Vector2(position.x * _tile_map.tile_set.tile_size.x, position.y * _tile_map.tile_set.tile_size.y)
		_trees.add_child(tree)
		return _pick_tile(Cell.GROUND)
	else:
		return _pick_tile(Cell.GROUND)

func _pick_tile(cell_type:Cell) -> Vector2i:
	match cell_type:
		Cell.BORDER:
			return Vector2i(0, 3)
		Cell.GROUND:
			return Vector2i(4, 0)
		Cell.OBSTACLE:
			return Vector2i(0, 3)
	return Vector2i(0, 3)
	
func _config_nav_region():
	var polygon = NavigationPolygon.new()
	var outline = PackedVector2Array([Vector2(0, 0), Vector2(0, size.y), Vector2(size.x, size.y), Vector2(size.x, 0)])
	
	polygon.add_outline(outline)
	polygon.make_polygons_from_outlines()
	polygon.agent_radius = 60
	_navigation_region_2d.navigation_polygon = polygon
	_navigation_region_2d.bake_navigation_polygon()
	

