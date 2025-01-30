extends Node2D

var shuji = SJSD_Only
var s = ScrollContainer.new()
var Tab = TabContainer.new()
var 頁碼 = 0
# 當節點進入場景樹時執行
func _ready() -> void:
	shuji.加載數據信息()
	shuji.初始化(SJSD_Only.姓氏)
	# 創建 ScrollContainer
	s.size = Vector2(1400, 1020)
	s.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	s.size_flags_vertical = Control.SIZE_EXPAND_FILL
	# 創建 VBoxContainer
	#v.size_flags_vertical = Control.SIZE_EXPAND_FILL
	Tab.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# 按照每兩頁一組進行分組
	
	var fm = preload("res://族譜UI相關/排版/封面頁面.tscn").instantiate()
	fm.更新文本(shuji.姓氏+"氏族譜")
	Tab.add_child(fm)  # 將封面添加到 VBoxContainer
	A3文本頁面預處理(shuji.前言頁面)
	# 添加封面頁面
	var fz = preload("res://族譜UI相關/排版/分支頁面.tscn").instantiate()
	fz.更新書芯(shuji.姓氏+"氏族譜")
	Tab.add_child(fz) 
	var 成員 = preload("res://族譜UI相關/排版/A3成員頁面.tscn").instantiate()
	var a = shuji.拆分成員(8)
	成員.初始化(a,0)
	成員.更新書芯(shuji.姓氏+"氏族譜")
	Tab.add_child(成員) 
	# 設置 VBoxContainer 的最小高度，確保可以滾動
	#v.custom_minimum_size = Vector2(1920, pairs.size() * 1020 + 1080)  # 每頁1020 + 封面1080
	A3文本頁面預處理(shuji.後記頁面)
	# 將 VBoxContainer 添加到 ScrollContainer
	s.add_child(Tab)
	s.queue_sort()

	# 將 ScrollContainer 添加到場景
	add_child(s)

# 每幀執行
func _process(delta: float) -> void:
	pass
func A3文本頁面預處理(單頁內容:Array):
	var pairs = []
	for i in range(0, 單頁內容.size(), 2):
		if i + 1 < 單頁內容.size():
			pairs.append([單頁內容[i], 單頁內容[i + 1]])
		else:
			# 如果是奇數頁，將最後一頁單獨加入
			pairs.append([shuji.前言頁面[i]])
	for a in range(pairs.size()):
		# 每一組都應該創建新的頁面實例
		頁碼 += a
		var 頁面1 = preload("res://族譜UI相關/排版/A3文本頁面.tscn").instantiate()
		# 初始化頁面內容
		頁面1.書芯 = shuji.姓氏+"氏族譜"
		頁面1.初始化(pairs[a], int(頁碼)) 
		
		Tab.add_child(頁面1)
	  # 設置頁碼索引
	頁碼 += 1
