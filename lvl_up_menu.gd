extends CanvasLayer

@export var number_of_upgrades:int
@export var button_scene:PackedScene
#@export var upgrades_group:ResourceGroup
@onready var upgrade_parent = %UpgradeParent

signal upgrade_selected(upgrade_type: Upgrade)

var _all_upgrades:Array[Upgrade] = []

func _ready():
	for file in DirAccess.get_files_at("res://upgrades/"):
		var resource_file = "res://upgrades/" + file
		var upgrade:Upgrade = load(resource_file) as Upgrade
		_all_upgrades.append(upgrade)

	#upgrades_group.load_all_into(_all_upgrades)
		
	

func display():
	_all_upgrades.shuffle()
	for i in number_of_upgrades:
		var button_instance = button_scene.instantiate()
		button_instance.init(_all_upgrades[i])
		button_instance.on_upgrade_selected.connect(_on_upgrade_selected)
		upgrade_parent.add_child(button_instance)
	visible = true
	

func _on_upgrade_selected(upgrade):
	upgrade_selected.emit(upgrade)
	for child in upgrade_parent.get_children():
		child.queue_free()
