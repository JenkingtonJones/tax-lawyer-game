# Tax Lawyer Game Content Blueprint

Source case file: `/opt/mantaculus/projects/Tax_Lawyer/TAX_CASES.md`

Current Godot prototype: `res://scenes/MainStreet.tscn`

Companion build artifacts:

- `docs/first_arc_case_specs.md`: implementation-ready specs for the first four customs cases.
- `docs/godot_content_build_blueprint.md`: Godot-facing architecture and build order.
- `content/cases/first_arc_cases.json`: structured case catalog for future data-driven loading.

## Narrative Premise

The player is a small-practice tax and customs lawyer in a city where every commercial crisis turns on a strange technical classification problem. Clients arrive with goods stuck at the border, rulings they do not understand, reassessments they cannot afford, or agency positions that sound absurd until a duty rate, audit risk, or VAT bill appears.

The story frame is not about becoming a heroic litigator in the usual sense. It is about building a serious practice in a world where the difference between "duty free" and "commercial catastrophe" may depend on whether a dog chew is leather, feed, bone, offal, or dairy.

The game should stay readable and satirical. Legal doctrine is real enough to give the player meaningful choices, but every scene should translate that doctrine into concrete facts: packaging, ingredients, marketing, production method, intended use, expert evidence, agency conduct, and missing paperwork.

## Player Goals

The player's immediate goal in each case is to convert a confused client problem into a defensible legal position before the file becomes too risky or expensive.

The longer campaign goal is to grow the practice from a one-lawyer storefront into a respected customs and indirect-tax shop. Progress is measured through:

- Money: fees earned, refunds recovered, penalties avoided, and office upgrades purchased.
- Reputation: unlocks higher-stakes clients, tribunal matters, and agency attention.
- Client confidence: rises when the player asks useful questions and avoids premature conclusions.
- Audit risk: rises when the player makes sloppy filings, accepts weak facts, or ignores classification traps.
- Stamina/time: spent on travel, research, interviews, inspections, and argument encounters.
- Precedent notes: reusable legal ideas gained from completed cases, later used as stronger argument moves.

The player should feel that progress comes from practicing law better: identifying the real issue, finding the decisive fact, choosing the correct theory, and knowing when a case is really about procedure rather than money.

## Core Loop

1. Intake: a client describes the problem in ordinary, confused, or emotional terms.
2. Triage: the player identifies the live issue, likely authority, and potential stakes.
3. Travel: the player visits the relevant location to gather facts or documents.
4. Investigation: the player interviews NPCs, inspects goods, reviews records, and finds contradictions.
5. Analysis: the player chooses a theory and assembles facts, law, and positioning.
6. Argument: the player faces an agency officer or tribunal panel in a compact argument battle.
7. Resolution: the file closes with money, reputation, risk, client confidence, and precedent effects.
8. Practice growth: the office, map, case list, and available research tools expand.

This loop should support short errands, medium investigations, and boss-style argument cases without changing the basic verbs.

## Game Layers

### Office Layer

The office is the player's base. It should handle intake, case selection, research, drafting, stamina recovery, and upgrades.

Office interactions:

- Client chair: accept or defer new files.
- Desk: review active case notes and choose the next task.
- Research shelf: unlock or review precedent notes.
- Filing cabinet: sort documents and identify missing evidence.
- Calendar: manage deadlines and decide whether to spend time researching, traveling, or resting.

Current prototype fit: the existing `MainStreet` dialogue and HUD can be refactored into office intake plus street/client interaction. The current elderly-client interaction is a useful mechanical test, but its content should become data-driven rather than hardcoded.

### World And Travel Layer

The map should become a compact legal-economic city board. It does not need to be large at first. It needs clear destinations that imply case activity.

Core districts:

- Law office: home base, intake, research, drafting, rest.
- Customs house: advance rulings, tariff disputes, CBSA-style classification positions.
- Port warehouse: inspect goods, packaging, labels, samples, and seized shipments.
- Tribunal: boss encounters, oral argument, precedent unlocks.
- Business district: importers, distributors, retailers, product managers.
- Grocery plaza: food tax and hot-food side cases.
- Industrial edge: manufacturers, pet chew plant, gelato powder importer, product testing.
- Government tax office: reassessments, document requests, procedural pressure.

Travel should cost time or stamina. Early game travel can be menu-style or scene-door based; later versions can use an overworld map.

### Fact-Gathering Layer

Facts are the player's ammunition. Each case should expose facts in a small set of repeatable interaction types:

- Interview: ask a client, employee, officer, or expert about the product or transaction.
- Inspect item: examine product samples, packaging, labels, ingredients, manuals, or display setup.
- Review document: invoices, ruling requests, agency letters, marketing sheets, product specs, temperature logs.
- Spot contradiction: compare what a document says against how the product is actually sold or used.
- Request missing evidence: spend time or client confidence to unlock a stronger fact later.

