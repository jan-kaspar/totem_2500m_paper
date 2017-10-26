import three;
import math;
access settings;

texpreamble("\SelectNimbusCMFonts\LoadFonts\SetFontSizesIX");

settings.prc = false;
settings.render = 0;


unitsize(0.3cm);

//currentprojection = orthographic((0, 0.01, 1), (0, 1, 0));
currentprojection = orthographic((-19, 8, -5), up=Y, target=(0, 0, 8));

//----------------------------------------------------------------------------------------------------

transform3 ZRot(real phi)
{
	return rotate(phi, (0, 0, 1));
}

//----------------------------------------------------------------------------------------------------

real edge = 3.6101;
real cutEdge = 2.22721 / sqrt(2);

path3 Det0 = (cutEdge, 0, 0)--(edge, 0, 0)--(edge, edge, 0)--(0, edge, 0)--(0, cutEdge, 0)--cycle;
path3 Det = rotate(45, (0, 0, 1)) * shift(-0.6, -0.6, 0) * Det0;

void DrawDet(transform3 t)
{
	pen pSur = lightgray;
	pen pMesh = nullpen + opacity(0.5);
	draw(surface(t*Det), surfacepen = pSur, meshpen = pMesh, light=nolight, meshlight=nolight);
	draw(t*Det, black+1pt);
}

real z1 = 0, z2 = 2, z3 = 6, z4 = 8;

dotfactor = 4;


DrawDet(ZRot(180)*shift(0, 0, z1));

draw((0, 0, z1-2)--(0, 0, z4+2), black+dashed);

draw((-1, 1, z4)--(-1, 1, z4+2), black);
DrawDet(ZRot(0)*shift(0, 0, z4));
DrawDet(ZRot(180)*shift(0, 0, z4));

draw((-1, 1, z3)--(-1, 1, z4), black);
dot((-1, 1, z4), black);
DrawDet(ZRot(90)*shift(0, 0, z3));

draw((-1, 1, z2)--(-1, 1, z3), black);
dot((-1, 1, z3), black);
DrawDet(ZRot(90)*shift(0, 0, z2));

draw((-1, 1, z1)--(-1, 1, z2), black);
dot((-1, 1, z2), black);
DrawDet(ZRot(0)*shift(0, 0, z1));

draw((-1, 1, z1-2)--(-1, 1, z1), black);
dot((-1, 1, z1), black);

label("stack of 10", (-3.7, 4.5));
label("detectors", (-3.7, 3.3));

draw((-6.2, 3.8)--(-6.5, 2.6), EndArrow);
draw((-1.3, 4.0)--(-1.0, 3.0), EndArrow);

shipout(bbox(0mm, Fill(white)));
