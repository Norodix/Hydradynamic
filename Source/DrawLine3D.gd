extends Node2D

class Line:
	var Start
	var End
	var LineColor
	var TTL # Time to live
	var Drawn
	
	func _init(start,end,linecolor,ttl):
		self.Start = start
		self.End = end
		self.LineColor = linecolor
		self.TTL = ttl
		self.Drawn = false

var Lines = []
var RemovedLine = false

func _process(delta):
	for i in range(len(Lines)):
		Lines[i].TTL -= delta
	
	if Lines.size() > 0:
		queue_redraw()
	

func _draw():
	#Remove lines that have timed out and have been drawn already
	var j = Lines.size() - 1
	while (j >= 0):
		if(Lines[j].TTL < 0.0 && Lines[j].Drawn):
			Lines.remove_at(j)
			RemovedLine = true
		j -= 1	


	var Cam = get_viewport().get_camera_3d()
	
	if not Cam:
		return
		
	for i in range(len(Lines)):
		var ScreenPointStart = Cam.unproject_position(Lines[i].Start)
		var ScreenPointEnd = Cam.unproject_position(Lines[i].End)
		
		Lines[i].Drawn = true # mark as drawn even if not visible to avoid mem leak
		
		#Dont draw line if either start or end is considered behind the camera
		#this causes the line to not be drawn sometimes but avoids a bug where the
		#line is drawn incorrectly
		if(Cam.is_position_behind(Lines[i].Start) ||
			Cam.is_position_behind(Lines[i].End)):
			continue
		
		draw_line(ScreenPointStart, ScreenPointEnd, Lines[i].LineColor)
	


func DrawLine(Start, End, LineColor, TTL = 0.0):
	Lines.append(Line.new(Start, End, LineColor, TTL))

func DrawRay(Start, Ray, LineColor, TTL = 0.0):
	Lines.append(Line.new(Start, Start + Ray, LineColor, TTL))

func DrawCoords(t : Transform3D, ColorX = Color.RED, ColorY = Color.GREEN, ColorZ = Color.BLUE, TTL = 0.0):
	DrawRay(t.origin, t.basis.x, ColorX, TTL)
	DrawRay(t.origin, t.basis.y, ColorY, TTL)
	DrawRay(t.origin, t.basis.z, ColorZ, TTL)

func DrawCube(Center, HalfExtents, LineColor, TTL = 0.0):
	#Start at the 'top left'
	var LinePointStart = Center
	LinePointStart.x -= HalfExtents
	LinePointStart.y += HalfExtents
	LinePointStart.z -= HalfExtents
	
	#Draw top square
	var LinePointEnd = LinePointStart + Vector3(0, 0, HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, TTL);
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, TTL);
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(0, 0, -HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, TTL);
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(-HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, TTL);
	
	#Draw bottom square
	LinePointStart = LinePointEnd + Vector3(0, -HalfExtents * 2.0, 0)
	LinePointEnd = LinePointStart + Vector3(0, 0, HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, TTL);
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, TTL);
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(0, 0, -HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, TTL);
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(-HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, TTL);
	
	#Draw vertical lines
	LinePointStart = LinePointEnd
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, TTL)
	LinePointStart += Vector3(0, 0, HalfExtents * 2.0)
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, TTL)
	LinePointStart += Vector3(HalfExtents * 2.0, 0, 0)
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, TTL)
	LinePointStart += Vector3(0, 0, -HalfExtents * 2.0)
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, TTL)
