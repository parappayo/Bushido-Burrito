
#include <stdio.h>
#include <windows.h>
// #include <winuser.h>
#include <strsafe.h>

const char* gHelpText = "Auto-Clicker Help:\n \
- Press 1 to register the active window as where to send click messages.\n \
- Press 2 to register the current mouse position as the coordinate to click.\n \
- Press 3 to toggle the spamming of click messages.\n \
\n";

// dirty globals
HHOOK gNextKeyHook;
HWND gTargetWindow;
POINT gMousePos;
BOOL gSpamClicks;

static char* szWindowClass = "bbautoclicker";
static char* szTitle	   = "Auto-Clicker";

//
// https://msdn.microsoft.com/en-us/library/windows/desktop/ms680582(v=vs.85).aspx
//
void ErrorExit(LPTSTR lpszFunction) 
{ 
	LPVOID lpMsgBuf;
	LPVOID lpDisplayBuf;
	DWORD dw = GetLastError();

	gSpamClicks = FALSE;

	FormatMessage(
		FORMAT_MESSAGE_ALLOCATE_BUFFER | 
		FORMAT_MESSAGE_FROM_SYSTEM |
		FORMAT_MESSAGE_IGNORE_INSERTS,
		NULL,
		dw,
		MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
		(LPTSTR) &lpMsgBuf,
		0, NULL );

	lpDisplayBuf = (LPVOID)LocalAlloc(LMEM_ZEROINIT, 
		(lstrlen((LPCTSTR)lpMsgBuf) + lstrlen((LPCTSTR)lpszFunction) + 40) * sizeof(TCHAR)); 
	StringCchPrintf((LPTSTR)lpDisplayBuf, 
		LocalSize(lpDisplayBuf) / sizeof(TCHAR),
		TEXT("%s failed with error %d: %s"), 
		lpszFunction, dw, lpMsgBuf); 
	MessageBox(NULL, (LPCTSTR)lpDisplayBuf, TEXT("Error"), MB_OK); 

	LocalFree(lpMsgBuf);
	LocalFree(lpDisplayBuf);
	ExitProcess(dw); 
}

void SendClick(HWND targetWindow, POINT mousePos)
{
	INPUT click;
	UINT currentThreadId, targetThreadId;

	click.type = INPUT_MOUSE;
	click.mi.dx = mousePos.x;
	click.mi.dy = mousePos.y;
	click.mi.mouseData = 0;
	click.mi.dwFlags = MOUSEEVENTF_ABSOLUTE;
	click.mi.time = 0;
	click.mi.dwExtraInfo = 0;

	currentThreadId = GetCurrentThreadId();
	targetThreadId = GetWindowThreadProcessId(targetWindow, NULL);

	if (currentThreadId == targetThreadId)
	{
		SendInput(1, &click, sizeof(INPUT));
	}
	else if (AttachThreadInput(targetThreadId, currentThreadId, TRUE))
	{
		if (!SetFocus(targetWindow)) { ErrorExit("SetFocus"); }
		if (!SendInput(1, &click, sizeof(INPUT))) { ErrorExit("SendInput"); }
		AttachThreadInput(targetThreadId, currentThreadId, FALSE);
	}
	else
	{
		ErrorExit("AttachThreadInput");
	}
}

void HandleKeydown(int keyCode)
{
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

	case 0x33: // KeyCodes.VK_3
		{
			if (gSpamClicks)
			{
				gSpamClicks = FALSE;
				printf("done\n");
			}
			else
			{
				gSpamClicks = TRUE;
				printf("spamming...");
			}
		}
		break;
	}
}

LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	switch (msg) {

		case WM_INPUT:
			{
				UINT dwSize;
				LPBYTE lpb;
				RAWINPUT* raw;

				GetRawInputData((HRAWINPUT)lParam, RID_INPUT, NULL, &dwSize, sizeof(RAWINPUTHEADER));
				lpb = malloc(dwSize);
				if (!lpb) { return 0; }

				if (GetRawInputData((HRAWINPUT)lParam, RID_INPUT, lpb, &dwSize, sizeof(RAWINPUTHEADER)) != dwSize)
				{
					return 0;
				}
				raw = (RAWINPUT*)lpb;

				if (raw->header.dwType == RIM_TYPEKEYBOARD) 
				{
					if ((raw->data.keyboard.Flags & RI_KEY_BREAK) == 0) // keydown
					{
						HandleKeydown(raw->data.keyboard.VKey);
					}
				}

				free(lpb);
			}
			break;
			
		case WM_TIMER:
			{
				if (gSpamClicks)
				{
					RECT targetRect;
					GetWindowRect(gTargetWindow, &targetRect);
					//MapWindowPoints(HWND_DESKTOP, ???, (LPPOINT) &targetRect, 2);

					//SendClick(gTargetWindow, gMousePos);
					PostMessage(gTargetWindow, WM_LBUTTONDOWN, MK_LBUTTON, MAKELONG(gMousePos.x - targetRect.left, gMousePos.y - targetRect.top));
				}
			}
			break;

		case WM_DESTROY:
			{
				PostQuitMessage(0);
			}
			break;
 
		default:
			{
				return DefWindowProc(hwnd, msg, wParam, lParam);
			}
			break;
	}
 
	return 0;
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	WNDCLASSEX wcex;
	HWND hWnd;
	MSG msg;
	RAWINPUTDEVICE Rid[1];
	FILE* fileStream;

	gTargetWindow = 0;
	gMousePos.x = 0;
	gMousePos.y = 0;
	gSpamClicks = FALSE;
 
	wcex.cbSize			= sizeof(WNDCLASSEX);
	wcex.style			= CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc	= WndProc;
	wcex.cbClsExtra		= 0;
	wcex.cbWndExtra		= 0;
	wcex.hInstance		= hInstance;
	wcex.hIcon			= NULL; //LoadIcon(hInstance, MAKEINTRESOURCE(IDI_APPLICATION));
	wcex.hCursor		= LoadCursor(NULL, IDC_ARROW);
	wcex.hbrBackground  = (HBRUSH)(COLOR_WINDOW+1);
	wcex.lpszMenuName   = NULL;
	wcex.lpszClassName  = szWindowClass;
	wcex.hIconSm		= NULL; //LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_APPLICATION));
 
	if (!RegisterClassEx(&wcex)) {
		MessageBox(NULL,
			"Call to RegisterClassEx failed!",
			"Error",
			MB_OK | MB_ICONERROR);
		return 1;
	}
 
	hWnd = CreateWindow(
		szWindowClass,
		szTitle,
		0, // WS_POPUP
		CW_USEDEFAULT, CW_USEDEFAULT,
		0, 0, // 400, 300
		HWND_MESSAGE,
		NULL,
		hInstance,
		NULL);

	if (!hWnd) {
		MessageBox(NULL,
			"CreateWindow failed",
			"Error",
			MB_OK | MB_ICONERROR);
		return 1;
	}
	ShowWindow(hWnd, nCmdShow);
	UpdateWindow(hWnd);

	Rid[0].usUsagePage = 0x01; 
	Rid[0].usUsage = 0x06; // keyboard
	Rid[0].dwFlags = RIDEV_NOLEGACY | RIDEV_INPUTSINK;
	Rid[0].hwndTarget = hWnd;

	if (!RegisterRawInputDevices(Rid, 1, sizeof(Rid[0]))) {
		MessageBox(NULL,
			"RegisterRawInputDevices failed",
			"Error",
			MB_OK | MB_ICONERROR);
		return 1;
	}

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
	freopen_s(&fileStream, "CONOUT$", "wb", stdout);
	freopen_s(&fileStream, "CONOUT$", "wb", stderr);

	printf(gHelpText);

	SetTimer(hWnd, 1, 500, NULL);
 
	while (GetMessage(&msg, hWnd, 0, 0)) {
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	fclose(stdout);
	FreeConsole();
 
	return (int) msg.wParam;
}

