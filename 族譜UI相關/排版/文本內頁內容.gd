extends Container
@export var 行距: int = 18  # 可在編輯器中調整的行距值
@export var text = []
@export var 字號 = 42
@export var spacing: float = 15.0

func _ready():
	create_vertical_text()

func create_vertical_text():
	var 主成員 = LabelSettings.new()
	主成員.font_size = 字號
	主成員.font_color = Color.BLACK
	主成員.font = load("res://族譜UI相關/素材/TypeLand.com 康熙字典體完整版.ttf")
	# 清除現有的子節點
	for child in get_children():
		child.queue_free()
	var a = HBoxContainer.new()
	a.alignment = BoxContainer.ALIGNMENT_BEGIN
	a.add_theme_constant_override("separation", 行距)
	a.set_layout_direction(Control.LAYOUT_DIRECTION_RTL)
	for i in text:
		var label = Label.new()
		label.text = i
		label.label_settings = 主成員
		label.custom_minimum_size.x = 字號
		label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.size_flags_vertical = Control.SIZE_FILL
		a.add_child(label)
	add_child(a)
# 添加自動調整大小的功能

# 添加動態更新文字的功能
func 初始化(new_text: Array):
	text = new_text
	create_vertical_text()