Each fact should have a gameplay purpose. It should unlock a better argument, prevent a bad argument, lower risk, or reveal that the case is about a different issue than the client thought.

### Analysis Layer

Analysis is where the player turns facts into a legal theory. Choices should be short, specific, and risky enough to matter.

Recurring theories:

- Intended use: what the good is designed and marketed to do.
- Possible misuse: whether odd user behavior should affect classification.
- Essential character: which component gives a set its identity.
- Production method: how the good is made, not just what it is for.
- Material composition: ingredients, milk solids, rawhide, starch, protein, bone, offal.
- Functional essentiality: whether an ingredient is more essential than others.
- Ordinary meaning: whether a word like "climbing" should be broad or narrow.
- Commercial stake: whether an abstract classification fight matters if no duty changes.
- Administrative conduct: whether the authority's rulings or inspections created unfairness.

The analysis layer should be visible in the UI as a small "Theory" choice before an argument encounter, not as a long legal memo.

### Argument Layer

Argument encounters are compact battles against an agency officer, auditor, or tribunal panel. The player spends gathered facts and precedent notes as moves.

Move categories:

- Present fact: use a gathered fact to support the current theory.
- Cite rule: invoke a tariff rule, heading, explanatory note, or tax test.
- Distinguish: explain why a harmful analogy does not control.
- Cross-examine: challenge an expert, agency assumption, or witness statement.
- Reframe issue: change the fight from form to function, from use to production, or from classification to commercial stake.
- Request ruling/extension: avoid a bad immediate result at the cost of time or money.
- Concede and contain: accept a weaker point to reduce audit risk or preserve client confidence.

The first implementation should keep these as choice-driven encounters, not full tactical combat. Each move can adjust agency pressure, panel patience, client confidence, and case score.

## First Content Arc: Customs Practice Opens

This arc should be the first playable target after the current prototype shell. It teaches classification by escalating from straightforward ruling to nuanced expert evidence.

### Level 1: The Skulls In The Mail

Case source: Part 5, taxidermied skulls.

Narrative role: tutorial case for customs intake, advance rulings, item inspection, and a low-stakes win.

Client problem: an importer has cleaned animal skulls and jawbones from Australia and wants to know whether customs will treat them as collector pieces.

Locations:

- Office: intake and ruling request review.
- Customs house: ruling desk interaction.
- Port warehouse: inspect cleaned skull samples.

Key facts:

- The goods are dog, cat, and kangaroo skulls/jawbones.
- They were naturally decomposed, cleaned with dish soap, and treated with hydrogen peroxide.
- They are for personal display.
- The proposed classification is collectors' pieces of zoological or anatomical interest.

Player progress:

- Inspect samples to confirm they are preserved display items, not food, trophies, or commercial animal products.
- Review the ruling request and choose whether to emphasize "dead animals preserved for collections" or a less useful general animal-product theory.
- Submit the advance ruling position.

Resolution:

- Good play creates an easy ruling win, money, small reputation, and the precedent note "Advance rulings need a product story."
- Weak play still resolves but earns less confidence because the player overcomplicates an easy file.

Needed content:

- Client: oddities importer or collector.
- Item sprites: skull display samples, document/ruling letter.
- Scenes: office intake, warehouse inspection corner, customs ruling counter.

### Level 2: Retail Set Panic

Case source: Part 2, WCO retail set examples.

Narrative role: teaches essential character and the difference between goods merely packaged together and goods intended to be used together.

Client problem: a gift-box distributor wants one tariff answer for bundled food and household products.

Locations:

- Business district: distributor office.
- Port warehouse: inspect gift boxes and meal bundles.
- Office: compare examples and draft theory.

Key examples:

- Canned goods assortment: shrimp, pate, cheese, bacon, cocktail sausages.
- Beef sandwich with fries.
- Uncooked spaghetti with cheese and tomato sauce.
- Coffee jar with ceramic cup and saucer.

Player progress:

- Sort bundles into "single activity/meal" versus "selection of products."
- Identify which component gives essential character when the rule applies.
- Avoid treating every retail box as a set just because it is sold together.

Resolution:

- Strong play unlocks the precedent note "Essential character only matters after the set rule applies."
- Poor play increases audit risk by applying the rule too broadly.

Needed content:

- Item cards for each bundle.
- Sorting UI using document-card frames.
- NPC distributor and customs officer dialogue.

### Level 3: Dog Chew Apocalypse

Case source: Part 3, dog chew classifications.

Narrative role: first multi-branch customs investigation. It teaches that classification may turn on production method and material composition rather than product purpose.

Client problem: a pet product importer has multiple dog chew SKUs under review and needs to know which ones carry major duty or compliance risk.

