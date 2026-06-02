# First Arc Case Specs

Source file: `/opt/mantaculus/projects/Tax_Lawyer/TAX_CASES.md`

This document turns the first customs arc into implementation-ready gameplay content. It should be used with `docs/game_content_blueprint.md` and `content/cases/first_arc_cases.json`.

## Arc Shape

The first arc teaches customs classification through four cases:

1. The Skulls In The Mail: advance ruling tutorial.
2. Retail Set Panic: sorting and essential character tutorial.
3. Dog Chew Apocalypse: branching SKU investigation.
4. Meaning Of "Of": boss-style expert evidence and tribunal argument.

Each case should run through the same verbs:

- Intake: client explains the problem in plain language.
- Travel: player selects a destination from the office/street map.
- Investigation: player interviews, inspects items, and reviews documents.
- Theory: player chooses the legal theory that best fits the gathered facts.
- Argument/resolution: player applies facts and theory against an agency position.
- Reward: player earns money, reputation, risk changes, and possibly a precedent note.

## Shared First-Arc Locations

- Office hub: case intake, active file board, research shelf, calendar/rest, theory selector.
- Street/map hub: destination selector; can reuse `MainStreet` temporarily.
- Customs house: advance ruling desk, compliance warning, agency officer encounters.
- Port warehouse: detained goods, sample inspection, packaging/document checks.
- Business district: importer/distributor offices.
- Industrial edge: production plant and product lab.
- Tribunal room: boss argument scene.

Use placeholder doors/markers for all destinations until final location art is commissioned.

## Level 1: The Skulls In The Mail

### Intent

Tutorial case for customs intake, advance rulings, and item inspection. The player should learn that an advance ruling works better when the product story is specific and coherent.

### Client Pitch

An oddities importer has cleaned dog, cat, and kangaroo skulls and jawbones from Australia. They want to know whether customs will accept them as collectors' pieces for personal display.

### Scene Flow

1. Office intake: client describes the goods and asks if the ruling request is "too weird."
2. Port warehouse: inspect skull and jawbone samples.
3. Office desk: review the draft ruling request.
4. Customs house: submit the argument to the ruling officer.
5. Office resolution: receive ruling result and precedent note.

### Required Interactions

- Interview client:
  - Ask origin and use.
  - Ask how the goods were cleaned.
  - Ask whether they are food, trophies, or retail goods.
- Inspect samples:
  - Confirm dog, cat, and kangaroo skulls/jawbones.
  - Confirm no flesh remains.
  - Confirm dry personal display use.
- Review ruling request:
  - Identify proposed classification as collectors' pieces of zoological/anatomical interest.
  - Choose whether to tell a product story or file generic animal-product wording.

### Evidence Items

- `sample_cleaned_skulls`: cleaned skull and jawbone samples.
- `cleaning_process_note`: natural decomposition, dish soap soak, hydrogen peroxide treatment.
- `display_use_statement`: personal display use.
- `draft_advance_ruling`: draft classification request.

### Theory Choices

- Strong: "Treat them as preserved collectors' pieces; explain what they are, how they were cleaned, and why they are display items."
- Weak: "Treat them as generic animal products; avoid the odd details."
- Bad: "Treat them as food/agricultural goods because they are animal remains."

### Resolution Rules

- Strong theory with at least three evidence items: full win, low audit risk, precedent note.
- Weak theory with at least two evidence items: ruling accepted, lower client confidence.
- Bad theory or missing inspection: no fatal loss, but reduced money and higher risk because the player made an easy file harder.

### Rewards

- Full: money +250, reputation +1, audit risk -5, precedent `advance_rulings_need_product_story`.
- Partial: money +150, reputation +0, audit risk +0.
- Bad: money +75, reputation +0, audit risk +8.

## Level 2: Retail Set Panic

### Intent

Sorting case for sets put up for retail sale. The player should learn that "essential character" matters only after determining that the bundled goods are intended to be used together.

### Client Pitch

