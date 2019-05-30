SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir ; Ensures a consistent starting directory.

global a1:=1
global a2:=0

class HotkeyClass
{
__New()
{
Hotkey "g", this.KeyG.Bind()
Hotkey "If", "a2==1"
Hotkey "h", this.KeyH.Bind()
Hotkey "If"
return this
}
KeyG()
{
a2:=1-a2
return
}
KeyH()
{
SoundBeep(440)
return
}
}

#If a2==1

#If
