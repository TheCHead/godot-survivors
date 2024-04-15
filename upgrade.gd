class_name Upgrade
extends Resource

@export var name:String
@export var icon:Texture2D
@export var type:Upgrade.Type


enum Type {hp_up, damage_up, speed_up, range_up, cooldown_down}
