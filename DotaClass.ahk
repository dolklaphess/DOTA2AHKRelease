;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SetWorkingDir A_ScriptDir 
#include DotaFunc.ahk
#include ColorCatcher.ahk
#include Mymath.ahk
#include Gdip_All.ahk

global default_item_nkey:=["{WheelUp}","{WheelDown}","{space}","6","{XButton2}","{XButton1}",,,,"5"] ;my default, adjust it for yourself or read from ini. 1~3 are always quick
global default_item_qkey:=["{WheelUp}","{WheelDown}","{space}","6{click}","{XButton2}{click}","{XButton1}{click}",,,"5{click}"]
global default_castkey := ["w","e","r","g","d","f"]
global default_ncastkey := ["w","e","r","g","d","f"]
/*
	global sysw:=1920
	global sysh:=1080
	*/
	;default_castkey:=["w","e","r","g","d","f"]
;ability_interval:=[ 0,1,2,5,3,4 ]

class DotaHero
{
	h_ability:=[]
	n_ability:=4
	dx:=0
	castkey := ["w","e","r","g","d","f"] ;can read from .ini, it must be altered for different user
	ncastkey := ["w","e","r","g","d","f"] ;can read from .ini, it must be altered for different user
	dir:="hero.ini"
	
	__New(n_ability,dir,dc:=0,castkey:=0,ncastkey:=0)
	{
		this.n_ability := n_ability	
		this.dir:=dir
		if(castkey==0)
		this.castkey:= default_castkey
		else
		this.castkey:=castkey
				if(ncastkey==0)
		this.ncastkey:= default_ncastkey
		else
		this.ncastkey:=ncastkey
		
		this.h_ability:=CreateAbilityArray(n_ability,dir,this.castkey,this.ncastkey)
		return this
	}
	
	Renew(probe,dir:=0,dc:=0)
	{
	this.n_ability:=GetAbilityNum(probe,dc)
	if(this.n_ability==-1)
	return -1
	if dir==0
	this.dir:=Format(this.n_ability "ability.ini")
	h_ability:=CreateAbilityArray(this.n_ability,this.dir,this.castkey,this.ncastkey)
	if(h_ability)
	this.h_ability:=h_ability
	else
	return 1
	}
	
	RefreshAllColor(probe,dc:=0)
	{
		n:=GetAbilityNum(probe,dc)
		if (n==this.n_ability)
		{
			Loop this.n_ability
			this.h_ability[A_Index].ResetColor(probe,dir) ;can also capture only once
			return 1
		}
		else if(n!==-1)
		{
			throw 2
			MsgBox "n changed"
		}
	}
	
	QCast(n)
	{
		if n>this.n_ability 
		{
			throw 2
			return 0
		}
		
		this.h_ability[n].Cast()
		return 1
		
	}
	
	NCast(n)
	{
		if n>this.n_ability 
		{
			throw 2
			return 0
		}
		
		this.h_ability[n].NCast()
		return 1
	}
}

