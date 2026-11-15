-- bullets.lua
-- player bullets go straight up. enemy bullets travel at an angle
-- (aimed at the player when fired).

pbullet_speed=4
ebullet_speed=1.2   -- waves.lua may scale this up per wave

pbullets={}
ebullets={}

-- shape of a bullet:
-- {
--  x,y     position
--  w,h     hitbox (a 1x4 or 2x4 rect is fine for player shots)
--  dx,dy   velocity per frame (player shots: dx=0, dy=-pbullet_speed)
-- }

function fire_pbullet(x,y)
 -- todo(m3): add a new bullet table to pbullets.
 -- todo(m11): sfx.
end

-- fire an enemy bullet from (x,y) toward the point (tx,ty).
-- approach:
--  - get the angle with atan2(tx-x, ty-y). result is in turns (0..1).
--  - dx = cos(angle)*speed, dy = sin(angle)*speed.
--  - check the sign! pico-8's sin is inverted. print dx,dy and
--    confirm the bullet actually flies toward the player.
-- design question: should enemies only fire if the player is below
-- them? (a bullet aimed upward looks odd.)
function fire_ebullet(x,y,tx,ty)
 -- todo(m8)
end

-- move every bullet in both lists; remove any that are off-screen.
function update_bullets()
 -- todo(m3): player bullets. removing while iterating is the lesson
 --           here; see notes.md, "removing from a list".
 -- todo(m8): enemy bullets (off-screen in any direction).
end

function draw_bullets()
 -- todo(m3): spr(2,...) or a small rectfill for player shots.
 -- todo(m8): enemy shots in a contrasting colour (e.g. circfill r=1).
end
