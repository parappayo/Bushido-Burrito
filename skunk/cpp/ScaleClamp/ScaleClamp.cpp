
// build with
//   clang-cl -Wall ScaleClamp.cpp -o ScaleClamp.exe

#include <iostream>
#include <cassert>

template<typename T> inline T min(T a, T b)
{
	return a < b ? a : b;
}

template<typename T> inline T max(T a, T b)
{
	return b < a ? a : b;
}

template<typename T> inline T clamp(T value, T min_value, T max_value)
{
	assert(min_value <= max_value);
	return max(min(value, max_value), min_value);
}

// adapted from Chevy Ray's version seen on Twitter
// https://twitter.com/Sosowski/status/841973849503719424
template<typename T> T scaleClamp(T value, T min1, T max1, T min2, T max2)
{
	const T delta1 = max1 - min1;
	const T delta2 = max2 - min2;

	value = min2 + ((value - min1) / delta1) * delta2;

	if (max2 > min2)
	{
		return clamp<T>(value, min2, max2);
	}

	return clamp<T>(value, max2, min2);
}

template<typename T> class Range
{
public:
	T start;
	T end;

	Range(T start_value, T end_value)
		: start(start_value)
		, end(end_value)
	{}

	T delta() const { return end - start; }
	T normalize(T value) const { return (value - start) / delta(); }

	T projection(T value, Range<T> range) const
	{
		return start + range.normalize(value) * delta();
	}

	T clamp(T value) const
	{
		return (start < end) ? ::clamp(value, start, end) : ::clamp(value, end, start);
	}
};

template<typename T> T scaleClamp(T value, const Range<T>& source, const Range<T>& target)
{
	return target.clamp(target.projection(value, source));
}

int main()
{
	float floatResult = scaleClamp(5.0f, 1.0f, 12.0f, 7.0f, 20.0f);
	std::cout << "floatResult = " << floatResult << std::endl;

	floatResult = scaleClamp(5.0f, Range<float>(1.0f, 12.0f), Range<float>(7.0f, 20.0f));
	std::cout << "floatResult = " << floatResult << std::endl;

	double doubleResult = scaleClamp(5.0, 1.0, 12.0, 7.0, 20.0);
	std::cout << "doubleResult = " << doubleResult << std::endl;

	doubleResult = scaleClamp(5.0, Range<double>(1.0, 12.0), Range<double>(7.0, 20.0));
	std::cout << "doubleResult = " << doubleResult << std::endl;

	int intResult = scaleClamp(5, 1, 12, 7, 20);
	std::cout << "intResult = " << intResult << std::endl;

	intResult = scaleClamp(5, Range<int>(1, 12), Range<int>(7, 20));
	std::cout << "intResult = " << intResult << std::endl;

	char charResult = scaleClamp<char>(5, 1, 12, 7, 20);
	std::cout << "charResult = " << (int)charResult << std::endl;

	charResult = scaleClamp((char)5, Range<char>(1, 12), Range<char>(7, 20));
	std::cout << "charResult = " << (int)charResult << std::endl;

	return 0;
}
