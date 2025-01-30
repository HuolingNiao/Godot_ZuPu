extends Node2D

var shuji = SJSD_Only
var s = ScrollContainer.new()
var Tab = TabContainer.new()
var 頁碼 = 0
var pdf = []
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
	pdf.append(fm)
	Tab.add_child(fm)  # 將封面添加到 VBoxContainer
	A3文本頁面預處理(shuji.前言頁面)
	# 添加封面頁面`
	var fz = preload("res://族譜UI相關/排版/分支頁面.tscn").instantiate()
	fz.更新書芯(shuji.姓氏+"氏族譜")
	pdf.append(fz)
	Tab.add_child(fz) 
	var 成員 = preload("res://族譜UI相關/排版/A3成員頁面.tscn").instantiate()
	var a = shuji.拆分成員(8)
	成員.初始化(a,0)
	成員.更新書芯(shuji.姓氏+"氏族譜")
	pdf.append(成員)
	Tab.add_child(成員) 
	# 設置 VBoxContainer 的最小高度，確保可以滾動
	#v.custom_minimum_size = Vector2(1920, pairs.size() * 1020 + 1080)  # 每頁1020 + 封面1080
	A3文本頁面預處理(shuji.後記頁面)
	# 將 VBoxContainer 添加到 ScrollContainer
	SJSD_Only.pdf頁面 =Tab
	s.add_child(Tab)
	s.queue_sort()

	# 將 ScrollContainer 添加到場景
	add_child(s)
	
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
		pdf.append(頁面1)
		Tab.add_child(頁面1)
	  # 設置頁碼索引
	頁碼 += 1
 # 直接存儲 PNG 格式數據
func 輸出img(i:Control):
	
	var a = i.duplicate()
	$SubViewportContainer/SubViewport.size = Vector2(1400,1020)
	$SubViewportContainer/SubViewport.add_child(a)
	await RenderingServer.frame_post_draw
	var image = $SubViewportContainer/SubViewport.get_texture().get_image()
	image.convert(Image.FORMAT_RGB8)
	image.save_jpg_to_buffer(80)
	image.save_png("res://screenshot" + str(i) + ".png")
	$SubViewportContainer/SubViewport.remove_child(a)
	return image
func 導出pdf():
	var images = []
	
	# **1. 遍歷 TabContainer 內的所有子節點**
	for i in range(Tab.get_child_count()):
		var page = Tab.get_child(i)
		Tab.current_tab = i
		await get_tree().create_timer(0.2).timeout
		if page is Control:
			# **2. 截圖該頁面**
			var img = await 輸出img(page)
			if img:
				images.append(img)
	var pdf_path = "res://族譜輸出.pdf"
	var a = shuji
	a.生成pdf(images,pdf_path)

func _on_主菜單_pdf(date: Variant) -> void:
	導出pdf()
	print("1")
	pass # Replace with function body.
