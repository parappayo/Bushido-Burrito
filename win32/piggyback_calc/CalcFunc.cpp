#include "calcfunc.h"
#include "piggyback.h"

float DoOperation(char operation, float op1, float op2, int* isErr)
{
	return GetPiggybackCalcResult();

	switch (operation)
	{
	case '+':
		return DoAdd(op1, op2);
		break;
	case '-':
		return DoSub(op1, op2);
		break;	
	case '*':
		return DoMul(op1, op2);
		break;
	case '/':
		return DoDiv(op1, op2, isErr);
		break;
	}
	return op2;
}

float DoAdd(float op1, float op2)
{
	return op1 + op2;
}

float DoSub(float op1, float op2)
{
	return op1 - op2;
}

float DoMul(float op1, float op2)
{
	return op1 * op2;
}

float DoDiv(float op1, float op2, int *isErr)
{
	//TODO set isErr to One if op2 is zero, or Zero
	//TODO return the quotient of op1 and op2

	if (op2 == 0.0f) {
		*isErr = true;
		return 0.0f;
	}

	*isErr = false;
	return op1 / op2;
}