A gift-box distributor wants a single tariff answer for several bundled products and assumes every box sold together is a "set."

### Scene Flow

1. Business district: distributor shows product bundles.
2. Port warehouse: inspect actual bundles and packaging.
3. Office desk: sort examples into "set" or "selection."
4. Customs house: explain classification logic to an officer.
5. Office resolution: unlock precedent note.

### Required Interactions

- Interview distributor:
  - Ask whether the bundle supports one activity or is simply a gift assortment.
  - Ask how customers are expected to use the goods.
- Inspect bundles:
  - Canned goods assortment.
  - Beef sandwich with fries.
  - Spaghetti, grated cheese, and tomato sauce.
  - Coffee jar with cup and saucer.
- Sorting UI:
  - Drag or choose each item card into "single use/set" or "selection."
  - Then choose essential character only for valid sets.

### Evidence Items

- `canned_goods_assortment`
- `sandwich_fries_meal`
- `spaghetti_meal_kit`
- `coffee_cup_saucer_box`
- `wco_set_rule_note`

### Correct Sorting

- Canned goods assortment: selection, no single joint activity.
- Sandwich and fries: set/meal, essential character is sandwich.
- Spaghetti, cheese, sauce: set/meal, essential character is spaghetti.
- Coffee, cup, saucer: selection, not a set under the rule.

### Theory Choices

- Strong: "First ask whether the goods are intended to be used together; only then apply essential character."
- Weak: "Everything in one retail box is a set."
- Bad: "Choose the highest-value component every time."

### Resolution Rules

- Four correct sorts plus strong theory: full win and precedent.
- Three correct sorts: partial win, minor client frustration.
- Fewer than three correct sorts: audit risk increase and no precedent.

### Rewards

- Full: money +325, reputation +1, audit risk -3, precedent `essential_character_after_set_rule`.
- Partial: money +225, reputation +0, audit risk +3.
- Bad: money +100, reputation +0, audit risk +12.

## Level 3: Dog Chew Apocalypse

### Intent

First multi-branch investigation. The player should learn that customs classification may turn on production method and material composition rather than the product's consumer-facing purpose.

### Client Pitch

A pet product importer has six dog chew SKUs under review. Customs has flagged cheese-based dog chews as a compliance priority and the client does not understand why one chew is "leather," another is "animal feeding," and another is a dairy crisis.

### Scene Flow

1. Office intake: importer unloads the SKU problem.
2. Port warehouse: inspect detained shipment and samples.
3. Industrial edge: interview production staff.
4. Customs house: receive compliance warning.
5. Office desk: fill SKU classification matrix.
6. Customs house: submit risk memo and containment plan.

### Required Interactions

- Interview importer:
  - Ask which SKUs are detained.
  - Ask which SKUs have dairy inputs.
  - Ask whether any products are rawhide.
- Interview plant worker:
  - Ask whether products are simply cut, extruded, braided, or hardened/dried.
  - Ask about binders, flavourings, starch, protein, lime juice, and sea salt.
- Inspect samples:
  - Bone chew.
  - Bone with tissue/offal.
  - Extruded animal/vegetable chew.
  - Flavoured rawhide chew.
  - Braided rawhide with starch/protein.
  - Hardened yak cheese chew.
- Build SKU matrix:
  - One row per SKU.
  - Columns: material, process, correct classification, risk flag.

### Evidence Items

- `plain_cut_bone_sample`
- `bone_with_tissue_sample`
- `extruded_chew_formula`
- `rawhide_chew_sample`
- `braided_rawhide_formula`
- `yak_cheese_ingredient_sheet`
- `compliance_priority_notice`

### Correct SKU Outcomes

- Cleaned, simply cut bone: bone.
- Bone with meat/cartilage/ears/tendons/snouts/offal: animal products not elsewhere specified.
- Extruded animal/vegetable inputs with binders/flavourings: preparations for animal feeding.
- Rawhide chew: article of leather, not food.
- Braided rawhide with starch/protein: preparations for animal feeding.
- Hardened yak cheese chew: dairy product and high supply-management risk.

