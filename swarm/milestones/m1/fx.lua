-- fx.lua
-- purely visual effects: starfield, explosion particles, screen shake.
-- nothing here affects gameplay, so it's a safe place to experiment.

stars={}
particles={}
shake=0   -- frames of screen shake remaining (m11)

-- shape of a star:     {x,y,spd,c}   spd and colour vary by "depth"
-- shape of a particle: {x,y,dx,dy,life,c}

-- fill `stars` with ~40 random stars.
-- parallax: give slow stars a dim colour (1 or 5) and fast stars a
-- bright one (6 or 7). the depth effect comes for free.
function init_stars()
 stars={}
 for i=1,40 do
  -- pick a depth layer: 1 = far, 2 = mid, 3 = near
  local depth=flr(rnd(3))+1
  add(stars,{
   x=rnd(128),
   y=rnd(128),
   spd=depth*0.25+rnd(0.2),  -- far stars drift, near ones zip
   c=({1,5,7})[depth],       -- dim -> bright with depth
  })
 end
end

-- move stars down; when one passes y>127, wrap it to the top at a new
-- random x.
function update_stars()
 for s in all(stars) do
  s.y+=s.spd
  if s.y>127 then
   s.y-=128       -- keep the fractional part so spacing stays even
   s.x=rnd(128)
  end
 end
end

function draw_stars()
 for s in all(stars) do
  pset(s.x,s.y,s.c)
 end
end

-- spawn n particles at (x,y) flying in random directions.
-- approach: random angle a=rnd(1) (turns!), random speed s;
-- dx=cos(a)*s, dy=sin(a)*s. life ~15-30 frames.
function explode(x,y,n)
 -- todo(m5)
end

-- move particles, apply a little drag (dx*=0.9) if you like,
-- count life down, remove dead ones.
function update_particles()
 -- todo(m5)
end

function draw_particles()
 -- todo(m5): pset, or a colour that fades as life drops
 --           (7 -> 10 -> 9 -> 8 -> 2).
end

-- screen shake: in _draw, before drawing the world, offset everything
-- with camera(rnd(4)-2, rnd(4)-2) while shake>0, then camera() to reset
-- before drawing the hud.
function apply_shake()
 -- todo(m11)
end