Locations:

- Industrial edge: pet chew plant.
- Port warehouse: detained shipment.
- Customs house: compliance-priority warning.
- Office: SKU matrix and risk analysis.

Product branches:

- Cleaned, simply cut bone: classify as bone.
- Bone with meat, cartilage, ears, tendons, snouts, or offal: animal products not elsewhere specified.
- Extruded animal/vegetable inputs with binders and flavourings: preparations for animal feeding.
- Rawhide chew: article of leather, not food.
- Braided rawhide with starch and protein: preparation for animal feeding.
- Hardened yak cheese chew: dairy product and supply-management danger.

Player progress:

- Interview production staff about cleaning, extrusion, braiding, binders, and flavourings.
- Inspect ingredient lists and samples.
- Build an SKU classification table.
- Flag cheese-based dog chews as the high-risk compliance priority.

Resolution:

- Strong play earns money, reputation, and "Production method beats product vibes."
- Missing the yak-cheese branch can trigger a major duty hit and high audit risk.

Needed content:

- Multiple dog chew item sprites or placeholder cards.
- Plant NPC, importer NPC, customs compliance NPC.
- Case matrix UI with six rows and classification outcomes.

### Level 4: Meaning Of "Of"

Case source: Part 7, gelato/ice cream powders.

Narrative role: first boss-style argument. It teaches that a tiny word can carry high financial stakes and that expert evidence can defeat an intuitive agency position.

Client problem: an importer faces a 250.5% dairy duty because customs says flavoured powders are food preparations "of" milk.

Locations:

- Office: intake and tariff-stakes briefing.
- Industrial edge: gelato powder importer.
- Product lab: expert testimony about ingredients and function.
- Tribunal: argument encounter.

Key facts:

- Powders contain milk solids, fat components, sweeteners, stabilizers, emulsifiers, and flavouring.
- Sugar is the largest component by percentage.
- Milk is less than 50%.
- The agency argues that containing milk means the goods are preparations "of" milk.
- The better issue is whether milk/dairy is more essential to purpose and function than the other ingredients.
- Expert evidence says every ingredient has an important functional contribution.

Player progress:

- Gather ingredient percentages.
- Interview experts about function, texture, taste, quality, and rehydration.
- Choose between a weak percentage-only theory and a stronger functional-essentiality theory.
- Argue that the goods are not based on milk because milk is not more essential than the other ingredients.

Resolution:

- Strong play wins a major duty reduction, high reputation, and the precedent note "Of means based on; based on means essentiality."
- Weak play may avoid total disaster but leaves money on the table and raises client frustration.

Needed content:

- Gelato importer NPC, expert witness NPC, customs counsel/panel sprites.
- Ingredient document cards.
- Tribunal scene with argument choices and pressure meter.

## Later Expansion Cases

### Smart Fitness Mirror

Case source: Part 1.

Use as a mid-game intended-use case. The player must decide whether the possibility of passive watching defeats classification as exercise equipment. It pairs well with item inspection, marketing review, and a tribunal debate about whether misuse is really use.

Primary locations: business district, showroom, tribunal.

Useful unlock: "Possible misuse does not always define the good."

### Hot Chicken Incident

Case source: Part 6.

Use as a grocery-plaza side arc or indirect-tax district opener. The player investigates packaging, heat retention, display method, advertising, and agency conduct. It should feel like an investigative comedy with serious money behind it.

Primary locations: grocery plaza, government tax office, tribunal.

Useful unlock: "Marketing and actual sale conditions can diverge."

### Rotating Playground Climber

Case source: Part 8.

Use as a later ordinary-meaning case. The player debates whether "climbing" means broad physical movement or something narrower when paired with mountaineering.

Primary locations: playground equipment importer, municipal park/showroom, tribunal.

Useful unlock: "Dictionary meaning may be too broad without context."

### Cheese Fondue With No Money At Stake

Case source: Part 9.

Use as a late-game procedural comedy case. The player discovers that the agency and importer are fighting over classification even though the duty rate is zero either way. The winning theory may be to attack the purpose of the proceeding rather than the classification itself.

Primary locations: customs house, tribunal.

Useful unlock: "No commercial stake, no real fight."

### Residential Rental Risk Board

Case source: Part 4.

Use as optional advisory content, not part of the first customs arc. It can become a bulletin-board or consulting side system where the player reviews non-customs risk memos for money and reputation.

Primary locations: office, government tax office, development site.

Useful unlock: indirect-tax practice expansion.

## Progression Structure

### Case Difficulty

Cases should escalate along three axes:

- Fact complexity: from one product sample to multiple SKUs, ingredients, documents, and witnesses.
- Legal ambiguity: from a clean advance ruling to competing theories with weak analogies.
- Stakes: from small fees and confidence to major duty, penalties, reputation, and precedent.

