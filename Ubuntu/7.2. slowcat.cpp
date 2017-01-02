#include <iostream>
#include <thread>
#include <chrono>
#include <string>

using namespace std;

int main(int argc, char **argv)
{
	int SleepTime = 10;
	int BlockSize = 10;
	if (argc > 1)
	{
		SleepTime = stoi(argv[1]);
	}
	if (argc > 2)
	{
		BlockSize = stoi(argv[2]);
	}

	char * buffer = new char[BlockSize];

	while (!cin.eof())
	{
		cin.read(buffer, BlockSize);
		//cin.getline(buffer, BlockSize, 27);
		int n = cin.gcount();
		//buffer[n - 1] = 27;
		cout.write(buffer, n);
		this_thread::sleep_for(chrono::milliseconds(SleepTime));
	}

	return 0;
}
