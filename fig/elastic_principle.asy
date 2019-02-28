import style;

unitsize(0.45mm);

dotfactor = 10;
dot((0, 0));
label("IP5", (0, 0), 2N);

real z_max = 180, z_cut = 20, z_gap = 3, st_span = 50;
real w_vert = 2.3, h_vert = 11, offset_vert = 8;
real w_hor = 2.3, h_hor = 11;
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
	return (z - 200.000) / 7 * st_span + 20;
}

void DrawRect(real x, real y, real w, real h, pen bound, pen fill)
{
	filldraw((x-w/2, y-h/2)--(x+w/2, y-h/2)--(x+w/2, y+h/2)--(x-w/2, y+h/2)--cycle, fill, bound);
}

real z_210_nr_v = z_convert(203.377);
real z_210_nr_h = z_convert(203.826);
real z_210_fr_h = z_convert(212.551);
real z_210_fr_v = z_convert(213.000);

real z_220_nr_v = z_convert(214.628);
real z_220_nr_h = z_convert(215.077);
real z_220_fr_h = z_convert(219.551);
real z_220_fr_v = z_convert(220.000);

pen p_line_rp_used = black;
pen p_fill_rp_used = black;

pen p_line_rp_other = gray;
pen p_fill_rp_other = lightgray;

for (real sign : new real[] {+1, -1})
{
	DrawRect(sign * z_210_nr_v, +offset_vert, w_vert, h_vert, p_line_rp_other, p_fill_rp_other);
	DrawRect(sign * z_210_nr_v, -offset_vert, w_vert, h_vert, p_line_rp_other, p_fill_rp_other);
	DrawRect(sign * z_210_nr_h, 0, w_vert, h_vert, p_line_rp_other, p_fill_rp_other);

	DrawRect(sign * z_210_fr_h, 0, w_vert, h_vert, p_line_rp_used, p_fill_rp_used);
	DrawRect(sign * z_210_fr_v, +offset_vert, w_vert, h_vert, p_line_rp_used, p_fill_rp_used);
	DrawRect(sign * z_210_fr_v, -offset_vert, w_vert, h_vert, p_line_rp_used, p_fill_rp_used);

	DrawRect(sign * z_220_nr_v, +offset_vert, w_vert, h_vert, p_line_rp_other, p_fill_rp_other);
	DrawRect(sign * z_220_nr_v, -offset_vert, w_vert, h_vert, p_line_rp_other, p_fill_rp_other);
	DrawRect(sign * z_220_nr_h, 0, w_vert, h_vert, p_line_rp_other, p_fill_rp_other);

	DrawRect(sign * z_220_fr_h, 0, w_vert, h_vert, p_line_rp_used, p_fill_rp_used);
	DrawRect(sign * z_220_fr_v, +offset_vert, w_vert, h_vert, p_line_rp_used, p_fill_rp_used);
	DrawRect(sign * z_220_fr_v, -offset_vert, w_vert, h_vert, p_line_rp_used, p_fill_rp_used);
}

offset_vert -= 2;

label("top", (z_220_fr_v-w_vert/2, +offset_vert+h_vert/2), W);
label("bottom", (z_220_fr_v-w_vert/2, -offset_vert-h_vert/2), W);
label("horizontal", (z_220_fr_h-w_hor/2, -h_hor/2), W);


real z_corr = 4;

label("{\bf LHC sector 56 (right arm)}", ((z_210_nr_v+z_210_fr_v)/2, y_st), black);
label("210-nr", (z_210_nr_v, y_unit), p_line_rp_other);
label("210-fr", (z_210_fr_v-z_corr, y_unit), p_line_rp_used);
label("220-nr", (z_220_nr_v+z_corr, y_unit), p_line_rp_other);
label("220-fr", (z_220_fr_v, y_unit), p_line_rp_used);
label("$+213\un{m}$", (z_210_fr_v, y_dist), black);
label("$+220\un{m}$", (z_220_fr_v, y_dist), black);

label("{\bf LHC sector 45 (left arm)}", (-(z_210_nr_v+z_210_fr_v)/2, y_st), black);
label("210-nr", (-z_210_nr_v, y_unit), p_line_rp_other);
label("210-fr", (-z_210_fr_v+z_corr, y_unit), p_line_rp_used);
label("220-nr", (-z_220_nr_v-z_corr, y_unit), p_line_rp_other);
label("220-fr", (-z_220_fr_v, y_unit), p_line_rp_used);
label("$-213\un{m}$", (-z_210_fr_v, y_dist), black);
label("$-220\un{m}$", (-z_220_fr_v, y_dist), black);

shipout(bbox(0mm, nullpen));
