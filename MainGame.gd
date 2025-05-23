extends Node
#常量
const START_POS:Vector2i = Vector2i(4,0)
const DISTANCE:Vector2i = Vector2i(0,1)
#下一个形状
var nextTileMap:TileMap
var nextShape:Array
var nextShapeIndex:int=1
#当前形状
var currentTileMap:TileMap
var currentShape:Array
var currentShapeIndex:int=1
#已经落地的形状
var landedTiles:Array = []
#预测落点
var finalLocationShape:Array=[]
#变量
var lateralMove:int = 0
var statusIndex:int = 0
var isGameNotOver:bool = 1
var gameMode:bool = 1
var speed:int = 1
var color:int = 0
var music:int = 0

#计时器
var tick:Timer
var LateralTimer:Timer


#GUI
var GUI:Control

func _ready():
	#拿组件
	nextTileMap=$NextTileMap
	currentTileMap=$TileMap
	tick=$Tick
	LateralTimer=$LateralTimer
	GUI=$GUI

	#开始的UI处理
	$Title.hide()
	$Died.hide()
	$Button.hide()
	color=randi_range(0,4)
	
	
	get_next_shape()
	delete_next_shape()
	show_next_shape()
	get_current_shape()
	final_location()
	show_current_shape()
	delete_next_shape()
	get_next_shape()
	show_next_shape()
	tick.start()
	
	GUI.reset()
	
func _process(delta):
	if isGameNotOver:
		lateralMove=Input.get_action_strength("move_right")-Input.get_action_strength("move_left")
		if Input.is_action_just_pressed("move_down"):
			tick.stop()
			tick.wait_time=0.1
			tick.start()
			if music>=0 && music<4:
				$Audio/Quick1.play()
			elif music<8:
				$Audio/Quick2.play()
			else :
				$Audio/Quick3.play()
		if Input.is_action_just_released("move_down"):
			tick.stop()
			tick.wait_time=GUI.speedTimer
			tick.start()
		if Input.is_action_just_pressed("spin"):
			get_rotated()
		if Input.is_action_just_pressed("fast_down"):
			get_fast_down()
		if Input.is_action_just_pressed("switch"):
			gameMode=!gameMode
			if gameMode:
				$Audio/GameMode1.play()
			else:
				$Audio/GameMode2.play()
		

#获取下一个形状
func get_next_shape():
	randomize()
	if gameMode:
		nextShapeIndex=randi() % 7 + 1
	else: 
		nextShapeIndex=randi_range(6,7)
	nextShape=Globals.shapes["shape"+str(nextShapeIndex)]

#绘制下一个形状
func show_next_shape():
	for cell in nextShape:
		nextTileMap.set_cell(0,Vector2i(cell.x,cell.y),color,Vector2i(0,0))

#删除下一个形状
func delete_next_shape():
	for cell in nextShape:
		nextTileMap.set_cell(0,Vector2i(cell.x,cell.y),-1,Vector2i(-1,-1))

#获取目前形状
func get_current_shape():
	statusIndex=0
	currentShapeIndex=nextShapeIndex
	currentShape=[]
	for cell in nextShape:
		currentShape.append(Vector2i(cell.x+START_POS.x,cell.y+START_POS.y))

#绘制目前形状
func show_current_shape():
	for cell in currentShape:
		currentTileMap.set_cell(0,Vector2i(cell.x,cell.y),color,Vector2i(0,0))

#删除目前形状
func delete_current_shape():
	for cell in currentShape:
		currentTileMap.set_cell(0,Vector2i(cell.x,cell.y),-1,Vector2i(0,0))

#旋转方法
func get_rotated():
	delete_current_shape()
	rotated_current_shape()
	final_location()
	show_current_shape()

