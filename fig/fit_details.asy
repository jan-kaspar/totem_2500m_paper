import root;
import pad_layout;
import style;

ySizeDef = 4.5cm;

string topDir = "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/combined/coulomb_analysis_1/";

string it_dir = "F_C+H, iteration 2";

string unc_file = "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/beta2500/2rp/systematics/matrix.root";
string unc_types[], unc_labels[];
pen unc_pens[];
unc_types.push("all"); unc_pens.push(yellow+opacity(0.5)); unc_labels.push("full syst.~unc.~band");
unc_types.push("all-but-norm"); unc_pens.push(heavygreen); unc_labels.push("syst.~unc.~without normalisation");

TGraph_errorBar = None;

string ref_label = "\hbox{ref} = 633 \e^{-20.4\,|t|} + {\d\sigma^{\rm C}\over\d t}";

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
		guide g_u, g_b;

		for (int bi = 1; bi < relUnc.iExec("GetNbinsX"); ++bi)
		{
			real c = relUnc.rExec("GetBinCenter", bi);
			real w = relUnc.rExec("GetBinWidth", bi);
			real ru = relUnc.rExec("GetBinContent", bi);

			real v = bc.rExec("Eval", c);

			g_u = g_u -- Scale((c-w/2, v*(1.+ru))) -- Scale((c+w/2, v*(1.+ru)));
			g_b = g_b -- Scale((c-w/2, v*(1.-ru))) -- Scale((c+w/2, v*(1.-ru)));

			//g_u = g_u -- Scale((c, v*(1.+ru)));
			//g_b = g_b -- Scale((c, v*(1.-ru)));
		}

		g_b = reverse(g_b);
		filldraw(g_u--g_b--cycle, p, nullpen);
	}
}

//----------------------------------------------------------------------------------------------------

void DrawRelUncBand(RootObject bc, RootObject relUnc, RootObject ref, pen p)
{
	if (relUnc.InheritsFrom("TH1"))
	{
		guide g_u, g_b;

		for (int bi = 1; bi < relUnc.iExec("GetNbinsX"); ++bi)
		{
			real c = relUnc.rExec("GetBinCenter", bi);
			real w = relUnc.rExec("GetBinWidth", bi);
			real rel_unc = relUnc.rExec("GetBinContent", bi);

			if (c > TH1_x_max)
				break;

			real band_cen = bc.rExec("Eval", c);
			real y_ref = ref.rExec("Eval", c);

			real y_up = band_cen * (1. + rel_unc) / y_ref - 1.;
			real y_dw = band_cen * (1. - rel_unc) / y_ref - 1.;

			g_u = g_u -- Scale((c-w/2, y_up)) -- Scale((c+w/2, y_up));
			g_b = g_b -- Scale((c-w/2, y_dw)) -- Scale((c+w/2, y_dw));
		}

		g_b = reverse(g_b);
		filldraw(g_u--g_b--cycle, p, nullpen);
	}
}

//----------------------------------------------------------------------------------------------------

void MakeRelativePlot(string f, string binning, real t_max)
{
	TGraph_x_max = t_max * 1.1;
	TH1_x_max = t_max * 1.1;

	xSizeDef = 7.5cm;

	NewPad("$|t|\ung{GeV^2}$", "${\d\sigma/\d t - \hbox{ref}\over\hbox{ref}}\ ,\quad " + ref_label + "$");
	currentpad.xTicks = LeftTicks(0.05, 0.01);
	currentpad.yTicks = RightTicks(0.05, 0.01);

	RootObject fit = RootGetObject(f, "g_fit_CH");
	RootObject ref = RootGetObject(f, "g_refC");

	for (int ui : unc_types.keys)
	{
		RootObject relUnc = RootGetObject(unc_file, "matrices/" + unc_types[ui] + "/" + binning + "/h_stddev");

		DrawRelUncBand(fit, relUnc, ref, unc_pens[ui]);
		AddToLegend(unc_labels[ui], mSq+6pt+unc_pens[ui]);
	}

	draw(RootGetObject(f, "fit canvas, relC|g_fit_H_relC"), "l", blue+1pt, "fit, hadronic component only");
	draw(RootGetObject(f, "fit canvas, relC|g_fit_CH_relC"), "l", red+1pt, "fit, all components");

	draw(RootGetObject(f, "fit canvas, relC|g_data_relC0"), "p", black, mCi+black+1pt, "data with stat.~unc.");	

	limits((0, -0.15), (t_max, 0.05), Crop);

	AttachLegend(shift(0, 10)*BuildLegend(SE, vSkip=-1mm), SE);
}

//----------------------------------------------------------------------------------------------------

void MakeFitPlots(string f, string binning)
{
	xSizeDef = 4.5cm;

	RootObject data_ih = RootGetObject(f, "h_input_dataset_0");
	//RootObject data_unc_stat = RootGetObject(f, "g_data_coll_unc_stat");
	//RootObject data_unc_full = RootGetObject(f, "g_data_coll_unc_full");
	RootObject fit = RootGetObject(f, "fit canvas|g_fit_CH");

	NewPad("$|t|\ung{GeV^2}$", "$\d\sigma/\d t \ung{mb/GeV^2}$");
	scale(Linear, Log);
	//currentpad.xTicks = LeftTicks(0.005, 0.001);

	for (int ui : unc_types.keys)
	{
		RootObject relUnc = RootGetObject(unc_file, "matrices/" + unc_types[ui] + "/" + binning + "/h_stddev");
		DrawUncBand(fit, relUnc, unc_pens[ui]);
		//AddToLegend(unc_labels[ui], mSq+6pt+unc_pens[ui]);
	}

	draw(fit, "l", red+1pt);
	draw(data_ih, "eb", black);
	//draw(data_unc_full, "p", heavygreen+squarecap+3pt);
	//draw(data_unc_stat, "p", blue+squarecap, mCi+blue+1pt);

	limits((0, 1e-2), (1., 1e3), Crop);

	AttachLegend(NE, NE);
}

//----------------------------------------------------------------------------------------------------

void PlotOne(string expn, string binning, string tmax, real t_max, string f_out)
{
	string f_in = topDir + "fits/2500-2rp-"+binning+"/"+expn+",t_max="+tmax+"/fit.root";

	write("* " + f_in);

	MakeRelativePlot(f_in, binning, t_max);
	//MakeComponentPlots(f_in);
	//MakeFitPlots(f_in, binning);

	GShipout(f_out, margin=0.5mm, hSkip=3mm);
}

//----------------------------------------------------------------------------------------------------

string binning = "ob-2-10-0.05";

PlotOne("exp1", binning, "0.07", 0.07, "fit_details_exp1_0p07.pdf");

PlotOne("exp3", binning, "0.15", 0.15, "fit_details_exp3_0p15.pdf");
