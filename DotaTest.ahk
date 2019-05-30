;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.
#include Gdip_All.ahk
#include ColorCatcher.ahk
#include DotaClass.ahk
#include Mymath.ahk
#include DotaFunc.ahk
;#include debugtest.ahk

Gdip_Startup()
probe0 := new ColorProbe(846,178) ;823,902-1668,1079
bitmap:=probe0.BltCapture(823,902,846,178)
dir:="item.ini"
itemslot:= new SlotARGBVector
dict1:=new ItemDict()
dict1.MultiLoad("STreads|ITreads|ATreads")
inven:= new DotaInventory
colorf1:=[]
colorf2:=[]
colorf3:=[]
outdir:="10output.ini"
dictout:="item.ini"

;ab5:= new Ability(5,1303,941,46,46,1339,947,1345,959,[0],[0],[0],key:="d",keyN:="d")
;ab6:= new Ability(6,1347,941,46,46,1383,947,1389,959,[0],[0],[0],key:="f",keyN:="f")
hero10:= new DotaHero(10,"10ability.ini")


w::
t0:=A_TickCount
return

w up::
Timelapse:=A_TickCount-t0
MsgBox Timelapse
return

x::
bitmap:=probe0.BltCapture(823,902,846,178)
bitmap.LockBits()
itemslot.AcquireFromBitmap(bitmap,1,4)
itemslot.OutPut(dictout,"Elu",13)
bitmap.UnLockBits()
return


z::
MsgBox hero10.h_ability[1].IsReady(probe0)
return
/*
Loop 4
{
hero10.h_ability[A_Index].ResetColor(probe0,outdir)
}
return
;dict1.MultiLoad("empty1|empty5")
;ItemDict.Load("empty1")

/*
ult4 := new Ability(4,1359,945,58,58,1408,947,1413,969,[4285232252],[4283916392],[4281942345],"g","g") ;,0,0,0,
GetAbilityNum(probe0)
n:=GetAbilityNum(probe0)
dir:=Format(n "_ability.ini")
fourskillhero:=new DotaHero(n,dir)

;m1 := new GMem(0, 20)
;m2 := {base: GMem}.__New(0, 30)

/*
g::
m0.Show()
return
*/

/*
z::
n_ability:=GetAbilityNum(probe0)
inven.RefreshAll(probe0,dict1)
;Bitmap:=probe0.BltCapture(823,902,846,178)
;Gdip_SaveBitmapTOFile(Bitmap.pBitmap,"screenshot.bmp")

;ToolTip n_ability,1000,500
return

x::
Timelapse:=A_TickCount
bitmap:=probe0.BltCapture(823,902,846,178)
;bitmap.LockBits()
Loop 1 ;1000000,25076ms
{
MsgBox bitmap.GetPixel(1000,1000)
}
;bitmap.UnLockBits()
Timelapse:=A_TickCount-Timelapse
MsgBox Timelapse
return

c::
timediff:=[A_TickCount]
SetTimer("Beep",0)
return

Beep()
{
global
timediff.Push(A_TickCount)
ToolTip (timediff[timediff.Length()]-timediff[timediff.Length()-1]),1000,500
sleep 50
;SoundBeep(440,100)
return
}

/*
;Timelapse:=A_TickCount
;Gdip_LockBits(probe0.pBitmap, 0, 0,846,178,  Stride, Scan0, BitmapData)
;probe0.GetPixel(1000,1000)
;Gdip_LockBits(probe0.pBitmap, 0, 0,846,178,  Stride, Scan0, BitmapData)

Timelapse:=A_TickCount
Loop 100
{
probe0.BltCapture(823,902,846,178)
;itemslot.AcquireFromBitmap(probe0,A_Index,n)
;dict1.Find(itemslot)
;MsgBox inven.slot[A_Index].name
}
Timelapse:=A_TickCount-Timelapse
MsgBox Timelapse

return

c::
Timelapse:=A_TickCount
inven.Use("STreads")
Timelapse:=A_TickCount-Timelapse
;MsgBox Timelapse
return


;return
;probe0.UnLockBits()

/*
Loop 1000000
{
colorf:=Gdip_GetLockBitPixel(Scan0, 500, 100, Stride)
}
Timelapse:=A_TickCount-Timelapse
;Gdip_UnlockBits(pBitmap, BitmapData)
;Timelapse:=A_TickCount-Timelapse
;	r1 := (0x00ff0000 & colorf) >> 16
;	g1 := (0x0000ff00 & colorf) >> 8
;	b1 := 0x000000ff & colorf
MsgBox Timelapse
MsgBox r1 "|" g1 "|" b1
;MsgBox(dict1.Find(itemslot))*/




/*
z::
fourskillhero.h_ability[1].Cast()
return

x::
fourskillhero.h_ability[2].Cast()
return

c::
fourskillhero.h_ability[3].Cast()
return 

v::
fourskillhero.h_ability[4].Cast()
return

$g::
MsgBox fourskillhero.h_ability[1].IsReady(probe0)
return

$h::
MsgBox fourskillhero.h_ability[2].IsReady(probe0)
return

$j::
MsgBox fourskillhero.h_ability[3].IsReady(probe0)
return

$k::
MsgBox fourskillhero.h_ability[4].IsReady(probe0)
return

$n::
fourskillhero.RefreshAllColor(probe0)
return
*/