
#include "Singleton.h"

#include <assert.h>
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
};

int main(int argc, char* argv[])
{
	SingletonTest* test = SingletonTest::get();
	assert(test);
	return 0;
}
