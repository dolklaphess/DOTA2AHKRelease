SendMode "Input" ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.

#include Gdip_All.ahk
#include ColorCatcher.ahk
#include Mymath.ahk
#include DotaFunc.ahk
#include DotaClass.ahk
#include ThreadManager.ahk

SetKeyDelay -1


global default_ability_triggerkey := ["$w","$e","$r","$g","$d","$f"]
global default_ability_keyup := ["w","e","r","g","d","f"]
global default_timeout:=3000

Gdip_Startup()
probe0 := new ColorProbe(846,178) ;823,902-1668,1079
MT:=new ThreadManager()
bitmap0:=probe0.BltCapture(823,902,846,178)
common_hero:= new DotaHero(4,"4ability.ini")
dict:=new ItemDict()
dict.MultiLoad("Elu")
inventory:= new DotaInventory
elu_number:=0
canceled:=0
n_ability:=4

~+S:: ;need renew the hero at the same time
common_hero.Renew(probe0)
n_ability:=common_hero.n_ability
inventory.RefreshAll(probe0,dict)
elu_number:=inventory.SearchItem("Elu")
return

#if elu_number>0
~q::
if(inventory.IsReady(elu_number,probe0,dict))
{
inventory.QCast(elu_number)
SendInput("{NumpadDiv}")
canceled:=0
MT.TimerUntil(default_timeout,"WaitforCasting",30)
}
else
{
	inventory.Cast(elu_number)
}
return
#if


WaitforCasting()
{
	global
		if(!inventory.IsReady(elu_number,probe0,dict))
		{
		MT.Timer("WaitforCasting","Off")
		AfterEluCast()
		}
	return
}
	
	
AfterEluCast()
{
	global
SendInput("s")
sleep 1821
if(canceled==0)
{
SendInput("{Numpad6 down}{RButton}s{Numpad6 up}")
sleep 200
SendInput(default_castkey[1])
}
SendInput("{NumpadMult}")
return
}

~s::
canceled:=1
return
	