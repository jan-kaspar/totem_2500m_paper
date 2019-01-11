import root;
import pad_layout;
import style;

xSizeDef = 5.5cm;
ySizeDef = 5.5cm;

string topDir = "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/beta2500/2rp/";

TH2_palette = Gradient(blue, heavygreen, yellow, red);

string dataset = "DS-fill5313";
string diagonal = "45b_56t";

int cuts[] = { 1, 2 };

real scale_x[] = { 1e6, 1e6, 1e6, 1e6, 1e0, 1e0, 1e6, 1e6 };
real scale_y[] = { 1e6, 1e6, 1e0, 1e0, 1e0, 1e0, 1e0, 1e0 };

string label_x[] = { "$\theta_x^{*\rm R}\ung{\mu rad}$", "$\theta_y^{*\rm R}\ung{\mu rad}$", "$\th_x^{*R}\ung{\mu rad}$", "$\th_x^{*L}\ung{\mu rad}$", "$y^{R,N}\ung{mm}$", "$y^{L,N}\ung{mm}$", "$\th_x^*\ung{\mu rad}$", "$\th_y^*\ung{\mu rad}$" };
string label_y[] = { "$\theta_x^{*\rm L}\ung{\mu rad}$", "$\theta_y^{*\rm L}\ung{\mu rad}$", "$x^{*R}\ung{mm}$", "$x^{*L}\ung{mm}$", "$y^{R,F} - y^{R,N}\ung{mm}$", "$y^{L,F} - y^{L,N}\ung{mm}$", "$\De^{R-L} x^*\ung{mm}$", "$\De^{R-L} y^*\ung{mm}$" };
string label_cut[] = { "$\De^{R-L} \theta_x^{*}\ung{\mu rad}$", "$\De^{R-L} \theta_y^{*}\ung{\mu rad}$", "$x^{*R}\ung{mm}$", "$x^{*L}\ung{mm}$", "$cq5$", "$cq6$", "$cq7$", "$cq8$" };

real lim_x_low[] = { -200, 0, -1000, -1000, -15, -15, -200, -600 };
real lim_x_high[] = { +200, 150, +1000, +1000, +15, +15, +200, +600 };

real lim_y_low[] = { -200, 0, -0.8, -0.8, -0.5, -0.5, -15, -4 };
real lim_y_high[] = { +200, 150, +0.8, +0.8, +0.5, +0.5, +5, +4 };

for (int ci : cuts.keys)
{
	int cut = cuts[ci];
	int idx = cut - 1;

	string f = topDir + dataset+"/distributions_" + diagonal + ".root";

	NewRow();
	
	NewPad(label_x[idx], label_y[idx]);
	scale(Linear, Linear, Log);
	string objC = format("elastic cuts/cut %i", cut) + format("/plot_before_cq%i", cut);
	draw(scale(scale_x[idx], scale_y[idx]), RootGetObject(f, objC+"#0"), "p,d0,bar");
	draw(scale(scale_x[idx], scale_y[idx]), RootGetObject(f, objC+"#1"));
	draw(scale(scale_x[idx], scale_y[idx]), RootGetObject(f, objC+"#2"));
	limits((lim_x_low[idx], lim_y_low[idx]), (lim_x_high[idx], lim_y_high[idx]), Crop);
	//limits((-lim_x_high[idx], -lim_y_high[idx]), (-lim_x_low[idx], -lim_y_low[idx]), Crop);

	AttachLegend(format("cut %u", cuts[ci]), NW, NW);
}

GShipout(margin=0mm, hSkip=5mm, vSkip=1mm);
