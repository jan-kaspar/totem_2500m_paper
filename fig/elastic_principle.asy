unitsize(0.45mm);

texpreamble("\SelectNimbusCMFonts\LoadFonts\SetFontSizesIX");

dotfactor = 10;
dot((0, 0));
label("IP5", (0, 0), 2N);

real z_max = 130, z_cut = 20, z_gap = 3, z_st = 80, st_span = 50;
real w_vert = 3, h_vert = 11, offset_vert = 8;
real w_hor = 2, h_hor = 10;
real y_track = 5;
real y_unit = 20;
real y_dist = -20;
real y_st = 32;

draw((0, 0)--(z_cut, 0), dashed, EndBar(30));
draw((z_cut+z_gap, 0)--(z_max, 0), dashed, BeginBar(30));

draw((0, 0)--(-z_cut, 0), dashed, EndBar(30));
draw((-z_cut-z_gap, 0)--(-z_max, 0), dashed, BeginBar(30));

draw((0, 0)--(z_cut, y_track), black+solid, MidArrow);
draw((z_cut+z_gap, y_track)--(z_max, y_track), black+solid, EndArrow);

draw((0, 0)--(-z_cut, -y_track), black+solid, MidArrow);
draw((-z_cut-z_gap, -y_track)--(-z_max, -y_track), black+solid, EndArrow);

real z_convert(real z)
{
	return (z - 217.000) / 5 * st_span + z_st;
}

void DrawRect(real x, real y, real w, real h, pen bound, pen fill)
{
	filldraw((x-w/2, y-h/2)--(x+w/2, y-h/2)--(x+w/2, y+h/2)--(x-w/2, y+h/2)--cycle, fill, bound);
}

real z_vert_near = z_convert(214.628);
real z_hor_near = z_convert(215.077);
real z_hor_far = z_convert(219.551);
real z_vert_far = z_convert(220.000);

DrawRect(z_vert_near, +offset_vert, w_vert, h_vert, black, black);
DrawRect(z_vert_near, -offset_vert, w_vert, h_vert, black, black);
DrawRect(z_hor_near, 0, w_vert, h_vert, black, black);
DrawRect(z_hor_far, 0, w_vert, h_vert, black, black);
DrawRect(z_vert_far, +offset_vert, w_vert, h_vert, black, black);
DrawRect(z_vert_far, -offset_vert, w_vert, h_vert, black, black);

DrawRect(-z_vert_near, +offset_vert, w_vert, h_vert, black, black);
DrawRect(-z_vert_near, -offset_vert, w_vert, h_vert, black, black);
DrawRect(-z_hor_near, 0, w_vert, h_vert, black, black);
DrawRect(-z_hor_far, 0, w_vert, h_vert, black, black);
DrawRect(-z_vert_far, +offset_vert, w_vert, h_vert, black, black);
DrawRect(-z_vert_far, -offset_vert, w_vert, h_vert, black, black);

offset_vert -= 2;

label("top", (z_vert_near+w_vert/2, +offset_vert+h_vert/2), E);
label("bottom", (z_vert_near+w_vert/2, -offset_vert-h_vert/2), E);
label("horizontal", (z_hor_near+w_hor/2, -h_hor/2), E);

label("top", (-z_vert_near-w_vert/2, +offset_vert+h_vert/2), W);
label("bottom", (-z_vert_near-w_vert/2, -offset_vert-h_vert/2), W);
label("horizontal", (-z_hor_near-w_hor/2, +h_hor/2), W);

label("{\bf sector 56 (right arm)}", ((z_vert_near+z_vert_far)/2, y_st), black);
label("near", (z_vert_near, y_unit), black);
label("far", (z_vert_far, y_unit), black);
label("$+215\un{m}$", (z_vert_near, y_dist), black);
label("$+220\un{m}$", (z_vert_far, y_dist), black);

label("{\bf sector 45 (left arm)}", (-(z_vert_near+z_vert_far)/2, y_st), black);
label("near", (-z_vert_near, y_unit), black);
label("far", (-z_vert_far, y_unit), black);
label("$-215\un{m}$", (-z_vert_near, y_dist), black);
label("$-220\un{m}$", (-z_vert_far, y_dist), black);

shipout(bbox(0mm, nullpen));
