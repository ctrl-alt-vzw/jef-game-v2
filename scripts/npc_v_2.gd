extends CharacterBody2D

@export var asset_holder: Resource

@onready var right_arm: Polygon2D = $sprite2D/polygons/right_arm
@onready var right_leg: Polygon2D = $sprite2D/polygons/right_leg
@onready var body: Polygon2D = $sprite2D/polygons/body
@onready var left_leg: Polygon2D = $sprite2D/polygons/left_leg
@onready var left_arm: Polygon2D = $sprite2D/polygons/left_arm
@onready var head: Polygon2D = $sprite2D/polygons/head



func update_assets():
	print("updating")
	right_arm.texture = asset_holder.npc_asset
	right_leg.texture = asset_holder.npc_asset
	body.texture = asset_holder.npc_asset
	left_leg.texture = asset_holder.npc_asset
	left_arm.texture = asset_holder.npc_asset
	head.texture = asset_holder.npc_asset
	pass;
