extends Container
@export var 行距: int = 18  # 可在編輯器中調整的行距值
@export var text = []
@export var 字號 = 42
@export var spacing: float = 15.0

func _ready():
	create_vertical_text()

func create_vertical_text():
	# 清除現有的子節點
	for child in get_children():
		child.queue_free()
	var a = HBoxContainer.new()
	a.alignment = BoxContainer.ALIGNMENT_BEGIN
	a.add_theme_constant_override("separation", 行距)
	a.set_layout_direction(Control.LAYOUT_DIRECTION_RTL)
	for i in text:
		if i is RY:
			var s = 生成成員信息(i)
			a.add_child(s)
	add_child(a)
# 添加自動調整大小的功能

# 添加動態更新文字的功能
func 初始化(new_text: Array):
	text = new_text
	create_vertical_text()

func 生成成員信息(a:RY):
	var 大 = LabelSettings.new()
	大.font_size = 26
	大.font_color = Color.BLACK
	大.font = load("res://族譜UI相關/素材/TypeLand.com 康熙字典體完整版.ttf")
	var 中 = LabelSettings.new()
	中.font_size = 18
	中.font_color = Color.BLACK
	中.font = load("res://族譜UI相關/素材/TypeLand.com 康熙字典體完整版.ttf")
	var 姓名欄 = HBoxContainer.new()
	var 世代 = Label.new()
	世代.text = "第"+SJSD.數字轉中文(a.輩份)+"世"
	世代.label_settings = 中
	世代.custom_minimum_size.x = 18
	世代.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	世代.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	世代.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	世代.size_flags_vertical = Control.SIZE_FILL
	var 姓名 = Label.new()
	姓名.text = a.姓名
	姓名.label_settings = 大
	姓名.custom_minimum_size.x = 24
	姓名.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	姓名.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	姓名.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	姓名.size_flags_vertical = Control.SIZE_FILL
	姓名欄.add_child(世代)
	姓名欄.add_child(姓名)
	var 簡介欄 = HBoxContainer.new()
	var b = SJSD.拆分文本(a.個人簡介,15)
	for i in b:
		var label = Label.new()
		label.text = i
		label.label_settings = 大
		label.custom_minimum_size.x = 24
		label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.size_flags_vertical = Control.SIZE_FILL
		簡介欄.add_child(label)
	var 成員欄 = VBoxContainer.new()
	成員欄.add_child(姓名欄)
	成員欄.add_child(簡介欄)
	return 成員欄
