# Godot Content Build Blueprint

This plan translates the content blueprint into Godot implementation work. It assumes Godot 4.x and the current prototype scene at `res://scenes/MainStreet.tscn`.

## Current State

- The project runs from `MainStreet.tscn`.
- Movement, HUD, dialogue, and one elderly-client interaction are hardcoded in `scripts/MainStreet.gd`.
- Existing assets are enough for placeholder player/NPC/dialogue/HUD work.
- There is no reusable case data, evidence inventory, travel system, or argument system yet.

## Target Architecture

Create a small content-driven layer before adding more cases.

Recommended folders:

- `content/cases/`: JSON case catalogues for authored case data.
- `scripts/core/`: game state, case state, content loading.
- `scripts/ui/`: dialogue, evidence, theory, and resolution presenters.
- `scripts/world/`: interactables, travel points, location controllers.
- `scenes/ui/`: reusable UI panels.
- `scenes/world/`: reusable location shells and interactables.
- `scenes/locations/`: office, street/map, customs house, warehouse, business interior, industrial interior, tribunal.

## Data Interfaces

The first implementation should load `content/cases/first_arc_cases.json` and keep the current scene code thin.

Minimum case fields:

- `id`, `title`, `source_part`, `difficulty`, `client_pitch`
- `locations`
- `npcs`
- `evidence`
- `interactions`
- `theories`
- `resolutions`
- `rewards`
- `precedent_note`
- `asset_needs`

Runtime state per case:

- `status`: locked, available, active, resolved
- `visited_locations`: array of location ids
- `discovered_evidence`: array of evidence ids
- `completed_interactions`: array of interaction ids
- `selected_theory`: theory id or empty
- `resolution`: full, partial, bad, or empty

Global campaign state:

- `money`
- `reputation`
- `audit_risk`
- `stamina`
- `day`
- `active_case_id`
- `unlocked_precedents`

## Scene Responsibilities

### Office Hub

The office is the main menu in-world.

Responsibilities:

- Show active case and available cases.
- Open case file/evidence list.
- Let player choose theory once enough evidence is discovered.
- Allow rest/calendar actions.
- Apply final case rewards.

Placeholder implementation:

- Reuse street background if needed.
- Place interactable markers named `CaseBoard`, `Desk`, `ResearchShelf`, and `Calendar`.

### Street/Map Hub

The travel hub connects locations.

Responsibilities:

- Display unlocked destinations.
- Spend stamina/time for travel.
- Load target location shell.
- Return to office.

Placeholder implementation:

- Evolve `MainStreet.tscn` into the travel hub, or duplicate it into `StreetMap.tscn` and keep `MainStreet` as a test scene.
- Use text labels and simple markers until map art exists.

### Location Shells

Each location should be a shell that reads active-case interactions and spawns only relevant placeholders.

Locations for first slice:

- `OfficeHub`
- `StreetMap`
- `CustomsHouse`
- `PortWarehouse`
- `BusinessInterior`
- `IndustrialInterior`
- `TribunalRoom`

Each shell needs:

- A background placeholder.
- A `World` node for player/interactables.
- A `UI` node using shared dialogue/evidence panels.
- A list of interaction spawn points keyed by role: client, officer, item, document, door.

### Dialogue Presenter

Replace hardcoded dialogue constants with data-driven dialogue.

Responsibilities:

- Show prompt when the player enters an `Interactable` area.
- Present line text and choices.
- Apply choice outcomes: discover evidence, complete interaction, adjust stats, unlock next interaction, or close dialogue.
- Support keyboard shortcuts 1-4 and click selection.

### Evidence Inventory

Evidence is not just collectibles; it unlocks better choices.

Responsibilities:

- Add evidence when an inspection/interview/document review succeeds.
- Show evidence cards in the active case file.
- Gate theories and argument moves by required evidence.
- Mark red herrings without punishing the player until they rely on them.

### Theory Selector

The theory selector should appear at the office desk after minimum evidence is found.

Responsibilities:

- List available theories for the active case.
- Show short tradeoff text.
- Record selected theory.
- Unlock resolution or argument encounter.

### Argument Encounter

First version can be choice-driven rather than tactical.

Responsibilities:

- Present agency/panel pressure.
- Offer argument moves unlocked by evidence and precedent notes.
- Score moves against the selected theory.
- Produce full/partial/bad resolution.

Use this first for `meaning_of_of`; Levels 1 and 2 can use simpler resolution checks.

## Implementation Order

1. Preserve the prototype by either keeping `MainStreet.tscn` as a test scene or duplicating it before refactor.
2. Add a global campaign state script and content loader that can parse `first_arc_cases.json`.
3. Refactor dialogue choice data out of `MainStreet.gd` into a reusable presenter.
4. Add generic `Interactable` nodes for NPCs, documents, item samples, doors, and map destinations.
5. Build `OfficeHub` and `StreetMap` placeholders.
6. Build `PortWarehouse` and `CustomsHouse` placeholders.
7. Implement Level 1 end to end.
8. Add evidence file UI and sorting interaction UI.
9. Implement Level 2 end to end.
10. Add Dog Chew matrix UI and Gelato argument encounter after Levels 1-2 are playable.

## Placeholder Asset Rules

- Reuse the elderly client sprite for all NPC roles until new art exists.
- Reuse UI document frames for evidence cards.
- Use existing icons for money/stamina/audit/client counters.
- Use labels for location signs and product names.
- Do not block content implementation on missing location or item art.

## Acceptance Tests

Manual tests for Levels 1-2:

- Start a new game and see the office hub.
- Accept `The Skulls In The Mail`.
- Travel to the port warehouse and customs house.
- Discover skull evidence through inspection/interview.
- Choose the strong ruling theory.
- Resolve the case and see money/reputation/audit risk/precedent updates.
- Accept `Retail Set Panic`.
- Inspect all four bundles.
- Sort them correctly and incorrectly in separate runs.
- Confirm rewards change based on sorting accuracy.
- Confirm returning to a resolved case does not grant duplicate rewards.

Technical checks:

- Project opens in Godot without parser errors.
- Case JSON loads without runtime errors.
- Missing or unknown evidence ids fail gracefully in UI.
- Dialogue text wraps inside the existing panel.
- Keyboard and mouse choice selection both work.
