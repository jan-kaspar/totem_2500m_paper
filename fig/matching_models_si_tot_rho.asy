import root;
import pad_layout;
import style;

string topDir = "/home/jkaspar/publications/elastic figures/nicolescu/";

xSizeDef = 6.6cm;
ySizeDef = 4.8cm;

drawGridDef = false;

pen p_Nico_2007 = blue + dashed, p_Nico_2017 = blue;
pen p_Durh = black, p_Durh_odd08 = magenta, p_Durh_odd13 = heavygreen;

//----------------------------------------------------------------------------------------------------

// fine shift
real fsh=0;

void DrawPoint(real W, real si, real em, real ep=em, pen col=red, marker m)
{
	col += squarecap;

	draw(shift(fsh, 0)*(Scale((W, si-em))--Scale((W, si+ep))), col);
	draw(shift(fsh, 0)*Scale((W, si)), m);

	// reset fine shift
	fsh = 0;
}

//----------------------------------------------------------------------------------------------------

void DrawAxes(real y_label)
{
	yaxis(XEquals(0.546e3, false), dotted + roundcap);
	yaxis(XEquals(0.9e3, false), dotted + roundcap);
	yaxis(XEquals(1.8e3, false), dotted + roundcap);
	yaxis(XEquals(2.76e3, false), dotted + roundcap);
	yaxis(XEquals(7e3, false), dotted + roundcap);
	yaxis(XEquals(8e3, false), dotted + roundcap);
	yaxis(XEquals(13e3, false), dotted + roundcap);

	label(rotate(90)*Label("\SmallerFonts$0.546\un{TeV}$"), Scale((0.546e3, y_label)), Fill(white));
	label(rotate(90)*Label("\SmallerFonts$0.9\un{TeV}$"), Scale((0.9e3, y_label)), Fill(white));
	label(rotate(90)*Label("\SmallerFonts$1.8\un{TeV}$"), Scale((1.8e3, y_label)), Fill(white));
	label(rotate(90)*Label("\SmallerFonts$2.76\un{TeV}$"), Scale((2.76e3, y_label)), Fill(white));
	label(rotate(90)*Label("\SmallerFonts$7\un{TeV}$"), Scale((7e3-300, y_label)), Fill(white));
	label(rotate(90)*Label("\SmallerFonts$8\un{TeV}$"), Scale((8e3+300, y_label)), Fill(white));
	label(rotate(90)*Label("\SmallerFonts$13\un{TeV}$"), Scale((13e3, y_label)), Fill(white));
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------

TGraph_x_max = 1.1e5;

NewPad("$\sqrt s\ung{GeV}$", "$\si_{\rm tot}\ung{mb}$");
currentpad.drawGridY = true;
currentpad.yTicks = RightTicks(10., 5.);
scale(Log, Linear);

// Nicolescu's 2017 paper
//draw(Scale((2.76e3, 83.66))--Scale((7e3, 98.76))--Scale((8e3, 101.09))--Scale((13e3, 109.92)), nullpen, m_Nico);
draw(RootGetObject(topDir + "model_2007.root", "g_si_tot_pp_vs_s"), p_Nico_2007);
draw(RootGetObject(topDir + "model_2017.root", "g_si_tot_pp_vs_s"), p_Nico_2017);

// Durham model, without Odderon
draw(
	Scale((0.546e3, 62.46))--Scale((1.8e3, 77.08))--Scale((2.76e3, 83.23))--Scale((7e3, 98.82))--Scale((8e3, 101.34))--Scale((13e3, 111.19))--Scale((100e3, 166.2))
	, p_Durh);

// TOTEM data
real fshu = 0.02;

fsh = +0fshu; DrawPoint(2.76e3, 84.7, 3.3, red, mCi+2pt+red);

fsh = -1.0fshu; DrawPoint(7e3, 98.0, 2.5, red, mCi+2pt+red);
fsh = +1.0fshu; DrawPoint(7e3, 98.6, 2.2, red, mCi+2pt+red);

fsh = -1.0fshu; DrawPoint(8e3, 101.5, 2.1, red, mCi+2pt+red);
fsh = +1.0fshu; DrawPoint(8e3, 102.9, 2.3, red, mCi+2pt+red);

fsh = 0fshu; DrawPoint(13e3, 110.5, 2.4, red, mCi+2pt+red);
//fsh = +1fshu; DrawPoint(13e3, 112.1, 3.0, red, mCi+2pt+red);

limits((1e2, 35), (2e4, 120), Crop);

DrawAxes(47);

//AddToLegend("ref.~TOTEM meas.", red, mCi+2pt+red);
AddToLegend("Nicolescu et al. (2007)", p_Nico_2007);
AddToLegend("Nicolescu et al. (2017)", p_Nico_2017);
AddToLegend("Durham, no 3g exch.", p_Durh);
AddToLegend("Durham, 3g exch.~$0.8\un{mb}$\hskip-1mm", p_Durh_odd08);
AddToLegend("Durham, 3g exch.~$1.3\un{mb}$\hskip-1mm", p_Durh_odd13);
AttachLegend(BuildLegend(NW, vSkip=-1mm, lineLength=4.5mm, ymargin=0mm), NW);


//----------------------------------------------------------------------------------------------------

NewPad("$\sqrt s\ung{GeV}$", "$\rh$");
currentpad.drawGridY = true;
currentpad.yTicks = RightTicks(0.01, 0.005);
scale(Log, Linear);

// Nicolescu's 2017 paper
draw(RootGetObject(topDir + "model_2007.root", "g_rho_pp_vs_s"), p_Nico_2007);
//draw(Scale((2.76e3, 0.123))--Scale((7e3, 0.109))--Scale((8e3, 0.106))--Scale((13e3, 0.0976)), nullpen, m_Nico);
draw(RootGetObject(topDir + "model_2017.root", "g_rho_pp_vs_s"), p_Nico_2017);

// Durham model
draw(Scale((0.546e3, 0.1277))--Scale((1.8e3, 0.1228))--Scale((2.76e3, 0.1209))--Scale((7e3, 0.1166))--Scale((8e3, 0.1159))
	--Scale((13e3, 0.1134))--Scale((100e3, 0.102)), p_Durh);

// Durham model, with Odderon from note
real si_tot_diff = 0.8;
draw(Scale((0.546e3, 0.1277 - si_tot_diff/62.46))
	--Scale((1.8e3, 0.1228 - si_tot_diff/77.08))
	--Scale((2.76e3, 0.1209 - si_tot_diff/83.23))
	--Scale((7e3, 0.1166 - si_tot_diff/98.82))
	--Scale((8e3, 0.1159 - si_tot_diff/101.34))
	--Scale((13e3, 0.1134 - si_tot_diff/111.19))
	--Scale((100e3, 0.102 - si_tot_diff/166.2))
		, p_Durh_odd08);

real si_tot_diff = 1.3;
draw(Scale((0.546e3, 0.1277 - si_tot_diff/62.46))
	--Scale((1.8e3, 0.1228 - si_tot_diff/77.08))
	--Scale((2.76e3, 0.1209 - si_tot_diff/83.23))
	--Scale((7e3, 0.1166 - si_tot_diff/98.82))
	--Scale((8e3, 0.1159 - si_tot_diff/101.34))
	--Scale((13e3, 0.1134 - si_tot_diff/111.19))
	--Scale((100e3, 0.102 - si_tot_diff/166.2))
		, p_Durh_odd13);

// TOTEM data
DrawPoint(8e3, 0.12, 0.03, red+0.8pt, mCi+true+2pt+red);

fsh = -1fshu; DrawPoint(13e3, 0.10, 0.01, red+0.8pt, mCi+true+2pt+red);
fsh = +1fshu; DrawPoint(13e3, 0.09, 0.01, red+0.8pt, mCi+true+2pt+red);

limits((1e2, 0.04), (2e4, 0.16), Crop);

DrawAxes(0.058);

AddToLegend("ref.~TOTEM meas.", red, mCi+2pt+red);
AttachLegend(BuildLegend(NE, vSkip=-1mm, lineLength=6mm, ymargin=0), NE);

//----------------------------------------------------------------------------------------------------

GShipout(margin=1mm, hSkip=3mm);
