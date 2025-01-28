extends VBoxContainer

var 世代 = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	更新()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func 更新():
	add_theme_constant_override("separation", 96)
	var 主成員 = LabelSettings.new()
	主成員.font_size = 24
	主成員.font_color = Color.BLACK
	主成員.font = load("res://族譜UI相關/素材/TypeLand.com 康熙字典體完整版.ttf")
	for a in range(5):
		var t = Label.new()
		var wb = SJSD.數字轉中文(int(a+世代))
		t.text = wb+"世"
		t.label_settings = 主成員
		t.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		add_child(t)
