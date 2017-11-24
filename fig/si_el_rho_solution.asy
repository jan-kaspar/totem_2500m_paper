import graph;
import pad_layout;
import style;

xSizeDef = 7cm;
ySizeDef = 5cm;

//----------------------------------------------------------------------------------------------------

real rho_0, si_el_0;

real rho_90(real si_el)
{
	real K = si_el_0 * (1. + rho_0 * rho_0);

	return sqrt(K/si_el - 1);
}

real rho_2500(real si_el)
{
	real S = -0.2;

	return rho_0 + S * (si_el / si_el_0 - 1.);
}

string MakeLabel()
{
	return format("$\rh^0 = %#.4f$, ", rho_0) + format("$\si_{\rm el}^0 = %#.3f\un{mb}$", si_el_0);
}

//----------------------------------------------------------------------------------------------------

NewPad("$\si_{\rm el}\ung{mb}$", "$\rh$");
currentpad.xTicks = LeftTicks(0.1, 0.02);

real si_el_min = 30.7;
real si_el_max = 31.3;

//--------------------

AddToLegend("constraint from this publ.", red, mTD+red+2pt);

real si_el_2500_1 = 31.0;
real rho_2500_1 = 0.09975;

real si_el_2500_2 = 31.1;
real rho_2500_2 = 0.09926;

real a_2500 = (rho_2500_2 - rho_2500_1) / (si_el_2500_2 - si_el_2500_1);
real b_2500 = rho_2500_2 - a_2500 * si_el_2500_2;

draw((si_el_min, a_2500*si_el_min + b_2500)--(si_el_max, a_2500*si_el_max + b_2500), red);

draw((si_el_2500_1, rho_2500_1), mTD+red+2pt);
draw((si_el_2500_2, rho_2500_2), mTD+red+2pt);

//--------------------

AddToLegend("constraint from 90m", blue, mTU+blue+2pt);

real rho_90_1 = 0.14;
real si_el_90_1 = 30.7437;
rho_0 = rho_90_1;
si_el_0 = si_el_90_1;
draw(graph(rho_90, si_el_min, si_el_max), blue);
draw((si_el_0, rho_0), mTU+blue+2pt);

real rho_90_2 = 0.10;
real si_el_90_2 = 31.0359;
rho_0 = rho_90_2;
si_el_0 = si_el_90_2;
draw(graph(rho_90, si_el_min, si_el_max), blue);
draw((si_el_0, rho_0), mTU+blue+2pt);


real de_si_el = 0.01;
real a_90 = (rho_90(si_el_90_2 + de_si_el) - rho_90(si_el_90_2 - de_si_el)) / 2 / de_si_el;
real b_90 = rho_90(si_el_90_2) - a_90 * si_el_90_2;

//draw((si_el_min, a_90*si_el_min + b_90)--(si_el_max, a_90*si_el_max + b_90), dashed);

//--------------------

real si_el_sol = - (b_2500 - b_90) / (a_2500 - a_90);
real rho_sol = a_2500 * si_el_sol + b_2500;

//real scale_factor = si_el_sol / 31.0359;
//real si_tot_sol = 110.5753 * scale_factor;
//real si_inel_sol = 79.5394 * scale_factor;

//string label_sol = format("$\rh = %#.4f$, ", rho_sol) + format("$\si_{\rm el} = %#.3f\un{mb}$", si_el_sol);
string label_sol = "consistent combination";
draw((si_el_sol, rho_sol), nullpen, label_sol, mCi+heavygreen+2pt);

//AddToLegend(format("$\si_{\rm tot} = %#.3f\un{mb}$", si_tot_sol));
//AddToLegend(format("$\si_{\rm inel} = %#.3f\un{mb}$", si_inel_sol));

limits((si_el_min, 0.08), (si_el_max, 0.145), Crop);
//limits((31.0, 0.09), (31.1, 0.10), Crop);

AttachLegend(NE, NE);
