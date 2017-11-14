
#include "BufferPool.h"

#include <assert.h>
#include <cstring>

using namespace std;

namespace BushidoBurrito
{
	BufferPool::BufferPool(size_t bufferSize, size_t poolSize)
		: _bufferSize(bufferSize)
		, _maxPoolSize(poolSize)
	{
		for (size_t i = 0; i < poolSize; i++) {
			_bufferQueue.push(malloc(bufferSize));
		}
	}

	BufferPool::~BufferPool()
	{
		while (!_bufferQueue.empty()) {
			free(_bufferQueue.pop());
		}
	}

	void* BufferPool::getBuffer()
	{
		assert(_bufferQueue.size() > 0);
		return _bufferQueue.pop();
	}

	void BufferPool::releaseBuffer(void* buffer)
	{
		assert(_bufferQueue.size() < _maxPoolSize);
		_bufferQueue.push(buffer);
	}
}
