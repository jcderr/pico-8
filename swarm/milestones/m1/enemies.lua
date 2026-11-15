-- enemies.lua
-- every enemy is a table in the `enemies` list and runs its own
-- small state machine:
--   entering -> formation -> diving -> returning -> formation ...
-- see the diagram in notes.md.

enemies={}

-- formation grid geometry (pixels)
form_x=24        -- left edge of column 0, before sway
form_y=16        -- top edge of row 0
form_dx=10       -- horizontal spacing between columns
form_dy=10       -- vertical spacing between rows
sway_amp=8       -- how far the whole formation drifts left/right
sway_period=240  -- frames for one full sway cycle

-- data-driven enemy kinds. the update/draw code reads these instead
-- of hard-coding per-type behaviour; adding a kind = adding a row.
-- spr      first animation frame (second frame is spr+1)
-- hp       hits to kill
-- pts      score (in tens) when killed in formation
-- dive_pts score (in tens) when killed while diving (more risk, more reward)
-- shots    bullets fired per dive
enemy_kinds={
 drone  ={spr=16,hp=1,pts=5, dive_pts=10,shots=1},
 stinger={spr=18,hp=1,pts=8, dive_pts=16,shots=2},
 carrier={spr=20,hp=2,pts=15,dive_pts=40,shots=3},
}

-- shape of an enemy:
-- {
--  kind     key into enemy_kinds ("drone", ...)
--  hp       remaining hits
--  col,row  formation slot (fixed for the enemy's whole life)
--  x,y      current pixel position (top-left)
--  w,h      hitbox
--  state    "entering"|"formation"|"diving"|"returning"
--  t        progress along the current path, 0..1
--  path     current bezier path: {x={p0,p1,p2,p3}, y={p0,p1,p2,p3}}
--  shots    bullets left to fire on this dive
--  flash    frames to draw in white after being hit (m11)
-- }

-- create an enemy table and add it to `enemies`.
-- until m9, spawn straight into "formation" at slot_pos(col,row).
function spawn_enemy(kind,col,row)
 -- todo(m4)
end

-- current formation sway offset in pixels, the same for every enemy.
-- approach: sin(frame/sway_period)*sway_amp.
-- todo(m11 stretch): also "breathe": spread columns apart and back.
function formation_offset()
 -- todo(m6): until m6, just return 0.
end

-- turn a slot into a pixel position *right now*.
-- returns two values: x,y. (lua functions can return several values;
-- `local x,y=slot_pos(c,r)`.)
function slot_pos(col,row)
 -- todo(m4): form_x + col*form_dx (+ formation_offset() from m6), etc.
end

-- per-frame update for every enemy. dispatch on e.state to the
-- matching helper below. this is the same pattern as main.lua's
-- state machine, just per entity.
function update_enemies()
 -- todo(m4/m7/m9)
 -- todo(m11): count down e.flash.
end

-- sits in its slot.
function enemy_formation(e)
 -- todo(m4): x,y = slot_pos(...)
end

-- follows e.path, advancing e.t. when t>=1, switch to "formation".
-- think: how many frames should an entry take? derive the t
-- increment from that.
function enemy_entering(e)
 -- todo(m9)
end

-- follows its dive path. randomly (or at fixed points along t) fires
-- at the player while shots>0. when it goes below the screen (y>128),
-- move it to y=-8 at its slot's x and switch to "returning".
function enemy_diving(e)
 -- todo(m7): movement.
 -- todo(m8): shooting via fire_ebullet().
end

-- steer toward the slot's *current* position (it's moving, because of
-- sway). approach: compute dx,dy to the target, move a fixed speed
-- along that direction (or simply step x and y toward the target).
-- when close enough (say < 1px), snap to it and switch to "formation".
function enemy_returning(e)
 -- todo(m7)
end

-- build a dive path for e and switch it to "diving".
-- approach: a bezier from the enemy's current position that swings
-- out to one side (p1), curves back toward the player's x (p2), and
-- exits below the screen (p3). add some rnd() so dives differ.
-- this is where the game gets its feel; experiment.
function start_dive(e)
 -- todo(m7)
end

-- called every frame from update_play. decides whether to launch a
-- dive this frame.
-- approach: keep a countdown; when it hits 0, pick a random enemy whose
-- state=="formation", call start_dive, and reset the countdown to a
-- value that shrinks as waves go up (see wave_dive_interval()).
-- stretch: occasionally launch a pair from adjacent columns.
function update_dive_ai()
 -- todo(m7)
end

-- apply one hit. if hp reaches 0: award points (dive_pts if diving),
-- spawn an explosion, remove from `enemies`.
-- returns true if the enemy died (handy in check_collisions).
function hit_enemy(e)
 -- todo(m5)
 -- todo(m11): set e.flash; carriers swap to their damaged sprite (22).
end

function draw_enemies()
 -- todo(m4): spr(kind's spr, x, y).
 -- todo(m6): two-frame animation: spr + (frame\16)%2.
 --           (`\` is pico-8's integer division.)
 -- todo(m11): when flash>0, pal() every colour to 7, draw, then pal().
end