Recommended first arc difficulty:

1. Taxidermied skulls: one good, one strong classification, low risk.
2. Retail sets: several examples, one interpretive rule, moderate risk.
3. Dog chews: several product branches, production method, high compliance risk.
4. Gelato powders: high-stakes boss file, expert evidence, nuanced wording.

### Resources

Money should buy office upgrades, research tools, and later staff support.

Stamina should limit how much interviewing, traveling, and arguing the player can do before resting.

Time should matter through deadlines, client patience, and whether missing evidence arrives before an argument.

Audit risk should be a campaign pressure meter. It rises from sloppy positions and falls through careful facts, advance rulings, and procedural wins.

Reputation should unlock higher-stakes files and new map districts.

Precedent notes should be the most important progression reward because they change later argument options.

### Player Choice Quality

Choices should not be simple right/wrong trivia. They should ask the player to choose the theory that best fits the gathered facts.

Good choices:

- Use specific facts.
- State a legal theory in plain language.
- Carry a visible tradeoff.
- Unlock a stronger argument later.

Weak choices:

- Sound plausible but overgeneralize.
- Ignore a decisive fact.
- Use the wrong test.
- Resolve the case with worse money, risk, or confidence.

## Content Template For Each Case

Each case should be authored into the same structure before scripting:

- Case title.
- Source part from `TAX_CASES.md`.
- Client pitch.
- Stakes.
- Primary legal issue.
- Locations used.
- NPCs required.
- Evidence items.
- Key facts.
- Red herrings.
- Player theories.
- Argument moves unlocked by evidence.
- Success state.
- Partial-success state.
- Failure or bad-resolution state.
- Rewards: money, reputation, risk changes, precedent note.
- Asset needs.
- Godot scene needs.

This template is the bridge between writing and implementation. Once a case is filled in, the Godot work should mostly become data entry, interaction placement, and UI wiring.

## World Map And Scene Implications

The first map does not need final art. It needs a clear topology that supports the loop.

Minimum first-build scenes:

- Office hub: accepts cases, shows active file, research shelf, calendar/rest.
- Street/map hub: connects office to destination doors or markers.
- Customs house counter: agency dialogue, ruling requests, compliance warnings.
- Port warehouse: item inspection and detained goods.
- Business/industrial interior: client and production interviews.
- Tribunal room: argument encounter.

The current `MainStreet` scene can evolve into either the street/map hub or a small office-street transition scene. Do not pile all future logic into `MainStreet.gd`; split reusable systems before adding many cases.

Recommended Godot systems for the next implementation pass:

- `CaseData` resources or JSON/dictionary data for case content.
- Reusable interaction component for NPCs, documents, doors, and item samples.
- Dialogue presenter that reads lines and choices from case data.
- Evidence inventory that tracks discovered facts.
- Case state object for progress, active theory, rewards, and resolution.
- Map transition controller for moving between locations.
- Argument encounter controller for legal choice battles.

## Asset Implications

Use placeholders until the blueprint and first arc are stable. New AI asset work should be commissioned after the first four case structures are locked.

Assets needed for the first arc:

- NPCs: collector/importer, gift-box distributor, pet product importer, plant worker, gelato importer, expert witness, customs officer, tribunal panel.
- Locations: office interior, customs house, port warehouse, industrial plant, product lab, tribunal room.
- Items: skull display samples, meal/gift bundles, dog chew variants, ingredient sheets, powder bags, ruling letters, agency notices.
- UI: evidence cards, case file panel, map markers, theory selector, argument pressure meter, precedent-note display.

Existing usable assets:

- Player idle/walk/talk frames.
- Elderly client idle/talk/worried frames.
- Street background.
- HUD, dialogue, choice, document, icon, and panel assets.

## First Playable Vertical Slice Target

The first substantial Godot build should cover one complete mini-arc rather than all cases shallowly.

Recommended slice:

- Office hub with one active case file.
- Travel to customs house and port warehouse.
- One full tutorial case: The Skulls In The Mail.
- One structured sorting case: Retail Set Panic.
- Shared evidence inventory and dialogue system.
- Basic resolution rewards: money, reputation, audit risk, and one precedent note.

Dog Chew Apocalypse and Meaning Of "Of" should be authored immediately after this slice because they prove the systems can handle branching classification and boss argument logic.

## Acceptance Criteria For This Blueprint

Future work can be considered aligned with this document if:

- Customs classification remains the center of the first playable arc.
- Each level has a clear case source, player goal, location set, evidence set, and resolution.
- New scenes exist to serve the gameplay loop, not just to show more art.
- Legal concepts are playable through facts and choices, not long exposition.
- Progression rewards improve the player's practice and later argument options.
- Placeholder art is acceptable until the first case arc structure is stable.
