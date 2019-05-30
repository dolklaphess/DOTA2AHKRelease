;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.
#include Gdip_All.ahk
#include ColorCatcher.ahk
#include ThreadManager.ahk

;dllpath:=A_AhkDir "\AutoHotkey.dll"
;DllCall("LoadLibrary","Str",dllpath)
TM:=new ThreadManager()
Gdip_Startup()
Probe1 := new ColorProbe(1000,500)
Timenow1:=[]



g::
mydc:=GetDC()
;MsgBox this is ahk
TimeElapse:=A_TickCount
loop 1
{
pic:=Probe1.BltCapture(1000,500,600,400)
Gdip_SaveBitmapToFile(pic,"test.PNG")
CArgb:=Probe1.GetPixel(1500,800)
}
TimeElapse:=A_TickCount-TimeElapse
Gdip_FromARGB(CArgb,A,R,G,B)
MsgBox TimeElapse " second A " A " R " R " G " G " B " B 
return

z::
Timenow1:=[]
TM.TimerUntil(2000,"Timer1",,-10)
;MsgBox TM.timer_list["Timer1"].on_off
;TM.SetTimeoutTimer(2000,"Timer1")
;SetTimer("Timer2Off",-5000,100)
;SetTimer("Timer2Off",-1000,100)

;SetTimer("Timer1")
return 

x::
TM.Timer("Timer3",500,-5)
return

c::
TM.Timer("Timer1","Off",0)
return

v::
TM.Timer("Timer1","On")
return

q::
MsgBox ("" is "number")
return

Timer2Off()
{
SetTimer("Timer2","Off")
return
}

Timer1()
{
global
Timenow1.Push(A_TickCount)
ToolTip((Timenow1[Timenow1.Length()]-TM.timer_list["Timer1"].TimeStart),1500,700)
return
}

Timer2()
{
ToolTip A_TickCount,1500,700
return
}

Timer3()
{
sleep 2000
;SoundBeep(440,1000)
return
}