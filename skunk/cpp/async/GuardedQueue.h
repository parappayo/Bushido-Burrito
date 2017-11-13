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

		void pop()
		{
			lock_guard<mutex> lock(_mutex);
			_queue.pop();
		}

		T front()
		{
			lock_guard<mutex> lock(_mutex);
			return _queue.front();
		}

		T back()
		{
			lock_guard<mutex> lock(_mutex);
			return _queue.back();
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
