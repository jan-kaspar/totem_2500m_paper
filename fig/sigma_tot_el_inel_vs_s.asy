import root;
import pad_layout;
import style;

include "/home/jkaspar/publications/elastic figures/common_code.asy";

string topDir = "/home/jkaspar/publications/elastic figures/";
fit_file = topDir + "build_uncertainty_bands.root";

drawGridDef = false;

texpreamble("\def\ln{\mathop{\rm ln}}");
//texpreamble("\SelectCMFonts\LoadFonts\rm");
//texpreamble("\def\ung#1{\quad{\rm[#1]}}");


// ------------------ settings ------------------

mark m_PDG_app = mTU + false + 1.5pt;
mark m_PDG_pp = mTD + false + 1.5pt;
mark m_Auger = mSq + false + 1.5pt;
mark m_ALICE = mCr2 + false + 1.5pt;
mark m_ATLAS = mTL + false + 1.5pt;
mark m_CMS = mTR + false + 1.5pt;
mark m_LHCb = mPl2 + false + 1.5pt;
mark m_STAR = mSt + false + 1.9pt;
mark m_TOTEM = mCi + true + 1.6pt;

pen p_tot = red;
pen p_inel = blue;
pen p_el = heavygreen;

// fine-shift unit
real fshu = 0.01;


// -------------------- inset --------------------

picture inset = new picture;
currentpicture = inset;

unitsize(5mm, 2mm);

DrawPoint(1, 110.6, 3.4, p_tot, m_TOTEM+false+p_tot);

DrawPoint(2, 110.32, 3.95, p_tot, m_TOTEM+false+p_tot);

DrawPoint(3, 110.48, 2.58, p_tot, m_TOTEM+true+p_tot);

limits((0, 105), (4, 115), Crop);

xaxis(BottomTop, NoTicks);
yaxis(LeftRight, RightTicks(5., 1.).GetTicks());

// -------------------- main pad --------------------

NewPad("$\sqrt s\ung{GeV}$", "$\si_{\rm el}$ (green), $\si_{\rm inel}$ (blue) and  $\si_{\rm tot}$ (red) $\ung{mb}$", 14.5cm, 10cm);

scale(Log, Linear);

// -------------------- fits --------------------

// p-anti p
DrawFitUncBand("si_tot_p_ap", black+opacity(0.1));
DrawFit("si_tot_p_ap", solid);
DrawFitUncBand("si_inel_p_ap", black+opacity(0.1));
DrawFit("si_inel_p_ap", dashdotted);

// pp
DrawFitUncBand("si_tot_p_p", black+opacity(0.1));
DrawFit("si_tot_p_p", solid);
DrawFitUncBand("si_inel_p_p", black+opacity(0.1));
DrawFit("si_inel_p_p", dashdotted);

// common
DrawFitUncBand("si_el", black+opacity(0.2));
DrawFit("si_el", linetype(new real[] {8,7}, offset=6));

// -------------------- PDG --------------------

// PDG reference: K. Nakamura et al. (Particle Data Group), J. Phys. G 37, 075021 (2010)

// PDG sigma tot data
DrawDataSet(topDir + "pdg/pbarp_total.dat", p_tot+0.2pt, m_PDG_app);
DrawDataSet(topDir + "pdg/pp_total.dat", p_tot+0.2pt, m_PDG_pp);

// PDG sigma el data
DrawDataSet(topDir + "pdg/pbarp_elastic.dat", p_el+0.2pt, m_PDG_app);
DrawDataSet(topDir + "pdg/pp_elastic.dat", p_el+0.2pt, m_PDG_pp);

// PDG sigma inel data
DrawInelasticDataSet(topDir + "pdg/pbarp_total.dat", "pdg/pbarp_elastic.dat", p_inel+0.2pt, m_PDG_app);
DrawInelasticDataSet(topDir + "pdg/pp_total.dat", "pdg/pp_elastic.dat", p_inel+0.2pt, m_PDG_pp);


// -------------------- cosmics --------------------

// Auger; P. Abreu et al. (Pierre Auger Collaboration), Phys. Rev. Lett. 109, 062002 (2012)
fsh = -0.5fshu; DrawPointE(57e3, 6e3, 6e3, 92, 14.8, 13.4, p_inel, m_Auger+p_inel);
fsh = +0.5fshu; DrawPointE(57e3, 6e3, 6e3, 133, 28.7, 26.7, p_tot, m_Auger+p_tot);

// -------------------- RHIC --------------------

// https://indico.cern.ch/event/713101/contributions/3102222/attachments/1704998/2747001/GurynDiffraction2018.pdf, unc.~added in quad
fsh = 0fshu; DrawPoint(200., 51.3, 2.04, 2.04, p_tot, m_STAR+p_tot);
fsh = 0fshu; DrawPoint(200., 9.6, 0.71, 0.71, p_el, m_STAR+p_el);


// -------------------- LHC, 2.76 TeV --------------------

