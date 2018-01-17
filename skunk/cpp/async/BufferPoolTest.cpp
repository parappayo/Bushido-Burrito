#include <assert.h>
#include <iostream>
#include <thread>

#include "BufferPool.h"

using namespace std;
using namespace BushidoBurrito;

void populateTestData(char* buffer, size_t size)
{
	for (size_t i = 0; i < size; i++) {
		buffer[i] = (char) i % 256;
	}
}

bool hasTestDataChanged(char* buffer, size_t size)
{
	for (size_t i = 0; i < size; i++) {
		if (buffer[i] != (char) i % 256) {
			return true;
		}
	}
	return false;
}

bool areContentsEqual(char* buffer1, char* buffer2, size_t size)
{
	for (size_t i = 0; i < size; i++) {
		if (buffer1[i] != buffer2[i]) {
			return false;
		}
	}
	return true;
}

void bufferContentsTest()
{
	cout << "running bufferContentsTest" << endl;

	size_t bufferSize = 1024;
	BufferPool pool(bufferSize, 5);
	assert(pool.size() == 5);

	char* buffer1 = (char*) pool.getBuffer();
	char* buffer2 = (char*) pool.getBuffer();
	assert(buffer1 != buffer2);
	assert(pool.size() == 3);

	populateTestData(buffer1, bufferSize);
	populateTestData(buffer2, bufferSize);
	assert(!hasTestDataChanged(buffer1, bufferSize));

	pool.releaseBuffer((void*) buffer1);
	pool.releaseBuffer((void*) buffer2);
	assert(pool.size() == 5);
}

void bufferTooSmallTest()
{
	size_t bufferSize = 1024;
	BufferPool pool(bufferSize, 2);
	assert(pool.size() == 2);

	char* buffer1 = (char*) pool.getBuffer();
	char* buffer2 = (char*) pool.getBuffer();
	char* buffer3 = (char*) pool.getBuffer();

	pool.releaseBuffer((void*) buffer1);
	pool.releaseBuffer((void*) buffer2);
	pool.releaseBuffer((void*) buffer3);
}

int main(int argc, char* argv[])
{
	bufferContentsTest();

	// bufferTooSmallTest();

	return 0;
}
