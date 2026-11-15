# swarm

A fixed-screen shooter. The player ship slides along the bottom of the
screen. Enemies fly in along curved paths, settle into a formation at the
top, and then peel off in ones and twos to dive at the player while
shooting. Clear the wave and the next one comes in faster.

## Architecture

Think of it as a single-process event loop running at 60 fps, with a
small state machine on top:

```
          btnp(❎)               lives == 0
 title ───────────▶ play ────────────────────▶ gameover
   ▲                 │  ▲                          │
   │                 ▼  │ wave cleared             │ btnp(❎)
   │               (next wave)                     │
   └───────────────────────────────────────────────┘
```

Each frame, PICO-8 calls `_update60()` and then `_draw()`. `main.lua`
dispatches both to whatever state is active (`update_play`,
`draw_play`, and so on). Keep **update** (change state) and **draw** (read
state, put pixels on screen) strictly separate. Never move anything inside a
draw function.

Everything that moves is an **entity**: a plain Lua table with fields such
as `x`, `y`, and `state`. Entities of the same kind live in a list (a table
used as an array). Every frame you loop over each list to update it, and
loop again to draw it. That is the whole engine. It's the same idea as a
worker pulling jobs off a queue: no classes or inheritance, just data and
functions that operate on it.

| list        | file          | contents                              |
|-------------|---------------|---------------------------------------|
| `player`    | `player.lua`  | a single table, not a list            |
| `pbullets`  | `bullets.lua` | player shots, moving up               |
| `ebullets`  | `bullets.lua` | enemy shots, moving at an angle       |
| `enemies`   | `enemies.lua` | every live enemy, whatever its state  |
| `particles` | `fx.lua`      | explosion sparks                      |
| `stars`     | `fx.lua`      | background starfield                  |

### Enemy states

Each enemy runs its own small state machine. This is the heart of the game.

```
 entering ──(path done)──▶ formation ──(picked to dive)──▶ diving
                               ▲                              │
                               └──── returning ◀──(off bottom)┘
```

- **entering**: follows an entry path (a Bézier curve) from off-screen to
  its formation slot.
- **formation**: sits at its slot, which sways left and right with the
  whole formation.
- **diving**: follows a dive path down toward the player, firing.
- **returning**: has wrapped back to the top of the screen and steers
  toward its (moving) slot.

### Formation slots

An enemy doesn't store a fixed position in the formation. It stores a
**slot** (`col`, `row`). Each frame, `slot_pos(col,row)` turns that slot
into pixels using a global formation offset that oscillates over time.
That one sine wave makes the whole formation sway together for free.

## Build order (milestones)

Each milestone should run and show something on screen. Commit or back up
before starting the next one. `-- todo(m3)` tags in the `.lua` files map
to these numbers.

- [x] **m1 — skeleton**: state machine in `main.lua`. Title screen text;
      ❎ goes to play (a black screen) and ❎ again goes to gameover. Add
      the scrolling starfield.
- [ ] **m2 — player**: draw the ship and move it left/right with
      `btn(0)`/`btn(1)`, clamped to the screen edges.
- [ ] **m3 — shooting**: 🅾️ fires. At most 2 player bullets on screen at
      once. Bullets move up and are removed when they leave the screen.
- [ ] **m4 — static formation**: spawn a grid of enemies directly in
      `formation` state and draw them at their slots.
- [ ] **m5 — collision**: player bullets destroy enemies, spawn an
      explosion, and add to the score. Draw the score in a HUD.
- [ ] **m6 — sway**: the formation offset oscillates and all enemies move
      with it.
- [ ] **m7 — diving**: every so often, pick a random enemy in formation and
      switch it to `diving`. It follows a curve down the screen, then wraps
      to the top and `returning` brings it back to its slot.
- [ ] **m8 — danger**: diving enemies fire aimed bullets. Enemy bullets and
      enemy bodies kill the player. Lives, a short respawn delay, and game
      over at 0 lives.
- [ ] **m9 — entry paths**: new waves fly in along Bézier paths in
      staggered groups instead of appearing in place.
- [ ] **m10 — waves**: when all enemies are dead, start the next wave with
      more frequent dives and faster bullets. Save a high score with
      `cartdata`.
- [ ] **m11 — polish**: sfx, screen shake on death, enemy hit-flash, more
      enemy kinds (see `enemy_kinds` in `enemies.lua`).

## Sprite sheet plan

Draw these in the sprite editor. The stubs refer to them by number.

| sprite | use                                             |
|--------|-------------------------------------------------|
| 1      | player ship                                     |
| 2      | player bullet (or skip it and use `rectfill`)   |
| 16, 17 | drone, 2 animation frames                       |
| 18, 19 | stinger, 2 animation frames                     |
| 20, 21 | carrier, 2 animation frames                     |
| 22     | carrier, damaged                                |

## Concepts you'll run into

- **Removing from a list while looping over it.** `del(t, v)` inside a
  `for v in all(t)` loop is safe in PICO-8 (it's documented to work).
  With a numeric `for i=1,#t` loop it isn't: either go backwards
  (`for i=#t,1,-1`) or mark the item dead and sweep later. Know why.
- **AABB collision.** Two rectangles overlap unless one is entirely to the
  left of, right of, above, or below the other. That's 4 comparisons.
  Lives in `util.lua`.
- **PICO-8 trig uses turns, not radians.** `sin(0.25)` is a quarter turn.
  Also, **`sin()` is inverted** (screen y points down), so `sin(0.25)` is
  `-1`. `atan2(dx, dy)` returns turns in 0..1. You'll need it to aim
  enemy bullets at the player.
- **Bézier curves.** A cubic Bézier is just `lerp` nested three times. Once
  you have `lerp(a,b,t)`, `bezier(...)` is a few lines. Moving `t` from
  0 to 1 over N frames makes something follow the curve. Both entry paths
  and dive paths can use it.
- **Fixed-point numbers.** PICO-8 numbers top out at 32767. A score can
  overflow that, so the stub keeps score in **tens** and prints it with a
  trailing `"0"`. Also be careful with `t+=1/60`-style timers: small
  fractions add up rounding error. Integer frame counters are safer.
- **Randomness.** `rnd(n)` gives a float in [0,n). `flr(rnd(n))` gives an
  int. `rnd(tbl)` picks a random element of a table.
- **Persistence.** `cartdata("jcderr_swarm")` once in `_init`, then
  `dget(0)`/`dset(0, v)` for the high score.

## File layout and include order

`swarm.p8` includes the files in this order: `util`, `fx`, `player`,
`bullets`, `enemies`, `waves`, `main`. Functions can call each other in
any order (by the time `_init` runs, everything is defined). Top-level
*constants* must be defined before another file's top-level code uses
them, which is why `util` comes first.
