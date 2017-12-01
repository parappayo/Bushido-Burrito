
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
	LazySingletonTest* test = LazySingletonTest::get();
	assert(test);
	return 0;
}
