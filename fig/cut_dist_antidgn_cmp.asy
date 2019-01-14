import root;
import pad_layout;
import style;

xSizeDef = 6.8cm;
ySizeDef = 5cm;

string topDir = "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/beta2500/2rp/";

string dataset = "DS-fill5314";

string diagonals[] = { "45b_56t", "anti_45b_56b", "anti_45t_56t" };
string dgn_labels[] = { "45 bot -- 56 top", "45 bot -- 56 bot", "45 top -- 56 top" };

//----------------------------------------------------------------------------------------------------


NewPad("$\theta_x^{*\rm R} - \theta_x^{*\rm L}\ung{\mu rad}$", "events per bin", xTicks=LeftTicks(50., 10.));
scale(Linear, Log(true));

AddToLegend("<no cuts:");

string dir = topDir+"background_studies/"+dataset+"/no_cuts";
draw(scale(1e6, 1), RootGetObject(dir + "/distributions_45b_56t.root", "elastic cuts/cut 1/h_cq1"), "vl", black, "45 bot -- 56 top");

AddToLegend("<cut 2:");

string dir = topDir+"background_studies/"+dataset+"/cuts:2";
draw(scale(1e6, 1), RootGetObject(dir + "/distributions_45b_56t.root", "elastic cuts/cut 1/h_cq1"), "vl", red, "45 bot -- 56 top");
draw(scale(1e6, 1), RootGetObject(dir + "/distributions_anti_45b_56b.root", "elastic cuts/cut 1/h_cq1"), "vl", blue, "45 bot -- 56 bot");
draw(scale(1e6, 1), RootGetObject(dir + "/distributions_anti_45t_56t.root", "elastic cuts/cut 1/h_cq1"), "vl", heavygreen, "45 top -- 56 top");

real n_si = 4;
real sigma = 14.;
yaxis(XEquals(-n_si * sigma, false), dashed);
yaxis(XEquals(+n_si * sigma, false), dashed);

xlimits(-150, +150, Crop);
AttachLegend(BuildLegend(NE, lineLength=5mm, vSkip=-1mm, ymargin=-0.2mm), NE);
