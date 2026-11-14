-- player.lua
-- the player's ship. there's only one, so it's a single table,
-- not a list.

player_speed=1.5
player_max_shots=2   -- max player bullets on screen at once
respawn_frames=120   -- how long the player stays gone after dying

-- shape of the player table:
-- player={
--  x,y      top-left pixel position (y stays fixed near the bottom)
--  w,h      hitbox size. make it smaller than the 8x8 sprite (e.g.
--           6x6, offset in) so near misses feel fair.
--  alive    false while exploding/respawning
--  timer    counts down respawn_frames while dead
--  inv      invulnerability frames after respawning (blink while > 0)
-- }

function init_player()
 -- todo(m2): build the player table. start it centred horizontally,
 --           around y=116.
end

function update_player()
 -- todo(m2): move left/right with btn(0)/btn(1), then clamp x so the
 --           ship never leaves the screen.
 -- todo(m3): on btnp(4) (🅾️), if #pbullets < player_max_shots, call
 --           fire_pbullet() from the nose of the ship. why btnp and not
 --           btn here? try both and see.
 -- todo(m8): if not alive, count timer down, and when it hits 0 respawn
 --           (alive=true, reset x, set inv). count inv down every frame.
end

-- called from check_collisions when something hits the player.
function kill_player()
 -- todo(m8): ignore the hit if already dead or inv>0.
 --           otherwise: alive=false, start the timer, lives-=1,
 --           spawn an explosion at the ship.
 -- todo(m11): screen shake, sfx.
end

function draw_player()
 -- todo(m2): spr(1, x, y).
 -- todo(m8): don't draw while dead. while inv>0, blink by drawing only
 --           on some frames (hint: frame%8 < 4).
end