// ALICE; Eur. Phys. J. C73 no. 6, (2013) 2456; unct. added in quad.
fsh = -1fshu; DrawPoint(2.76e3, 62.8, 4.2, 2.7, p_inel, m_ALICE+p_inel);

// TOTEM; not yet published
fsh = +0fshu; DrawPoint(2.76e3, 84.7, 3.3, p_tot, m_TOTEM+p_tot);
fsh = +1fshu; DrawPoint(2.76e3, 62.8, 2.9, p_inel, m_TOTEM+p_inel);
fsh = +0fshu; DrawPoint(2.76e3, 21.8, 1.4, p_el+1pt, m_TOTEM+p_el);


// -------------------- LHC, 7 TeV --------------------

// ALICE; Eur. Phys. J. C73 no. 6, (2013) 2456; unct. added in quad.
fsh = -3fshu; DrawPointE(7e3, 0, 0, 73.1, 5.3, 3.3, p_inel, m_ALICE+p_inel);

// ATLAS; Nature Commun. 2 (2011) 463; unct. added in quad.
fsh = -2fshu; DrawPointE(7e3, 0, 0, 69.1, 7.3, 7.3, p_inel, m_ATLAS+p_inel);

// ATLAS - ALFA; Nucl. Phys. B889 (2014) 486–548
fsh = +0fshu; DrawPointE(7e3, 0, 0, 95.35, 1.36, 1.36, p_tot, m_ATLAS+p_tot);
fsh = -1fshu; DrawPointE(7e3, 0, 0, 71.34, 0.90, 0.90, p_inel, m_ATLAS+p_inel);
fsh = +1fshu; DrawPointE(7e3, 0, 0, 24.00, 0.60, 0.60, p_el, m_ATLAS+p_el);

// CMS; CMS-PAS-FWD-11-001
fsh = +1fshu; DrawPointE(7e3, 0, 0, 68.0, 5.1, 5.1, p_inel, m_CMS+p_inel);

// CMS; CMS-PAS-QCD-11-002
//DrawPointE(7e3, 0, 0, 64.5, 3.4, 3.4, p_inel, m_CMS+p_inel);

// LHCb; JHEP 02 (2015) 129; unct. added in quad.
fsh = +2fshu; DrawPointE(7e3, 0, 0, 66.9, 5.3, 5.3, p_inel, m_LHCb+p_inel);

// TOTEM; EPL 101 (2013) 21002, Table 7, unc.~added in quad.
fsh = +2fshu; DrawPoint(7e3, 25.43, 1.07, p_el+1pt, m_TOTEM+p_el);

// TOTEM; EPL 101 (2013) 21004
fsh = -1.1fshu; DrawPoint(7e3, 98.0, 2.5, 2.5, p_tot, m_TOTEM+p_tot);	// luminosity independent
fsh = +1.1fshu; DrawPoint(7e3, 98.6, 2.2, 2.2, p_tot, m_TOTEM+p_tot);	// elastic only
fsh = +0fshu; DrawPointE(7e3, 0, 0, 72.9, 1.5, 1.5, p_inel, m_TOTEM+p_inel);
fsh = -1fshu; DrawPointE(7e3, 0, 0, 25.1, 1.1, 1.1, p_el+1pt, m_TOTEM+p_el);


// -------------------- LHC, 8 TeV --------------------

// TOTEM; Phys. Rev. Lett. 111 no. 1, (2013) 012001
// tot: 101.7 +- 2.9
fsh = +0fshu; DrawPoint(8e3, 74.7, 1.7, p_inel, m_TOTEM+p_inel);
fsh = +0fshu; DrawPoint(8e3, 27.1, 1.4, p_el+1pt, m_TOTEM+p_el);

// TOTEM; Nucl. Phys. B 899 (2015) 527-546, N_b = 2
fsh = -1.1fshu; DrawPoint(8e3, 101.5, 2.1, 2.1, p_tot, m_TOTEM+p_tot);

// TOTEM; Eur. Phys. J. C76 (2016) 661, N_b = 3, Cahn/KL, constant phase
fsh = +1.1fshu; DrawPoint(8e3, 102.9, 2.3, 2.3, p_tot, m_TOTEM+p_tot);

// ATLAS - ALFA, Phys. Lett. B 761 (2016) 158-178
fsh = +0fshu; DrawPointE(8e3, 0, 0, 96.07, 0.92, 0.92, p_tot, m_ATLAS+p_tot);
fsh = +0fshu; DrawPointE(8e3, 0, 0, 71.73, 0.71, 0.71, p_inel, m_ATLAS+p_inel);
fsh = +0fshu; DrawPointE(8e3, 0, 0, 24.33, 0.39, 0.39, p_el, m_ATLAS+p_el);


// -------------------- LHC, 13 TeV --------------------

// ATLAS; Phys. Rev. Lett. 117, 182002
fsh = -1fshu; DrawPoint(13e3, 78.1, 2.9, p_inel, m_ATLAS+p_inel);

// CMS; CMS-PAS-FSQ-15-005 also arXiv:1607.02033; uncertainties summed in quadrature
fsh = +0fshu; DrawPoint(13e3, 71.3, 3.5, p_inel, m_CMS+p_inel);

