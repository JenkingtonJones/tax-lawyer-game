# Task 2 Run Note

Open the folder `tax-lawyer-game` in Godot 4.

Main scene:
`res://scenes/MainStreet.tscn`

Controls:
- Left/right arrows: move the player along the sidewalk.
- Space or Up: jump.
- E: talk to the elderly client when the prompt appears.
- Click one of the three choices, or press 1, 2, or 3, to close the dialogue and update the HUD.
- After a choice result appears, press E again to close the dialogue and return control to the player.

Assembly notes:
- The street background matched the `1280x720` aspect ratio when scaled from `1672x941`.
- Player and elderly client animation frames were already on consistent `362x362` transparent canvases.
- UI panel assets are usable, but the generated HUD bars are very large; they were scaled down in-scene rather than reprocessed.
- The elderly client worried animation uses the processed third-row frames named `client_elderly_worried_*.png`.
- Local verification note: the project opens headlessly in Godot `4.6.2.stable` without parser errors.

Interaction test:
1. Walk to the elderly client.
2. Press Space or Up while moving to confirm the player jumps and uses the walk animation in the air.
3. Confirm the player can clear the elderly client without changing the interaction outcome.
4. Press E to open the first dialogue.
5. Select a choice by clicking it or pressing 1, 2, or 3.
6. Confirm the HUD changes immediately and the result text replaces the choices.
7. Press E to close the result.
8. Press E near the same client again and confirm only "Thank you for your help." appears, with no additional rewards.

Text layout test:
1. Confirm the initial elderly client line wraps inside the dialogue panel.
2. Confirm each result line remains inside the dialogue panel.
3. Confirm the visible choice labels fit inside the choice panel as "Missing docs", "Accept receipts", and "CRA guidance".
4. Confirm no dialogue or choice text touches the panel border.
5. Confirm the longest CRA guidance result uses smaller text but remains readable.
