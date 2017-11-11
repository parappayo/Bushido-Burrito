
#include <assert.h>
#include <iostream>

#include "GuardedBuffer.h"

using namespace std;
using namespace BushidoBurrito;

void assertContentsAreEqual(char* buffer1, char* buffer2, size_t size)
{
	for (size_t i = 0; i < size; i++) {
		assert(buffer1[i] == buffer2[i]);
	}
}

void bufferContentsTest()
{
	size_t size = 1024;
	GuardedBuffer buffer(size);
	char* testData = (char*) malloc(size);

	for (size_t i = 0; i < size; i++) {
		testData[i] = (char) i % 256;
	}

	buffer.set(testData, size);

	for (size_t i = 0; i < size; i++) {
		assert(testData[i] == (char) i % 256);
	}

	char* copy = (char*) buffer.copy();
	assertContentsAreEqual(testData, copy, size);

	buffer.get(testData, size);
	assertContentsAreEqual(testData, copy, size);

	free(copy);
	free(testData);
}

void inequalBufferTest()
{
	GuardedBuffer buffer1(1024);
	GuardedBuffer buffer2(512);
	buffer1.set(buffer2); // fails with assert
}

int main(int argc, char* argv[])
{
	bufferContentsTest();

	//inequalBufferTest();

	return 0;
}
