;This Script provide the functions below.
;Ctrl+CapsLock to enable repeatedly right click without attack while holding mouse right button
;`+Item to swap it to the backpack or retrive it back
;F6 and F7 to switch the AutoAttack Mode more powerful.
;(NotFinished)Ctrl+Item to use it repeatedly in order to trigger it on the moment available. Such as when Tinker using his ultimate.


;Warning! To add #if criteria may cause other script work inproperly due to AHK's overriding feature.


SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.

;SetKeyDelay -1
#include Gdip_All.ahk
#include ColorCatcher.ahk
#include Mymath.ahk
#include DotaFunc.ahk
#include DotaClass.ahk
#include ThreadManager.ahk

#HotkeyInterval 100
#MaxHotkeysPerInterval 1000
SendMode("Input")
SetKeyDelay 60, -1


global default_item_triggerkey:=["*WheelUp","*WheelDown","*Space","*6","*Xbutton2","*Xbutton1",,,,"5"] 
global default_ability_triggerkey := ["$w","$e","$r","$g","$d","$f"]
global default_ability_keyup := ["w","e","r","g","d","f"]
global tip2_x:=2300-(2560-A_ScreenWidth)
global tip2_y:=150
global default_timeout:=3000
global switchback_delay:=1000

Gdip_Startup()
global probe1 := new ColorProbe(846,178) ;823,902-1668,1079
global MT:=new ThreadManager()
global dict:=new ItemDict()
global inventory:= new DotaInventory
global n_ability:=4
Rep_Stat := 0
Auto_Attack := 0
Unit_Attack := -1
Swap:=0
subdll:=AhkThread("#include GMSubThread.ahk")

Loop 6
{
	Hotkey default_item_triggerkey[A_Index],Format("TriggerItem" A_Index)
}
return

~NumpadSub::
Suspend "Off"
SoundBeep 523
SoundBeep 262
return

~NumpadAdd::
Suspend "On"
SoundBeep 262
SoundBeep 523
return

~^LWin::
Reload
return

^CapsLock::
Rep_Stat := 1 - Rep_Stat
ToolTip("Rep_Stat:" Rep_Stat,tip2_x,tip2_y,2)
MT.Timer("Tip2Off",-3000)
if(Rep_Stat)
{
subdll.ahkPostFunction("MTBeep","440","200")
subdll.ahkPostFunction("MTBeep","880","200")
}
else
{
subdll.ahkPostFunction("MTBeep","880","200")
subdll.ahkPostFunction("MTBeep","440","200")
}
return

~RButton::
if(Rep_Stat)
{
	if(MT.timer_list["RclickRepeat"]==1)
	{
		if MT.timer_list["RclickRepeat"].on_off==0
		MT.Timer("RclickRepeat","On")
	}
	else
	MT.Timer("RclickRepeat",10,-5)
}
return

~`::
Swap:=1
return

