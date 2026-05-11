class_name WeaponSelect
extends Control

@export var available_weapons: Array[WeaponData] = []

@onready var weapons_row: HBoxContainer = %WeaponsRow

signal weapon_selected(weapon: WeaponData)

func _ready() -> void:
	for weapon : WeaponData in available_weapons:
		var button : Button = Button.new()
		button.text = weapon.weapon_name.to_upper() + weapon.stat_description
		button.custom_minimum_size = Vector2(96,96)
		button.pressed.connect(func() -> void: _on_weapon_chosen(weapon))
		weapons_row.add_child(button)

func _on_weapon_chosen(weapon: WeaponData) -> void:
	weapon_selected.emit(weapon)
