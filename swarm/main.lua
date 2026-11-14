-- main.lua
-- entry points and the top-level state machine.
-- pico-8 calls _init once, then _update60 and _draw every frame.

-- current game state: "title" | "play" | "gameover"
state="title"

-- score is stored in tens to avoid 16-bit overflow (see notes.md).
-- display it as tostr(score).."0" (and handle score==0 nicely).
score=0
hiscore=0
lives=3
frame=0   -- global frame counter; handy for animation and timers

function _init()
 -- todo(m1): set the initial state.
 -- todo(m1): call init_stars().
 -- todo(m10): cartdata("jcderr_swarm") and load hiscore with dget(0).
end

function _update60()
 -- todo(m1): increment frame.
 -- todo(m1): update the stars (they scroll in every state).
 -- todo(m1): dispatch to update_title / update_play / update_gameover
 --           based on state. a chain of if/elseif is fine.
 --           (stretch: a table mapping state name -> function.)
end

function _draw()
 -- todo(m1): cls(), draw the stars, then dispatch to the matching
 --           draw_* function.
end

----------------------------------------------------------------
-- title
----------------------------------------------------------------

function update_title()
 -- todo(m1): on btnp(5) (❎) call start_game().
end

function draw_title()
 -- todo(m1): game name, "press ❎ to start", and the high score.
 --           centering text: each char is 4px wide, so
 --           x = 64 - #str*2.
end

----------------------------------------------------------------
-- play
----------------------------------------------------------------

-- resets everything for a new game and switches to play.
function start_game()
 -- todo(m1): reset score and lives; set state="play".
 -- todo(m2): init_player().
 -- todo(m3): clear the bullet lists (pbullets={}, ebullets={}).
 -- todo(m4): start_wave(1). until m9 this can just place enemies
 --           straight into formation.
end

function update_play()
 -- order matters here. a sensible order is:
 --   1. player   (reads input)
 --   2. bullets  (move)
 --   3. enemies  (move, decide to dive or shoot)
 --   4. collisions (bullets vs enemies, enemies/ebullets vs player)
 --   5. particles
 --   6. wave bookkeeping (is the wave cleared? -> next wave)
 --   7. game over check (lives==0 -> state="gameover")
 -- todo(m2..m10): fill in as each milestone needs it.
end

-- all the "did x touch y" checks live together here so the
-- per-entity update functions stay simple.
function check_collisions()
 -- todo(m5): for each player bullet, for each enemy: if they overlap
 --           (see overlap() in util.lua), damage the enemy, remove the
 --           bullet, and stop checking that bullet.
 --           think: what happens if you del() from a list while you're
 --           iterating over it with a numeric for loop?
 -- todo(m8): enemy bullets vs player, and enemy bodies vs player.
 --           skip both while the player is dead or respawning.
end

function draw_play()
 -- draw back to front: enemies, bullets, player, particles, then hud last
 -- so it sits on top.
 -- todo(m2..m5)
end

function draw_hud()
 -- todo(m5): score in the top-left corner, lives as small ship icons
 --           in the bottom-left or top-right corner.
 -- todo(m10): wave number when a new wave starts (a "wave 3" banner
 --            for ~90 frames).
end

----------------------------------------------------------------
-- gameover
----------------------------------------------------------------

function update_gameover()
 -- todo(m1): ❎ returns to title.
 -- todo(m10): before leaving, if score>hiscore, save it with dset(0,...).
 --            (or do that once, at the moment you enter gameover.)
 -- hint: add a short delay (e.g. 60 frames) before accepting input so
 -- the player doesn't skip the screen by accident while still mashing
 -- fire.
end

function draw_gameover()
 -- todo(m1): "game over", final score, "press ❎".
end
