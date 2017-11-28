import root;
import pad_layout;
import style;

include "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/beta2500/alignment/plots/run_info.asy";

string topDir = "/afs/cern.ch/work/j/jkaspar/analyses/elastic/6500GeV/beta2500/common/rates/";

xSizeDef = 14.5cm;
ySizeDef = 4.5cm;

TGraph_errorBar = None;

xTicksDef = LeftTicks(1., 0.2);


//----------------------------------------------------------------------------------------------------

string fills[], runs[][];

/*
fills.push("5313");
runs.push(new string[] {
	"10190",
	//"10191",
	"10192",
	//"10193",
	"10194",
	//"10195",
	"10196",
	//"10197",
	"10198",
	//"10199",
	"10200",
	//"10201",
	"10202",
	//"10203",
	"10204",
	//"10205",
	"10206",
});

fills.push("5314");
runs.push(new string[] {
	"10208",
	"10209",
	"10210",
	//"10211",
	"10212",
	//"10213",
	"10214",
	//"10215",
	"10216",
	//"10217",
	"10218",
	//"10219",
	"10220",
	//"10221",
	"10222",
	//"10223",
	"10224",
});

fills.push("5317.1");
runs.push(new string[] {
	"10225",
	//"10226",
	"10227",
	//"10228",
	"10229",
	//"10230",
	"10231",
	//"10232",
	"10233",
	"10234",
	//"10235",
	"10236",
	//"10237",
	"10238",
	//"10239",
	"10240",
	//"10241",
	"10242",
	"10243",
	//"10244",
	"10245",
	//"10246",	// too few events for a rate estimate
	"10248",
	"10249",
	"10250",
	//"10251",
	"10252",
	//"10253",
	"10254",
	//"10255",
});


fills.push("5317.2");
runs.push(new string[] {
	"10256",
	//"10257",
	"10258",
	//"10259",
	"10260",
	//"10261",
	"10262",
	//"10263",
	"10264",
	//"10265",
	"10266",
	//"10267",
	"10268",
	//"10269",
	"10270",
	//"10271",
	"10272",
});
*/

fills.push("5321");
runs.push(new string[] {
	//"10279",
	//"10280",	// problem, but cleaning
	"10281",
	//"10282",	// problem, but cleaning
	"10283",
	//"10284",	// problem, but cleaning
	"10285",
	"10286",
	//"10287",
	"10288",
	"10289",
	//"10291",	// TODO: problem
	"10292",
	"10293",
	"10294",
	"10295",
	//"10296",
	"10297",
	"10298",
	"10299",
	//"10300",
	"10301",
	"10302",
	"10303",
	//"10304",
	"10305",
});

//----------------------------------------------------------------------------------------------------

string objs[], obj_labels[];
pen obj_pens[];
//objs.push("rp_5.track"); obj_labels.push("45-210-fr-bt, single track"); obj_pens.push(black);
objs.push("rp_5.unresolved"); obj_labels.push("45-210-fr-bt, unresolved activity"); obj_pens.push(red);
objs.push("dgn_45b_56t"); obj_labels.push("diagonal 45 bot - 56 top, 4x single track"); obj_pens.push(blue);
objs.push("dgn_45t_56b"); obj_labels.push("diagonal 45 top - 56 bot, 4x single track"); obj_pens.push(heavygreen);

//----------------------------------------------------------------------------------------------------

void SetPadWidth()
{
	real timespan = currentpicture.userMax2().x - currentpicture.userMin2().x;
	currentpad.xSize = timespan / 1 * 3.2cm;
}

//----------------------------------------------------------------------------------------------------

for (int fi : fills.keys)
{
	NewRow();

	//NewPad(false);
	label("{\SetFontSizesXX fill " + fills[fi] + "}");

	NewPad("time from 20 September 2016, 0:00 $\ung{h}$", "rate $\ung{Hz}$");
	real y_min = 0, y_max = 50;

	DrawRunBands(fills[fi], y_min, y_max, false);

	for (int ri : runs[fi].keys)
	{
		string f = topDir + "data/run_"+runs[fi][ri]+"_rates.root";

		currentpicture.legend.delete();
		for (int oi : objs.keys)
		{
			pen p = obj_pens[oi];
			draw(RootGetObject(f, objs[oi]), "p", p, mCi+1pt+p, obj_labels[oi]);
		}
	}

	ylimits(y_min, y_max, Crop);

	//SetPadWidth();

	AttachLegend(NE, NE);
}

/*
frame f_legend = BuildLegend();

NewPad(false);
attach(f_legend);
*/

GShipout(vSkip=1mm, margin=0mm);
