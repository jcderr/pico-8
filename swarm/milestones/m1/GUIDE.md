# m1 guide: from empty stubs to a running skeleton

By the end of this guide you'll have a title screen, a "play" screen that
is just stars for now, and a game-over screen. ❎ moves you between them,
and a starfield scrolls behind all three. That's milestone m1 in
`NOTES.md`.

**Work in the main `swarm/` folder, not in `milestones/`.** This folder
(`milestones/m1/`) holds a finished version of m1. Try each step yourself
first. Only open the matching file here when you're stuck, or to compare
once your version works.

Read `NOTES.md` up to "Build order" before you start. It explains the
state machine you're about to build.

---

## Step 0: get PICO-8 to see the project

PICO-8 can only open files inside its own "root" folder.

1. Open PICO-8. You get a command prompt.
2. Type `folder` and press Enter. Finder opens PICO-8's root folder
   (on a Mac, `~/Library/Application Support/pico-8/carts/`).
3. Put the project where PICO-8 can see it, either by copying the
   `swarm` folder into that root, or with a symlink from a terminal (this
   keeps a single copy):

   ```sh
   ln -s /path/to/pico-8 ~/Library/Application\ Support/pico-8/carts/jcderr
   ```

4. Back in PICO-8:

   ```
   > ls             list files and folders
   > cd jcderr      (or wherever you put it)
   > cd swarm
   > load swarm
   > run            (or press Ctrl-R)
   ```

Nothing happens yet. Every function is empty, so the cart runs and draws
nothing, and the old console text stays on screen. Press **Esc** to stop
it. That's expected.

### How you'll work from here

- Edit the `.lua` files in your normal text editor (VS Code or similar).
- Switch to PICO-8 and press **Ctrl-R**. PICO-8 re-reads the included
  `.lua` files every time you run, so you never need to reload.
- **Esc** stops the game. Pressing Esc again toggles between the console
  and the built-in editors.
- If there's an error, PICO-8 stops and prints the message and the line
  it failed on. Read it. It's usually right.

**Don't** edit `swarm.p8` in your text editor while it's loaded in
PICO-8. Saving in PICO-8 (Ctrl-S) rewrites the whole `.p8` file and will
undo your change. Your code lives in the `.lua` files, which PICO-8
never writes to, so they're safe.

---

## Step 1: put anything on screen

Goal: prove the loop is running.

Open `main.lua`. PICO-8 calls `_init()` once, then calls `_update60()`
and `_draw()` 60 times a second. That's the game loop.

In `_draw()`:

- call `cls()` to clear the screen to black
- call `print("hello", 10, 10, 7)` to print some text at (10,10) in
  colour 7 (white)

Ctrl-R. You should see "hello" on a black screen. Then delete the `print`
again; it was only a test.

> **Lua note:** `function name() ... end` defines a function. There are no
> braces or colons, and indentation doesn't matter to Lua (it's just for
> you). Blocks always close with `end`.

---

## Step 2: centred text (`print_c` in `util.lua`)

You'll print a lot of centred text, so write the helper first.

- Every character is 4 pixels wide and the screen is 128 wide, so a
  string of `n` characters starts at `x = 64 - n*2`.
