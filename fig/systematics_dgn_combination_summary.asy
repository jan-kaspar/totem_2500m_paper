import root;
import pad_layout;
import style;

xSizeDef = 6.8cm;
ySizeDef = 5cm;

string topDir = "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/beta2500/2rp/";

include "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/beta2500/2rp/plots/systematics/common_code.asy";

string f = topDir + "systematics/matrix.root";

string binning = "ob-2-10-0.05";

string objects[] = {
//	"input/45b_56t/<binning>",
//	"input/45t_56b/<binning>",
	"combined/<binning>/combination0",
	"combined/<binning>/combination1",
};

string object_labels[] = {
//	"45b-56t",
//	"45t-56b",
	"dgn. combination",
	"2nd dgn. combination",
};

real z_t_mins[], z_t_maxs[], z_t_Steps[], z_t_steps[], z_e_maxs[], z_e_Steps[], z_e_steps[];
z_t_mins.push(6e-4); z_t_maxs.push(0.004); z_t_Steps.push(0.001); z_t_steps.push(0.0002); z_e_maxs.push(0.02); z_e_Steps.push(0.005); z_e_steps.push(0.001);
z_t_mins.push(0e-4);z_t_maxs.push(0.2); z_t_Steps.push(0.05); z_t_steps.push(0.01); z_e_maxs.push(0.02); z_e_Steps.push(0.005); z_e_steps.push(0.001);
//z_t_maxs.push(1.0); z_t_Steps.push(0.2); z_t_steps.push(0.1); z_e_maxs.push(0.04); z_e_Steps.push(0.01); z_e_steps.push(0.005);

TH1_x_min = 8.01e-4;

//----------------------------------------------------------------------------------------------------

void AddLeadingModes()
{
	AddMode("$\theta_y^*$ shift, L-R sym., T-B corr.", red,
		"", "sh-thy", 1,
		"", "sh-thy", 1
	);

	AddMode("$\theta_{x,y}^*$ scaling, mode 3", blue,
		"", "sc-thxy-mode3", 1,
		"", "sc-thxy-mode3", 1
	);
	
	AddMode("uncert.~of vert.~beam diverg.", heavygreen,
		"", "dy-sigma", 1,
		"", "dy-sigma", 1
	);
	
	AddMode("uncert.~of beam momentum", cyan,
		"", "beam-mom", 1,
		"", "beam-mom", 1
	);
}

AddLeadingModes();

//----------------------------------------------------------------------------------------------------

void PlotAllModes()
{
	int ci = 0;

	for (int mi : modes.keys)
	{
		for (int oi : objects.keys)
		{
			string pth = "contributions/" + modes[mi].mc_tag + "/" + replace(objects[oi], "<binning>", binning);
			RootObject obj = RootGetObject(f, pth, error=false);
			if (obj.valid)
			{
				draw(scale(1, 100), obj, "vl,d0", modes[mi].p, modes[mi].label);
				++ci;
			}
		}
	}

	pen p_envelope = black + 0.7pt;
	draw(scale(1, +100), RootGetObject(f, "matrices/all-but-norm/"+binning+"/h_stddev"), "vl", p_envelope);
	draw(scale(1, -100), RootGetObject(f, "matrices/all-but-norm/"+binning+"/h_stddev"), "vl", p_envelope);
	AddToLegend("$\pm 1\un{\si}$ envelope", p_envelope);
}


//----------------------------------------------------------------------------------------------------

for (int zi : z_t_maxs.keys)
{
	NewPad("$|t|\ung{GeV^2}$", "systematic effect$\ung{\%}$");

	PlotAllModes();

	real t_Step = z_t_Steps[zi];
	real t_step = z_t_steps[zi];
	real e_Step = z_e_Steps[zi] * 100;
	real e_step = z_e_steps[zi] * 100;

	real t_min = z_t_mins[zi];
	real t_max = z_t_maxs[zi];
	real e_min = -z_e_maxs[zi] * 100;
	real e_max = z_e_maxs[zi] * 100;

	currentpad.xTicks = LeftTicks(t_Step, t_step);
	currentpad.yTicks = RightTicks(e_Step, e_step);

	limits((t_min, -e_max), (t_max, e_max), Crop);

	xaxis(YEquals(0, false), dashed);
	//yaxis(XEquals(8e-4, false), dashed);

	if (zi == 0)
		AttachLegend(BuildLegend(lineLength=5mm, NE, vSkip=-1.1mm, ymargin=0.2mm), NE);
}

GShipout(hSkip=5mm, margin=0mm);
