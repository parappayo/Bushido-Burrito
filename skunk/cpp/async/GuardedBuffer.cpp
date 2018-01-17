
#include "GuardedBuffer.h"

#include <assert.h>
#include <cstring>

using namespace std;

namespace BushidoBurrito
{
	GuardedBuffer::GuardedBuffer(size_t size)
		: _size(size)
	{
		_buffer = malloc(size);
		if (!_buffer) { _size = 0; }
	}

	GuardedBuffer::~GuardedBuffer()
	{
		lock_guard<mutex> lock(_mutex);
		if (_buffer) { free(_buffer); }
	}

	void GuardedBuffer::set(void* source, size_t size)
	{
		assert(size == _size);
		if (size != _size) { return; }

		lock_guard<mutex> lock(_mutex);
		memcpy(_buffer, source, _size);
	}

	void GuardedBuffer::get(void* dest, size_t size)
	{
		assert(size == _size);
		if (size != _size) { return; }

		lock_guard<mutex> lock(_mutex);
		memcpy(dest, _buffer, _size);
	}

	void* GuardedBuffer::copy()
	{
		if (_size < 1) { return nullptr; }
		void* result = malloc(_size);

		lock_guard<mutex> lock(_mutex);
		memcpy(result, _buffer, _size);
		return result;
	}

	bool GuardedBuffer::trySet(void* source, size_t size)
	{
		if (!_mutex.try_lock()) {
			return false;
		}

		set(source, size);
		_mutex.unlock();
		return true;
	}

	bool GuardedBuffer::tryGet(void* dest, size_t size)
	{
		if (!_mutex.try_lock()) {
			return false;
		}

		get(dest, size);
		_mutex.unlock();
		return true;
	}

	void* GuardedBuffer::tryCopy()
	{
		if (!_mutex.try_lock()) {
			return nullptr;
		}

		void* result = copy();
		_mutex.unlock();
		return result;
	}

	void GuardedBuffer::set(GuardedBuffer& source)
	{
		assert(source._size == _size);
		if (source._size != _size) { return; }

		lock_guard<mutex> lock(_mutex);
		lock_guard<mutex> sourceLock(source._mutex);
		memcpy(_buffer, source._buffer, _size);
	}

	void GuardedBuffer::get(GuardedBuffer& dest)
	{
		assert(dest._size == _size);
		if (dest._size != _size) { return; }

		lock_guard<mutex> lock(_mutex);
		lock_guard<mutex> destLock(dest._mutex);
		memcpy(dest._buffer, _buffer, _size);
	}
}
