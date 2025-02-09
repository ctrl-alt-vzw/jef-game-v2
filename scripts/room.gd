extends Node2D

@export var asset_holder: Resource

@onready var room: Node2D = $"."

# Reference to the TileMap node
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var henchmen: Node2D = $henchmen
@onready var npcs: Node2D = $NPCs
@onready var bbeg: CharacterBody2D = $bbeg

const SCALAR = 2

const indices = [
	Vector2i(0, 0),
	Vector2i(1, 0),
	Vector2i(2, 0),
	Vector2i(3, 0),
	Vector2i(0, 1),
	Vector2i(1, 1),
	Vector2i(2, 1),
	Vector2i(3, 1),
	Vector2i(0, 2),
	Vector2i(1, 2),
	Vector2i(2, 2),
	Vector2i(3, 2),
	Vector2i(0, 3),
	Vector2i(1, 3),
	Vector2i(2, 3),
	Vector2i(3, 3)
]

var y_offset = 0;

var start_x=0;
var start_y=0;

const AMOUNT_OF_MAPS = 200;

func _ready():
	generate_terrain()

func generate_terrain():
	var image = Image.new()
	var map_num = floor(randf() * 88)+1
	var image_path = "res://maps/tile_map-"+str(map_num)+".png"  # Replace with the actual path to your image
	
	
	var error = image.load(image_path)

	if error != OK:
		print("Failed to load image: ", error)
		return

	var tile_width = image.get_width()
	var tile_height = image.get_height()
	var p = image.get_pixel(0,0)
	start_x = -(p[0] * tile_width) / SCALAR;
	start_y = -(p[1] * tile_height) / SCALAR;
	
	for x in range(tile_width/SCALAR):
		#y_offset += 1
		for y in range(tile_height/SCALAR):
			var pixel = image.get_pixel(x*SCALAR, y*SCALAR)
			var brightness = pixel[0];
			var i_s = indices.size()-1
			var tile_vector = indices[min(i_s, abs(floor((1-brightness) * i_s)))]
			
			if brightness == 1:
				tile_map_layer.set_cell(Vector2(x + start_x , y + start_y), 1, tile_vector)
			else:
				tile_map_layer.set_cell(Vector2(x + start_x , y + start_y), 1, tile_vector)
	
	#Set special items on map
	for i in range(5):
		var NPC_pixel = image.get_pixel(1+i, 1)
		var NPC_pos = coor_to_position(Vector2i(NPC_pixel[0]*tile_width, NPC_pixel[1]*tile_height))
		## Debug positioning
		## tile_map_layer.set_cell(coor, 1, Vector2i(3, 3))
		if i == 0 || i == 2:
			var NPC = preload("res://scenes/npc_v2.tscn").instantiate()
			NPC.position = NPC_pos;
			NPC.scale *= .13;
			npcs.add_child(NPC);
		if i == 1 || i == 3:
			for j in range(3):
				var hench = preload("res://scenes/henchman.tscn").instantiate()
				hench.position = NPC_pos;
				hench.scale *= .15;
				hench.position.y -=50
				hench.position.y += j * 50
				henchmen.add_child(hench);
			
		if i == 4:
			bbeg.position = NPC_pos;
			bbeg.position.x += 40
			bbeg.start_point_x = bbeg.position.x
			bbeg.start_point_y = bbeg.position.y
		
		

func coor_to_position(pixel_pos):
	var coor = Vector2i(pixel_pos.x/SCALAR + start_x, pixel_pos.y/SCALAR + start_y)
	var loc = tile_map_layer.map_to_local(coor)
	var position = Vector2i(loc.x * tile_map_layer.scale.x, loc.y * tile_map_layer.scale.y)
	return position


func update_assets():
	var texture = asset_holder.tilemap_asset
	print(texture)
	tile_map_layer.tile_set.get_source(1).texture = texture
	
	for hench in henchmen.get_children():
		hench.update_assets()
	for npc in npcs.get_children():
		npc.update_assets()
		
	bbeg.update_assets()
	