class DotaInventory
{
	n_ability:=4
	dx:=0
	slot:=[] ; slot[n]:Item
	backpack:=[]
	__New(n_ability:=4,dc:=0)
	{
		this.n_ability:=n_ability
		
		
		Loop 6
		this.slot[A_Index]:= new Item(A_Index,Format("Empty" A_Index))
		
		
		return this
	}
	SearchItem(name)
	{
		target:=[]
		Loop 6
		{
			if (Instr(this.slot[A_Index].name,name))
			return A_Index
		}
		return 0 ;represent not found
	}
	Cast(n)
	{
	if(n==0)
	return
	this.slot[n].Cast()
	return
	}
	QCast(n)
	{
	if(n==0)
	return
	this.slot[n].QCast()
	return
	}
	Use(name)
	{
		target:=[]
		Loop 6
		{
			if (Instr(this.slot[A_Index].name,name))
			{
			this.slot[A_Index].Cast()
			return A_Index
			}
		}
		
		return 0
	}
	RefreshAll(probe,dict) ;target items must not in cooldown
	{
		bitmap:=probe.BltCapture(1425,938,250,178)
		;Gdip_SaveBitmapTOFile(bitmap.pBitmap,"screenshot.bmp")
		this.n_ability:=GetAbilityNumFromBitmap(bitmap) ;for stablity, can be removed if hero doesn't alter it
		if(this.n_ability<4)
		return -1
		
		slot:=[]
		slotvector:= new SlotARGBVector
		bitmap.LockBits()

		Loop 6
		{
			slotvector.AcquireFromBitmap(bitmap,A_Index,this.n_ability)
			name:=dict.Find(slotvector,sn)
			if(sn>=5&&sn<=7)
			{	
				
				this.slot[A_Index]:=new ItemTreads(A_Index,sn)
				
			}
			else
			this.slot[A_Index]:=new Item(A_Index,name,sn)
			
			;this.slot[A_Index]:=t_item
		}
		bitmap.UnLockBits()
		;this.slot:=slot
		return 1
	}
		RefreshAllButCooldown(probe,dict) ;treat in-cooldown as previous
	{
		bitmap:=probe.BltCapture(1425,938,250,178)
		slotvector:= new SlotARGBVector
		bitmap.LockBits()
		Loop 6
		{
		
		slotvector.AcquireFromBitmap(bitmap,A_Index,this.n_ability)

		name:=dict.Find(slotvector,sn)
		if(sn==0) ;maybe in cooldown
		{
			this.slot[A_Index].stat:=0
		}
		else if(sn>=5&&sn<=7)
		{		
			;MsgBox sn
			if this.slot[A_Index].name=="Treads"
			{
				this.slot[A_Index].stat := sn
			}
			else
			{
				this.slot[A_Index]:=new ItemTreads(A_Index,stat)
			}
		}
		else if(sn!=this.slot[A_Index].sn)
		{
			this.slot[A_Index]:=new Item(A_Index,name,sn)
		}
		}
				bitmap.UnLockBits()
		return
	}
		IsReady(n,probe,dict)
	{
		bitmap:=probe.BltCapture(1425,938,250,178)
		slotvector:= new SlotARGBVector
		bitmap.LockBits()		
		slotvector.AcquireFromBitmap(bitmap,n,this.n_ability)
		bitmap.UnLockBits()
		name:=dict.Find(slotvector,sn)
		if(sn==this.slot[n].sn) ;maybe in cooldown
		return 1
		else
		return 0
		
	}
	Refresh(probe,dict,n)
	{
	if(n<1||n>6)
	return 0
		bitmap:=probe.BltCapture(1425,938,250,178)
		slotvector:= new SlotARGBVector
		bitmap.LockBits()
		this.n_ability:=GetAbilityNumFromBitmap(bitmap)
		if(this.n_ability==-1)
		return -1
		slotvector.AcquireFromBitmap(bitmap,n,this.n_ability)
		bitmap.UnLockBits()
		name:=dict.Find(slotvector,sn)
		;MsgBox sn
		if(sn==0) ;maybe in cooldown
		{
			this.slot[n].stat:=0
			return 0 
		}
		this.slot[n].stat := sn
		if(sn>=5&&sn<=7)
		{		
			;MsgBox sn
			if this.slot[n].name=="Treads"
			{
				this.slot[n].stat := sn
				return 1
			}
			else
			{
				this.slot[n]:=new ItemTreads(n,stat)
				return 1
			}
		}
		else if(sn!==this.slot[n].sn)
		{
			;t_item
			this.slot[n]:=new Item(n,name,sn)
			;MsgBox this.slot[n].NKey
			return 1
		}
		return
	}
}

