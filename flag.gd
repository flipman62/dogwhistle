extends Area2D

signal reached_flag

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(_body: Node) -> void:
	reached_flag.emit()