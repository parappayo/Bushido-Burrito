#include <assert.h>
#include <iostream>
#include <thread>

#include "GuardedObject.h"

using namespace std;
using namespace BushidoBurrito;

class TestData
{
private:
	int _value;

public:
	TestData(int value)
		: _value(value)
	{}

	int value() const { return _value; }
};

void dataContentsTest()
{
	TestData testData123(123);
	TestData testData456(456);

	GuardedObject<TestData> guardedTestData(testData123);
	assert(testData123.value() == 123);

	guardedTestData.set(testData456);
	assert(testData123.value() == 123);
	assert(testData456.value() == 456);
}

int main(int argc, char* argv[])
{
	dataContentsTest();

	return 0;
}
