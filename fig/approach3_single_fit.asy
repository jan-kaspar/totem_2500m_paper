import root;
import style;
import pad_layout;

string topDir = "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/combined/coulomb_analysis_1/";

TGraph_errorBar = None;
	
xSizeDef = 15.7cm;
ySizeDef = 6cm;

//----------------------------------------------------------------------------------------------------

string dir = topDir + "attempts/11_22/";

string f_step_f = dir + "app3_step_f/fits/2500-2rp-ob-2-10-0.05/exp1,t_max=0.05/fit.root";

RootObject data_ih = RootGetObject(f_step_f, "h_input_dataset_0");
RootObject data_unc_stat = RootGetObject(f_step_f, "g_data_coll_unc_stat");
RootObject data_unc_syst = RootGetObject(f_step_f, "g_data_coll_unc_syst");
RootObject data_unc_full = RootGetObject(f_step_f, "g_data_coll_unc_full");

RootObject fit_step_f = RootGetObject(f_step_f, "fit canvas|g_fit_CH");

TH1_x_max = 0.05;

TGraph_x_min = 5e-4;
TGraph_x_max = 0.052;

pen p_data = black + squarecap;
pen p_unc_all_but_norm = heavygreen + squarecap;
pen p_fit = red + 1.pt + squarecap;

NewPad("$|t|\ung{GeV^2}$", "$\d\sigma/\d t \ung{mb/GeV^2}$");
currentpad.xTicks = LeftTicks(0.005, 0.001);


draw(data_unc_syst, "p", p_unc_all_but_norm+squarecap+3pt);

//TGraph_x_min = 0.00725; TGraph_x_max = 0.0261;
draw(fit_step_f, "l", p_fit);

draw(data_ih, "eb", black+squarecap);

AddToLegend("data with statistical uncertainties", mPl + 4pt + p_data);
AddToLegend("systematic uncertainties (except normalisation)", mSq +6pt + p_unc_all_but_norm);
AddToLegend("fit", p_fit);

limits((0, 200), (0.05, 900), Crop);
AttachLegend();

GShipout(hSkip=3mm, vSkip=0mm);
