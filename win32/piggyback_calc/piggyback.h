#ifndef PIGGYBACK_H
#define PIGGYBACK_H

#include <windows.h>

/** Call to start the piggyback calculator system. */
void InitPiggyback(void);

/** Call to clean up the piggyback calculator system. */
void FinPiggyback(void);

/** Returns the window handle of the piggyback calculator (assuming it exists). */
HWND FindPiggybackCalc(void);

/** Sends a command to the piggyback calculator (assuming it exists). */
void PiggybackCalcCommand(char command);

/** Retrieves a result from the piggyback calculator (assuming it exists). */
float GetPiggybackCalcResult(void);

/** Clears the screen of the piggyback calc (assuming it exists). */
void ClearPiggybackCalc(void);

#endif
