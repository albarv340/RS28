Left := "a"

Center := "LButton"

Right := "d"

;Must be in auto-execute section if I want to use the constants
#Include .\AHKHID.ahk

;Create GUI to receive messages
Gui, +LastFound
hGui := WinExist()

;Intercept WM_INPUT messages
WM_INPUT := 0xFF
OnMessage(WM_INPUT, "InputMsg")

;Register Remote Control with RIDEV_INPUTSINK (so that data is received even in the background)
p := AHKHID_Register(12, 1, hGui, RIDEV_INPUTSINK)

Return

InputMsg(wParam, lParam) {
    Local devh, iKey, sLabel
    
    Critical
    
    ;Get handle of device
    devh := AHKHID_GetInputInfo(lParam, II_DEVHANDLE)
    
    ;Check that it is my Foot pedal
    If (AHKHID_GetDevInfo(devh, DI_DEVTYPE, True) = RIM_TYPEHID)
        And (AHKHID_GetDevInfo(devh, DI_HID_VENDORID, True) = 1972)
        And (AHKHID_GetDevInfo(devh, DI_HID_PRODUCTID, True) = 536) 
	; And (AHKHID_GetDevInfo(devh, DI_HID_VERSIONNUMBER, True) = 1) 
    {
        
        ;Get data
        AHKHID_GetInputData(lParam, uData)
        iKey := NumGet(uData, 3, "UInt")
        sLabel := "FOOT_" . iKey
	if IsLabel(sLabel)
		Gosub, %sLabel%
    }
}

;None
FOOT_0:
    Send {%Left% up}
    Send {%Center% up}
    Send {%Right% up}
Return

;Left
FOOT_1:
    SetKeyDelay 10
    Send {%Left% down}
    Send {%Center% up}
    Send {%Right% up}
Return

;Right
FOOT_2:
    SetKeyDelay 10
    Send {%Left% up}
    Send {%Center% up}
    Send {%Right% down}
Return

;Center
FOOT_4:
    Send {%Left% up}
    Send {%Center% down}
    Send {%Right% up}
Return

;Left and Right
FOOT_3:
    Send {%Left% down}
    Send {%Center% up}
    Send {%Right% down}
Return

;Left and Center
FOOT_5:
    Send {%Left% down}
    Send {%Center% down}
    Send {%Right% up}
Return

;Right and Center
FOOT_6:
    Send {%Left% up}
    Send {%Center% down}
    Send {%Right% down}
Return

;Right, Left and Center
FOOT_7:
    Send {%Left% down}
    Send {%Center% down}
    Send {%Right% down}
Return
