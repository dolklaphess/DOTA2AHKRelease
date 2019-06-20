;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
	; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.
#include ColorCatcher.ahk
#include MyMath.ahk
#include Gdip_All.ahk

global tip10_x:=2300-(2560-A_ScreenWidth)
global tip10_y:=500

GetAbilityNum(probe,sdc:=0) ;this function retrive the total number of current hero's abilities
{
	bitmap:=probe.BltCapture(1115,990,390,1,sdc)
	argb1:=bitmap.GetPixel(1500,990)
	x:=1499
	while(x>1115)
	{
		argb2:=bitmap.GetPixel(x,990)
		if(ColorDarker(argb2,argb1,50))
		{
			if(x==1425)
			n:=4
			else if(x==1440)
			n:=5
			else if(x==1469)
			n:=6
			else if(x=1455) ;morphling or rubic with shift
			n:=10
			else
			{
				if(WinActive("ahk_exe dota2.exe"))
				{
					ToolTip("unexpected hud",tip10_x,tip10_y,10) 
					SoundBeep(2000,500)
					SetTimer("Tip10Off",-5000)
					return -2
					;throw 2 ;unexpected error
				}
				else
				return -1
				
			}
			;MsgBox n
			return n
		}
		argb1:=argb2
		x--
	}
	if(WinActive("ahk_exe dota2.exe"))
	{
			ToolTip("unexpected hud",tip10_x,tip10_y,10) 
			SoundBeep(2000,500)
			SetTimer("Tip10Off",-5000)
		return -2
	}
	return -1
}

GetAbilityNumFromBitmap(bitmap,sdc:=0) ;this function retrive the total number of current hero's abilities from Bitmap Already Captured
{		
	
	argb1:=bitmap.GetPixel(1500,990)
	x:=1499
	while(x>1115)
	{
		argb2:=bitmap.GetPixel(x,990)
		if(ColorDarker(argb2,argb1,50))
		{
			if(x==1425)
			n:=4
			else if(x==1440)
			n:=5
			else if(x==1469)
			n:=6
			else if(x=1455) ;morphling or rubic with shift
			n:=10
			else
			{
				if(WinActive("ahk_exe dota2.exe"))
				{
			ToolTip("unexpected hud",tip10_x,tip10_y,10) 
			SoundBeep(2000,500)
			SetTimer("Tip10Off",-5000)
		return -2
				}
				else
				return -1
				
			}
			;MsgBox n
			return n
		}
		argb1:=argb2
		x--
	}
	if(WinActive("ahk_exe dota2.exe"))
	{
			ToolTip("HeroNotFound",tip10_x,tip10_y,10) 
			SoundBeep(2000,500)
			SetTimer("Tip10Off",-5000)
		return -2
	}
	return -1
}

RefreshAbilityColor(probe,dir,n,x0,y0,x1,y1,x2,y2,ByRef colorf1,ByRef colorf2,ByRef colorf3,sdc:=0)
{
	
	bitmap:=probe.BltCapture(x1,y1,x2-x1+1,y2-y1+1,sdc)
	colorf1_now:=bitmap.GetPixel(x1,y1) ;x1,y1 leftup in ARGB,color of frame, the same below
	colorf2_now:=bitmap.GetPixel(x2,y1) ;x2,y1 rightup
	colorf3_now:=bitmap.GetPixel(x2,y2) ;x2,y2 rightbottom
		IniWrite(x0,dir, Format("Ability" n), Format("x0"))
		IniWrite(y0,dir, Format("Ability" n), Format("y0"))
		IniWrite(x1,dir, Format("Ability" n), Format("x1"))
		IniWrite(y1,dir, Format("Ability" n), Format("y1"))
		IniWrite(x2,dir, Format("Ability" n), Format("x2"))
		IniWrite(y2,dir, Format("Ability" n), Format("y2"))
	update:=1
	Loop colorf1.Length()
	{
		if(colorf1_now==colorf1[A_Index])
		update:=update*0
	}
	if(update==1)
	{
		colorf1.Push(colorf1_now)
		IniWrite colorf1_now, dir, Format("Ability" n), Format("P1_" (colorf1.Length()))
	}
	
	update:=1
	Loop colorf2.Length()
	{
		if(colorf2_now==colorf2[A_Index])
		update:=update*0
	}
	if(update==1)
	{
		colorf2.Push(colorf2_now)
		IniWrite colorf2_now, dir, Format("Ability" n), Format("P2_" (colorf2.Length()))
	}
	update:=1
	Loop colorf3.Length()
	{
		if(colorf3_now==colorf3[A_Index])
		update:=update*0
	}
	if(update==1)
	{
		colorf3.Push(colorf3_now)
		IniWrite colorf3_now, dir, Format("Ability" n), Format("P3_" (colorf3.Length()))
	}
	
	;MsgBox colorf1[colorf1.Length()] " " colorf2[colorf2.Length()] " " colorf3[colorf3.Length()] 
	return
}

