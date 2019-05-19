SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.
x0:=1050
y0:=980
canceled:=0

~^LWin::
Reload
return

#if WinActive("ahk_exe dota2.exe")

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
SendInput "!73"
	MouseGetPos xpos, ypos
	BlockInput("MouseMove")
	MouseMove x0-(2560-A_ScreenWidth)/2, y0
	SendInput "{Click left}"
	BlockInput("MouseMoveOff")
	MouseMove xpos, ypos
	SendInput "1"
return

f::
SendInput "!83"
	MouseGetPos xpos, ypos
	BlockInput("MouseMove")
	MouseMove x0-(2560-A_ScreenWidth)/2, y0
	SendInput "{Click left}"
	BlockInput("MouseMoveOff")
	MouseMove xpos, ypos
	SendInput "1"
return

~s::
canceled:=0
return

~g::
canceled:=0
KeyWait "g"
if(canceled==0)
{
	SendInput "{click}"
}
canceled:=1
return

#if WinActive("ahk_exe dota2.exe")&&(canceled==0)
RButton::
canceled:=1
SendInput "{Esc}"
KeyWait "RButton"
return

#if