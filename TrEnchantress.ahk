﻿/*
	;This script only works fully on 4 or 6 ability heros, except the hero with toggle-ability, Invoker and Morphling or Rubic with previous abilities stolen
	;For 5 ability heros or those total number of abilites may change during game(like acquiring an new ability from scepter), this script only partially works.
	;The reason is that 5 abilities heroes do not have an invariant ability frame which can be used for check the cooldown.
	;In the case, moving Power Treads to another slot or the changing of hero Hud need to press Shift+S hotkey to reset the Script.
	;Also only works for direct cast abilities, does not work bind with Alt to cast on self.
	;However you can add a {Blind} just after Every "SendInput" command to achieve this yourself.
	;Warning! This script may break invisibility due to switch the Treads. It's highly recommanded to write a specific Treads Script for invisible Hero.
	;The Hotkeys is set based on my own dota2-ability-hotkey["w","e","r","g","d","f"] 
	;and item-hotkey["{WheelUp}","{WheelDown}","{space}","6","{f4}","{f5}",,,,"5"]
	;You must replace it all for yourself, both here(like default_item_triggerkey) and in DotaClass.ahk
*/	


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
SendMode("Input")

global tip1_x:=2300-(2560-A_ScreenWidth)
global tip1_y:=100
global default_timeout:=3000
global switchback_delay:=1000
if(enchantress_ability_triggerkey is "object")
default_ability_triggerkey:=enchantress_ability_triggerkey
if(enchantress_ability_keyup is "object")
default_ability_keyup:=enchantress_ability_keyup
;adjust it for your own hotkey setting

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
n_ability:=4
rb_toggle:=2 ;0:default--switch to Strength while moving, 1: To Default, 2::switch both while moving and after casting, 
;3::not switch on moving but after casting, -1:not switch at all
	;To mention that, the Invoker, Nyx, Templar, Weaver and Windranger have little fade time that may break invisibility if using switch while moving
	;only 4 and 6 ability heroes fully support rbtoggle>=2 mode
;Because of wheel input feature, not recommand to bind treads to wheel when use another wheel hotkey at the same time

;itemslot:= new SlotARGBVector

Loop 6
{
	Hotkey "If",Format('WinActive("ahk_exe dota2.exe")&&(stick_number==' A_Index ')&&(treads_number>0)')
	Hotkey default_item_triggerkey[A_Index],"UseStick"
}

	Hotkey "If",'WinActive("ahk_exe dota2.exe")&&(treads_number>0)'
	Hotkey default_ability_triggerkey[2],Format("Hero46CastAbility2")
	Hotkey default_ability_triggerkey[3],Format("Hero46CastAbility3")
	Hotkey default_ability_triggerkey[4],Format("Hero46CastAbility4")	
Hotkey "If"

;#include put other script which contain hotkeys here.

#SuspendExempt
~NumpadSub::
Suspend "On"
SoundBeep 523
SoundBeep 262
return

~NumpadAdd::
Suspend "Off"
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
treads_number:=inventory.SearchItem("Treads")
stick_number:=inventory.SearchItem("Wand")
if(stick_number==0)
stick_number:=inventory.SearchItem("Stick")
;MsgBox wand_number
n_ability:=common_hero.n_ability
if(treads_number>=1&&treads_number<=6)
treads_default:=inventory.slot[treads_number].stat
return

~y::
if(rb_toggle==-1)
{
	rb_toggle:=0
	ToolTip("RightToStrength",tip1_x,tip1_y,1)
}
else if(rb_toggle==0)
{
	rb_toggle:=1
	ToolTip("RightToDefault",tip1_x,tip1_y,1)
}
else if(rb_toggle==1)
{
	rb_toggle:=3
	ToolTip("OnlyAfterCast",tip1_x,tip1_y,1)
}
else if(rb_toggle==3)
{
	rb_toggle:=2
	ToolTip("SwitchBoth",tip1_x,tip1_y,1)
}
else if(rb_toggle==2)
{
	rb_toggle:=4
	ToolTip("AlwaysSwitch",tip1_x,tip1_y,1)
	}
