#pragma once

namespace BushidoBurrito
{
	class Noncopyable
	{
	protected:
		Noncopyable() {}
		~Noncopyable() {}

	private:
		Noncopyable(const Noncopyable&) = delete;
		Noncopyable& operator=(const Noncopyable) = delete;
	};
}
