;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.
SetKeyDelay -1
#include Gdip_All.ahk
#include ColorCatcher.ahk
#include Mymath.ahk
#include DotaFunc.ahk
#include DotaClass.ahk
#include ThreadManager.ahk

#HotkeyInterval 100
#MaxHotkeysPerInterval 1000

global tip1_x:=2300-(2560-A_ScreenWidth)
global tip1_y:=100
global default_timeout:=3000
global switchback_delay:=1000
global default_item_triggerkey:=["WheelUp","WheelDown","Space","6","$Xbutton2","$Xbutton1",,,,"5"] 
global default_ability_triggerkey := ["$w","$e","$r","$g","$d","$f"]
global default_ability_keyup := ["w","e","r","g","d","f"]

Gdip_Startup()
probe0 := new ColorProbe(846,178) ;823,902-1668,1079
MT:=new ThreadManager()
bitmap0:=probe0.BltCapture(823,902,846,178)
common_hero:= new DotaHero(4,"4ability.ini")
dict:=new ItemDict()
dict.MultiLoad("STreads|ITreads|ATreads|Wand|Stick|Soul|ArmletOff|ArmletOn")
inventory:= new DotaInventory

block_right_switch:=0
treads_number:=0
treads_default:=0
stick_number:=0 ;both stick and wand
soul_number:=0
armlet_number:=0
n_ability:=4

#SuspendExempt
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
#SuspendExempt 0

~^LWin::
Reload
return

#if WinActive("ahk_exe dota2.exe")
~+S:: ;need renew the hero at the same time
common_hero.Renew(probe0)
inventory.RefreshAll(probe0,dict)
stick_number:=inventory.SearchItem("Wand")
if(stick_number==0)
stick_number:=inventory.SearchItem("Stick")
armlet_number:=inventory.SearchItem("Armlet")
;MsgBox wand_number
n_ability:=common_hero.n_ability
return

~q::
SendInput("w")
sleep 1550
SendInput("r")
return
#if


#if WinActive("ahk_exe dota2.exe")&&(armlet_number>0)

~$t:: ;one-click to toggle the Armlet and use Magic Stick, can success in DOT
inventory.Refresh(probe0,dict,armlet_number)
if(inventory.slot[armlet_number].stat==11)
{
	inventory.Cast(armlet_number)
}
else if(inventory.slot[armlet_number].stat==12)
{
	inventory.Cast(armlet_number)
	if(stick_number>0)
	{
		inventory.Cast(stick_number)
		;MsgBox inventory.slot[stick_number].Qkey
		;MsgBox stick_number
	}
	inventory.Cast(armlet_number)
}
KeyWait("t")
return

#if
