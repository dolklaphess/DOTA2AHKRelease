;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.

dir:="Morphling.ini"
		
		n_ability:=3
		n_interval:=[ 0,1,2 ]
		x0a1:=1130
		y0a1:=941
		x1a1:=1177
		y1a1:=947
		x2a1:=1183
		y2a1:=969
		w:=60
		d:=58
		

		
			n:=1
			while(n <= n_ability)
	{
		
				x0:=x0a1+d*n_interval[n]
		y0:=y0a1
		x1:=x1a1+d*n_interval[n]
		y1:=y1a1
		x2:=x2a1+d*n_interval[n]
		y2:=y2a1
		IniWrite(x0,dir, Format("Ability" n), Format("x0"))
		IniWrite(y0,dir, Format("Ability" n), Format("y0"))
		IniWrite(x1,dir, Format("Ability" n), Format("x1"))
		IniWrite(y1,dir, Format("Ability" n), Format("y1"))
		IniWrite(x2,dir, Format("Ability" n), Format("x2"))
		IniWrite(y2,dir, Format("Ability" n), Format("y2"))
		n++
	}
	d:=262		
				x0:=x0a1+d
		y0:=y0a1
		x1:=x1a1+d
		y1:=y1a1
		x2:=x2a1+d
		y2:=y2a1
		IniWrite(x0,dir, Format("Ability" n), Format("x0"))
		IniWrite(y0,dir, Format("Ability" n), Format("y0"))
		IniWrite(x1,dir, Format("Ability" n), Format("x1"))
		IniWrite(y1,dir, Format("Ability" n), Format("y1"))
		IniWrite(x2,dir, Format("Ability" n), Format("x2"))
		IniWrite(y2,dir, Format("Ability" n), Format("y2"))
		n++

	return