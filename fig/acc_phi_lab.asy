import root;
import pad_layout;
import style;

xSizeDef = 5cm;
ySizeDef = 5cm;

string topDir = "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/beta2500/2rp/";

string dataSets[] = { "DS-fill5317" };

TH2_palette = Gradient(blue, heavygreen, yellow, red);

real thetas[] = { 50, 100, 150 };

//----------------------------------------------------------------------------------------------------

void DrawAcceptedArcs(real th, real sign, RootObject cut_l, RootObject cut_h)
{
	real dphi = 360. / 10000;
	bool inside = false;
	real phi_start;
	for (real p = 0; p < 180; p += dphi)
	{
		real phi = sign * p;

		real x = th * Cos(phi);
		real y = th * Sin(phi);

		real y_l = cut_l.rExec("Eval", x*1e-6)*1e6;
		real y_h = cut_h.rExec("Eval", x*1e-6)*1e6;

		bool p_in = (abs(y_l) < abs(y) && abs(y) < abs(y_h));

		if (!inside && p_in)
		{
			phi_start = phi;
			inside = true;
		}

		if (inside && !p_in)
		{
			inside = false;
			real phi_end = phi - dphi;
			draw(arc((0, 0), th, phi_start, phi_end), black+1pt);
		}
	}
}

//----------------------------------------------------------------------------------------------------

void DrawFullArc(real th)
{
	draw(scale(th)*unitcircle, dotted);
}

//----------------------------------------------------------------------------------------------------

for (int dsi : dataSets.keys)
{
	NewPad("$\theta_x^{*}\ung{\mu rad}$", "$\theta_y^{*}\ung{\mu rad}$");
	scale(Linear, Linear, Log);
	//TH2_zLabel = "(corrected) events per bin";
	//TH2_paletteBarWidth = 0.05;
	
	for (real th : thetas)
		DrawFullArc(th);

	// z scale
	TH2_z_min = 1;
	TH2_z_max = 1e4;

	// 45 bottom - 56 top
	string f = topDir+"/"+dataSets[dsi]+"/distributions_45b_56t.root";
	draw(scale(1e6, 1e6), RootGetObject(f, "acceptance correction/h_th_y_vs_th_x_after"), "def");

	RootObject cut_l = RootGetObject(f, "fiducial cuts/fc_G_l");
	draw(scale(1e6, 1e6), cut_l, "l", magenta+1pt);
	RootObject cut_h = RootGetObject(f, "fiducial cuts/fc_G_h");
	draw(scale(1e6, 1e6), cut_h, "l", red+1pt);

	for (real th : thetas)
		DrawAcceptedArcs(th, +1, cut_l, cut_h);
	
	// 45 top - 56 bottom
	string f = topDir+"/"+dataSets[dsi]+"/distributions_45t_56b.root";
	draw(scale(1e6, 1e6), RootGetObject(f, "acceptance correction/h_th_y_vs_th_x_after"), "p");

	RootObject cut_l = RootGetObject(f, "fiducial cuts/fc_G_l");
	draw(scale(1e6, 1e6), cut_l, "l", magenta+1pt);
	RootObject cut_h = RootGetObject(f, "fiducial cuts/fc_G_h");
	draw(scale(1e6, 1e6), cut_h, "l", red+1pt);

	for (real th : thetas)
		DrawAcceptedArcs(th, -1, cut_l, cut_h);

	label("\vbox{\hbox{detector}\hbox{edges}}", (-160, -130), SE, magenta, Fill(white));
	draw((-120, -135)--(-130, +4), magenta, EndArrow());
	draw((-120, -135)--(-110, -9), magenta, EndArrow());

	label("\vbox{\hbox{LHC}\hbox{apertures}}", (-140, 190), S, red, Fill(white));
	draw((-160, 130)--(-140, +100), red, EndArrow);
	draw((-160, 130)--(-190, -100), red, EndArrow);

	/*
	real o = 0.;
	label("$\theta^*\!=$", (50, 0), 0.5W, Fill(white+opacity(o)));
	label(rotate(-90)*Label("\SmallerFonts $\rm\mu rad$"), (165, 0), 0.5E, Fill(white+opacity(o)));
	for (real th : thetas)
		label(rotate(-90)*Label(format("\SmallerFonts $%.0f$", th)), (th, 0), 0.5E, Fill(white+opacity(o)));
	*/

	limits((-200, -200), (200, 200), Crop);
	//AttachLegend(dataSets[dsi]);
}

GShipout("acc_phi_lab", margin=0mm);
