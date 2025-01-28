extends HBoxContainer

@onready var date_input: LineEdit = $LineEdit
@onready var hour_select: OptionButton = $OptionButton

const CHINESE_HOURS = ["子時(23:00-1:00)", "丑時(1:00-3:00)", "寅時(3:00-5:00)", 
					  "卯時(5:00-7:00)", "辰時(7:00-9:00)", "巳時(9:00-11:00)",
					  "午時(11:00-13:00)", "未時(13:00-15:00)", "申時(15:00-17:00)",
					  "酉時(17:00-19:00)", "戌時(19:00-21:00)", "亥時(21:00-23:00)"]

func _ready():
	setup_date_input()
	setup_hour_select()

func setup_date_input():
	date_input.placeholder_text = "YYYY-MM-DD"
	date_input.text_changed.connect(_on_date_changed)

func setup_hour_select():
	for hour in CHINESE_HOURS:
		hour_select.add_item(hour)
	hour_select.item_selected.connect(_on_hour_selected)

func _on_date_changed(new_text: String):
	if SJ.檢查日期格式(new_text):
		date_input.modulate = Color.WHITE
	else:
		date_input.modulate = Color.RED

func _on_hour_selected(index: int):
	var hour = index * 2
	if hour == 0:
		hour = 23

func 獲取時間():
	var a = SJ.new(date_input.text,hour_select.selected * 2 if hour_select.selected > 0 else 23)
	
func 更新文本(a:String):
	if a == "+0":
		date_input.text = ""
		hour_select.select(-1)
	var date_parts = a.split("+")
	
	date_input.text = date_parts[0]
	hour_select.select(int(date_parts[1]))
