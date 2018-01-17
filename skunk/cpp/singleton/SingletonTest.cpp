
#include "Singleton.h"

#include <iostream>

using namespace std;
using namespace BushidoBurrito;

class SingletonTest : public Singleton<SingletonTest>
{
public:
	SingletonTest()
	{
		cout << "SingletonTest object constructed" << endl;
	}

	~SingletonTest()
	{
		cout << "SingletonTest object deleted"  << endl;
	}

	void test()
	{
		cout << "instance works" << endl;
	}
};

int main(int argc, char* argv[])
{
	cout << "before first get" << endl;
	SingletonTest::get().test();
	cout << "after first get" << endl;
	return 0;
}
