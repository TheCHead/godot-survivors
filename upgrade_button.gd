extends Button

var upgrade_type:Upgrade

signal on_upgrade_selected(upgradeType : Upgrade)

func _on_pressed():
	on_upgrade_selected.emit(upgrade_type)
	

func init(upgrade:Upgrade):
	upgrade_type = upgrade
	icon = upgrade.icon
	self.text = upgrade.name
