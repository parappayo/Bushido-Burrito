
#pragma once

#include <assert.h>
#include <cstdlib>

using namespace std;

namespace BushidoBurrito
{
	template <class T>
	class LazySingleton
	{
	private:
		static T* _instance;

		static void create()
		{
			assert(!_instance);
			_instance = new T();
			std::atexit(destroy);
		}

		static void destroy()
		{
			if (!_instance) { return; }
			delete _instance;
			_instance = nullptr;
		}

	public:
		static T* get()
		{
			if (!_instance) { create(); }
			return _instance;
		}
	};

	template <class T>
	T* LazySingleton<T>::_instance = nullptr;
}
