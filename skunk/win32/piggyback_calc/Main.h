
int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow);
LRESULT CALLBACK WindowProc (HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam);
void CreateChildControls(HWND hwnd);
void CreateCalculatorButton(HWND hwnd, char command, int x, int y, int nWidth, int nHeight);
void ProcessButtonClick(char command);
void SetDisplayText(char* text);