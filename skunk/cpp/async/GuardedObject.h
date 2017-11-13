#pragma once

#include <mutex>

using namespace std;

namespace BushidoBurrito
{
	template <typename T>
	class GuardedObject
	{
	private:
		T _object;
		mutex _mutex;

	public:
		GuardedObject(T& objectRef)
			: _object(objectRef)
		{}

		~GuardedObject()
		{
			lock_guard<mutex> lock(_mutex);
		}

		void set(const T& objectRef)
		{
			lock_guard<mutex> lock(_mutex);
			_object = objectRef;
		}

		T get()
		{
			lock_guard<mutex> lock(_mutex);
			return _object;
		}
	};
}
