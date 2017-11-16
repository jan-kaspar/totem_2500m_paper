import root;
import pad_layout;
import style;

xSizeDef = 4.8cm;
ySizeDef = 4.8cm;

string topDir = "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/beta2500/2rp/";

string datasets[];
datasets.push("DS-fill5314");

string diagonals[] = { "45b_56t", "45t_56b", "anti_45b_56b", "anti_45t_56t" };
string dgn_labels[] = { "45 bot -- 56 top", "45 top -- 56 bot", "45 bot -- 56 bot", "45 top -- 56 top" };
pen dgn_pens[] = { red, magenta, blue, heavygreen };

string cut_str = "cuts:1,2";

string binning = "ob-3-5-0.05";

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------

for (int dsi : datasets.keys)
{
	NewRow();

	string dataset = datasets[dsi];

	NewPad("$|t|\ung{GeV^2}$", "$\d N / \d t\ung{a.u.}$");
	scale(Log, Log);
	
	for (int dgni : diagonals.keys)
	{
		string f = topDir+"background_studies/"+datasets[dsi]+"/"+cut_str + "/distributions_"+diagonals[dgni]+".root";
		draw(RootGetObject(f, "acceptance correction/" + binning + "/h_t_after"), "d0,vl,eb", dgn_pens[dgni], dgn_labels[dgni]);
	}

	limits((8e-4, 1e2), (0.2, 1e8), Crop);
	AttachLegend(BuildLegend("cuts 1 and 2:", NW, lineLength=10mm), NE);
}
