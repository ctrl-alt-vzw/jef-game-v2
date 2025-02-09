extends Resource
class_name Asset_holder
 
@export var protagonist_asset : Texture = null
@export var antagonist_asset : Texture = null
@export var npc_asset : Texture = null
@export var henchmen_asset : Texture = null
@export var weapon_asset : Texture = null
@export var tilemap_asset : Texture = null
@export var panel_asset : Texture = null


@export var UUID : String = ""
@export var title : String = ""
@export var story_elements : String = ""
@export var goal : String = ""
@export var npc_quote : String = ""


func clear():
	var protagonist_asset : Texture = null
	var antagonist_asset : Texture = null
	var npc_asset : Texture = null
	var henchmen_asset : Texture = null
	var weapon_asset : Texture = null
	var tilemap_asset : Texture = null
	var panel_asset : Texture = null
	
