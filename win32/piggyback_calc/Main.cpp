#include <windows.h>
#include <stdio.h>
#include "calcfunc.h"
#include "piggyback.h"
#include "main.h"

#define IDE_TEXT 101

char g_szClassName[ ] = "WindowsApp";
char g_Operator = '~';
char g_Memory[15];
bool g_DoClear = FALSE;
static HWND hwndEditBox;

int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	/* Define the Window Class and try to register it */
	WNDCLASSEX wc;
	wc.cbSize        = sizeof (WNDCLASSEX);
	wc.style         = 0; 
	wc.lpfnWndProc   = WindowProc;
	wc.cbClsExtra    = 0;
    wc.cbWndExtra    = 0;
    wc.hInstance     = hInstance;
    wc.hIcon         = LoadIcon(NULL, IDI_APPLICATION);
    wc.hCursor       = LoadCursor(NULL, IDC_ARROW);
	wc.hbrBackground = (HBRUSH) COLOR_BACKGROUND;
    wc.lpszMenuName  = NULL;
    wc.lpszClassName = g_szClassName;
    wc.hIconSm       = LoadIcon(NULL, IDI_APPLICATION);
	if (!RegisterClassEx (&wc)) return 0;

	InitPiggyback();

	/* Create and Show the Window */
	HWND hwnd = CreateWindowEx (
		0, g_szClassName, "The OMGWTF Calculator",
		WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, 
		220, 270, 
		HWND_DESKTOP, NULL, hInstance, NULL);
	ShowWindow (hwnd, nCmdShow);

	/* Process the Message Loop  */
	MSG messages; 
	while (GetMessage (&messages, NULL, 0, 0))
	{
		TranslateMessage(&messages);
		DispatchMessage(&messages);
	}

	FinPiggyback();

	return (int)messages.wParam;
}

LRESULT CALLBACK WindowProc (HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	/* Process a Message sent to the Window */
	switch (message)
	{
		case WM_CREATE:
			CreateChildControls(hwnd);
			break;

		case WM_COMMAND:
			if( HIWORD( wParam ) == BN_CLICKED )
			{
				ProcessButtonClick( (char)LOWORD( wParam ) );
			}
			break;

		case WM_DESTROY:
			PostQuitMessage (0); 
			break;
	}
	return DefWindowProc (hwnd, message, wParam, lParam);
}


void CreateChildControls(HWND hwnd)
{
	// Create the Individual Buttons
	CreateCalculatorButton(hwnd, '7',  10,  40, 40, 40);
	CreateCalculatorButton(hwnd, '8',  60,  40, 40, 40);
	CreateCalculatorButton(hwnd, '9', 110,  40, 40, 40);
	CreateCalculatorButton(hwnd, '4',  10,  90, 40, 40);
	CreateCalculatorButton(hwnd, '5',  60,  90, 40, 40);
	CreateCalculatorButton(hwnd, '6', 110,  90, 40, 40);
	CreateCalculatorButton(hwnd, '1',  10, 140, 40, 40);
	CreateCalculatorButton(hwnd, '2',  60, 140, 40, 40);
	CreateCalculatorButton(hwnd, '3', 110, 140, 40, 40);
	CreateCalculatorButton(hwnd, '0',  10, 190, 40, 40);
	CreateCalculatorButton(hwnd, 'C',  60, 190, 40, 40);
	CreateCalculatorButton(hwnd, '=', 110, 190, 40, 40);
	CreateCalculatorButton(hwnd, '+', 160,  40, 40, 40);
	CreateCalculatorButton(hwnd, '-', 160,  90, 40, 40);
	CreateCalculatorButton(hwnd, '*', 160, 140, 40, 40);
	CreateCalculatorButton(hwnd, '/', 160, 190, 40, 40);

	// Create the Display Text Box
	hwndEditBox = CreateWindow(
		"Edit", "0",
		WS_VISIBLE | WS_CHILD,
		10, 10, 190,20,
		hwnd, (HMENU) IDE_TEXT,
		GetModuleHandle(NULL), NULL);
	
	//SEt the memory buffer to 0
	strcpy(g_Memory, "0");
}

void CreateCalculatorButton(HWND hwnd, char command, int x, int y, int nWidth, int nHeight)
{
	char caption[2] = { command, '\0' };
	CreateWindow("Button", caption,
		WS_CHILD|WS_VISIBLE|BS_PUSHBUTTON,
		x, y, nWidth, nHeight,
		hwnd, (HMENU)command,
		GetModuleHandle(NULL), NULL);
}


void SetDisplayText(char* text)
{
	SendMessage(hwndEditBox, WM_SETTEXT, 0, (LPARAM)text);
}

void ProcessButtonClick(char command)
{
	PiggybackCalcCommand(command);

	//Was a Number Button Clicked?
	if (command >= '0' && command <= '9')
	{
		//Should the Display be cleared out?
		if (g_DoClear)
		{
			SetDisplayText("0");
			g_DoClear = FALSE;
		}

		//Get current text and text of number pressed
		char currentText[15]; SendMessage(
			hwndEditBox, WM_GETTEXT, 
			sizeof(currentText), (LPARAM)(void*)currentText);
		char numText[2] = { command, '\0' };

		//New Text is a concatenation (unless "0")
		char* newText =
			strcmp(currentText, "0") 
				? strcat(currentText, numText)
				: numText;

		//Set the new  text
		SetDisplayText(newText);

	}
	else if (command == 'C')
	{
		//Clear Memory, Operator, and Text
		SetDisplayText("0");
		g_Operator = '~';
		strcpy(g_Memory, "0");

		//PiggybackCalcCommand(0x7f);  // doesn't work??
		ClearPiggybackCalc();
	}
	else 
	{
		//Get current text 
		char currentText[15]; SendMessage(
			hwndEditBox, WM_GETTEXT, 
			sizeof(currentText), (LPARAM)(void*)currentText);

		//Get ops
		float op1 = atof(g_Memory);
		float op2 = atof(currentText);

		//get answer/Error indicator
		int isErr = 0;
		float ans = DoOperation(g_Operator, op1, op2, &isErr);

		//Display Answer
		char newText[15] = "0";
		if (isErr == 1)
		{
			SetDisplayText("Err");
		}
		else
		{
			sprintf(newText, "%g", ans);
			SetDisplayText(newText);
		}

		//Set
		g_DoClear = TRUE;
		strcpy(g_Memory, newText);
		g_Operator = command;
	}

}
