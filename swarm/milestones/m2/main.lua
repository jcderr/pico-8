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
state_frame=0  -- value of `frame` when the current state was entered

-- switch states and remember when it happened, so a state can ask
-- "how long have i been active?" (frame-state_frame).
function set_state(s)
 state=s
 state_frame=frame
end

function _init()
 set_state("title")
 init_stars()
 -- todo(m10): cartdata("jcderr_swarm") and load hiscore with dget(0).
end

function _update60()
 frame+=1
 update_stars()   -- stars scroll behind every state

 if state=="title" then
  update_title()
 elseif state=="play" then
  update_play()
 elseif state=="gameover" then
  update_gameover()
 end
end

function _draw()
 cls()
 draw_stars()

 if state=="title" then
  draw_title()
 elseif state=="play" then
  draw_play()
 elseif state=="gameover" then
  draw_gameover()
 end
end

----------------------------------------------------------------
-- title
----------------------------------------------------------------

function update_title()
 if btnp(5) then
  start_game()
 end
end

function draw_title()
 print_c("s w a r m",40,11)
 -- blink the prompt: visible for 30 frames, hidden for 15
 if frame%45<30 then
  print_c("press ❎ to start",70,7)
 end
 print_c("hi "..score_str(hiscore),100,6)
end

-- score is stored in tens, so append a "0" -- except for zero
-- itself, which would otherwise read "00".
function score_str(s)
 if s==0 then return "0" end
 return tostr(s).."0"
end

----------------------------------------------------------------
-- play
----------------------------------------------------------------

-- resets everything for a new game and switches to play.
function start_game()
 score=0
 lives=3
 set_state("play")
 init_player()
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
 -- todo(m3..m10): fill in as each milestone needs it.
 update_player()

 -- m1 only: ❎ ends the game so the whole state loop can be tested.
 -- remove this once m8 adds a real game-over condition.
 if btnp(5) then
  set_state("gameover")
 end
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
 -- todo(m3..m5)
 draw_player()
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

gameover_delay=60  -- frames before ❎ is accepted on the gameover screen

function update_gameover()
 -- todo(m10): before leaving, if score>hiscore, save it with dset(0,...).
 --            (or do that once, at the moment you enter gameover.)
 -- ignore input for a moment so a player still mashing fire doesn't
 -- skip the screen by accident.
 if frame-state_frame>=gameover_delay and btnp(5) then
  set_state("title")
 end
end

function draw_gameover()
 print_c("game over",50,8)
 print_c("score "..score_str(score),62,7)
 -- only show the prompt once input is actually accepted
 if frame-state_frame>=gameover_delay then
  print_c("press ❎",80,6)
 end
end
