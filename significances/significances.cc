#include "TMath.h"

#include <vector>
#include <string>

using namespace std;

//----------------------------------------------------------------------------------------------------

struct Entry
{
	string tag;

	double meas;
	double meas_unc;

	vector<double> bands;
};

//----------------------------------------------------------------------------------------------------

void CopyEntries(const vector<Entry> &src, const string &tag, vector<Entry> &dest)
{
	for (const auto &e : src)
	{
		if (e.tag == tag)
			dest.push_back(e);
	}
}

//----------------------------------------------------------------------------------------------------

void Evaluate(const vector<Entry> &entries, const vector<string> bands)
{
	printf("* entries: %lu\n", entries.size());

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
}

//----------------------------------------------------------------------------------------------------

int main()
{
	vector<string> bands = {
		"blue",
		"magenta",
		"green"
	};

	vector<Entry> entries = {
		{ "si_tot, 2.76TeV", 84.7, 3.3, {83.5, 81.2, 79.5} },

		{ "si_tot, 7TeV, 1", 98.0, 2.5, {99.0, 94.0, 90.5} },
		{ "si_tot, 7TeV, 2", 98.6, 2.2, {99.0, 94.0, 90.5} },

		{ "si_tot, 8TeV, 1", 101.5, 2.1, {101.5, 96.0, 92.0} },
		{ "si_tot, 8TeV, 2", 102.9, 2.3, {101.5, 96.0, 92.0} },

		{ "si_tot, 13TeV, 1", 110.6, 3.4, {110.5, 103.2, 98.0} },
		//{ "si_tot, 13TeV, 2", 112.1, 3.0, {110.5, 103.2, 98.0} },

		{ "rho, 8TeV", 0.12, 0.03, {0.142, 0.120, 0.103} },

		{ "rho, 13TeV, exp1", 0.08, 0.01, {0.137, 0.116, 0.098} },
	};

	printf("\n----- si_tot, all points -----\n");
	vector<Entry> e_si_tot_all;
	CopyEntries(entries, "si_tot, 2.76TeV", e_si_tot_all);
	CopyEntries(entries, "si_tot, 7TeV, 1", e_si_tot_all);
	CopyEntries(entries, "si_tot, 7TeV, 2", e_si_tot_all);
	CopyEntries(entries, "si_tot, 8TeV, 1", e_si_tot_all);
	CopyEntries(entries, "si_tot, 8TeV, 2", e_si_tot_all);
	CopyEntries(entries, "si_tot, 13TeV, 1", e_si_tot_all);
	Evaluate(e_si_tot_all, bands);

	printf("\n----- si_tot, 1 point per energy -----\n");
	vector<Entry> e_si_tot_sel;
	CopyEntries(entries, "si_tot, 2.76TeV", e_si_tot_sel);
	CopyEntries(entries, "si_tot, 7TeV, 1", e_si_tot_sel);
	CopyEntries(entries, "si_tot, 8TeV, 1", e_si_tot_sel);
	CopyEntries(entries, "si_tot, 13TeV, 1", e_si_tot_sel);
	Evaluate(e_si_tot_sel, bands);

	printf("\n----- rho, 13TeV, exp1 -----\n");
	vector<Entry> e_rho_sel;
	CopyEntries(entries, "rho, 13TeV, exp1", e_rho_sel);
	Evaluate(e_rho_sel, bands);

	return 0;
}
