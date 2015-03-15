#include <windows.h>
 
static char* szWindowClass = "bbtest";
static char* szTitle       = "Bushido Burrito Demo Win32 App";
static const char buttonId = 'b';
 
// determines if user is allowed to click the button
static const char buttonPermission = 0;
 
LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    DWORD buttonStyle = WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON;
 
    switch (msg) {
 
        case WM_CREATE:
            if (!buttonPermission) {
                buttonStyle |= WS_DISABLED;
            }
            CreateWindow(
                "Button",
                "button",
                buttonStyle,
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
 
                MessageBox(NULL,
                    "You clicked the button.",
                    "Message",
                    MB_OK | MB_ICONINFORMATION);
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
         MAKEINTRESOURCE((int) IDI_APPLICATION));
    wcex.hCursor        = LoadCursor(NULL, IDC_ARROW);
    wcex.hbrBackground  = (HBRUSH)(COLOR_WINDOW+1);
    wcex.lpszMenuName   = NULL;
    wcex.lpszClassName  = szWindowClass;
    wcex.hIconSm        = LoadIcon(wcex.hInstance,
        MAKEINTRESOURCE((int) IDI_APPLICATION));
 
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

