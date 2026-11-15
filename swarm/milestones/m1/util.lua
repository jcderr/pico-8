-- util.lua
-- small pure helpers with no game state. good place to practise lua:
-- each one is a few lines and easy to test with printh.

-- linear interpolation: returns a when t=0, b when t=1, and the
-- proportional value between them otherwise.
function lerp(a,b,t)
 -- todo(m9): one line of arithmetic.
end

-- cubic bezier along one axis. call it once for x and once for y.
-- p0 = start, p3 = end, p1/p2 = control points that "pull" the curve.
-- approach (de casteljau): lerp each neighbouring pair (3 results),
-- lerp those pairs (2 results), lerp those (1 result). that's the point.
-- returns: the coordinate at t (0..1).
function bezier(p0,p1,p2,p3,t)
 -- todo(m9)
end

-- axis-aligned bounding box overlap.
-- a and b are tables with x,y (top-left) and w,h.
-- returns true if they overlap.
-- approach: they *don't* overlap if a is fully left of b, fully right,
-- fully above, or fully below. return the negation of that.
function overlap(a,b)
 -- todo(m5)
end

-- clamp v into [lo,hi]. pico-8 has mid(), which does exactly this.
-- look it up and decide whether you even need this wrapper.
function clamp(v,lo,hi)
 -- todo(m2)
end

-- print text centred horizontally at row y in colour c.
-- remember: each glyph is 4px wide (3 + 1 space). glyphs like ❎ are 8.
function print_c(str,y,c)
 -- #str counts characters. a glyph like ❎ counts as 1 but is 8px
 -- wide, so strings containing one sit 2px right of true centre.
 -- close enough for a title screen.
 print(str,64-#str*2,y,c)
end
