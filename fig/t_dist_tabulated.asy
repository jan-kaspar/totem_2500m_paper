import root;
import pad_layout;
import style;

xSizeDef = 15.8cm;
ySizeDef = 7cm;

string topDir = "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/beta2500/2rp/";

string f = topDir + "tabulation/tabulate.root";

drawGridDef = true;

//----------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------

/*
	TGraph *g_b_left = new TGraph();
	TGraph *g_b_right = new TGraph();
	TGraph *g_rep_mean = new TGraph();
	TGraph *g_v = new TGraph();
	TGraph *g_v_unc_stat = new TGraph();
	TGraph *g_v_unc_syst_all = new TGraph();
	TGraph *g_v_unc_syst_all_anal = new TGraph();
*/

void PlotEverything(pen p_data = black + 0.8pt)
{
	pen p_data = black + squarecap;
	pen p_unc_all_but_norm = heavygreen + squarecap;
	pen p_unc_all = yellow+opacity(0.5) + squarecap;

	RootObject g_b_left = RootGetObject(f, "g_b_left");
	RootObject g_b_right = RootGetObject(f, "g_b_right");
	RootObject g_b_rep_mean = RootGetObject(f, "g_b_rep_mean");
	RootObject g_v = RootGetObject(f, "g_v");
	RootObject g_v_ref = RootGetObject(f, "g_v_ref");
	RootObject g_v_unc_stat = RootGetObject(f, "g_v_unc_stat");
	RootObject g_v_unc_syst_all = RootGetObject(f, "g_v_unc_syst_all");
	RootObject g_v_unc_syst_all_anal = RootGetObject(f, "g_v_unc_syst_all_anal");

	int n = g_b_left.iExec("GetN");

	for (int i = 0; i < n; ++i)
	{
		real ax[] = {0};
		real ay[] = {0};

		g_b_left.vExec("GetPoint", i, ax, ay); real b_left = ay[0];
		g_b_right.vExec("GetPoint", i, ax, ay); real b_right = ay[0];
		g_b_rep_mean.vExec("GetPoint", i, ax, ay); real b_rep_mean = ay[0];
		g_v.vExec("GetPoint", i, ax, ay); real v = ay[0];
		g_v_ref.vExec("GetPoint", i, ax, ay); real v_ref = ay[0];
		g_v_unc_stat.vExec("GetPoint", i, ax, ay); real v_unc_stat = ay[0];
		g_v_unc_syst_all.vExec("GetPoint", i, ax, ay); real v_unc_syst_all = ay[0];
		g_v_unc_syst_all_anal.vExec("GetPoint", i, ax, ay); real v_unc_syst_all_anal = ay[0];

		real v_cen = v;
		//real v_cen = v_ref;

		path box = Scale((b_left, v_cen-v_unc_syst_all))--Scale((b_right, v_cen-v_unc_syst_all))
			--Scale((b_right, v_cen+v_unc_syst_all))--Scale((b_left, v_cen+v_unc_syst_all))--cycle;
		filldraw(box, p_unc_all, nullpen);

		path box = Scale((b_left, v_cen-v_unc_syst_all_anal))--Scale((b_right, v_cen-v_unc_syst_all_anal))
			--Scale((b_right, v_cen+v_unc_syst_all_anal))--Scale((b_left, v_cen+v_unc_syst_all_anal))--cycle;
		filldraw(box, p_unc_all_but_norm, nullpen);

		draw(Scale((b_left, v))--Scale((b_right, v)), p_data);
		draw(Scale((b_rep_mean, v - v_unc_stat))--Scale((b_rep_mean, v + v_unc_stat)), p_data);
	}

	AddToLegend("data with statistical uncertainties", mPl+4pt+p_data);

	AddToLegend("<systematic uncertainties:");
	AddToLegend("all", mSq+6pt+p_unc_all);
	AddToLegend("all except normalisation", mSq+6pt+p_unc_all_but_norm);
}

//----------------------------------------------------------------------------------------------------

picture inset = new picture;
currentpicture = inset;

unitsize(5000mm, 0.072mm);

PlotEverything(black + 0.5pt);

currentpad.xTicks = LeftTicks(0.002, 0.001);
limits((0, 450), (0.01, 950), Crop);

xaxis(BottomTop, LeftTicks(0.005, 0.001).GetTicks());
yaxis(LeftRight, RightTicks(100., 20.).GetTicks());

//----------------------------------------------------------------------------------------------------

NewPad("$|t|\ung{GeV^2}$", "$\d\si/\d t\ung{mb/GeV^2}$");
scale(Linear, Log);

attach(bbox(inset, 1mm, nullpen, FillDraw(white)), (0.129, 0.95));

PlotEverything();

currentpad.xTicks = LeftTicks(0.02, 0.01);
limits((0, 1e1), (0.2, 1e3), Crop);

AttachLegend(shift(5, 5)*BuildLegend(lineLength=5mm, ymargin=0mm, SW), SW);

GShipout(margin=0mm);