~` Up::
Swap:=0
return

~Alt::Numpad6 ;Directional Move in dota2-setting-hotkeys set to KP_6
return

Lwin::Numpad9 ;toggle Centralize the hero with command, need "bind KP_9 dota_camera_center" in cfg
return


CapsLock::m
return

/*
$f4::XButton2 ;Provide Voice Party in Picking Stage (Set Voice Chat Party:Mouse5)
return

$f5::XButton1 ;Provide Voice Team in Picking Stage (Set Voice Chat Party:Mouse5)
return
*/
~F6:: ;need setkeydelay
if(Auto_Attack<2)
{
	Auto_Attack := Auto_Attack+1
}
else
{
	Auto_Attack := 0
}
Clipboard := Format("dota_player_units_auto_attack_mode " Auto_Attack)
SendEvent "{Numpad0}^v{Enter}{Esc}"
ToolTip("Hero Attack:" Auto_Attack,tip2_x,tip2_y,2)
MT.Timer("Tip2Off",-3000)
return

~F7::
if(Unit_Attack<2)
{
	Unit_Attack := Unit_Attack+1
}
else
{
	Unit_Attack := -1
}
Clipboard := Format("dota_summoned_units_auto_attack_mode_2 " Unit_Attack)
SendEvent "{Numpad0}^v{Enter}{Esc}"
ToolTip("Unit Attack:" Unit_Attack,tip2_x,tip2_y,2)
MT.Timer("Tip2Off",-3000)
return

Tip2Off()
{
	ToolTip ,,,2
	return
}

TriggerItem1:
if (Swap)&&WinActive("ahk_exe dota2.exe")
{
	inventory.Refresh(probe1,dict,1)
	if(inventory.slot[1].stat==-1)
	SwapUp(1)
	else
	SwapDown(1)
}
else if(!GetKeyState("Mbutton")) ;prevent wheel while hoding M_button
SendInput(Format("{Blind}" default_item_nkey[1]))
return

TriggerItem2:
if (Swap)&&WinActive("ahk_exe dota2.exe")
{
	inventory.Refresh(probe1,dict,2)
	if(inventory.slot[2].stat==-1)
	SwapUp(2)
	else
	SwapDown(2)
}
else if(!GetKeyState("Mbutton"))
SendInput(Format("{Blind}" default_item_nkey[2]))
return

TriggerItem3:
if (Swap)&&WinActive("ahk_exe dota2.exe")
{
	inventory.Refresh(probe1,dict,3)
	if(inventory.slot[3].stat==-1)
	SwapUp(3)
	else
	SwapDown(3)
}
else
SendInput(Format("{Blind}" default_item_nkey[3]))
return

TriggerItem4:
if (Swap)&&WinActive("ahk_exe dota2.exe")
{
	inventory.Refresh(probe1,dict,4)
	if(inventory.slot[4].stat==-1)
	SwapUp(4)
	else
	SwapDown(4)
}
else
SendInput(Format("{Blind}" default_item_nkey[4]))
return

TriggerItem5:
if (Swap)&&WinActive("ahk_exe dota2.exe")
{
	inventory.Refresh(probe1,dict,5)
	if(inventory.slot[5].stat==-1)
	SwapUp(5)
	else
	SwapDown(5)
}
else
SendInput(Format("{Blind}" default_item_nkey[5]))
return

TriggerItem6:
if (Swap)&&WinActive("ahk_exe dota2.exe")
{
	inventory.Refresh(probe1,dict,6)
	if(inventory.slot[6].stat==-1)
	SwapUp(6)
	else
	SwapDown(6)
}
else
SendInput(Format("{Blind}" default_item_nkey[6]))
return

SwapDown(n)
{
	n_ability:=inventory.n_ability
	if(n_ability==0)
	{
		MsgBox "Not in Dota"
		return
	}
	if(n_ability==4)
	{
		x0:=1432
		y0:=943	
	}
	else if(n_ability==5)
	{
		x0:=1447
		y0:=943	
	}
	else if(n_ability==6)
	{
		x0:=1476
		y0:=943
	}
	else if(n_ability==10)
	{
		x0:=1462
		y0:=943
	}
	else
	{
		throw 2 
	}	
	if((n>=1)&&(n<=3))
	{
		y0:=y0+15
		n:=n-1
	}
	else if((n>=4)&&(n<=6))
	{
		n:=n-4
		y0:=y0+15+48	
	}
	else
	{
		MsgBox "out of range"
		throw 2
	}
	
	x0:=x0+65*n+15 ;ystash:=1056
	
	MouseGetPos xpos, ypos
	BlockInput("MouseMove")
	MouseMove x0-(2560-A_ScreenWidth)/2, y0
	SendInput "{Click left down}"
	sleep 60
	MouseMove x0-(2560-A_ScreenWidth)/2, 1056 , 100
	sleep 60
	SendInput "{Click left up}"
	BlockInput("MouseMoveOff")
	MouseMove xpos, ypos
	
	return
}

SwapUp(n)
{
	n_ability:=inventory.n_ability
	if(n_ability==0)
	{
		MsgBox "Not in Dota"
		return
	}
	if(n_ability==4)
	{
		x0:=1432
		y0:=943	
	}
	else if(n_ability==5)
	{
		x0:=1447
		y0:=943	
	}
	else if(n_ability==6)
	{
		x0:=1476
		y0:=943
	}
	else if(n_ability==10)
	{
		x0:=1462
		y0:=943
	}
	else
	{
		throw 2 
	}	
	if((n>=1)&&(n<=3))
	{
		y0:=y0+15
		n:=n-1
	}
	else if((n>=4)&&(n<=6))`
	{
		n:=n-4
		y0:=y0+15+48	
	}
	else
	{
		MsgBox "out of range"
		throw 2
	}
	
	x0:=x0+65*n+15 ;ystash:=1056
	
	MouseGetPos xpos, ypos
	BlockInput("MouseMove")
	MouseMove x0-(2560-A_ScreenWidth)/2, 1056
	SendInput "{Click left down}"
	sleep 60
	MouseMove x0-(2560-A_ScreenWidth)/2, y0 , 100
	sleep 60
	SendInput "{Click left up}"
	BlockInput("MouseMoveOff")
	MouseMove xpos, ypos
	
	return
}

RclickRepeat()
{
	global
	if(GetKeyState("RButton","P")==0)
	MT.Timer("RclickRepeat","Off")
	SendInput "{Click Right}m"
}
