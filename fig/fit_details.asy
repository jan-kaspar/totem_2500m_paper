import root;
import pad_layout;
import style;

ySizeDef = 4.5cm;

string topDir = "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/combined/coulomb_analysis_1/";

string it_dir = "F_C+H, iteration 2";

TGraph_errorBar = None;

//----------------------------------------------------------------------------------------------------

void PlotRelDiff(RootObject data, RootObject fit, pen p, marker m=nomarker)
{
	if (data.InheritsFrom("TGraph"))
	{
		int n_points = data.iExec("GetN");
		for (int i = 0; i < n_points; ++i)
		{
			real ax[] = {0.};
			real ay[] = {0.};
			data.vExec("GetPoint", i, ax, ay);
	
			real x = ax[0];
			real y = ay[0];
			real y_unc = data.rExec("GetErrorY", i);
	
			real y_fit = fit.rExec("Eval", x);
	
			real y_rel = (y - y_fit) / y_fit;
			real y_rel_unc = y_unc / y_fit;
	
			draw((x, y_rel), m);
			draw((x, y_rel-y_rel_unc)--(x, y_rel+y_rel_unc), p+squarecap);
		}
	}

	if (data.InheritsFrom("TH1"))
	{
		for (int bi = 1; bi <= data.iExec("GetNbinsX"); ++bi)
		{
			real x = data.rExec("GetBinCenter", bi);

			if (x < TH1_x_min || x > TH1_x_max)
				continue;

			real w = data.rExec("GetBinWidth", bi);
			real c = data.rExec("GetBinContent", bi);
			real u = data.rExec("GetBinError", bi);

			real y_fit = fit.rExec("Eval", x);
	
			real y_rel = (c - y_fit) / y_fit;
			real y_rel_unc = u / y_fit;
	
			//draw((x, y_rel), mCi+2pt+p);
			draw((x-w/2, y_rel)--(x+w/2, y_rel), p+squarecap);
			draw((x, y_rel-y_rel_unc)--(x, y_rel+y_rel_unc), p+squarecap);
		}
	}
}

//----------------------------------------------------------------------------------------------------

void MakeFitPlots(string f)
{
	xSizeDef = 4.5cm;

	RootObject data_ih = RootGetObject(f, "h_input_dataset_0");
	RootObject data_unc_stat = RootGetObject(f, "g_data_coll_unc_stat");
	RootObject data_unc_full = RootGetObject(f, "g_data_coll_unc_full");
	RootObject fit = RootGetObject(f, "fit canvas|g_fit_CH");

	//----------

	NewPad("$|t|\ung{GeV^2}$", "$\d\sigma/\d t \ung{mb/GeV^2}$");
	scale(Linear, Log);
	//currentpad.xTicks = LeftTicks(0.005, 0.001);

	draw(fit, "l", red+1pt);
	draw(data_ih, "eb", black);
	//draw(data_unc_full, "p", heavygreen+squarecap+3pt);
	//draw(data_unc_stat, "p", blue+squarecap, mCi+blue+1pt);

	limits((0, 1e-2), (1., 1e3), Crop);

	AttachLegend(NE, NE);

}

//----------------------------------------------------------------------------------------------------

void MakeComponentPlots(string f)
{
	xSizeDef = 6cm;

	NewPad("$|t|\ung{GeV^2}$", "$\d\sigma/\d t \ung{mb/GeV^2}$");
	currentpad.xTicks = LeftTicks(0.005, 0.001);

	AddToLegend("<{\it data}:");
	AddToLegend("$\be^*=2500\un{m}$");

	AddToLegend("<{\it fit components}:");

	draw(RootGetObject(f, "g_fit_C"), "l", blue+1pt, "Coulomb only");
	draw(RootGetObject(f, "g_fit_H"), "l", red+1pt, "hadronic only");
	draw(RootGetObject(f, "g_fit_CH"), "l", heavygreen+1pt, "Coulomb $\oplus$ hadronic");

	draw(RootGetObject(f, "g_input_data0"), "p", black+1pt, mCi+1pt);

	limits((0, 400), (0.02, 900), Crop);

	AttachLegend();
}

//----------------------------------------------------------------------------------------------------

void MakeRelativePlot(string f, real t_max)
{
	xSizeDef = 7.5cm;

	NewPad("$|t|\ung{GeV^2}$", "$\d\sigma/\d t - \hbox{ref}\over\hbox{ref}$");
	currentpad.xTicks = LeftTicks(0.05, 0.01);

	draw(RootGetObject(f, "fit canvas, relC|g_data_relC0"), "p", black, mCi+black+1pt);

	draw(RootGetObject(f, "fit canvas, relC|g_fit_H_relC"), "l", blue+1pt);
	draw(RootGetObject(f, "fit canvas, relC|g_fit_CH_relC"), "l", red+1pt);
	

	limits((0, -0.12), (t_max, 0.02), Crop);

	//AttachLegend();
}

//----------------------------------------------------------------------------------------------------

void PlotOne(string expn, string binning, string tmax, real t_max, string f_out)
{
	string f_in = topDir + "fits/2500-2rp-"+binning+"/"+expn+",t_max="+tmax+"/fit.root";

	write("* " + f_in);

	MakeRelativePlot(f_in, t_max);
	//MakeComponentPlots(f_in);
	MakeFitPlots(f_in);

	GShipout(f_out, margin=0.5mm, hSkip=3mm);
}

//----------------------------------------------------------------------------------------------------

string binning = "ob-2-10-0.05";

PlotOne("exp1", binning, "0.07", 0.07, "fit_details_exp1_0p07.pdf");

PlotOne("exp3", binning, "0.15", 0.15, "fit_details_exp3_0p15.pdf");