class Item
{	
	n:=1 ;slot1-6 backpack7-9 TP10
	name:="Unknown" ;empty
	stat:=0 ;-1:empty, 0:cooldown or unknown, >1:has_item, 567:power_tread
	sn:=0 ;same as above but unchange in cooldown
	NKey:=""
	QKey:=""
	__New(n,name:=0,stat:=-1)
	{
		global
		this.n:=n
		this.NKey:=default_item_nkey[n]
		this.QKey:=default_item_qkey[n]
		if name
		this.name:=name
		this.stat:=stat
		this.sn:=stat
		return this
	}
	
	QCast()
	{
		SendInput(this.QKey)
		return
	}
	Cast()
	{
		SendInput(this.NKey)
		return
	}
}


class ItemTreads extends Item
{
	name:="Treads"
	__New(n,stat)
	{
		this.n:=n
		this.NKey:=default_item_nkey[n]
		this.QKey:=default_item_qkey[n]
		this.stat:=stat
		this.sn:=stat ;marking the default
		return this
	}
	
}

class SlotARGBVector
{
	name:=""
	i_max:=9 ;3*3
	n:=1 ;slot1-6 backpack7-9 TP10
	w:=57
	h:=30
	;x_P:=[] ;P[i];i=1~i_max
	;y_P:=[]
	r_P:=[]
	g_P:=[]
	b_P:=[]	
	sn:=-1
	null:=1
	
	__New()
	{
		
		return this
	}
	
	AcquireFromBitmap(bitmap,n,n_ability) ;with captured Bitmap Locked
	{
	;Gdip_SaveBitmapTOFile(bitmap.pBitmap,"test.bmp",)
	bitmap.occupied:=1
	this.null:=1
	Critical
		this.n:=n
		
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
			return 0
		}
		
		;MsgBox "here0"
		
		if((n>=1)&&(n<=3))
		{
			;MsgBox "here1"
			y0:=y0+15
			n:=n-1
		}
		else if((n>=4)&&(n<=6))
		{
			;MsgBox "here2"
			n:=n-4
			y0:=y0+15+48	
			;MsgBox y0
		}
		else
		{
			return 0
			MsgBox "out of range"
			throw 2
		}
		
		x0:=x0+65*n
		sum:=10*5 ;block:=10*10
		Scan0:=bitmap.Scan0
		Stride:=bitmap.Stride
		x:=x0-bitmap.x ;
	y:=y0-bitmap.y ;
	;MsgBox x "|" y "|" Scan0 "|" Stride 
	;MsgBox y0
	;Gdip_LockBits(probe.pBitmap, x0-probe.x, y0-probe.y,65,48, Stride,Scan0, BitmapData)
	
	j:=0
	while(j<=2)
	{
		i:=0
		while(i<=2)
		{
			this.r_P[i+3*j+1]:=0
			this.g_P[i+3*j+1]:=0
			this.b_P[i+3*j+1]:=0
			
			b:=0
			while(b<=4)
			{
				a:=0
				while(a<=9)
				{
					colorp:=NumGet(Scan0+0, ((x+10*i+a)*4)+((y+10*j+2*b)*Stride), "UInt")
					;colorp:=bitmap.GetPixel((x+19*i+2*a),(y+10*j+2*b)) NumGet(Scan0+0, ((x+19*i+2*a)*4)+((y+10*j+2*b)*Stride), "UInt")
					;probe.GetLockBitPixel(x0+19*i+a,y0+10*j+b)
					this.r_P[i+3*j+1] +=(0x00ff0000 & colorp) >> 16						
					this.g_P[i+3*j+1] +=(0x0000ff00 & colorp) >> 8	
					this.b_P[i+3*j+1] += (0x000000ff & colorp)	
					a++
				}
				b++
			}
			this.r_P[i+3*j+1] /= sum
			this.g_P[i+3*j+1] /= sum
			this.b_P[i+3*j+1] /= sum
			;MsgBox x0 "|" y0
			;MsgBox (x0+i*20+a) "|" (y0+j*10+b) "|" this.r_P[i+3*j+1] "|" this.g_P[i+3*j+1] "|" this.g_P[i+3*j+1]
			i++
			}
			j++
		}
	Critical "Off"
	bitmap.occupied:=0
	this.null:=0
		;Gdip_UnlockBits(probe.pBitmap, BitmapData)
		return 1
	}
	

	OutPut(dir,name,sn)
	{
		Loop 9
		{
			outputvar:=Format(this.r_P[A_Index] "|" this.g_P[A_Index] "|" this.b_P[A_Index])
			IniWrite outputvar, dir, Format(name), Format(A_Index "Average")	
		}
		IniWrite sn, dir, Format(name), "Sn"
		return
	}

}

