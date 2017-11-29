import root;
import pad_layout;
import style;

xSizeDef = 6.3cm;
ySizeDef = 4.8cm;

string topDir = "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/beta2500/2rp/";
string topDir_2RP = topDir;
string topDir_4RP = "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/beta2500/4rp/";

string binning = "ob-3-5-0.05";

real x_min = 0;
real x_max = 0.02;
real y_min = 400;
real y_max = 900;

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------

NewPad("$|t|\ung{GeV^2}$", "$\d\si/\d t\ung{mb/GeV^2}$");
currentpad.xTicks = LeftTicks(0.005, 0.001);
currentpad.yTicks = RightTicks(100., 50.);

//string dataset = "DS-fill5321";
string dataset = "merged";

draw(RootGetObject(topDir+"/DS-merged/merged.root", binning + "/" + dataset + "/45b_56t/h_dsdt"), "d0,eb", red, "45 bottom -- 56 top");
draw(RootGetObject(topDir+"/DS-merged/merged.root", binning + "/" + dataset + "/45t_56b/h_dsdt"), "d0,eb", blue, "45 top -- 56 bottom");

limits((x_min, y_min), (x_max, y_max), Crop);
AttachLegend();

//----------------------------------------------------------------------------------------------------

NewPad("$|t|\ung{GeV^2}$", "$\d\si/\d t\ung{mb/GeV^2}$");
currentpad.xTicks = LeftTicks(0.005, 0.001);
currentpad.yTicks = RightTicks(100., 50.);

draw(RootGetObject(topDir_2RP+"/DS-merged/merged.root", binning + "/DS-firstParts/combined/h_dsdt"), "d0,eb", red, "after cleaning");
draw(RootGetObject(topDir_2RP+"/DS-merged/merged.root", binning + "/DS-lastParts/combined/h_dsdt"), "d0,eb", blue, "before cleaning");

limits((x_min, y_min), (x_max, y_max), Crop);
AttachLegend();

//----------------------------------------------------------------------------------------------------
NewRow();
//----------------------------------------------------------------------------------------------------

NewPad("$|t|\ung{GeV^2}$", "$\d\si/\d t\ung{mb/GeV^2}$");
currentpad.xTicks = LeftTicks(0.005, 0.001);
currentpad.yTicks = RightTicks(100., 50.);

draw(RootGetObject(topDir_2RP+"/DS-merged/merged.root", binning + "/merged/combined/h_dsdt"), "d0,eb", red, "``2RP'' analysis");

TH1_x_min = 1.28e-3;
draw(RootGetObject(topDir_4RP+"/DS-merged/merged.root", binning + "/merged/combined/h_dsdt"), "d0,eb", blue, "``4RP'' analysis");
TH1_x_min = -inf;

limits((x_min, y_min), (x_max, y_max), Crop);
AttachLegend();

//----------------------------------------------------------------------------------------------------

// TODO: 90 vs 2500m data comparison
NewPad("$|t|\ung{GeV^2}$", "$\d\si/\d t\ung{mb/GeV^2}$");
currentpad.xTicks = LeftTicks(0.005, 0.001);
currentpad.yTicks = RightTicks(100., 50.);

draw(RootGetObject(topDir_2RP+"/DS-merged/merged.root", binning + "/merged/combined/h_dsdt"), "d0,eb", red, "$\beta^* = 2500\un{m}$");


limits((x_min, y_min), (x_max, y_max), Crop);
AttachLegend();

//----------------------------------------------------------------------------------------------------


GShipout(hSkip=1mm, vSkip=1mm, margin=0mm);
