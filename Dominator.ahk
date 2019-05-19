SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.

x0:=1050
y0:=980

t::
SendInput "3w1"
return

z::
SendInput "3m1"
return

x::
SendInput "3a1"
return

d::
SendInput "{Numpad4}3"
	MouseGetPos xpos, ypos
	BlockInput("MouseMove")
	MouseMove x0-(2560-A_ScreenWidth)/2, y0
	SendInput "{Click left}"
	BlockInput("MouseMoveOff")
	MouseMove xpos, ypos
	SendInput "1"
return

f::
SendInput "{Numpad5}3"
	MouseGetPos xpos, ypos
	BlockInput("MouseMove")
	MouseMove x0-(2560-A_ScreenWidth)/2, y0
	SendInput "{Click left}"
	BlockInput("MouseMoveOff")
	MouseMove xpos, ypos
	SendInput "1"
return