extends Control

var 姓氏 = ""
func 更新文本(a:String):
	姓氏 =a
	$Label.text = 姓氏+"氏族譜"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	更新文本("溫")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
