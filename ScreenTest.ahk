SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.

#include ColorCatcher.ahk

Gdip_Startup()
probe0 := new ColorProbe(A_ScreenWidth,A_ScreenHeight)

~f11::
screenshot:=probe0.RealCoordinateCapture(0,0,A_ScreenWidth,A_ScreenHeight)
sleep 1000
Gdip_SaveBitmapToFile(screenshot.pBitmap, "ScreenTest.png")
;MsgBox A_ScreenWidth "|" A_ScreenHeight
return
