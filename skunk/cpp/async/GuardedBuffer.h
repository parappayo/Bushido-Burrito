#pragma once

#include <mutex>

#include "Noncopyable.h"

using namespace std;

namespace BushidoBurrito
{
	class GuardedBuffer : public Noncopyable
	{
	private:
		void* _buffer;
		size_t _size;
		mutex _mutex;

	public:
		GuardedBuffer(size_t size);
		~GuardedBuffer();

		size_t size() const { return _size; }

		void set(void* source, size_t size);
		void get(void* dest, size_t size);
		void* copy();

		bool trySet(void* source, size_t size);
		bool tryGet(void* dest, size_t size);
		void* tryCopy();

		void set(GuardedBuffer& source);
		void get(GuardedBuffer& dest);
	};
}
