;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
	; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.

class ThreadManager
{
	default_period:=250
	timer_list:=[]
	sub_list:=[]
	
	__New()
	{
		return this
	}
	
	
	RunAndTimer(Callback, PeriodOnOffDelete:="", Priority:="")
	{
	

	this.Timer(Callback, PeriodOnOffDelete, Priority)
		%Callback%()
	return
	}
	
	SetTimeoutTimer(timeout,Callback,do_on_timeout:=0)
	{
			
				if(timeout>0)
				{
					this.timer_list[Callback].Timeout(timeout,do_on_timeout)
				}		
				
	return
	}
	
	TimerUntil(timeout,Callback,PeriodOnOffDelete:="", Priority:="",do_on_timeout:=0)
	{
		
		this.Timer(Callback, PeriodOnOffDelete, Priority)

				if(timeout>0)
				{
					this.timer_list[Callback].Timeout(timeout,do_on_timeout)
				}		
				
		return
	}
	
		RunAndTimerUntil(timeout,Callback, PeriodOnOffDelete:="", Priority:="",do_on_timeout:=0)
		{
				

		this.Timer(Callback, PeriodOnOffDelete, Priority)
			%Callback%()
				if(timeout>0)
				{
	this.timer_list[Callback].Timeout(timeout,do_on_timeout)
				}		
				
		return
		
		}
	
	Timer(Callback, PeriodOnOffDelete:="", Priority:="") ;replace SetTimer
	{ ;Callback can not be omit, for the function doesn't know and record which timer to change
	
		if(this.timer_list[Callback])
		{
			if(PeriodOnOffDelete="Delete") ;not case sensitive
			{
				SetTimer(Callback,"Delete")
				this.timer_list[Callback].Delete(Callback)
				return
			}
			else if(PeriodOnOffDelete=="") ;reset on
			{
				SetTimer(Callback,,Priority)
				if(Priority is "number")
				{
					this.timer_list[Callback].Priority:=Priority
					
				}
				else
				{
					this.timer_list[Callback].on_off:=1
					this.timer_list[Callback].TimeStart:=A_TickCount
				}
				
				return
			}
			else if(PeriodOnOffDelete="On")
			{
				SetTimer(Callback,"On",Priority)
				this.timer_list[Callback].TimeStart:=A_TickCount
				if(Priority is "number")
				this.timer_list[Callback].Priority:=Priority
				this.timer_list[Callback].on_off:=1
				if(PeriodOnOffDelete<0)
				this.timer_list[Callback].on_off:=-1
				return
				
			}
			else if(PeriodOnOffDelete="Off")
			{
				SetTimer(Callback,"Off",Priority)
				
				this.timer_list[Callback].on_off:=0
				this.timer_list[Callback].off_confirm:=0
				if(Priority is "number")
				this.timer_list[Callback].Priority:=Priority
			return
			}
			else if(PeriodOnOffDelete is "number")
			{
				SetTimer(Callback,PeriodOnOffDelete,Priority)
				this.timer_list[Callback].TimeStart:=A_TickCount
				if(Priority is "number")
				this.timer_list[Callback].Priority:=Priority
				this.timer_list[Callback].Period:=PeriodOnOffDelete
				this.timer_list[Callback].on_off:=1
				if(PeriodOnOffDelete<0)
				this.timer_list[Callback].on_off:=0
				
				return
				
			}
			else
			{
				throw 2 ;unexpected input
				return
			}
			
		}
		else
		{
			if(PeriodOnOffDelete=="")
			PeriodOnOffDelete:=default_period
			if(Priority=="")
			Priority:=0
			
			this.timer_list[Callback]:=new ThreadWithProperty(this,Callback, PeriodOnOffDelete, Priority)
			SetTimer(Callback, PeriodOnOffDelete, Priority)
			return
			
		}
		
		return
	}
	
	Subroutine(sub_label) ;replace Gosub however slightly slowed
	{
		this.sub_list[sub_label]:=1
		Gosub %sub_label%
		this.sub_list[sub_label]:=0
		return		
	}
	
	
}

class ThreadWithProperty
{
	Callback:=""
	TimeStart:=A_TickCount ;not reliable since we don't know the actual script running time,especially in the case Period too small
	Period:=0
	on_off:=0
	do_on_timeout:=0
	timeout_priority:=100 ;high priority
	manager:=""
	off_confirm:=1
	
	__New(manager,Callback, PeriodOnOffDelete, Priority)
	{
	this.manager:=manager
		this.Callback:=Callback
		this.Period:=PeriodOnOffDelete ;0:off,+:period,-:run only once
		this.Priority:=Priority
		this.on_off:=1
		this.TimeStart:=A_TickCount
		this.timer:= ObjBindMethod(this,"TurnOff")
		return this
	}
	Timeout(timeout,do_on_timeout)
	{
		this.timeout_start:=A_TickCount
		this.off_confirm:=1
		if(do_on_timeout)
		this.do_on_timeout:=do_on_timeout
		else
		this.do_on_timeout:=0
		SetTimer(this.timer,-timeout,this.timeout_priority)
		return this
	}
	
		TurnOff()
	{
		if(this.on_off==1&&this.off_confirm==1)
		{
		this.manager.Timer(this.Callback,"Off")
		if(this.do_on_timeout)
		%this.do_on_timeout%()
		}
return
	}
	/*
	Period[] ;0:off,+:period,-:run only once
	{
		set
		{
			this.ppt_Period:=value
			TimeStart:=A_TickCount
			return value
		}
		get
		{
		return this.ppt_Period
		}
	}
	on_off[]
	{
		get
		{
		return this.ppt_on_off
		}
		set
		{
		this.ppt_on_off:=value
			TimeStart:=A_TickCount
			return value
		}
	}
	*/
}

/*
class TimeoutTimer extends ThreadWithProperty
{
Priority:=100 ;high priority

	__New(Callback,manager,timeout)
	{
		this.Callback:=Callback
		this.Period:=-timeout
		this.on_off:=0
		this.manager:=manager
		this.TimeStart:=A_TickCount
		this.timer:= ObjBindMethod(this,"TurnOff")
		MsgBox this.Period
		SetTimer(this.timer,this.Period,this.Priority)
		return this
	}
	
	TurnOff()
	{
		if(this.manager.timer_list[this.Callback].on_off==1)
		{
	this.manager.Timer(this.Callback,"Off")
		}
return
	}


}
*/