#pragma once

#include <mutex>
#include <queue>

using namespace std;

namespace BushidoBurrito
{
	template <typename T>
	class GuardedQueue
	{
	private:
		mutex _mutex;
		queue<T> _queue;

	public:
		void push(const T& item)
		{
			lock_guard<mutex> lock(_mutex);
			_queue.push(item);
		}

		T pop()
		{
			lock_guard<mutex> lock(_mutex);
			T result = _queue.front();
			_queue.pop();
			return result;
		}

		bool empty()
		{
			lock_guard<mutex> lock(_mutex);
			return _queue.empty();
		}

		size_t size()
		{
			lock_guard<mutex> lock(_mutex);
			return _queue.size();
		}
	};
}
