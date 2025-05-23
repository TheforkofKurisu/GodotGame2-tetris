extends Node


var shapes:Dictionary = {"shape1":[Vector2i(0,0),Vector2i(0,1),Vector2i(1,1),Vector2i(2,1)],
						 "shape2":[Vector2i(2,0),Vector2i(0,1),Vector2i(1,1),Vector2i(2,1)],
						 "shape3":[Vector2i(0,0),Vector2i(1,0),Vector2i(1,1),Vector2i(2,1)],
						 "shape4":[Vector2i(1,0),Vector2i(2,0),Vector2i(0,1),Vector2i(1,1)],
						 "shape5":[Vector2i(1,0),Vector2i(0,1),Vector2i(1,1),Vector2i(2,1)],
						 "shape6":[Vector2i(0,1),Vector2i(1,1),Vector2i(2,1),Vector2i(3,1)],
						 "shape7":[Vector2i(0,0),Vector2i(1,0),Vector2i(0,1),Vector2i(1,1)]
						}


var shape1_state:Array = [[Vector2i(0,0),Vector2i(0, 1),Vector2i(1, 1),Vector2i(2, 1)],[Vector2i(1,0) ,Vector2i(1, 1) ,Vector2i(0,2),Vector2i(1,2)],
[Vector2i(0,0),Vector2i(1,0),Vector2i(2,0),Vector2i(2, 1)], [Vector2i(0, 0),Vector2i(0, 1) ,Vector2i(0,2),Vector2i(1,0)]]

var shape2_state:Array = [[Vector2i(2, 0) ,Vector2i(0,1) ,Vector2i(1,1),Vector2i(2, 1)], [Vector2i(0,0) ,Vector2i(1,0),Vector2i(1, 1) ,Vector2i(1,2)],
[Vector2i(0,0),Vector2i(1,0) ,Vector2i(2,0),Vector2i(0, 1)],[Vector2i(0,0),Vector2i(0, 1),Vector2i(0,2),Vector2i(1,2)]]

var shape3_state:Array = [[Vector2i(0,0) ,Vector2i(1,0),Vector2i(1, 1),Vector2i(2, 1)], [Vector2i(1,0) ,Vector2i(0, 1),Vector2i(1, 1) ,Vector2i(0,2)]]

var shape4_state:Array = [[Vector2i(1, 0),Vector2i(2 ,0),Vector2i(0, 1),Vector2i(1,1)],[Vector2i(0,0),Vector2i(0,1),Vector2i(1,1) ,Vector2i(1,2)]]

var shape5_state:Array = [[Vector2i(1,0),Vector2i(0, 1),Vector2i(1, 1),Vector2i(2, 1)],[Vector2i(1,0) ,Vector2i(0, 1) ,Vector2i(1, 1),Vector2i(1,2)],
[Vector2i(0, 1) ,Vector2i(1, 1),Vector2i(2, 1),Vector2i( 1,2)], [Vector2i( 1, 0),Vector2i(1,1) ,Vector2i(2, 1),Vector2i(1,2)]]

var shape6_state:Array = [[Vector2i(0, 1) ,Vector2i(1, 1),Vector2i(2, 1),Vector2i(3, 1)],[Vector2i(1,0) ,Vector2i(1, 1),Vector2i(1,2) ,Vector2i(1,3)]]

var add_score:Array = [100,300,700,1500]

var level_score:Array = [2000,5000,10000,15000,20000,30000,40000,50000,100000]
