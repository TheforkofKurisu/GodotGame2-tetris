extends Control
var scoreLabel:Label
var speedLabel:Label
var lines:int = 0
var score:int = 0
var speed:int = 1
var speedTimer:float = 1

func _ready():
	scoreLabel=$Score
	speedLabel=$Speed
	
func add_level(value:int):
	lines+=value
	score+=Globals.add_score[value-1]
	scoreLabel.text=str(score)
	
func reset():
	lines=0
	score=0
	speed=1
	speedTimer=1
	scoreLabel.text=str(score)
	speedLabel.text=str(speed)
	
	
func check_speed():
	var index:int = Globals.level_score.size()-1
	var tempSpeed:int =1
	
	for i in Globals.level_score.size():
		if score<Globals.level_score[index]:
			index-=1
		else :
			tempSpeed=index+2
			
	if speed != tempSpeed:
		speed=tempSpeed
		speedLabel.text=str(speed)
		speedTimer=1.1-speed*0.1
		owner.set_wait_time(speedTimer)
			
	
