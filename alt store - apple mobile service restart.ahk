; /////////////////////////////////////////////////////////////////
; //              Apple Mobile Service Restart                 //
; /////////////////////////////////////////////////////////////////
#Requires AutoHotkey v2.0

if not A_IsAdmin {
    try {
        Run('*RunAs "' A_AhkPath '" "' A_ScriptFullPath '"')
        ExitApp
    }
}

serviceName := "Apple Mobile Device Service"
intervalMinutes := 15             ; Change to 15 or 30 as needed

; Convert minutes to milliseconds
intervalMs := intervalMinutes * 60 * 1000

SetTimer(RestartService, intervalMs)
Persistent()

RestartService() {
    global serviceName
    
    try {
        ; Show tooltip in corner (AHK will auto-position it)
        Tooltip("Restarting " serviceName "...", A_ScreenWidth - 300, A_ScreenHeight - 100)
        
        RunWait('net stop "' serviceName '"', , "Hide")
        Sleep(2000)
        RunWait('net start "' serviceName '"', , "Hide")
        
        Tooltip("Service restarted successfully!", A_ScreenWidth - 300, A_ScreenHeight - 100)
        Sleep(2000)
        Tooltip()
        
        ; Log action
        currentTime := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        FileAppend("Service restarted at: " currentTime "`n", "service_restart.log")
        
    } catch as e {
        Tooltip("Error: " e.Message, A_ScreenWidth - 300, A_ScreenHeight - 100)
        Sleep(3000)
        Tooltip()
        
        currentTime := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        FileAppend("Error at " currentTime ": " e.Message "`n", "service_restart.log")
    }
}

; Hotkey to manually trigger restart (optional)
F1::RestartService()
