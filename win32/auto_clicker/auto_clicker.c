
#include <stdio.h>
#include <windows.h>
#include <winuser.h>

const char* gHelpText = "Auto-Clicker Help:\n \
- Press 1 to register the active window as where to send click messages.\n \
- Press 2 to register the current mouse position as the coordinate to click.\n \
\n";

// dirty globals
HHOOK gNextKeyHook;
HWND gTargetWindow;
POINT gMousePos;

 
LRESULT CALLBACK KeyboardProc(int code, WPARAM wParam, LPARAM lParam)
{
	// only listen for key-down messages
	if (code != HC_ACTION || (HIWORD(lParam) & (KF_UP | KF_REPEAT)) != 0)
	{
		return;
	}

	int keyCode = (char) wParam;

	switch (keyCode)
	{
		case 0x31: // KeyCodes.VK_1
			{
				gTargetWindow = GetForegroundWindow();
				printf("registered target window = 0x%x\n", gTargetWindow);
			}
			break;

		case 0x32: // KeyCodes.VK_2
			{
				GetCursorPos(&gMousePos);
				printf("registered mouse position = %d, %d\n", gMousePos.x, gMousePos.y);
			}
			break;
	}

	CallNextHookEx(gNextKeyHook, code, wParam, lParam);
}
 
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	gNextKeyHook = SetWindowsHookEx(
		WH_KEYBOARD,
		(HOOKPROC) KeyboardProc,
		GetModuleHandle("user32"),
		0);

	FreeConsole();
	if (!AllocConsole()
//			&& !AttachConsole(ATTACH_PARENT_PROCESS)
	   		) {
        MessageBox(NULL,
            "AllocConsole failed",
            "Error",
            MB_OK | MB_ICONERROR);
        return 1;
	}
	//freopen("CONIN$", "rb", stdin);
	freopen("CONOUT$", "wb", stdout);
	freopen("CONOUT$", "wb", stderr);

	printf(gHelpText);
 
    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

	fclose(stdout);
	FreeConsole();
 
    return (int) msg.wParam;
}

