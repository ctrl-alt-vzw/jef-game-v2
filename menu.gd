extends Control

@export var asset_holder: Resource

@onready var id_input: LineEdit = $MarginContainer/VBoxContainer/id_input


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	id_input.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_game() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	pass

func _on_run_button_down() -> void:
	load_game()


func _on_id_text_submitted(new_text: String) -> void:
	load_game()


func _on_quit_button_down() -> void:
	get_tree().quit()
