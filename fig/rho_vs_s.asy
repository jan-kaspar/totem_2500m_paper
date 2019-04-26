import root;
import pad_layout;
import style;

include "/home/jkaspar/publications/elastic figures/common_code.asy";

string topDir = "/home/jkaspar/publications/elastic figures/";
string base_dir = "/home/jkaspar/publications/elastic figures/pdg/";

fit_file = topDir + "build_uncertainty_bands.root";

xSizeDef = 12cm;
ySizeDef = 5.5cm;

drawGridDef = false;

//----------------------------------------------------------------------------------------------------

real p2W(real p)
{
	real m = 0.938270; // GeV
	real E = sqrt(m*m + p*p);
	return sqrt(2*m*(m + E));
}

//----------------------------------------------------------------------------------------------------

struct Meas
{
	real p, p_min, p_max;
	real si, si_ep, si_em;
	string ref;
}

//----------------------------------------------------------------------------------------------------

int LoadFile(string fn, Meas data[])
{
	file f = input(fn, false);
	if (error(f))
		return 1;

	while (!eof(f))
	{
		string line = f;

		string[] bits = split(line);
		if (bits.length < 10)
			continue;

		Meas m;
		m.p = (real) bits[1];		// GeV
		m.p_min = (real) bits[2];
		m.p_max = (real) bits[3];

		m.si = (real) bits[4];		// mb
		real si_sep = (real) bits[5];
		real si_sem = (real) bits[6];
		real si_srep = (real) bits[7];	// %
		real si_srem = (real) bits[8];

		m.ref = bits[9] + " " + bits[10] + ";";
		for (int i = 11; i < bits.length; ++i)
			m.ref += " " + bits[i];

		m.si_ep = sqrt(si_sep^2 + (m.si*si_srep/100)^2);
		m.si_em = sqrt(si_sem^2 + (m.si*si_srem/100)^2);

		data.push(m);
	}

	return 0;
}

//----------------------------------------------------------------------------------------------------

void PlotRho(string f, pen col, mark m)
{
	Meas data_rho[];
	LoadFile(base_dir + f, data_rho);

	for (int pi : data_rho.keys)
	{
		//write(data_rho[pi].si);

		real W = p2W(data_rho[pi].p);
		real W_min = p2W(data_rho[pi].p_min);
		real W_max = p2W(data_rho[pi].p_max);

		real rho = data_rho[pi].si;
		real rho_ep = data_rho[pi].si_ep;
		real rho_em = data_rho[pi].si_em;

		draw(Scale((W_min, rho))--Scale((W_max, rho)), col);
		draw(Scale((W, rho-rho_em))--Scale((W, rho+rho_ep)), col);
		draw(Scale((W, rho)), m+col);

		//label(rotate(90)*Label("{\SetFontSizesVI " + data_rho[pi].ref + "}"), Scale((W_min, rho)), N, col);
	}
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------

NewPad("$\sqrt s\ung{GeV}$", "$\rh$");
currentpad.yTicks=RightTicks(0.05, 0.01);
currentpad.drawGridY = true;
scale(Log, Linear);

// PDG data
PlotRho("pbarp_elastic_reim.dat", heavygreen, mTU+2pt+false);
PlotRho("pp_elastic_reim.dat", blue, mTD+2pt+true);

// TOTEM measurements

// 7 TeV
DrawPoint(7e3, 0.145, 0.091, red+0.8pt, mTL+false+2.5pt+red);

// 8 TeV
DrawPoint(8e3, 0.12, 0.03, red+0.8pt, mCi+true+2pt+red);

// 13 TeV
fsh = -0.02; DrawPoint(13e3, 0.10, 0.01, red+0.8pt, mTU+true+2.5pt+red);	// exp3
fsh = +0.02; DrawPoint(13e3, 0.09, 0.01, red+0.8pt, mTD+true+2.5pt+red);	// exp1

// fits
DrawFitUncBand("rho_p_ap", heavygreen+opacity(0.1));
DrawFit("rho_p_ap", heavygreen);
DrawFitUncBand("rho_p_p", blue+opacity(0.1));
DrawFit("rho_p_p", blue);

//AddToLegend("<COMPETE model $\rm R^{qc}RL^{qc}$:");
//draw(graph(rho_app_compete_R_qc_RL_qc, 1e1, 2e4), black, "$\rm\overline pp$");
//draw(graph(rho_pp_compete_R_qc_RL_qc, 1e1, 2e4), red, "$\rm pp$");

// limits
limits((1e1, -0.2), (1e5, +0.25), Crop);

// axes
yaxis(XEquals(0.546e3, false), dotted + roundcap);
yaxis(XEquals(0.9e3, false), dotted + roundcap);
yaxis(XEquals(1.8e3, false), dotted + roundcap);
yaxis(XEquals(2.76e3, false), dotted + roundcap);
yaxis(XEquals(7e3, false), dotted + roundcap);
yaxis(XEquals(8e3, false), dotted + roundcap);
yaxis(XEquals(13e3, false), dotted + roundcap);

real y_label = 0.;
label(rotate(90)*Label("\SmallerFonts$0.546\un{TeV}$"), Scale((0.546e3, y_label)), Fill(white));
label(rotate(90)*Label("\SmallerFonts$0.9\un{TeV}$"), Scale((0.9e3, y_label)), Fill(white));
label(rotate(90)*Label("\SmallerFonts$1.8\un{TeV}$"), Scale((1.8e3, y_label)), Fill(white));
label(rotate(90)*Label("\SmallerFonts$2.76\un{TeV}$"), Scale((2.76e3, y_label)), Fill(white));
label(rotate(90)*Label("\SmallerFonts$7\un{TeV}$"), Scale((7e3-300, y_label)), Fill(white));
label(rotate(90)*Label("\SmallerFonts$8\un{TeV}$"), Scale((8e3+300, y_label)), Fill(white));
label(rotate(90)*Label("\SmallerFonts$13\un{TeV}$"), Scale((13e3, y_label)), Fill(white));

// legend
AddToLegend("<PDG:");
AddToLegend("$\rm \overline pp$", mTU+false+2.5pt+heavygreen);
AddToLegend("$\rm pp$", mTD+true+2.5pt+blue);
//AddToLegend("\break");

AddToLegend("<TOTEM:");
AddToLegend("indirect", mTL+false+2.5pt+red);
AddToLegend("via CNI", MarkerArray(mCi+true+2pt+red, mTU+true+2.5pt+red, mTD+true+2.5pt+red, sep=2mm, shift=-1.9mm));
//AddToLegend("\break");

AddToLegend("<COMPETE");
AddToLegend("<(pre-LHC model $\rm RRP_{nf}L2_{u}$):");
AddToLegend("$\rm\overline pp$", heavygreen);
AddToLegend("$\rm pp$", blue);

AttachLegend(shift(0, 0)*BuildLegend(1, NW, stretch=false, hSkip=5mm, lineLength=8mm), NE);

GShipout(margin=0.5mm, hSkip=5mm);