else if(rb_toggle==4)
{
	rb_toggle:=-1
	ToolTip("SwitchOff",tip1_x,tip1_y,1)
}
block_right_switch:=0
MT.Timer("Tip1Off",-3000)
return

t::
SendInput "3w1"
return

d::
SendInput "2a1"
return


z::
SendInput "3m1"
return

x::
SendInput "3a1"
return

~c::
if(treads_number>0)
ToATreads()
return

~v::
if(treads_number>0)
ToSTreads()
return

~b::
if(treads_number>0)
ToITreads()
if(rb_toggle!==3)
rb_toggle:=3
return

#if WinActive("ahk_exe dota2.exe")&&(rb_toggle==0||rb_toggle==1||rb_toggle==2)
~a::
ToITreads()
KeyWait "a"
return

#if WinActive("ahk_exe dota2.exe")&&(treads_default>=5&&treads_default<=7)
~Rbutton:: ;may conflict with default rclick, need rewrite it to #if
if(rb_toggle==0||rb_toggle==2||rb_toggle==4)&&(block_right_switch==0)
ToSTreads()
else if(rb_toggle==1)
{
	SwitchToDefault()
}
KeyWait "Rbutton"
return

#if WinActive("ahk_exe dota2.exe")&&(stick_number==1)&&(treads_number>0)

#if WinActive("ahk_exe dota2.exe")&&(stick_number==2)&&(treads_number>0)

#if WinActive("ahk_exe dota2.exe")&&(stick_number==3)&&(treads_number>0)

#if WinActive("ahk_exe dota2.exe")&&(stick_number==4)&&(treads_number>0)

#if WinActive("ahk_exe dota2.exe")&&(stick_number==5)&&(treads_number>0)

#if WinActive("ahk_exe dota2.exe")&&(stick_number==6)&&(treads_number>0)

#if WinActive("ahk_exe dota2.exe")&&(treads_number>0)

#if


TreadsNow()
{
	global
	;MsgBox this.timer
	inventory.RefreshAllButCooldown(probe0,dict)
	treads_number:=inventory.SearchItem("Treads")
	;MsgBox treads_number	
	if(treads_number<1||treads_number>6)
	return
	
	;inventory.slot[treads_number].stat
	if (inventory.slot[treads_number].stat>=5&&inventory.slot[treads_number].stat<=7)
	{
		return inventory.slot[treads_number].stat
	}
	else
	{
		
		return 0
		treads_number:=0
	}
	return
}

ToSTreads()
{
	global
	stat:=TreadsNow()
	;MsgBox stat
	if(stat==5)
	return
	else if(stat==6)
	{
		SendInput inventory.slot[treads_number].nkey
		sleep 30
		SendInput inventory.slot[treads_number].nkey
	}
	else if(stat==7)
	{
		SendInput inventory.slot[treads_number].nkey	
	}
	else
	return
	return
}

ToITreads()
{
	global
	stat:=TreadsNow()
	if(stat==5)
	SendInput inventory.slot[treads_number].nkey
	else if(stat==6)
	return
	else if(stat==7)
	{
		SendInput inventory.slot[treads_number].nkey
		sleep 30
		SendInput inventory.slot[treads_number].nkey
	}
	else
	return
	return
}

ToATreads()
{
	global
	stat:=TreadsNow()
	if(stat==5)
	{
		SendInput inventory.slot[treads_number].nkey
		sleep 30
		SendInput inventory.slot[treads_number].nkey
	}
	else if(stat==6)
	SendInput inventory.slot[treads_number].nkey
	else if(stat==7)
	return
	else
	return
	return
}

SwitchToDefault()
{
	global
	if(treads_default==5)
	ToSTreads()
	else if(treads_default==6)
	ToITreads()
	else if(treads_default==7)
	ToATreads()
	return
}

Tip1Off()
{
	ToolTip ,,,1
	return
}

Ability1SwitchS()
{
	global
	if(!common_hero.h_ability[1].IsReady(probe0))
	{
		ToSTreads()
		MT.Timer("Ability1SwitchS","Off")
		return
	}
	return
}

