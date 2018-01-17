
#include <assert.h>
#include <iostream>
#include <thread>

#include "GuardedBuffer.h"

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
	cout << "running: bufferContentsTest" << endl;

	size_t size = 1024;
	GuardedBuffer buffer(size);

	char* testData = (char*) malloc(size);
	populateTestData(testData, size);

	buffer.set(testData, size);

	assert(!hasTestDataChanged(testData, size));

	char* copy = (char*) buffer.copy();
	assert(areContentsEqual(testData, copy, size));

	buffer.get(testData, size);
	assert(areContentsEqual(testData, copy, size));

	free(copy);
	free(testData);
}

void slowProducer(GuardedBuffer* sharedBuffer, size_t size)
{
	chrono::milliseconds sleepInterval(20);

	char* testData = (char*) malloc(size);
	populateTestData(testData, size);

	for (int i = 0; i < 100; i++)
	{
		sharedBuffer->set(testData, size);
		this_thread::sleep_for(sleepInterval);
	}

	free(testData);
}

void fastConsumer(GuardedBuffer* sharedBuffer, size_t size)
{
	char* testData = (char*) malloc(size);

	for (int i = 0; i < 1000; i++)
	{
		sharedBuffer->get(testData, size);
		assert(!hasTestDataChanged(testData, size));
		this_thread::yield();
	}

	free(testData);
}

void slowProducerFastConsumerTest()
{
	cout << "running: slowProducerFastConsumerTest" << endl;

	size_t size = 1024;
	GuardedBuffer buffer(size);

	thread producerThread(slowProducer, &buffer, size);
	thread consumerThread(fastConsumer, &buffer, size);
	producerThread.join();
	consumerThread.join();
}

void inequalBufferTest()
{
	cout << "running: inequalBufferTest" << endl;

	GuardedBuffer buffer1(1024);
	GuardedBuffer buffer2(512);
	buffer1.set(buffer2); // fails with assert
}

int main(int argc, char* argv[])
{
	bufferContentsTest();

	slowProducerFastConsumerTest();

	//inequalBufferTest();

	return 0;
}
