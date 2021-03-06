import root;
import pad_layout;
import style;

xSizeDef = 13cm;
ySizeDef = 7cm;

string topDir = "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/beta2500/2rp/";

//string binning = "ob-1-20-0.05";
string binning = "ob-2-10-0.05";
//string binning = "ob-3-5-0.05";

string diagonal = "combined";

string fit_file = "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/combined/coulomb_analysis_1/default-plots/fits/2500-2rp-ob-2-10-0.05/exp1,t_max=0.07/fit.root";
string fit_obj = "g_fit_CH";

string unc_file = "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/beta2500/2rp/systematics/matrix.root";
string unc_types[], unc_labels[];
pen unc_pens[];
unc_types.push("all"); unc_pens.push(yellow+opacity(0.5)); unc_labels.push("all");
unc_types.push("all-but-norm"); unc_pens.push(heavygreen); unc_labels.push("all except normalisation");

drawGridDef = true;

TH1_x_min = 8.1e-4;

//----------------------------------------------------------------------------------------------------

void DrawUncBand(RootObject bc, RootObject relUnc, pen p)
{
	if (relUnc.InheritsFrom("TGraph"))
	{
		int N = bc.iExec("GetN");

		guide g_u, g_b;
		for (int i = 0; i < N; ++i)
		{
			real ta[] = {0.};
			real sa[] = {0.};

			bc.vExec("GetPoint", i, ta, sa);
			real ru = relUnc.rExec("Eval", ta);

			g_u = g_u -- Scale((ta[0], sa[0] * (1. + ru)));
			g_b = g_b -- Scale((ta[0], sa[0] * (1. - ru)));
		}

		g_b = reverse(g_b);
		filldraw(g_u--g_b--cycle, p, nullpen);
	}

	if (relUnc.InheritsFrom("TH1"))
	{
		for (int bi = 1; bi < relUnc.iExec("GetNbinsX"); ++bi)
		{
			real c = relUnc.rExec("GetBinCenter", bi);
			real w = relUnc.rExec("GetBinWidth", bi);
			real ru = relUnc.rExec("GetBinContent", bi);

			real v = bc.rExec("Eval", c);

			real t_min = c-w/2, t_max = c+w/2;
			real v_min = v*(1.-ru), v_max = v*(1.+ru);

			filldraw(Scale((t_min, v_min))--Scale((t_max, v_min))--Scale((t_max, v_max))--Scale((t_min, v_max))--cycle,
				p, nullpen);
		}
	}
}

//----------------------------------------------------------------------------------------------------

void PlotEverything(pen p_data = black + 0.8pt)
{
	AddToLegend("<systematic uncertainties:");
	for (int ui : unc_types.keys)
	{
		RootObject fit = RootGetObject(fit_file, fit_obj);
		RootObject relUnc = RootGetObject(unc_file, "matrices/" + unc_types[ui] + "/" + binning + "/h_stddev");
		DrawUncBand(fit, relUnc, unc_pens[ui]);
		AddToLegend(unc_labels[ui], mSq+6pt+unc_pens[ui]);
	}

	AddToLegend("<data with statistical uncertainties:");
	draw(RootGetObject(topDir+"DS-merged/merged.root", binning + "/merged/" + diagonal + "/h_dsdt"), "d0,eb", p_data + squarecap);
	AddToLegend("data", mPl+4pt+(black+0.8pt));
}

//----------------------------------------------------------------------------------------------------

picture inset = new picture;
currentpicture = inset;

unitsize(4500mm, 0.066mm);

PlotEverything(black + 0.5pt);

currentpad.xTicks = LeftTicks(0.002, 0.001);
limits((0, 450), (0.01, 950), Crop);

xaxis(BottomTop, LeftTicks(0.005, 0.001).GetTicks());
yaxis(LeftRight, RightTicks(100., 20.).GetTicks());

//----------------------------------------------------------------------------------------------------

NewPad("$|t|\ung{GeV^2}$", "$\d\si/\d t\ung{mb/GeV^2}$");
scale(Linear, Log);

attach(bbox(inset, 1mm, nullpen, FillDraw(white)), (0.123, 1.1));

PlotEverything();

currentpad.xTicks = LeftTicks(0.02, 0.01);
limits((0, 1e1), (0.2, 1e3), Crop);

AttachLegend(shift(5, 5)*BuildLegend(lineLength=5mm, ymargin=0mm, SW), SW);

GShipout(margin=0mm);