Ability1SwitchBack()
{
	global
	if(!common_hero.h_ability[1].IsReady(probe0))
	{
		SwitchToDefault()
		MT.Timer("Ability1SwitchBack","Off")
		return
	}
	return
}

Ability2SwitchS()
{
	global
	if(!common_hero.h_ability[2].IsReady(probe0))
	{
	ToSTreads()
		MT.Timer("Ability2SwitchS","Off")
		return
	}
	return
}

Ability2SwitchBack()
{
	global
	if(!common_hero.h_ability[2].IsReady(probe0))
	{
		SwitchToDefault()
		MT.Timer("Ability2SwitchBack","Off")
		return
	}
	return
}

Ability3SwitchS()
{
	global
	if(!common_hero.h_ability[3].IsReady(probe0))
	{
		ToSTreads()
		MT.Timer("Ability3SwitchS","Off")
		return
	}
	return
}

Ability3SwitchBack()
{
	global
	if(!common_hero.h_ability[3].IsReady(probe0))
	{
		SwitchToDefault()
		MT.Timer("Ability3SwitchBack","Off")
		return
	}
	return
}

Ability4SwitchS()
{
	global
	if(!common_hero.h_ability[4].IsReady(probe0))
	{
		ToSTreads()
		MT.Timer("Ability4SwitchS","Off")
		return
	}
	return
}

Ability4SwitchBack()
{
	global
	if(!common_hero.h_ability[4].IsReady(probe0))
	{
		SwitchToDefault()
		MT.Timer("Ability4SwitchBack","Off")
		return
	}
	return
}

Ability5SwitchS()
{
	global
	if(!common_hero.h_ability[5].IsReady(probe0))
	{
		ToSTreads()
		MT.Timer("Ability5SwitchS","Off")
		return
	}
	return
}

Ability5SwitchBack()
{
	global
	if(!common_hero.h_ability[5].IsReady(probe0))
	{
		SwitchToDefault()
		MT.Timer("Ability5SwitchBack","Off")
		return
	}
	return
}

Ability6SwitchS()
{
	global
	if(!common_hero.h_ability[6].IsReady(probe0))
	{
		ToSTreads()
		MT.Timer("Ability6SwitchS","Off")
		return
	}
	return
}

Ability6SwitchBack()
{
	global
	if(!common_hero.h_ability[6].IsReady(probe0))
	{
		SwitchToDefault()
		MT.Timer("Ability6SwitchBack","Off")
		return
	}
	return
}

UseStick()
{
	global
ToATreads()
inventory.Cast(stick_number)
sleep 66
ToSTreads()
return
}

Hero46CastAbility2()
{
	global
if(common_hero.h_ability[2].IsReady(probe0)||rb_toggle==4)
{
	ToITreads()
}
SendInput common_hero.h_ability[2].key
if(rb_toggle==2)
{
	MT.TimerUntil(default_timeout,"Ability2SwitchS",30,,"ToSTreads")
}
else if(rb_toggle==3)
{
	MT.TimerUntil(default_timeout,"Ability2SwitchBack",30,,"SwitchToDefault")
}
KeyWait(default_ability_keyup[2])
return
}

Hero46CastAbility3()
{
	global
	if(common_hero.h_ability[3].IsReady(probe0)||rb_toggle==4)
	{
		ToITreads()
	}
	SendInput common_hero.h_ability[3].key
	
	if(rb_toggle==2)
	{
		MT.TimerUntil(default_timeout,"Ability3SwitchS",30,,"ToSTreads")
	}
	else if(rb_toggle==3)
	{
		MT.TimerUntil(default_timeout,"Ability3SwitchBack",30,,"SwitchToDefault")
	}
	KeyWait(default_ability_keyup[3])
	return
}

Hero46CastAbility4()
{
	global
if(rb_toggle==0||rb_toggle==1||rb_toggle==2)
ToITreads()
SendInput common_hero.h_ability[4].key
KeyWait(default_ability_keyup[4])
return
}