class BackpackARGBVector extends SlotARGBVector
{
	
}

class ItemDict ;SlotARGBVector:Name
{
	dict:=[] ;SlotARGBVector
	dir:="item_dict.ini"
	__New()
	{
		Loop 6
		this.Load(Format("Empty" A_Index))
		return this
	}
	Load(name) 
	{
		vector:= new SlotARGBVector
		vector.name:=name
		vector.sn:=IniRead(this.dir, Format(name),"Sn", 0)
		Loop 9
		{
			;MsgBox this.dir
			;MsgBox varead
			rgbvar:=StrSplit(IniRead(this.dir, Format(name), Format(A_Index "Average") , 0),"|")
			vector.r_P[A_Index]:=rgbvar[1]
			vector.g_P[A_Index]:=rgbvar[2]
			vector.b_P[A_Index]:=rgbvar[3]
			}
			if(rgbvar[3])
			{
				this.dict[name] := vector
				return 1
			}
			else
			{
				;MsgBox name "not in file"
				return 0 ; not found
				
			}
			return
		}
		MultiLoad(names) ;name1|name2|...
		{
			name:=StrSplit(names,"|")
			Loop name.Length()
			{
				this.Load(name[A_Index])
				
			}
			return	
		}
		Find(vector,Byref sn:=-1)
		{
			if(vector.null==1)
			{
			sn:=0
			return 0
			}
			For name, v2 in this.dict
			{
				if(ArgbVectorEqual(vector,v2,1))
				{
					;MsgBox v2.sn
					sn:=v2.sn
					return name
				}
			}
			sn:=0
			return 0
		}
		Search(n)
		{
			For name, v in this.dict
			{
				if(v.sn==n)
				{
					return name
				}
			}
			return 0
		}
		InDict(name)
		{
			For dname, v in this.dict
			{
				if(Instr(dname,name))
				{
					return v
				}
			}
			return 0
			
		}
		
}




class Ability
{
	n:=4 ;Serial Number:1,2,3,ult,4,5
	key:="g" ;quick cast
	keyN:="g" ;normal cast hotkey
	level:=0 
	ready:=0 ;0:on cooldown, 1: ready
	x0:=0
	y0:=0
	w:=1
	h:=1
	x1:=0
	y1:=0
	x2:=0
	y2:=0
	colorf1:=[] ;x1,y1 leftup in ARGB,color of frame, the same below
	colorf2:=[] ;x2,y1 rightup
	colorf3:=[] ;x2,y2 rightbottom
	
	__New(n,x0,y0,w,h,x1,y1,x2,y2,colorf1,colorf2,colorf3,key:="g",keyN:="g")
	{
		this.n:=n
		this.x0:=x0
		this.y0:=y0
		this.w:=w
		this.h:=h
		this.x1:=x1
		this.y1:=y1
		this.x2:=x2
		this.y2:=y2
		this.colorf1:=colorf1
		this.colorf2:=colorf2
		this.colorf3:=colorf3
		this.key:=key
		this.keyN:=keyN
		return this
	}
	
	Cast() ;quick cast
	{
		SendInput(this.key)
		return
	}
	
	NCast() ;normal cast
	{
		SendInput(this.keyN)
		return
	}
	
