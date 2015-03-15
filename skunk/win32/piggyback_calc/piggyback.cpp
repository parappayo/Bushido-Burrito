#include "piggyback.h"

void InitPiggyback(void)
{
	if (FindPiggybackCalc() == NULL) {
		ShellExecute(NULL, "open", "C:\\WINDOWS\\System32\\calc.exe", "", "c:\\WINDOWS\\System32", SW_SHOW);
	}
	Sleep(1000);
	if (FindPiggybackCalc() == NULL) {
		MessageBox(NULL, "Could not launch calculator back-end!", "Error", MB_OK);
	}
}

void FinPiggyback(void)
{
	HWND calc = FindPiggybackCalc();
	SendMessage(calc, WM_CLOSE, 0, 0);
}

HWND FindPiggybackCalc(void)
{
	HWND retval = FindWindow("SciCalc", "Calculator");
	if (retval == NULL) {
		retval = FindWindow("Calc", "Calculator");
	}
	return retval;
}

HWND FindPiggybackCalcEdit(void)
{
	HWND calc = FindPiggybackCalc();
	return FindWindowEx(calc, 0, "Edit", NULL);
}

void PiggybackCalcCommand(char command)
{
	HWND calc = FindPiggybackCalc();
	if (calc == NULL) {
		MessageBox(NULL, "Piggyback calculator not found", "Error", MB_OK);
	}

	PostMessage(calc, WM_CHAR, command, 0);
}

float GetPiggybackCalcResult(void)
{
	float retval = 0.0f;
	HWND calcEdit = FindPiggybackCalcEdit();
	if (calcEdit == NULL) {
		MessageBox(NULL, "Piggyback calculator not found", "Error", MB_OK);
	}

	long len = SendMessage(calcEdit, WM_GETTEXTLENGTH, 0, 0) + 1;
	char* temp = (char*) malloc(len);
	SendMessage(calcEdit, WM_GETTEXT, len, (LPARAM) temp);
	retval = atof(temp);
	free(temp);

	return retval;
}

void ClearPiggybackCalc(void)
{
	HWND calcEdit = FindPiggybackCalcEdit();
	if (calcEdit == NULL) {
		MessageBox(NULL, "Piggyback calculator not found", "Error", MB_OK);
	}

	PostMessage(calcEdit, WM_KEYDOWN, VK_DELETE, 0);
}
