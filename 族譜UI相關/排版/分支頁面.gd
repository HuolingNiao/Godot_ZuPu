extends Control
var 姓氏 = ""
func 更新書芯(a:String):
	$"PanelContainer/TextureRect/書芯".text = a
	$"PanelContainer/TextureRect/書芯".autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
