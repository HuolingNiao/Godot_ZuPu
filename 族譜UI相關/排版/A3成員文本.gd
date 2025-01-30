extends Control
var 書芯 = "軒轅族譜"
var 書籍 = SJSD.new()

func _ready() -> void:
	
	pass

# 優化後的初始化方法
func 初始化(a: Array, 頁碼: int) -> Control:
	# 確保輸入數據不為空
	$"PanelContainer/TextureRect/書芯".text = 書芯
	$"PanelContainer/TextureRect/書芯".autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if a.is_empty():
		print("初始化數據為空，無法處理")
		return self
	
	# 計算頁碼
	var 頁碼1_顯示:int = 頁碼 * 2 + 1  # 計算顯示的第一頁頁碼
	var 頁碼2_顯示:int = 頁碼 * 2 + 2  # 計算顯示的第二頁頁碼
	
	# 初始化第一頁內容
	$Container.初始化(a[0])
	$"PanelContainer/TextureRect/頁碼1".text = SJSD.數字轉中文(頁碼1_顯示) 
	print(頁碼1_顯示) # 顯示頁碼

	# 處理第二頁（若有）
	if a.size() > 1:
		$Container2.初始化(a[1])
		$"PanelContainer/TextureRect/頁碼2".text = SJSD.數字轉中文(頁碼2_顯示)  # 顯示頁碼
	else:
		# 如果第二頁不存在，清空第二頁容器的內容
		#Container2.初始化("")  # 假設初始化空字符串即可清空
		$"PanelContainer/TextureRect/頁碼2".text = ""

	return self
func 更新書芯(a:String):
	$"PanelContainer/TextureRect/書芯".text = a
	$"PanelContainer/TextureRect/書芯".autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
