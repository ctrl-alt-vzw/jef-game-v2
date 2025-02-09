extends Control

@export var asset_holder: Resource


@onready var puck_id: LineEdit = $overlay/puck_id
@onready var overlay: CanvasLayer = $overlay
@onready var http_request: HTTPRequest = $HTTPRequest
@onready var choose_game_overlay: CanvasLayer = $choose_game_overlay
@onready var game_button_holders: VBoxContainer = $choose_game_overlay/Control/MarginContainer/Panel/MarginContainer/Panel/VBoxContainer/game_button_holders


var loaded = 0;

signal loaded_assets()
# A bunch of code for your mob


var response;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	puck_id.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_puck_id_text_submitted(new_text: String) -> void:
	print(new_text)
	overlay.hide()
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	var URL = "http://192.168.0.148:3001/games_by_cartridge/"+new_text.replace(" ", "%20")
	var error = http_request.request(URL)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	response = json.get_data()
	
	for resp in response:
		if resp["title"]:
			var title = resp["title"]["text"]
			var UUID = resp["UUID"]
			var btn = Button.new()
			btn.text = title
			btn.pressed.connect(self._on_game_chosen.bind( UUID))
			game_button_holders.add_child(btn)


func _on_game_chosen(UUID) -> void:
	var selected;
	for r in response:
		if r["UUID"] == UUID:
			selected = r
	
	var title = selected["title"]["text"]
	var story_elements = selected["story_elements"]["text"]
	var goal = selected["goal"]["text"]
	var npc_quote = selected["npc_quote"]["text"]
	
	asset_holder.UUID = UUID
	asset_holder.title = title
	asset_holder.story_elements = story_elements
	asset_holder.goal = goal
	asset_holder.npc_quote = npc_quote
	executeRequest("http://192.168.0.148:3030/generations/" + UUID + "_ENVIRONMENT.png")
	executeRequest("http://192.168.0.148:3030/generations/" + UUID + "_PROTAGONIST_LOOK.png")
	executeRequest("http://192.168.0.148:3030/generations/" + UUID + "_ANTAGONIST_LOOK.png")
	executeRequest("http://192.168.0.148:3030/generations/" + UUID + "_HENCHMEN.png")
	executeRequest("http://192.168.0.148:3030/generations/" + UUID + "_NPC.png")
	executeRequest("http://192.168.0.148:3030/generations/" + UUID + "_WEAPON.png")
	executeRequest("http://192.168.0.148:3030/generations/" + UUID + "_PANEL.png")
	
	print(asset_holder)
	
	
func executeRequest(url):
	print(url)
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", _image_http_request_completed.bind(url))
	var error = http_request.request(url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _image_http_request_completed(_result, _response_code, _headers, body, url):
	print("request completed")
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")
	else:
		var texture = ImageTexture.create_from_image(image)
		
		if url.contains("ENVIRONMENT"):
			asset_holder.tilemap_asset = texture
		if url.contains("PROTAGONIST"):
			asset_holder.protagonist_asset = texture
		if url.contains("ANTAGONIST"):
			asset_holder.antagonist_asset = texture
		if url.contains("HENCHMEN"):
			asset_holder.henchmen_asset = texture
		if url.contains("NPC"):
			asset_holder.npc_asset = texture
		if url.contains("WEAPON"):
			asset_holder.weapon_asset = texture
		if url.contains("PANEL"):
			asset_holder.panel_asset = texture
		
	loaded+=1
	
	if loaded == 7:
		loaded_assets.emit()
		choose_game_overlay.hide()
		
		
	
