-- waves.lua
-- what spawns in each wave, how enemies enter, and how difficulty
-- scales. keep tuning numbers here, not scattered through the code.

wave=0

-- formation layout, one string per row, one char per column.
-- d=drone s=stinger c=carrier .=empty
-- this is data, not logic: start_wave() parses it.
-- (lua strings: sub(str,i,i) gets the i-th char, #str is the length.)
wave_layout={
 "..cccc..",
 ".ssssss.",
 "dddddddd",
 "dddddddd",
}

-- character -> enemy kind
layout_kinds={d="drone",s="stinger",c="carrier"}

-- set up wave n: clear leftovers, spawn enemies from wave_layout.
-- approach: loop over rows and chars; for each non-"." char call
-- spawn_enemy(kind, col, row). remember lua strings/tables are
-- 1-based but your col/row math probably wants 0-based.
function start_wave(n)
 -- todo(m4): spawn straight into formation.
 -- todo(m9): instead, queue enemies to enter in groups (see below).
 -- todo(m10): reset the dive countdown, show a "wave n" banner.
end

-- m9: staggered entry.
-- approach: rather than spawning everything at once, keep a queue of
-- {kind,col,row,delay} entries. each frame, count delays down and spawn
-- the ones that are due in "entering" state with an entry path.
-- groups of 4-8 entering together, alternating sides, looks good.
function update_wave()
 -- todo(m9): process the spawn queue.
 -- todo(m10): if the queue is empty and #enemies==0, start_wave(wave+1).
end

-- build an entry path from off-screen to slot (col,row).
-- approach: p0 off-screen left or right, p1/p2 make a loop or swoop
-- through the middle of the screen, p3 = slot_pos(col,row).
-- catch: the slot moves (sway). either accept a small snap at the end,
-- or recompute p3 every frame in enemy_entering. try both.
function entry_path(col,row,from_left)
 -- todo(m9): return {x={...},y={...}}.
end

-- difficulty curves. each takes the wave number and returns a value.
-- keep them simple (linear with a floor/ceiling via max/min) and tune
-- by playing.
function wave_dive_interval()
 -- todo(m10): frames between dives; e.g. starts ~120, floors at ~30.
end

function wave_bullet_speed()
 -- todo(m10)
end