	IsReady(probe,dc:=0)
	{
		bitmap:=probe.BltCapture(this.x0,this.y0,this.w,this.h,dc) ;Getcolor to determine cooldown ; selecting target in normal cast is not considered
		colorf1_now:=bitmap.GetPixel(this.x1,this.y1) ;x1,y1 leftup in ARGB,color of frame, the same below
		colorf2_now:=bitmap.GetPixel(this.x2,this.y1) ;x2,y1 rightup
		colorf3_now:=bitmap.GetPixel(this.x2,this.y2) ;x2,y2 rightbottom
		
		cd1:=1
		Loop this.colorf1.Length()
		{
			if(ColorApprox(colorf1_now,this.colorf1[A_Index]))
			cd1:=cd1*0
		}
		
		cd2:=1
		Loop this.colorf2.Length()
		{
			if(ColorApprox(colorf2_now,this.colorf2[A_Index]))
			cd2:=cd2*0
		}
		
		
		cd3:=1
		Loop this.colorf3.Length()
		{
			if(ColorApprox(colorf3_now,this.colorf3[A_Index]))
			cd3:=cd3*0
		}
		
		
		
		if((!(cd1)*!(cd2)*!(cd3)))
		this.ready:=1
		else
		this.ready:=0 
		return this.ready
	}
	
	GetStatus(probe,ini_dir) ;not finished
	{
		bitmap:=probe.BltCapture(x0,y0,w,h)
		
		succ:=0 ;Getcolor and refresh Status and level
		level:=0 ;
		return succ
	}
	
	ResetColor(probe,dir)
	{
		colorf1:=this.colorf1
		colorf2:=this.colorf2
		colorf3:=this.colorf3
	RefreshAbilityColor(probe,dir,this.n,this.x0,this.y0,this.x1,this.y1,this.x2,this.y2,colorf1,colorf2,colorf3)
	;this.colorf1:=colorf1 ;variables in class cannot pass into function by byref
		;this.colorf2:=colorf2
	;this.colorf3:=colorf3
	return
	}
	
}

class DotaMorphling extends DotaHero
{
	n_ability:=10
	dir:="Morphling.ini"


}

class AttributeShift extends Ability
{
	ready:=0 ;0:unusable, 1:not shifting, 2:on shifting 
	                                 
	coloro1:=[]
	coloro2:=[]
	coloro3:=[]
		__New(n,key,keyN,dir:="Morphling.ini")
	{
	if(n!=5)&&(n!=6)
	throw -2 ;unexpected number
		this.n:=n
		this.key:=key
		this.keyN:=KeyN
		
		this.w:=46
		this.h:=46
		this.x0:=IniRead(dir, Format("Ability" n), "x0")
		this.y0:=IniRead(dir, Format("Ability" n), "y0")
		this.x1:=IniRead(dir, Format("Ability" n), "x1")
		this.y1:=IniRead(dir, Format("Ability" n), "y1")
		this.x2:=IniRead(dir, Format("Ability" n), "x2")
		this.y2:=IniRead(dir, Format("Ability" n), "y2")
		this.colorf1:=[]		
		i:=1
		colorf1_now:=IniRead(dir, Format("Ability" n), Format("P1_" i),0)
		while(colorf1_now)
		{
			this.colorf1.push(colorf1_now)
			i++
			colorf1_now:=IniRead(dir, Format("Ability" n), Format("P1_" i),0)
		}
		
		this.colorf2:=[]		
		i:=1
		colorf2_now:=IniRead(dir, Format("Ability" n), Format("P2_" i),0)
		while(colorf2_now)
		{
			this.colorf2.push(colorf2_now)
			i++
			colorf2_now:=IniRead(dir, Format("Ability" n), Format("P2_" i),0)
		}	
		
		this.colorf3:=[]
		i:=1
		colorf3_now:=IniRead(dir, Format("Ability" n), Format("P3_" i),0)
		while(colorf3_now)
		{
			this.colorf3.push(colorf3_now)
			i++
			colorf3_now:=IniRead(dir, Format("Ability" n), Format("P3_" i),0)
		}
		
				this.coloro1:=[]		
		i:=1
		coloro1_now:=IniRead(dir, Format("Ability" n), Format("O1_" i),0)
		while(coloro1_now)
		{
			this.coloro1.push(coloro1_now)
			i++
			coloro1_now:=IniRead(dir, Format("Ability" n), Format("O1_" i),0)
		}
		
		this.coloro2:=[]		
		i:=1
		coloro2_now:=IniRead(dir, Format("Ability" n), Format("O2_" i),0)
		while(coloro2_now)
		{
			this.coloro2.push(coloro2_now)
			i++
			coloro2_now:=IniRead(dir, Format("Ability" n), Format("O2_" i),0)
		}	
		
		this.coloro3:=[]
		i:=1
		coloro3_now:=IniRead(dir, Format("Ability" n), Format("O3_" i),0)
		while(coloro3_now)
		{
			this.coloro3.push(coloro3_now)
			i++
			coloro3_now:=IniRead(dir, Format("Ability" n), Format("O3_" i),0)
		}
	return this
	}
	