RefreshItemColor(probe,name,n,x1,y1,x2,y2,ByRef colorf1,ByRef colorf2,ByRef colorf3,dir,sdc:=0)
{
	
	bitmap:=probe.BltCapture(x1,y1,x2-x1+1,y2-y1+1,sdc)
	colorf1_now:=bitmap.GetPixel(x1,y1) ;x1,y1 leftup in ARGB,color of frame, the same below
	colorf2_now:=bitmap.GetPixel(x2,y1) ;x2,y1 rightup
	colorf3_now:=bitmap.GetPixel(x2,y2) ;x2,y2 rightbottom
	
	update:=1
	Loop colorf1.Length()
	{
		if(colorf1_now==colorf1[A_Index])
		update:=update*0
	}
	if(update==1)
	{
		colorf1.Push(colorf1_now)
		IniWrite colorf1_now, dir, Format("Slot"), name
	}
	
	update:=1
	Loop colorf2.Length()
	{
		if(colorf2_now==colorf2[A_Index])
		update:=update*0
	}
	if(update==1)
	{
		colorf2.Push(colorf2_now)
		IniWrite colorf2_now, dir, Format("Slot" n name), Format("P2_" (colorf2.Length()))
	}
	update:=1
	Loop colorf3.Length()
	{
		if(colorf3_now==colorf3[A_Index])
		update:=update*0
	}
	if(update==1)
	{
		colorf3.Push(colorf3_now)
		IniWrite colorf3_now, dir, Format("Slot" n name), Format("P3_" (colorf3.Length()))
	}
	
	;MsgBox colorf1[colorf1.Length()] " " colorf2[colorf2.Length()] " " colorf3[colorf3.Length()] 
	return
}




CreateAbilityArray(n_ability,dir,castkey,ncastkey)
{
	h_ability:=[]
	

	if(n_ability==4)
	{
		n_interval:=[ 0,1,2,3 ]
		x0a1:=1161
		y0a1:=941
		x1a1:=1210
		y1a1:=947
		x2a1:=1218
		y2a1:=969
		w:=64
		d:=65
	}
	else if(n_ability==5)
	{
		n_interval:=[ 0,1,2,4,3 ]
		x0a1:=1145
		y0a1:=941
		w:=60
		d:=65
		x1a1:=1192
		y1a1:=947
		x2a1:=1198
		y2a1:=969
	}
	else if(n_ability==6)
	{
		n_interval:=[ 0,1,2,5,3,4 ]
		x0a1:=1116
		y0a1:=941
		x1a1:=1163
		y1a1:=947
		x2a1:=1169
		y2a1:=969
		w:=60
		d:=58
	}
	else if(n_ability==10)
	{
	h_ability[5]:=new AttributeShift(5,castkey[5],ncastkey[5],dir)
	h_ability[6]:=new AttributeShift(5,castkey[5],ncastkey[5],dir)	
	n_ability:=4
			w:=60
		d:=58
	}
	else
	{
		
		ToolTip("Ability number out of range",tip10_x,tip10_y,10) ;morphling n_a:=10, updating needed
		SetTimer("Tip10Off",-5000)
		SoundBeep 2000,500
		n_ability:=4
		n_interval:=[ 0,1,2,3 ]
		x0a1:=1161
		y0a1:=941
		x1a1:=1210
		y1a1:=947
		x2a1:=1218
		y2a1:=969
		w:=64
		d:=65
	}

	
	n:=1
	
	while(n <= n_ability)
	{
		x0:=IniRead(dir, Format("Ability" n), "x0")
		y0:=IniRead(dir, Format("Ability" n), "y0")
		x1:=IniRead(dir, Format("Ability" n), "x1")
		y1:=IniRead(dir, Format("Ability" n), "y1")
		x2:=IniRead(dir, Format("Ability" n), "x2")
		y2:=IniRead(dir, Format("Ability" n), "y2")
		colorf1:=[]		
		i:=1
		colorf1_now:=IniRead(dir, Format("Ability" n), Format("P1_" i),0)
		while(colorf1_now)
		{
			colorf1.push(colorf1_now)
			i++
			colorf1_now:=IniRead(dir, Format("Ability" n), Format("P1_" i),0)
		}
		
		colorf2:=[]		
		i:=1
		colorf2_now:=IniRead(dir, Format("Ability" n), Format("P2_" i),0)
		while(colorf2_now)
		{
			colorf2.push(colorf2_now)
			i++
			colorf2_now:=IniRead(dir, Format("Ability" n), Format("P2_" i),0)
		}	
		
		colorf3:=[]
		i:=1
		colorf3_now:=IniRead(dir, Format("Ability" n), Format("P3_" i),0)
		while(colorf3_now)
		{
			colorf3.push(colorf3_now)
			i++
			colorf3_now:=IniRead(dir, Format("Ability" n), Format("P3_" i),0)
		}
		
		h_ability[n]:=new Ability(n,x0,y0,w,w,x1,y1,x2,y2,colorf1,colorf2,colorf3,castkey[n],ncastkey[n])
		n++
	}
	return h_ability
}
/*
	k::
	fsdc:=GetDC()
	RefreshAbilityColor(probe0,4,1406,947,1413,969,colorf1,colorf2,colorf3)
	return
	*/
;GetAbilityNum(probe0,fsdc)

Tip10Off()
{
	ToolTip ,,,10
	return
}
