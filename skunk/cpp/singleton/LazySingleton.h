
#pragma once

#include "Noncopyable.h"

using namespace std;

namespace BushidoBurrito
{
	template <class T>
	class LazySingleton : public Noncopyable
	{
	public:
		static T* get()
		{
			static T instance;
			return &instance;
		}
	};
}
