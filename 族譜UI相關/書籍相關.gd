extends Node
class_name SJSD
var 成員 = SJK.new()
var 姓氏 = "軒轅"
var 族譜名稱 = ""
var 書芯名稱 = ""
var 字輩 = ""
var 前言 = ""
var 後記 = ""
var 前言頁面 = []
var 後記頁面 = []
var pdf頁面
# 通用族譜序言和後記生成腳本
# 使用方法：調用generate_intro或generate_epilogue函數，傳入姓氏作為參數

func 生成前言() -> String:
	var intro = ""

	# 姓氏起源
	intro += "前言\n"+\
			 姓氏 + "氏之源，肇自上古，滄海桑田，世代綿延。" + \
			 "據史籍所載，" + 姓氏 + "姓或因部族之名，或因地望而興，抑或因官職、功績而得。" + \
			 "或傳某上古聖人，其功昭於天地，遂以" + 姓氏 + "為氏，此實為" + 姓氏 + "姓之濫觴。\n\n"

	# 姓氏發展
	intro += "歷朝歷代，" + 姓氏 + "氏之繁衍有跡可循。" + \
			 "漢唐之際，族中多官宦與學士，其貢獻可謂彪炳史冊。" + \
			 "至於宋元明清，文武兼備，名垂青史者不勝枚舉。" + \
			 "其族裔更因時代變遷，或遷徙四方，或播遷海外，成為文化交融之橋樑。\n\n"

	# 姓氏分佈
	intro += "今觀" + 姓氏 + "氏，遍布九州四海，尤以江南與中原為最盛。" + \
			 "隨移民之風潮，其後裔早已遷徙五洲，於異邦立足，光耀先祖之德。" + \
			 "無論故土或異鄉，" + 姓氏 + "氏族皆以忠義孝悌、勤謹篤實為世所稱道。\n\n"

	# 姓氏文化
	intro += "" + 姓氏 + "氏之家風，涵養深厚，綿延千載。" + \
			 "家訓育人，族譜紀史，春秋祭祖，無不彰顯家族之傳統與精神。" + \
			 "每逢佳節，族人聚首，溯源敬祖，亦延續家族之凝聚力。" + \
			 "此等傳統，不僅乃宗族之寶，亦為民族文化之瑰寶。\n\n"

	# 收尾
	intro += "族譜之編纂，旨在承先啟後，啟迪後人。願" + 姓氏 + "氏族能繼承祖德，光大其業，" + \
			 "於未來創造更加輝煌之篇章。"

	return intro

func 生成後記() -> String:
	var epilogue = ""

	# 感謝與總結
	epilogue += "後記\n"+\
	"族譜一書，字字斟酌，乃族中長幼合力之成果。" + \
				"感謝諸位宗親，不辭勞苦，搜集史料，編撰成冊。此乃家族之盛事，當為永誌。\n\n"

	# 家族未來
	epilogue += "《" + 姓氏 + "》氏族千年流轉，代代相傳，其精神融於血脈，其文化植於心田。" + \
				"吾輩當謹守祖訓，敬宗收族，延續家風，使後世子孫不忘根本，砥礪前行。\n\n"

	# 展望
	epilogue += "余祈《" + 姓氏 + "》氏之後裔，興於德，成於業，不負先祖厚望。" + \
				"願此譜為明燈，照亮未來之路，使吾族子孫於百代之後，仍能承德報本，榮光長存。"

	return epilogue

static func 拆分文本(文本:String, 字數:int) -> Array:
	var 文本2 = []
	var 段落列表 = 文本.split("\n")
	
	for 段落 in 段落列表:
		if 段落.length() <= 字數:
			文本2.append(段落)
			continue
			
		var length = 段落.length()
		var index = 0
		
		while index < length:
			var end = min(index + 字數, length)
			文本2.append(段落.substr(index, 字數))
			index += 字數
			
		## 在每個段落後添加換行
		#if 段落 != 段落列表[-1]:
			#文本2.append("")
			
	return 文本2
