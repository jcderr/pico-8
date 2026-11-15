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
 player={
  x=60,       -- 64 - 8/2: centres the 8px sprite
  y=116,
  w=6,h=6,    -- smaller than the sprite; used from m5/m8
  alive=true,
  timer=0,
  inv=0,
 }
end

function update_player()
 -- btn() (not btnp) is true on every frame the button is held,
 -- which is what you want for smooth movement.
 if btn(0) then player.x-=player_speed end
 if btn(1) then player.x+=player_speed end
 -- x is the sprite's left edge, so the rightmost legal x is 128-8.
 player.x=clamp(player.x,0,120)

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
 -- player_speed is 1.5, so x is often fractional. spr() floors it
 -- for us; the ship still moves smoothly on average.
 spr(1,player.x,player.y)
 -- todo(m8): don't draw while dead. while inv>0, blink by drawing only
 --           on some frames (hint: frame%8 < 4).
end