#旋转当前方块
func rotated_current_shape():
	if currentShapeIndex != 7:
		var min_x:int = get_min_x(currentShape)
		var min_y:int = get_min_y(currentShape)
		
		var statusList:Array
		match currentShapeIndex:
			1:
				statusList=Globals.shape1_state
			2:
				statusList=Globals.shape2_state
			3:
				statusList=Globals.shape3_state
			4:
				statusList=Globals.shape4_state
			5:
				statusList=Globals.shape5_state
				if statusIndex==2:
					min_y-=1
				elif statusIndex==3:
					min_x-=1
			6:
				statusList=Globals.shape6_state
				if statusIndex==0:
					min_y-=1
				else :
					min_x-=1
		
		
		var tempIndex:int = statusIndex+1
		if tempIndex>=statusList.size():
			tempIndex=0
				
		var status:Array = statusList[tempIndex].duplicate()
		for i in status.size():
			status[i].x+=min_x
			status[i].y+=min_y
		
		var isBound:bool = check_bound(status)
		var isLanded:bool = check_landed(status)
		
		if not isBound and not isLanded:
			currentShape=status
			statusIndex=tempIndex
			if music>=0 && music<6:
				$Audio/Spin1.play()
			else :
				$Audio/Spin2.play()

	
#下落方法
func move_current_shape():
	check_game_over()
	delete_current_shape()
	var currentCopy:Array=[]
	for cell in currentShape:
		cell+=DISTANCE
		currentCopy.append(cell)
		
	var isLand:bool = check_landed(currentCopy)
	var isOverlap:bool = check_overlapping(currentCopy)
	
	if isLand:
		landedTiles.append_array(currentShape)
		delete_current_shape()
		get_current_shape()
		delete_next_shape()
		get_next_shape()
		show_next_shape()
		check_full_lines()
		final_location()
		show_current_shape()
		show_landed_shapes()
		if music>=0 && music<4:
			$Audio/Fall1.play()
		elif music<8:
			$Audio/Fall2.play()
		else :
			$Audio/Fall3.play()
		
	elif isOverlap:
		landedTiles.append_array(currentShape)
		delete_current_shape()
		get_current_shape()
		delete_next_shape()
		get_next_shape()
		show_next_shape()
		check_full_lines()
		final_location()
		show_current_shape()
		show_landed_shapes()
		if music>=0 && music<4:
			$Audio/Fall1.play()
		elif music<8:
			$Audio/Fall2.play()
		else :
			$Audio/Fall3.play()
	
	else :
		currentShape=currentCopy

#平移方法
func lateral_move_current_shape():
	delete_current_shape()

	var currentCopy:Array=[]
	for cell in currentShape:
		cell.x+=lateralMove
		currentCopy.append(cell)

	var isBound:bool = check_bound(currentCopy)
	var isOverlapp:bool = check_overlapping(currentCopy)
	if not isBound and not isOverlapp:
		currentShape=currentCopy
	$Audio/Move.play()
	
#检查是否平移超过边界
func check_bound(copy:Array):
	var isBound:bool = false
	var min_x:int = get_min_x(copy)
	var max_x:int = get_max_x(copy)
	
	if min_x < 0:
		isBound=true
	if max_x > 9:
		isBound=true
	
	return isBound

#检查是否落到底或其他方块

#落在地面上
func check_landed(copy:Array):
	
	var isLand:bool = false
	var max_y:int = get_max_y(copy)
	if  max_y>19:
		isLand=true
	
	return isLand

#落在其他方块上	
func check_overlapping(copy:Array):
	var isOverlap:bool = false
	for cell1 in landedTiles:
		for  cell2 in copy:
			if cell2 == cell1:
				isOverlap = true
				break
	return isOverlap

#找到最大v2的y值的方法
func get_max_y(copy:Array):
	var max_y:int = 0
	for cell in copy:
		if cell.y > max_y:
			max_y=cell.y
	return max_y

#找到最大v2的x值的方法
func get_max_x(copy:Array):
	var max_x:int = 0
	for cell in copy:
		if cell.x > max_x:
			max_x=cell.x
	return max_x
	
#找到最小v2的x值的方法
func get_min_x(copy:Array):
	var min_x:int = 100
	for cell in copy:
		if cell.x < min_x:
			min_x=cell.x
	return min_x

#找到最小的v2的y值方法
func get_min_y(copy:Array):
	var min_y:int = 100
	for cell in copy:
		if cell.y < min_y:
			min_y=cell.y
	return min_y

#绘制已经落地的方块	
func show_landed_shapes():
	for cell in landedTiles:
		currentTileMap.set_cell(0,Vector2i(cell.x,cell.y),color,Vector2i(0,0))					

