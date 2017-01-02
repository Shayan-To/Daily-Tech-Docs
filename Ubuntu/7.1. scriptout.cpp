#include <iostream>
#include <fstream>
#include <thread>
#include <chrono>
#include <string>
#include <algorithm>

using namespace std;

int main(int argc, char **argv)
{
	if (argc != 3 && argc != 4)
	{
		cerr << "Invalid arguments.\nUsage: scriptout file timing [speed_multiplier]\n";
		exit(1);
	}
	
	ifstream input(argv[1]);
	ifstream timing(argv[2]);
	
	double multiplier = 1;
	if (argc > 3)
	{
		multiplier = stod(argv[3]);
	}
	
	const int buffer_size = 2;
	char buffer[buffer_size];

	while (true)
	{
		double wait;
		int count;
		timing >> wait;
		if (timing.eof())
		{
			break;
		}
		timing >> count;
		
		this_thread::sleep_for(chrono::milliseconds(int(wait * 1000 / multiplier)));
		
		while (count != 0)
		{
			if (input.eof())
			{
				cerr << "Invalid timing file.\n";
				exit(1);
			}

			input.read(buffer, min(count, buffer_size));
			int n = input.gcount();
			count -= n;
			cout.write(buffer, n);
			cout.flush();
		}
	}
	
	return 0;
}