		IsReady(probe,dc:=0)
	{
		bitmap:=probe.BltCapture(this.x0,this.y0,this.w,this.h,dc) ;Getcolor to determine cooldown ; selecting target in normal cast is not considered
		colorf1_now:=bitmap.GetPixel(this.x1,this.y1) ;x1,y1 leftup in ARGB,color of frame, the same below
		colorf2_now:=bitmap.GetPixel(this.x2,this.y1) ;x2,y1 rightup
		colorf3_now:=bitmap.GetPixel(this.x2,this.y2) ;x2,y2 rightbottom
		
		cd1:=1
		Loop this.colorf1.Length()
		{
			if(ColorApprox(colorf1_now,this.colorf1[A_Index]))
			cd1:=cd1*0
		}
		
		cd2:=1
		Loop this.colorf2.Length()
		{
			if(ColorApprox(colorf2_now,this.colorf2[A_Index]))
			cd2:=cd2*0
		}
		
		
		cd3:=1
		Loop this.colorf3.Length()
		{
			if(ColorApprox(colorf3_now,this.colorf3[A_Index]))
			cd3:=cd3*0
		}
		
				if((!(cd1)*!(cd2)*!(cd3)))
		{
		this.ready:=1
		return this.ready
		}
			cd1:=1
		Loop this.coloro1.Length()
		{
			if(ColorApprox(colorf1_now,this.coloro1[A_Index]))
			cd1:=cd1*0
		}
		
		cd2:=1
		Loop this.coloro2.Length()
		{
			if(ColorApprox(colorf2_now,this.coloro2[A_Index]))
			cd2:=cd2*0
		}
		
		
		cd3:=1
		Loop this.coloro3.Length()
		{
			if(ColorApprox(colorf3_now,this.coloro3[A_Index]))
			cd3:=cd3*0
		}
		
		
		if((!(cd1)*!(cd2)*!(cd3)))
		this.ready:=2
		else
		this.ready:=0 
		return this.ready
	}
}



class ScepterAbility extends Ability
{
	scepter:=0 ;false:=0 true:=1
	
}

class OnCastingAbility extends Ability
{
	/* ;to determine if on casting
		x2:=0
		y2:=0
		w2:=0
		h2:=0
		colori1:=0 ;x2,y2 leftup in ARGB, the same below
		colori2:=0 ;x2+w,y2 rightup
		colori3:=0 ;x2+w,y2+h rightbottom
	*/
	}
	
	class InvokerSpell extends Ability
	{
	/* ;to determine if on casting
		x2:=0
		y2:=0
		w2:=0
		h2:=0
		colori1:=0 ;x2,y2 leftup in ARGB, the same below
		colori2:=0 ;x2+w,y2 rightup
		colori3:=0 ;x2+w,y2+h rightbottom
	*/
	}
	
		