#预测落点
func final_location():
	delete_final_shape()
	var depth:int = 1
	
	var currentCopy:Array=[]
	for cell in currentShape:
		cell.y+=depth
		currentCopy.append(cell)
		
	var isLanded:bool = check_landed(currentCopy)
	var isOverLap:bool = check_overlapping(currentCopy)
	
	while not isLanded and not isOverLap:
		depth+=1
		currentCopy=[]
		for cell in currentShape:
			cell.y+=depth
			currentCopy.append(cell)
		isLanded=check_landed(currentCopy)
		isOverLap=check_overlapping(currentCopy)
		
	finalLocationShape=[]
		
	for cell in currentCopy:
		cell.y-=1
		finalLocationShape.append(cell)
		
		show_final_shape()	

#绘制预测落点
func show_final_shape():
	for cell in finalLocationShape:
		currentTileMap.set_cell(0,Vector2i(cell.x,cell.y),color+5,Vector2i(0,0))
			
#删除预测落点
func delete_final_shape():
	for cell in finalLocationShape:
		currentTileMap.set_cell(0,Vector2i(cell.x,cell.y),-1,Vector2i(-1,-1))
	
#检查是否满行
func check_full_lines():
	#一行有多少个块
	var line_elements:int = 0
	#第几行
	var line:int = 19
	#当前行里所有数据的位置
	var tileIndex:Array = []
	#会满几行
	var fullLineCount:int = 0
	while line > 0:
		line_elements=0
		tileIndex=[]
		for i in landedTiles.size():
			var cell:Vector2i = landedTiles[i]
			if cell.y == line:
				line_elements+=1
				tileIndex.append(i)
		if line_elements==10:
			fullLineCount+=1
			delete_landed_data(tileIndex,line)
		else:
			line -= 1
	if fullLineCount>0:
		delete_landed_tile()
		show_landed_shapes()
		show_current_shape()
		if music>=0 && music<6:
			$Audio/Erase1.play()
		else: 
			$Audio/Erase2.play()
		GUI.add_level(fullLineCount)		

#删除落地的数据
func delete_landed_data(tileIndex:Array,line:int):
	while tileIndex.size()>0:
		landedTiles.remove_at(tileIndex.pop_back())					
	for i in landedTiles.size():
		if landedTiles[i].y<line:
			landedTiles[i].y+=1 
		
	
#删除落地的图形		
func delete_landed_tile():
	var cells:Array=currentTileMap.get_used_cells_by_id(0)
	for cell in cells:
		currentTileMap.set_cell(0,Vector2i(cell.x,cell.y),-1,Vector2i(-1,-1))

#检测失败

func check_game_over():
	for cell in landedTiles:
		if cell.y == 0:
			tick.stop()
			LateralTimer.stop()
			isGameNotOver=0
			$Audio/End.play()
			
			$Died.show()
			$.show()
			$Button.show()

#快速下落
func get_fast_down():
	check_game_over()
	for cell in finalLocationShape:
		landedTiles.append(cell)

	delete_current_shape()
	get_current_shape()
	delete_next_shape()
	get_next_shape()
	show_next_shape()
	check_full_lines()
	final_location()
	show_current_shape()
	show_landed_shapes()
	if music>=0 && music<4:
		$Audio/Fall1.play()
	elif music<8:
		$Audio/Fall2.play()
	else :
		$Audio/Fall3.play()
							
#计时器信号
func _on_tick_timeout():
	randomize()
	music=randi_range(0,10)
	if isGameNotOver:
		GUI.check_speed()
		move_current_shape()
		show_current_shape()


func _on_lateral_timer_timeout():
	if lateralMove!=0:
		lateral_move_current_shape()
		final_location()
		show_current_shape()


func set_wait_time(value:float):
	tick.stop()
	tick.wait_time=value
	tick.start()
	
	
func _on_button_button_down():
	$Died.hide()
	$Title.hide()
	$Button.hide()
	GUI.reset()
	for cell in landedTiles:
		currentTileMap.set_cell(0,Vector2i(cell.x,cell.y),-1,Vector2i(0,0))
	landedTiles=[]
	color=randi_range(0,4)
		
	isGameNotOver=1
	
	delete_next_shape()
	get_next_shape()
	show_next_shape()
	get_current_shape()
	final_location()
	show_current_shape()
	delete_next_shape()
	get_next_shape()
	show_next_shape()
	
	tick.start()
	LateralTimer.start()
	