### Theory Choices

- Strong: "Classify each SKU by material composition and production method, then isolate the cheese chew as the highest compliance risk."
- Weak: "Classify all chews as pet food because dogs chew them."
- Bad: "Classify all chews as animal products because they come from animals."

### Resolution Rules

- All six rows correct and cheese risk flagged: full win, major reputation.
- Four or five rows correct and cheese risk flagged: partial win.
- Cheese risk missed: bad resolution even if other rows are mostly correct.

### Rewards

- Full: money +575, reputation +2, audit risk -6, precedent `production_method_beats_product_vibes`.
- Partial: money +350, reputation +1, audit risk +5.
- Bad: money +150, reputation -1, audit risk +25.

## Level 4: Meaning Of "Of"

### Intent

First boss case. The player should learn that high-stakes customs arguments can turn on small words, expert evidence, and functional essentiality rather than only ingredient percentages.

### Client Pitch

A gelato powder importer faces a 250.5 percent dairy duty because customs says flavoured powders are food preparations "of" milk. The client thinks the case is simple because sugar is the largest ingredient and milk is less than half.

### Scene Flow

1. Office intake: importer explains duty shock.
2. Business/industrial interior: review ingredient sheets and product use.
3. Product lab: interview expert witnesses about functional contribution.
4. Office desk: choose theory.
5. Tribunal room: argument encounter against customs counsel/panel.
6. Office resolution: result and precedent note.

### Required Interactions

- Interview importer:
  - Ask what the powders make.
  - Ask what customs says "of milk" means.
  - Ask about duty exposure.
- Review documents:
  - Ingredient percentage sheet.
  - Customs assessment.
  - Prior "of means based on" note.
- Interview experts:
  - Ask whether milk is the most essential ingredient.
  - Ask what sugar, stabilizers, emulsifiers, fat components, flavouring, and rehydrating milk each do.
  - Ask whether every ingredient is fundamental to taste, texture, quality, and performance.
- Tribunal argument:
  - Present functional evidence.
  - Distinguish "contains milk" from "based on milk."
  - Avoid relying only on a 50 percent threshold.

### Evidence Items

- `ingredient_percentage_sheet`
- `customs_dairy_assessment`
- `of_means_based_on_note`
- `expert_functional_contribution`
- `rehydration_process_note`
- `duty_exposure_summary`

### Theory Choices

- Strong: "`Of milk` means based on milk; based on milk asks whether milk/dairy is more essential to purpose and function than the other ingredients."
- Partial: "Milk is under 50 percent, so the powders cannot be of milk."
- Bad: "The powders make ice cream, so customs is probably right."

### Argument Moves

- Present ingredient percentages: useful but insufficient alone.
- Present expert functional contribution: strong.
- Reframe "of" as "based on": strong if prior note is found.
- Attack duty rate as unfair: weak unless tied to classification.
- Concede milk is important but not more essential: strong.
- Argue sugar percentage alone controls: partial only.

### Resolution Rules

- Strong theory plus expert evidence plus prior note: full tribunal win.
- Percentage-only theory plus documents: partial reduction, no full precedent strength.
- Missing expert evidence: customs position largely holds.

### Rewards

- Full: money +900, reputation +3, audit risk -8, precedent `of_means_based_on_essentiality`.
- Partial: money +450, reputation +1, audit risk +8.
- Bad: money +100, reputation -1, audit risk +30.

## First Vertical Slice Recommendation

Build Levels 1 and 2 first. They prove the reusable systems without requiring complex branching argument logic:

- Office hub with case board and active file state.
- Street/map destination selection.
- Customs house and port warehouse placeholder scenes.
- Reusable dialogue presenter.
- Evidence inventory and discovery UI.
- Theory selector.
- Simple resolution/reward application.
- Retail sorting UI.

Then author Levels 3 and 4 against the same systems. Do not implement dog-chew or gelato special cases as one-off scene scripts unless the shared content system cannot express them.
