#pragma once

#include "GuardedQueue.h"
#include "Noncopyable.h"

using namespace std;

namespace BushidoBurrito
{
	class BufferPool : public Noncopyable
	{
	private:
		size_t _bufferSize;
		size_t _maxPoolSize;
		GuardedQueue<void*> _bufferQueue;

	public:
		BufferPool(size_t bufferSize, size_t poolSize);
		~BufferPool();

		void* getBuffer();
		void releaseBuffer(void* buffer);

		size_t size() { return _bufferQueue.size(); }
	};

	class AutoReleasePooledBuffer
	{
	private:
		void* _buffer;
		BufferPool& _pool;

	public:
		AutoReleasePooledBuffer(void* buffer, BufferPool& pool)
			: _buffer(buffer)
			, _pool(pool)
		{}

		~AutoReleasePooledBuffer()
		{
			_pool.releaseBuffer(this);
		}
	};
}
