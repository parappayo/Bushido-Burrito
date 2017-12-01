
#include "LazySingleton.h"

#include <assert.h>
#include <iostream>

using namespace std;
using namespace BushidoBurrito;

class LazySingletonTest : public LazySingleton<LazySingletonTest>
{
public:
	LazySingletonTest()
	{
		cout << "LazySingletonTest object constructed" << endl;
	}

	~LazySingletonTest()
	{
		cout << "LazySingletonTest object deleted"  << endl;
	}
};

int main(int argc, char* argv[])
{
	cout << "before first get" << endl;
	LazySingletonTest* test = LazySingletonTest::get();
	assert(test);
	cout << "after first get" << endl;
	return 0;
}
