import root;
import pad_layout;
import style;

xSizeDef = 4.8cm;
ySizeDef = 4.8cm;

string topDir = "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/beta2500/2rp/";

string diagonals[] = { "45t_56b" };
string diagonal_labels[] = { "45t -- 56b" };

string models[] = {
	//"fit2-1",
	"fit2-2",
	"fit2-4",
};

string m_labels[] = { "parametrisation 1", "parametrisation 2" };

pen m_pens[] = { blue, red+dashed};

string dataset = "DS-fill5313";

TGraph_x_min = 8e-4;

//----------------------------------------------------------------------------------------------------

for (int dgni : diagonals.keys)
{
	NewPad("$|t|\ung{GeV^2}$", "mutiplicative correction");
	currentpad.xTicks = LeftTicks(0.005, 0.001);
	currentpad.yTicks = RightTicks(0.001, 0.0005);

	for (int mi : models.keys)
	{
		string f = topDir + dataset + "/unfolding_cf_ni_" + diagonals[dgni] + ".root";
		draw(RootGetObject(f, models[mi] + "/g_t_corr"), m_pens[mi], m_labels[mi]);
	}

	limits((0.0005, 0.995), (0.01, 1.001), Crop);

	yaxis(XEquals(8e-4, false), dashed);

	AttachLegend(E, E);
}

GShipout(margin=1mm);
