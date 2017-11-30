import root;
import pad_layout;
import style;

xSizeDef = 6.5cm;
ySizeDef = 4.8cm;

string topDir = "/home/jkaspar/publications/elastic figures/";

string f = topDir + "/compete/distributions.root";

string models[];
int m_groups[];

models.push("Model_RPdPL2_20"); m_groups.push(10);
models.push("Model_RPdPL2u_17"); m_groups.push(10);
models.push("Model_RPdPL2u_19"); m_groups.push(10);
models.push("Model_RPdPqcL2u_16"); m_groups.push(10);
models.push("Model_RqcRcL2qc_12"); m_groups.push(20);
models.push("Model_RqcRcLqc_12"); m_groups.push(30);
models.push("Model_RqcRLqc_14"); m_groups.push(30);
models.push("Model_RRcdPL2u_15"); m_groups.push(10);
models.push("Model_RRcdPqcL2u_14"); m_groups.push(10);
models.push("Model_RRcL2qc_15"); m_groups.push(20);
models.push("Model_RRcLqc_15"); m_groups.push(30);
models.push("Model_RRcPL_19"); m_groups.push(30);
models.push("Model_RRL_18"); m_groups.push(30);
models.push("Model_RRL_19"); m_groups.push(30);
models.push("Model_RRL2_18"); m_groups.push(20);
models.push("Model_RRL2qc_17"); m_groups.push(20);
models.push("Model_RRLqc_17"); m_groups.push(30);
models.push("Model_RRPEu_19"); m_groups.push(11);
models.push("Model_RRPL_21"); m_groups.push(30);
models.push("Model_RRPL2_20"); m_groups.push(30);
models.push("Model_RRPL2qc_18"); m_groups.push(30);
models.push("Model_RRPL2u_19"); m_groups.push(10);
models.push("Model_RRPL2u_21"); m_groups.push(10);

legendLabelPen = fontcommand("\SetFontSizesVIII");

drawGridDef = false;

//----------------------------------------------------------------------------------------------------

pen GroupPen(int g)
{
	if (g == 10) return blue;
	if (g == 11) return blue+dashed;
	if (g == 20) return magenta;
	if (g == 30) return heavygreen;

	return black;
}

string GetModelsByGroup(int g, int ga = g)
{
	string l;
	for (int mi : models.keys)
	{
		if (m_groups[mi] == g || m_groups[mi] == ga)
		{
			string m = replace(substr(models[mi], 6), "_", "\_");

			if (length(l) != 0)
				l += ", ";
			l += m;
		}
	}

	return l;
}

//----------------------------------------------------------------------------------------------------

void DrawAll(string obj)
{
	for (int mi : models.keys)
	{
		draw(RootGetObject(f, models[mi] + "/" + obj), GroupPen(m_groups[mi]), replace(models[mi], "_", "\_"));
	}
}

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

DrawAll("g_si_p_p");

// TOTEM measurements
real fshu = 0.02;

fsh = +0fshu; DrawPoint(2.76e3, 84.7, 3.3, red, mCi+2pt+red);

fsh = -1.0fshu; DrawPoint(7e3, 98.0, 2.5, red, mCi+2pt+red);
fsh = +1.0fshu; DrawPoint(7e3, 98.6, 2.2, red, mCi+2pt+red);

fsh = -1.0fshu; DrawPoint(8e3, 101.5, 2.1, red, mCi+2pt+red);
fsh = +1.0fshu; DrawPoint(8e3, 102.9, 2.3, red, mCi+2pt+red);

fsh = -1fshu; DrawPoint(13e3, 110.6, 3.4, red, mCi+2pt+red);
fsh = +1fshu; DrawPoint(13e3, 112.1, 3.0, red, mCi+2pt+red);

limits((1e2, 35), (2e4, 120), Crop);

DrawAxes(47);


//----------------------------------------------------------------------------------------------------

NewPad("$\sqrt s\ung{GeV}$", "$\rh$");
currentpad.drawGridY = true;
currentpad.yTicks = RightTicks(0.01, 0.005);
scale(Log, Linear);

DrawAll("g_rho_p_p");

// TOTEM measurements
DrawPoint(8e3, 0.12, 0.03, red+0.8pt, mCi+true+2pt+red);

fsh = -1fshu; DrawPoint(13e3, 0.102, 0.012, red+0.8pt, mCi+true+2pt+red);
fsh = +1fshu; DrawPoint(13e3, 0.088, 0.010, red+0.8pt, mCi+true+2pt+red);

limits((1e2, 0.05), (2e4, 0.16), Crop);

DrawAxes(0.065);


//----------------------------------------------------------------------------------------------------

NewPad(false);

//AddToLegend("reference TOTEM measurements", red, mCi+2pt+red);

//AddToLegend("<COMPETE models:");

AddToLegend(GetModelsByGroup(10), GroupPen(10));
AddToLegend(GetModelsByGroup(11), GroupPen(11));
AddToLegend(GetModelsByGroup(20), GroupPen(20));
AddToLegend(GetModelsByGroup(30), GroupPen(30));

AttachLegend(BuildLegend(SE, vSkip=-1mm));
FixPad(310, 75);

GShipout(margin=1mm, hSkip=3mm);
