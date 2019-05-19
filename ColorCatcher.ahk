;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.
#include Gdip_All.ahk



class ColorProbe
{
	w:=1
	h:=1
	x:=0
	y:=0
	ws:=1
	hs:=1
	default_screen:="ahk_exe dota2.exe"
	chdc:=""
	hbm:=""
	obm :="" 
	hhdc:=0
	last_probe_bitmap:=""
	;Stride:=""
	;Scan0:=""
	;BitmapData:=""
	occupied:=0
	
	__New(w,h)
	{
		this.w:=w
		this.h:=h
		this.chdc := CreateCompatibleDC()
		this.hbm := CreateDIBSection(w, h, this.chdc)
		this.obm := SelectObject(this.chdc, this.hbm)
		;hhdc := hhdc ? hhdc : GetDC()
		return this
	}
	
	__Delete()
    {
		DeleteObject(this.obm)
		DeleteObject(this.hbm)
		DeleteDC(this.chdc)
        DllCall("GlobalFree", "Ptr", this.ptr)
		return
	}
	
	BltCapture(xs,ys,ws,hs,hhdc:=0)
	{
		Critical "On"
		hhdc := hhdc ? hhdc : GetDC(WinGetID(this.default_screen))
		this.x:=xs
		this.y:=ys
		this.hhdc:=hhdc
		if((ws>this.w)||(hs>this.h))
		throw 2 ;can't contain the target area
		this.ws:=ws
		this.hs:=hs	
		xs-= (2560-A_ScreenWidth)/2 ;only need to change xs at this point can adjust different sreen width automaticly: 
		BitBlt(this.chdc, 0, 0, this.ws, this.hs, hhdc, xs, ys)
		ReleaseDC(hhdc)
		probe_bitmap:=new ProbeBitmap(Gdip_CreateBitmapFromHBITMAP(this.hbm),this.x,this.y,ws,hs)
		this.last_probe_bitmap:=probe_bitmap
		Critical "Off"
		return probe_bitmap
	}
	
		TrueCoordinateCapture(xs,ys,ws,hs,hhdc:=0)
	{
		Critical "On"
		hhdc := hhdc ? hhdc : GetDC(WinGetID(this.default_screen))
		this.x:=xs
		this.y:=ys
		this.hhdc:=hhdc
		if((ws>this.w)||(hs>this.h))
		throw 2 ;can't contain the target area
		this.ws:=ws
		this.hs:=hs	
		;xs-= (2560-A_ScreenWidth)/2 ;only need to change xs at this point can adjust different sreen width automaticly: 
		BitBlt(this.chdc, 0, 0, this.ws, this.hs, hhdc, xs, ys)
		ReleaseDC(hhdc)
		probe_bitmap:=new ProbeBitmap(Gdip_CreateBitmapFromHBITMAP(this.hbm),this.x,this.y,ws,hs)
		this.last_probe_bitmap:=probe_bitmap
		Critical "Off"
		return probe_bitmap
	}
	
	
}

Class ProbeBitmap
{
	pBitmap:=""
	Stride:=0
	Scan0:=0
	BitmapData:=""
	x:=0
	y:=0
	ws:=1
	hs:=1
	locked:=0
	occupied:=0
	__New(ByRef pBitmap,x,y,ws,hs)
	{
		this.pBitmap:=pBitmap
		this.x:=x
		this.y:=y
		this.ws:=ws
		this.hs:=hs	
		return this
	}
	__Delete()
	{
		if(this.locked)
		this.UnLockBits()
		DllCall("GlobalFree", "Ptr", this.ptr)
		return
		
	}
	
	LockBits()
	{
	pbitmap:=this.pBitmap
		Gdip_LockBits(pBitmap, 0, 0,this.ws,this.hs, Stride,Scan0,BitmapData)
		;byref and class problem?
		this.locked:=1
		this.Stride:=Stride
		this.Scan0:=Scan0
		this.BitmapData:=BitmapData
		;MsgBox this.x "|" this.y "|" this.ws "|" this.hs "|" this.Scan0 "|" this.Stride 
		return 
	}
	
	UnLockBits()
	{
		if Gdip_UnlockBits(this.pBitmap, this.BitmapData)
		this.locked:=0	
		return 
	}
	
	GetPixel(xs,ys) ;for stabality
	{
		if(this.locked==0)
		return Gdip_GetPixel(this.pBitmap,(xs-this.x),(ys-this.y))
		else if(this.locked==1)
		{
			return (NumGet(this.Scan0+0, ((xs-this.x)*4)+((ys-this.y)*this.Stride), "UInt"))		
		}
		else
		{
			throw -1 ;prohibited manipulation
			return
		}
	}
	
	
	
	GetLockBitPixel(xs,ys)
	{
		return (NumGet(this.Scan0+0, ((xs-this.x)*4)+((ys-this.y)*this.Stride), "UInt"))
	}
	
	
	}
	
	
