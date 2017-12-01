#include "TMath.h"

#include <vector>
#include <string>

using namespace std;

struct Entry
{
	double meas;
	double meas_unc;

	vector<double> bands;
};


int main()
{
	vector<string> bands = {
		"blue",
		"magenta",
		"green"
	};

	vector<Entry> entries = {
		{ 84.7, 3.3, {83.5, 81.2, 79.5} },			// si_tot, 2.76 TeV	

		{ 98.0, 2.5, {99.0, 94.0, 90.5} },			// si_tot, 7 TeV
		//{ 98.6, 2.2, {99.0, 94.0, 90.5} },			// si_tot, 7 TeV

		{ 101.5, 2.1, {101.5, 96.0, 92.0} },		// si_tot, 8 TeV
		//{ 102.9, 2.3, {101.5, 96.0, 92.0} },		// si_tot, 8 TeV, CNI separated

		{ 110.6, 3.4, {110.5, 103.2, 98.0} },		// si_tot, 13 TeV
		//{ 112.1, 3.0, {110.5, 103.2, 98.0} },		// si_tot, 13 TeV, CNI separated

		//{ 0.12, 0.03, {0.142, 0.120, 0.103} },		// rho, 8 TeV

		/*
		{ 0.088, 0.010, {0.137, 0.116, 0.098} },		// rho, 13 TeV
		*/
	};

	for (unsigned int bi = 0; bi < bands.size(); bi++)
	{
		printf("* %s\n", bands[bi].c_str());

		unsigned int N = 0;
		double S2 = 0;

		for (const auto &e : entries)
		{
			N++;

			const double rd = (e.bands[bi] - e.meas) / e.meas_unc;
			S2 += rd*rd;
		}

		printf("    N = %u, S2 = %.3f, S2 / N = %.3f\n", N, S2, S2 / N);
		printf("    prob = %.3E\n", TMath::Prob(S2, N));
	}

	return 0;
}