func 拆分頁面(文本: String, 每行字數: int, 每頁行數: int) -> Array:
	var 結果 = []
	var 已拆分文本 = 拆分文本(文本, 每行字數)
	var 當前頁 = []

	for 行 in 已拆分文本:
		當前頁.append(行)

		if 當前頁.size() == 每頁行數:
			結果.append(當前頁)
			當前頁 = []

	if 當前頁.size() > 0:
		結果.append(當前頁)

	return 結果

func 初始化(a:String):
	姓氏 = a
	前言 = 生成前言()
	後記 = 生成後記()

	var 每行字數 = 17
	var 每頁行數 = 9

	前言頁面 = 拆分頁面(前言, 每行字數, 每頁行數)
	後記頁面 = 拆分頁面(後記, 每行字數, 每頁行數)

static func 數字轉中文(a: int) -> String:
	const CHINESE_NUMBERS = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
	const UNITS = ["", "十", "百", "千"]
	const LARGE_UNITS = ["", "萬", "億", "兆"]

	if a == 0:
		return CHINESE_NUMBERS[0]

	var result = ""
	var unit_index = 0
	var large_unit_index = 0
	var is_prev_zero = false

	while a > 0:
		var segment = a % 10000  # 取出每四位數作為一組 (萬進位)
		if segment > 0:
			var segment_str = ""
			var segment_unit_index = 0
			while segment > 0:
				var digit = segment % 10
				if digit > 0:
					if is_prev_zero:
						segment_str = CHINESE_NUMBERS[0] + segment_str
						is_prev_zero = false
					segment_str = CHINESE_NUMBERS[digit] + UNITS[segment_unit_index] + segment_str
				else:
					is_prev_zero = true
				segment = segment / 10
				segment_unit_index += 1
			result = segment_str + LARGE_UNITS[large_unit_index] + result
		else:
			is_prev_zero = true

		a = a / 10000
		large_unit_index += 1

	# 處理「一十」的簡化情況，例如將「一十二」簡化為「十二」
	if result.begins_with("一十"):
		result = result.substr(1)

	return result

static func 拆分成員(a:int) -> Array:
	var cy = []
	var dq = []
	var sj = SJK.new()
	sj.加载数据库()
	for i in sj.data.keys():
		var ry1 = sj.按ID查找(i)
		dq.append(ry1)
		if dq.size() == a:
			cy.append(dq)
			dq = []
	if dq.size() > 0:
		cy.append(dq)
	return cy
func 儲存書籍信息():
	var a = {
		"姓氏" = 姓氏,
		"族譜名稱" = 族譜名稱,
		"書芯名稱" = 書芯名稱,
		"字輩" = 字輩,
		"前言" = 前言,
		"後記" = 後記,
	}
	成員.保存書籍数据(a)
func 加載數據信息():
	成員.加载数据库()
	self.姓氏 = 成員.書籍信息["姓氏"]
	self.族譜名稱 = 成員.書籍信息["族譜名稱"]
	self.書芯名稱 = 成員.書籍信息["書芯名稱"]
	self.字輩 = 成員.書籍信息["字輩"]
	self.前言 = 成員.書籍信息["前言"]
	self.後記 = 成員.書籍信息["後記"]
	
func 導出pdf():
	get_tree().change_scene_to_file("res://族譜UI相關/排版/pdf測試.tscn")
	var images = []
	var tab_container = pdf頁面 as TabContainer

	for i in tab_container.get_children():
	# 切換到當前標籤頁
		#tab_container.current_tab = i
	
	# 獲取當前標籤頁的內容
		#var tab_content = tab_container.get_current_tab_control()
	
	# 等待一幀確保UI更新
		await get_tree().process_frame
	
	# 擷取圖像
		var img = await 視圖轉圖像(i)
	
		if img:
			images.append(img)
			img.save_png("res://screenshot" + str(i) + ".png")
		else:
			print("無法擷取圖像：" + str(i))

	# 指定 PDF 輸出路徑
	var pdf_path = "res://族譜輸出.pdf"

	# 生成 PDF 文件
	生成pdf(images, pdf_path)

	# 提示導出完成
	print("PDF 已成功導出到: ", pdf_path)

