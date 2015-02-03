
#include <stdio.h>
#include <windows.h>
#include <winuser.h>

// MinGW may need these
#ifndef HWND_MESSAGE
#define HWND_MESSAGE (HWND)-3
#endif
#ifndef ATTACH_PARENT_PROCESS
#define ATTACH_PARENT_PROCESS (DWORD)-1
#endif

static char* szWindowClass = "bbautoclicker";
static char* szTitle       = "Auto-Clicker";

HHOOK gNextKeyHook;
 
LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    switch (msg) {

		case WM_KEYDOWN:
			//printf("hey\t");
			break;
 
        case WM_DESTROY:
            PostQuitMessage(0);
            break;
 
        default:
            return DefWindowProc(hwnd, msg, wParam, lParam);
            break;
    }
 
    return 0;
}

LRESULT CALLBACK KeyboardProc(int code, WPARAM wParam, LPARAM lParam)
{
	printf("hey\t");

	CallNextHookEx(gNextKeyHook, code, wParam, lParam);
}
 
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
/*
    WNDCLASSEX wcex;
 
    wcex.cbSize			= sizeof(WNDCLASSEX);
    wcex.style          = CS_HREDRAW | CS_VREDRAW;
    wcex.lpfnWndProc    = WndProc;
    wcex.cbClsExtra     = 0;
    wcex.cbWndExtra     = 0;
    wcex.hInstance      = hInstance;
    wcex.hIcon          = NULL; //LoadIcon(hInstance, MAKEINTRESOURCE(IDI_APPLICATION));
    wcex.hCursor        = LoadCursor(NULL, IDC_ARROW);
    wcex.hbrBackground  = (HBRUSH)(COLOR_WINDOW+1);
    wcex.lpszMenuName   = NULL;
    wcex.lpszClassName  = szWindowClass;
    wcex.hIconSm        = NULL; //LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_APPLICATION));
 
    if (!RegisterClassEx(&wcex)) {
        MessageBox(NULL,
            "Call to RegisterClassEx failed!",
            "Error",
            MB_OK | MB_ICONERROR);
        return 1;
    }
 
    HWND hWnd = CreateWindowEx(
		0,
        szWindowClass,
        szTitle,
        WS_POPUP,
        CW_USEDEFAULT, CW_USEDEFAULT,
        400, 300,
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
*/

	gNextKeyHook = SetWindowsHookEx(WH_KEYBOARD, (HOOKPROC) KeyboardProc, GetModuleHandle("user32"), 0);

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

	printf("Auto-Clicker Ready\n");
 
    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

	fclose(stdout);
	FreeConsole();
 
    return (int) msg.wParam;
}

