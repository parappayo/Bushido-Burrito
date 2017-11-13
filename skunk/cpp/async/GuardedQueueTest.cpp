#include <assert.h>
#include <iostream>
#include <thread>

#include "GuardedQueue.h"

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
	cout << "running dataContentsTest" << endl;

	TestData testData123(123);
	TestData testData456(456);

	GuardedQueue<TestData> guardedQueue;
	assert(guardedQueue.size() == 0);

	guardedQueue.push(testData123);
	assert(guardedQueue.size() == 1);

	guardedQueue.push(testData456);
	assert(guardedQueue.size() == 2);

	TestData next = guardedQueue.front();
	assert(next.value() == 123);

	guardedQueue.pop();
	assert(guardedQueue.size() == 1);

	next = guardedQueue.front();
	assert(next.value() == 456);

	guardedQueue.pop();
	assert(guardedQueue.size() == 0);
}

int main(int argc, char* argv[])
{
	dataContentsTest();

	return 0;
}