# 擷取 Control 節點的圖像
func 視圖轉圖像(control: Control) -> Image:
	# 確保控制項有效
	if !is_instance_valid(control):
		return null
	var size = control.get_rect().size
	var viewport = SubViewport.new()
	add_child(viewport)
	
	viewport.size = size
	viewport.transparent_bg = false
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	
	# 直接使用原始控制項而不是複製
	viewport.add_child(control)
	
	# 多等待幾幀確保渲染完成
	await RenderingServer.frame_post_draw
	
	var image = viewport.get_texture().get_image()
	
	# 將控制項移回原位
	
	viewport.queue_free()
	
	return image





# 生成 PDF 文件（GDScript 純手寫 PDF）
func 生成pdf(images: Array, pdf_path: String):
	
	var pdf_content = "%PDF-1.7\n"  # PDF 文件頭
	var obj_count = 1
	var xrefs = []
	var binary_data = PackedByteArray()  # 存放二進制數據

	# **1. 根目錄 (Catalog)**
	var root_obj = obj_count
	pdf_content += str(root_obj) + " 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n"
	xrefs.append([root_obj, pdf_content.length()])
	obj_count += 1

	# **2. 頁面樹 (Pages)**
	var pages_obj = obj_count
	pdf_content += str(pages_obj) + " 0 obj\n<< /Type /Pages /Count " + str(images.size())
	pdf_content += " /Kids ["
	for i in range(images.size()):
		pdf_content += str(obj_count + i + 1) + " 0 R "  # 頁面對象引用
	pdf_content += "] >>\nendobj\n"
	xrefs.append([pages_obj, pdf_content.length()])
	obj_count += 1

	# **3. 圖像與頁面對象**
	for i in range(images.size()):
		var image_data = images[i]
		var img_obj = obj_count
		var page_obj = obj_count + 1
		obj_count += 2

		# **3.1 將 PNG 轉換為 JPEG（PDF 需要 JPEG）**
		var img_data_encoded = image_data_to_pdf_stream(image_data)
		var img_length = img_data_encoded.size()

		# **3.2 添加圖片對象**
		var img_header = str(img_obj) + " 0 obj\n"
		img_header += "<< /Type /XObject /Subtype /Image"
		img_header += " /Width " + str(image_data.get_width())
		img_header += " /Height " + str(image_data.get_height()) + " /ColorSpace /DeviceRGB"
		img_header += " /BitsPerComponent 8 /Filter /DCTDecode /Length " + str(img_length) + " >>\n"
		img_header += "stream\n"
		pdf_content += img_header
		xrefs.append([img_obj, pdf_content.length() + binary_data.size()])
		binary_data += img_data_encoded
		binary_data += "\nendstream\nendobj\n".to_utf8_buffer()

		# **3.3 添加頁面對象**
		var page_header = str(page_obj) + " 0 obj\n"
		page_header += "<< /Type /Page /Parent 2 0 R /Resources << /XObject << /Im1 " + str(img_obj) + " 0 R >> >>"
		page_header += " /MediaBox [0 0 " + str(image_data.get_width()) + " " + str(image_data.get_height()) + "]"
		page_header += " /Contents " + str(img_obj) + " 0 R >>\nendobj\n"
		pdf_content += page_header
		xrefs.append([page_obj, pdf_content.length()])

	# **4. XREF 表**
	var xref_pos = pdf_content.length() + binary_data.size()
	pdf_content += "xref\n0 " + str(obj_count) + "\n0000000000 65535 f \n"
	for entry in xrefs:
		pdf_content += "%010d 00000 n \n" % entry[1]
	pdf_content += "trailer\n<< /Size " + str(obj_count) + " /Root 1 0 R >>\nstartxref\n" + str(xref_pos) + "\n%%EOF"

	# **5. 寫入 PDF**
	var file = FileAccess.open(pdf_path, FileAccess.WRITE)
	file.store_string(pdf_content)  # 先寫入 PDF 文本部分
	file.store_buffer(binary_data)  # 再寫入二進制圖片數據
	file.close()
	print("PDF 生成成功: " + pdf_path)

# 將圖像數據轉換為 PDF 兼容格式
func image_data_to_pdf_stream(image: Image) -> PackedByteArray:
	image.convert(Image.FORMAT_RGB8)  # 確保為 RGB 格式
	return image.save_jpg_to_buffer(80)
