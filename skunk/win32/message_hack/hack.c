#include <windows.h>
 
static char* szWindowClass = "bbhack";
static char* szTitle       = "Bushido Burrito Demo Hacker";
static const char buttonId = 'b';
 
static char* szVictimWindowClass = "bbtest";
static char* szVictimTitle       = "Bushido Burrito Demo Win32 App";
static const char victimButtonId = 'b';
 
void DoTheHack(void)
{
    HWND bbdemo = FindWindow(szVictimWindowClass, szVictimTitle);
 
    if (!bbdemo) {
        MessageBox(NULL,
            "Could not find victim app",
            "Error",
            MB_OK | MB_ICONERROR);
        return;
    }
 
    WPARAM wParam = BN_CLICKED | victimButtonId;
    PostMessage(bbdemo, WM_COMMAND, wParam, 0);
}
 
LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    switch (msg) {
 
        case WM_CREATE:
            CreateWindow(
                "Button",
                "button",
                WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON,
                50, 50, 80, 50,
                hwnd,
                (HMENU) (int) buttonId,
                GetModuleHandle(NULL),
                NULL);
            break;
 
        case WM_DESTROY:
            PostQuitMessage(0);
            break;
 
        case WM_COMMAND:
            if (HIWORD(wParam) == BN_CLICKED &&
                (char) LOWORD(wParam) == buttonId) {
 
                DoTheHack();
            }
            break;
 
        default:
            return DefWindowProc(hwnd, msg, wParam, lParam);
            break;
    }
 
    return 0;
}
 
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
    WNDCLASSEX wcex;
 
    wcex.cbSize = sizeof(WNDCLASSEX);
    wcex.style          = CS_HREDRAW | CS_VREDRAW;
    wcex.lpfnWndProc    = WndProc;
    wcex.cbClsExtra     = 0;
    wcex.cbWndExtra     = 0;
    wcex.hInstance      = hInstance;
    wcex.hIcon          = LoadIcon(hInstance, 
        MAKEINTRESOURCE(IDI_APPLICATION));
    wcex.hCursor        = LoadCursor(NULL, IDC_ARROW);
    wcex.hbrBackground  = (HBRUSH)(COLOR_WINDOW+1);
    wcex.lpszMenuName   = NULL;
    wcex.lpszClassName  = szWindowClass;
    wcex.hIconSm        = LoadIcon(wcex.hInstance,
        MAKEINTRESOURCE(IDI_APPLICATION));
 
    if (!RegisterClassEx(&wcex)) {
        MessageBox(NULL,
            "Call to RegisterClassEx failed!",
            "Error",
            MB_OK | MB_ICONERROR);
        return 1;
    }
 
    HWND hWnd = CreateWindow(
        szWindowClass,
        szTitle,
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT,
        400, 300,
        NULL,
        NULL,
        hInstance,
        NULL);
 
    if (!hWnd) {
        MessageBox(NULL,
            "Call to CreateWindow failed!",
            "Error",
            MB_OK | MB_ICONERROR);
 
        return 1;
    }
 
    ShowWindow(hWnd, nCmdShow);
    UpdateWindow(hWnd);
 
    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
 
    return (int) msg.wParam;
}

