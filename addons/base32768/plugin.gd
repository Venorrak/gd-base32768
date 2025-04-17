@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("Base32768", "res://addons/base32768/base32768.gd")
