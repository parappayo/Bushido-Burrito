
#pragma once

using namespace std;

namespace BushidoBurrito
{
	template <class T>
	class Singleton
	{
	private:
		static T _instance;

	public:
		static T* get()
		{
			return &_instance;
		}
	};

	template <class T>
	T Singleton<T>::_instance;
}
