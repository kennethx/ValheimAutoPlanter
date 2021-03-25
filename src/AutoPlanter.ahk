#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#MaxThreadsPerHotkey 2
#SingleInstance Force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Fullmakt AS, hereby disclaims all copyright interest in the
; application `AutoPlanter' (an application for automatically planting crops in Valheim)
; written by Kenneth Ellefsen aka @Fullmakt March 2021

Kenneth Ellefsen, 25 March 2021
Owner of Fullmakt AS

; v1.1 23.03.21 Modified algorithm to work with cultivator nerf.
; v1.0 20.03.21 First public release on my Valheim discord server.

; Default values to start out with
global cooldownNerf := 600
global staminaTime := 8000
global plantInterval := 300
global rowInterval := 300
global plantsPrRow := 20
global newRowCorrection := 140 ; align first plant with previous row
global sidestepDelay := 180 ; Get sidestepping up to speed before planting 2nd plant
global cooldownDelay := cooldownNerf-rowInterval

myGui()

myGui()
{

   static staminaTimeGui := staminaTime
   static plantIntervalGui := plantInterval
   static rowIntervalGui := rowInterval
   static plantsPrRowGui := plantsPrRow

	gui, SomeGuiName: new
	gui,Default
	gui,+LastFound
	gui, add, groupbox, w270 h230, Fullmakts Valheim Auto Crop Planter
	gui, add, text, xm12 ym30 section, Stamina pause
	gui, add, text, xm12 yp+30, Planting interval
	gui, add, text, xm12 yp+30, Row interval
	gui, add, text, xm12 yp+30, Plants pr row
	gui, add, text, xm12 yp+30, Hotkey to start macro: F1
	gui, add, button, hidden yp+30 gDone, Update
	gui, add, edit, ys ym30 gCheck vstaminaTimeGui Number, %staminaTime%
	gui, add, edit, yp+30 gCheck vplantIntervalGui Number, %plantInterval%
	gui, add, edit, yp+30 gCheck vrowIntervalGui Number, %rowInterval%
	gui, add, edit, yp+30 gCheck vplantsPrRowGui Number, %plantsPrRow%
	gui, add, button, yp+30  gguiclose, Exit
	gui, show,, Auto Planter v1.1

   Edit1.OnEvent("Change", "ValueChange")

	return winexist()

	Done:

	{

		gui,submit,nohide

		;ListVars

		;msgbox your values `staminaTime :%staminaTime% `plantInterval :%plantInterval% `rowInterval :%rowInterval% `plantsPrRow :%plantsPrRow%

      staminaTime := staminaTimeGui
      plantInterval := plantIntervalGui
      rowInterval := rowIntervalGui
      plantsPrRow := plantsPrRowGui
      cooldownDelay := cooldownNerf-rowInterval

		return

	}



	guiclose:

	{

		gui,destroy

		ExitApp

		return

	}

   Check:
    {
         gui,submit,nohide
         ;msgbox your values `staminaTime :%staminaTime% `plantInterval :%plantInterval% `rowInterval :%rowInterval% `plantsPrRow :%plantsPrRow%
         staminaTime := staminaTimeGui
         plantInterval := plantIntervalGui
         rowInterval := rowIntervalGui
         plantsPrRow := plantsPrRowGui
         cooldownDelay := cooldownNerf-rowInterval
         return
   }
}


ValueChange()
{
   msgbox your values `staminaTime :%staminaTime% `plantInterval :%plantInterval% `rowInterval :%rowInterval% `plantsPrRow :%plantsPrRow%
}


; Hotkey modifiers ^Control, !Alt, +Shift
;List of keys: https://www.autohotkey.com/docs/KeyList.htm

;~^LButton:: ; The Hotkey, Control, Alt Left Mouse
F1:: ; The Hotkey, Control F1
global Active := !Active ; The assigned hotkey is a toggle



if(!Active)
{
   ToolTip, "Planting script is active waiting for hotkey"
   sleep, 1000
   ToolTip
   return
}

while (Active)
{
   ToolTip, "Planting of %plantsPrRow% plants is starting starting sidestep d"

   i := 1
   Send, {lbutton}
   while (i<plantsPrRow) and (Active)
   {
      i++
      Send {d down}
      ; do a small extra pause before planting 2nd so sidestepping can get up to speed.
      ;Sleep, sidestepDelay
      Sleep, plantInterval
      Send {d up}  ; Stop sidestep
      if(cooldownDelay > 0)
         Sleep, cooldownDelay
      Send, {lbutton}
   }

   if (!Active)
   {
      return
   }

   Tooltip, "row complete getting in position for stating next row and regening stamina"
   ; Step back to start new row
   Send, {s down}
   sleep, rowInterval
   Send, {s up}
   ; small correction to get planting alignment with previous row
;   Send {a down}
;   sleep, newRowCorrection
;   Send {a up}


   ; wait to regen stamina
   sleep, staminaTime
   if (!Active)
   {
      return
   }

   ToolTip, "Planting is starting starting sidestep a"
   ; Plant n number of plants for each row

   i := 1
   Send, {lbutton}
   while(i<plantsPrRow) and (Active)
   {
      i++
      Send {a down}
      ; do a small extra pause before planting 2nd so sidestepping can get up to speed.
      ;Sleep, sidestepDelay
      Sleep, plantInterval
      Send {a up}  ; Stop sidestep
      if(cooldownDelay > 0)
         Sleep, cooldownDelay
      Send, {lbutton}

   }

   if (!Active)
   {
      return
   }

   Tooltip, "row complete getting in position for stating next row and regenign stamina"
   ; Step back to start new row
   Send, {s down}
   sleep, rowInterval
   Send, {s up}
;   Send {d down}
;   sleep, newRowCorrection
;   Send {d up}

   ; wait to regen stamina
   sleep, staminaTime
   if (!Active)
   {
      return
   }
}