// LHCb; https://doi.org/10.1007/JHEP06(2018)100; uncertainties summed in quadrature
fsh = +1fshu; DrawPoint(13e3, 75.4, 5.4, p_inel, m_LHCb+p_inel);

// TOTEM; 90m analysis, for rho=0.10, preliminary, not yet published
fsh = +1.1fshu; DrawPoint(13e3, 110.6, 3.4, p_tot, m_TOTEM+false+p_tot);
fsh = +0fshu; DrawPoint(13e3,  79.5, 1.8, p_inel, m_TOTEM+p_inel);
fsh = +0fshu; DrawPoint(13e3,  31.0, 1.7, p_el+1pt, m_TOTEM+p_el);

// TOTEM; 2.5km analysis, approach 3, step d, preliminary, not yet published
fsh = -1.1fshu; DrawPoint(13e3, 110.3, 3.5, p_tot, m_TOTEM+false+p_tot);

// TOTEM; 90m + 2.5km combination, preliminary, not yet published
fsh = +0fshu; DrawPoint(13e3, 110.5, 2.4, p_tot, m_TOTEM+p_tot);


// -------------------- arrows --------------------

//real w = 2.76e3;
//draw(Label("$2.76\un{TeV}$", 0, N), (log10(w), 110)--(log10(w), 90), EndArrow);

//real w = 13e3;
//draw(Label("$13\un{TeV}$", 0, N, Fill(white+opacity(0.8))), (log10(w), 130)--(log10(w), 113), EndArrow);

// -------------------- limits --------------------

limits((1e1, 0), (1e5, 140), Crop);

// -------------------- axes --------------------

yaxis(XEquals(0.546e3, false), dotted + roundcap);
yaxis(XEquals(0.9e3, false), dotted + roundcap);
yaxis(XEquals(1.8e3, false), dotted + roundcap);
yaxis(XEquals(2.76e3, false), dotted + roundcap);
yaxis(XEquals(7e3, false), dotted + roundcap);
yaxis(XEquals(8e3, false), dotted + roundcap);
yaxis(XEquals(13e3, false), dotted + roundcap);

label(rotate(90)*Label("\SmallerFonts$0.546\un{TeV}$"), Scale((0.546e3, 30)), Fill(white));
label(rotate(90)*Label("\SmallerFonts$0.9\un{TeV}$"), Scale((0.9e3, 30)), Fill(white));
label(rotate(90)*Label("\SmallerFonts$1.8\un{TeV}$"), Scale((1.8e3, 30)), Fill(white));
label(rotate(90)*Label("\SmallerFonts$2.76\un{TeV}$"), Scale((2.76e3, 35)), Fill(white));
label(rotate(90)*Label("\SmallerFonts$7\un{TeV}$"), Scale((7e3-100, 40)), Fill(white));
label(rotate(90)*Label("\SmallerFonts$8\un{TeV}$"), Scale((8e3+100, 41)), Fill(white));
label(rotate(90)*Label("\SmallerFonts$13\un{TeV}$"), Scale((13e3, 45)), Fill(white));

for (real y = 10; y < 140; y += 10)
	xaxis(YEquals(y, false), dotted+roundcap);

// -------------------- attach insert --------------------

//attach(bbox(shift(0, -100)*inset, 1mm, nullpen, FillDraw(white)), (3.15, 92));
//draw((3.7, 115)--(4.08, 111), EndArrow);

// -------------------- labels --------------------

AddToLegend("$\rm \overline pp$ (PDG 2010)", nullpen, m_PDG_app+3pt);
AddToLegend("$\rm pp$ (PDG 2010)", nullpen, m_PDG_pp+3pt);
AddToLegend("Auger (+ Glauber)", m_Auger+3pt);
AddToLegend("STAR (prelim.)", m_STAR+3pt);
AddToLegend("ALICE", m_ALICE+3pt);
AddToLegend("ATLAS/ALFA", m_ATLAS+3pt);
AddToLegend("{\bf TOTEM}", nullpen, m_TOTEM+3pt);
AddToLegend("LHCb", m_LHCb+3pt);
AddToLegend("CMS", m_CMS+3pt);

label("$\si_{\rm tot}$", (3.1, 78), p_tot, Fill(white));
label("$\si_{\rm inel}$", (3.1, 50), p_inel, Fill(white));
label("$\si_{\rm el}$", (3.1, 11), p_el, Fill(white));

AttachLegend(BuildLegend(3, NW, lineLength=5mm), NW);

// fit labels
currentpicture.legend.delete();
AddToLegend("$\si_{\rm tot}$ fits by COMPETE", black);
AddToLegend("(pre-LHC model $\rm RRP_{\rm nf}L2_{\rm u}$)");
AddToLegend("$\si_{\rm el}$ fit by TOTEM", dashed);
AddToLegend("($11.84 - 1.617\ln s + 0.1359\ln^2 s$)");
AttachLegend(shift(0, 60.7)*BuildLegend(W), W);

GShipout();