- `#str` gives the length of a string. (Python's `len(str)`.)
- Call `print(str, x, y, c)`.

Test it: call `print_c("hello", 60, 7)` from `_draw()` and check it sits
in the middle. Try strings of a few different lengths.

---

## Step 3: the title screen

1. In `_init()`, set `state = "title"`.
2. In `_draw()`, after `cls()`, add a check: if `state == "title"`, call
   `draw_title()`.
3. Fill in `draw_title()` with the game's name and
   `"press ❎ to start"`, using `print_c`.

Ctrl-R. You should see your title screen.

> **Typing ❎:** inside PICO-8's own code editor, Shift+X types the ❎
> glyph. In an external editor, paste the ❎ character from this file. If
> it shows up wrong in game, write "x" instead. Only strings need the
> glyph: in code, ❎ is just button number `5`.

> **Lua note:** `==` compares, `=` assigns, and "not equal" is `~=`
> (PICO-8 also accepts `!=`). `if ... then ... elseif ... else ... end`.

---

## Step 4: the state machine

This is the main point of m1. There are three states, and ❎ moves you
from one to the next:

```
title --❎--> play --❎--> gameover --❎--> title
```

1. **Dispatch updates.** In `_update60()`, write an
   `if / elseif / elseif` chain on `state` that calls `update_title()`,
   `update_play()` or `update_gameover()`.
2. **Dispatch draws.** Do the same in `_draw()` for `draw_title()`,
   `draw_play()` and `draw_gameover()`.
3. **title → play.** In `update_title()`, if `btnp(5)` is true, call
   `start_game()`. In `start_game()`, reset `score` and `lives`, then set
   `state = "play"`.
4. **play → gameover.** In `update_play()`, if `btnp(5)` is true, set
   `state = "gameover"`. This is a temporary shortcut so you can test the
   loop. The game will end properly in m8, and you'll remove it then. Add
   a comment saying so.
5. **gameover → title.** In `update_gameover()`, ❎ sets
   `state = "title"`. Fill in `draw_gameover()` with "game over", the
   score and "press ❎".

Ctrl-R and press ❎ (the **X** key on a keyboard) a few times. You should
cycle title → black screen → game over → title.

Things to understand here:

- **Why `btnp` and not `btn`?** `btn(5)` is true on *every* frame the key
  is held, so one press would race through all three states in a few
  frames. `btnp(5)` ("button pressed") is true only on the frame the
  press starts. Try `btn` once to see the problem for yourself.
- **Why does play look black?** `draw_play()` is empty. That's correct for
  m1.
- **Update changes things; draw only reads them.** Never change `state`
  inside a `draw_` function. Keeping that rule now will save you a lot of
  trouble later.

---

## Step 5: frame counter, blinking text, input delay

1. In `_update60()`, add `frame += 1` before the dispatch. Now every part
   of the game can ask "what frame is it?"
2. **Blink the title prompt.** Only print "press ❎ to start" when
   `frame % 45 < 30`. (`%` is modulo, as in Python.) Work out why that
   makes it visible for 30 frames and hidden for 15.
3. **Delay on game over.** A player who has been mashing ❎ will skip the
   game-over screen without seeing it. Ignore ❎ for the first 60 frames
   in that state. One way is to remember `frame` at the moment you enter
   gameover and compare against it. Hide the "press ❎" prompt until input
   is allowed, so the screen doesn't lie.

Tip: you now set `state` in several places. If entering a state needs to
record something (like that frame number), a small `set_state(s)`
function keeps it all in one place. The finished version does this.

---

## Step 6: show the score properly

`score` is stored in **tens** (see "Fixed-point numbers" in NOTES.md), so
you display it with an extra `"0"` on the end. `tostr(n)` turns a number
into a string, and `..` joins strings: `"a" .. "b"` is `"ab"`.

Edge case: a score of 0 would print as "00". Write a tiny helper that
handles it, and use it on both the title (`hiscore`) and game-over
(`score`) screens.

---

## Step 7: the starfield (`fx.lua`)

Stars are your first **entity list**: a table of small tables, updated and
drawn every frame. Every enemy and bullet later works the same way, so
take your time here.

1. **`init_stars()`**: build 40 stars. Each one is a table like
   `{x=..., y=..., spd=..., c=...}`.
   - `rnd(128)` gives a random number from 0 up to (not including) 128.
   - `add(stars, s)` appends to the list (Python's `append`).
   - For depth: give each star a random layer. Far stars are slow and dim
     (colour 1 or 5); near stars are fast and bright (6 or 7).
2. **`update_stars()`**: move each star down by its `spd`. When `y` goes
   past 127, move it back to the top with a new random `x`.
   - `for s in all(stars) do ... end` loops over the list (Python's
     `for s in stars:`).
3. **`draw_stars()`**: `pset(x, y, c)` sets one pixel.
4. **Wire it up**: call `init_stars()` in `_init()`. Call
   `update_stars()` in `_update60()` and `draw_stars()` in `_draw()`,
   both *outside* the state dispatch, so stars scroll on every screen.
   In `_draw()`, draw the stars right after `cls()` and before the state's
   draw function, so text sits on top of them.

Ctrl-R. You should see a scrolling field with a sense of depth. Tweak the
speeds and colours until you like it.

> **Lua notes:**
> - Tables do the job of both Python dicts and lists. `s.x` is the same
>   as `s["x"]`.
> - Lists start at index **1**, not 0. `#stars` is the length.
> - Write `local` for variables that belong only to one function (like a
>   loop's temporary star). Without it, the variable is global.

---

## Step 8: check you're done

- [ ] Title shows the name, a blinking prompt and the high score (0).
- [ ] ❎ → black play screen with stars.
- [ ] ❎ → game over, showing the score; ❎ is ignored for about a second.
- [ ] ❎ → back to the title. Repeat as often as you like with no errors.
- [ ] Stars scroll on every screen, with slow dim ones and fast bright ones.
- [ ] No `draw_` function changes any variable.

All checked? Compare your code with the files in this folder. Different
is fine. If something in the reference surprises you, work out why it was
done that way. Then tick m1 in `NOTES.md` and move on to m2.

---

## Getting ready for m2: drawing a sprite

m2 needs a ship in **sprite 1**. m1 doesn't use any sprites, but this is
how the sprite editor works:

1. In PICO-8, press **Esc** to reach the editors. The tabs in the top
   right are code, **sprite**, map, sfx and music. Click the sprite tab
   (the second one).
2. The bottom half is the sprite sheet. Sprite 0 is top-left. Click the
   one next to it: that's **sprite 1**. (Leave sprite 0 empty. The map
   editor treats it as "no tile", so by convention it stays blank.)
3. Choose a colour from the palette and draw in the big 8×8 grid. Colour
   0 (black) is transparent when drawn, so use it for the background.
4. Draw a ship pointing up.
5. Press **Ctrl-S** to save. This writes the sprite into `swarm.p8`.
   Your `.lua` files aren't affected.

In code, `spr(1, x, y)` draws sprite 1 with its top-left corner at (x,y).

---

## When something goes wrong

- **Read the error.** It names the problem and a line number.
  "attempt to call a nil value" usually means a misspelled function name.
- **Print debugging:** `printh("x=" .. x)` writes to the terminal, but only
  if you start PICO-8 from a terminal:

  ```sh
  /Applications/PICO-8.app/Contents/MacOS/pico8 -run /path/to/swarm/swarm.p8
  ```

- **On-screen debugging:** temporarily `print()` a value at the end of
  `_draw()`, for example `print(state, 0, 0, 8)`.
- **Remember `0` is true** in Lua. Only `nil` and `false` are false.
  `if count then` is true even when `count` is 0.
