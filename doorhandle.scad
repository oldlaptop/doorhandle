height = 6;
width = 2.5;
depth = 1.5;
mh_dist = 1.5;
mh_dia = 0.125;
ah_dia = 3 / 8;

wall_thickness = 0.075;

chamfer = width / 2;
top_rad = 4;
scallop_rad = height * 2;

$fn = 128;
followthrough = 0.01;

module chamfer_block(width, depth, chamfer)
{
	linear_extrude(depth)
	{
		polygon([
			[0, 0],
			[0, chamfer],
			[0, chamfer + followthrough],
			[width, chamfer + followthrough],
			[width, chamfer],
			[chamfer, 0]
		]);
	}
}

module doorhandle_body(
	height = height,
	width = width,
	depth = depth,
	chamfer = chamfer,
	top_rad = top_rad
)
{
	intersection()
	{
		union()
		{
			translate([0, chamfer, 0])
			{
				cube([width, height - 2 * chamfer, depth]);
			}
			chamfer_block(width, depth, chamfer);
			translate([0, height, 0])
			{
				mirror([0, 1, 0])
				{
					chamfer_block(width, depth, chamfer);
				}
			}
		}
		translate([0, 0, depth - top_rad])
		{
			rotate([270, 0, 0])
			{
				cylinder(r = top_rad, h = height);
			}
		}
	}
}

module hole_channels(
	mh_dist = mh_dist,
	mh_dia = mh_dia,
	width = width,
	depth = depth
)
{
	for (mul = [+1, -1])
	{
		translate([width / 2, mh_dist / 2 * mul, -followthrough])
		{
			cylinder(d = mh_dia, h = depth + 2 * followthrough);
		}
	}
}

module doorhandle(
	height = height,
	width = width,
	depth = depth,
	chamfer = chamfer,
	top_rad = top_rad,
	scallop_rad = scallop_rad,
	mh_dist = mh_dist,
	mh_dia = mh_dia,
	wall_thickness = wall_thickness
)
{
	difference()
	{
		doorhandle_body(height, width, depth, chamfer, top_rad);
		translate([-followthrough, wall_thickness, wall_thickness])
		{
			doorhandle_body(
				height - 2 * wall_thickness,
				width - wall_thickness + followthrough,
				depth - 2 * wall_thickness,
				chamfer = chamfer,
				top_rad = top_rad
			);
		}
		translate([0, height / 2, 0])
		{
			union()
			{
				hole_channels(mh_dist, mh_dia, width, wall_thickness);
				translate([0, 0, wall_thickness + followthrough])
				{
					hole_channels(
						mh_dist,
						ah_dia,
						width,
						depth
					);
				}
				if (scallop_rad > 0)
				{
					xoffs = sqrt(
						pow(scallop_rad, 2)
						-
						pow(height, 2) / 4
					);
					translate([-xoffs, 0, wall_thickness])
					{
						cylinder(r = scallop_rad, h = height);
					}
				}
			}
		}

	}
}

doorhandle();
