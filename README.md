# Tax Lawyer

A Godot prototype for a satirical tax and customs lawyer game.

The current build is an early content-and-systems prototype. It has a playable `MainStreet` test scene with movement, a dialogue interaction, HUD state, and a data-backed first customs case loaded from JSON.

## Current Prototype

- Engine target: Godot 4.6
- Main scene: `res://scenes/MainStreet.tscn`
- Controls:
  - Left/right arrows: move
  - Space or Up: jump
  - E: interact/continue
  - 1, 2, 3 or mouse click: choose dialogue options

## Content

The first customs arc is documented and partially structured for data-driven loading:

- `docs/game_content_blueprint.md`
- `docs/first_arc_case_specs.md`
- `docs/godot_content_build_blueprint.md`
- `content/cases/first_arc_cases.json`

The first playable data-backed case is `The Skulls In The Mail`, a customs advance-ruling tutorial about taxidermied skulls and collectors' pieces.

## Development Notes

Generated Godot editor caches under `.godot/` are ignored. Source assets, scenes, scripts, docs, and import metadata are tracked.
