# 2026 Program Plan -- "Kaleidoscope"

Planning doc for the 2026 TEDxBreckenridge **digital program** -- a responsive,
mobile-first web page that replaces last year's printed program book. This
captures **structure and content decisions only**, not visual design (a design
is still to be chosen) and not the live pages themselves. Nothing here has been
built yet.

Source material analyzed: `~/Downloads/2025_TEDxProgram-Book_V4.pdf` (the 2025
"Metamorphosis" printed program, 13 pages / 24 spreads), cross-referenced
against the current repo (which is the deployed tedxbreckenridge.com).

## Decisions locked in

- **Theme: Kaleidoscope.** (`_config.yml` still reads `theme: "TBA"` -- update it
  when the page is built. A `kaleidoscope.css` / `theme-kaleidoscope` design
  system already exists in the repo and is applied by the `page` layout.)
- **A separate `/program/` page**, distinct from `/speakers/`. `/speakers/`
  stays the bio-depth "browse the lineup" page; `/program/` is the event-day
  agenda an attendee opens on their phone.
- **Web-native, not a print replica**, and **mobile-first is the priority** --
  most attendees load it on a phone, at the venue, possibly on weak signal, in a
  dim theater.
- **Dark by default.** The program page should render on a dark background to
  minimize distraction in the theater and reduce eye strain. (This is a
  page-level default, not a viewer preference toggle -- it stays dark regardless
  of the device's light/dark setting.)
- **One emcee this year: Joe Buck** (already on `/speakers/`).
- **Run of show:** convert the flat speaker list into an ordered, segmented run
  of show. Order below is a **random placeholder** to be rearranged later, with
  one fixed point: **Leon Joseph Littlebird is 6th** (first after intermission).
- **No book recommendations** this year (might add later -- keep the data field).
- **No swag / merch** promo this year.
- **No QR codes** -- native web links only.
- **No third-party advertiser pages** (e.g. 2025's Ecstatic Dance, TruPotential
  -- outside businesses buying a page). Dropped.
- **Sponsor ads ARE included** -- lead / anchor / supporting sponsors were
  promised dedicated ad space; see Part 6. (This is distinct from the dropped
  third-party advertiser pages above.)

---

## Part 1 -- Component inventory of the 2025 print program

What the printed book contained, distilled to distinct component types:

1. Event identity (logo, theme wordmark, theme art, year, URL)
2. Mission + values + 501(c)3 status
3. "What is TEDx?" boilerplate + social handles/hashtags
4. **Run of show**: segmented lineup with talk order + talk titles
5. Speaker profiles (headshot, name, talk title, long bio, per-speaker socials)
6. Emcee profiles
7. Book recommendations (one per speaker)
8. Tiered sponsor wall
9. Partner features (mission-aligned orgs, distinct from the logo wall)
10. Paid placements -- **sponsor ads kept** (lead/anchor/supporting, promised;
    see Part 6); **third-party advertiser pages dropped**
11. Merch / swag -- **dropped for 2026**
12. Donate CTA (+ QR in print; **web uses a link, no QR**)
13. Team roster + Advisory Board roster

---

## Part 2 -- What the repo already has (reuse, don't rebuild)

The deployed site *is* this repo, so 2026 content already lives here.

| Component | Where it lives | State |
|-----------|----------------|-------|
| Identity, theme | `_config.yml` (`event:` block) | Theme still `"TBA"` -- set to Kaleidoscope |
| Mission / values / 501(c)3 | `website/pages/about.md` | Have it |
| What is TEDx + socials | `_config.yml` `social:` + about | Have it |
| Segmented run of show | -- | **To build** (see Part 3) |
| Speaker profiles (2026) | `website/pages/speakers.md` front matter | 9 speakers + emcee, full bios |
| Per-speaker socials | speaker data model | **Missing field** -- add (Part 4) |
| Emcee (Joe Buck) | hardcoded block in `speakers.md` | Single; fine as-is or promote |
| Book recommendations | template supports `speaker.book`; no data | Leave field, no data this year |
| Sponsor wall (tiered) | `_data/sponsors.yml` + `_includes/facets/sponsor-wall.html` | Complete, reuse as-is |
| Team + Advisory Board | `website/pages/team.md` | **Out of date** -- see Part 7 |
| Main event details | `_events/2026-10-03-tedxbreckenridge-2026.md` | Venue, 3-6pm, tickets, map, Alpenglow Dinner |

### Design system note (why the program page is cheap to build)

`/speakers/` and every `layout: page` page already load `kaleidoscope.css` and a
"Facets" component kit: `fk-band` section bands, `fk-yearnav` sticky jump nav,
`facets/cta.html`, `facets/social-row.html` (Instagram/LinkedIn/etc. icons),
`facets/sponsor-wall.html`, `facets/page-header.html`. The `/program/` page can
be a `layout: page` + `full_width: true` page that composes these existing
includes -- **no new CSS or components required** for a first version.

### Sponsors (from tedxbreckenridge.com/sponsors, current)

The tiered data is already authoritative in `_data/sponsors.yml`; the program
page just includes the existing sponsor wall. Current tiers/sponsors:

- **Premier:** Imperial Hotel & Private Residences
- **Anchor:** The Summit Foundation; Summit Mountain Rentals
- **Supporting:** Mountain Comfort Furnishings
- **Community:** Rockridge Building Company; Arapahoe Basin; MARIX; Home Sweet
  Home Landscaping; Keystone Science School; EVO3 Workspace; Breck Create; Epic
  PRINT Pros; Ridge Street Kitchen; La Française
- **Corporate:** Aspen Alley Creative; Blue Iguana Productions; Andrew Dengate
  Art; Jenn Kaye

---

## Part 3 -- Run of show (segmented, mobile-first)

### Segments

Three segments, matching the TEDx convention and last year's structure, with an
intermission before the second half. Segment *names* are placeholders keyed to
the Kaleidoscope theme -- rename freely.

- **Segment I** (talks 1-5)
- **Intermission**
- **Segment II** (talks 6-9) -- opens with Leon Joseph Littlebird

> Note: whether to keep three named segments or two halves split by the
> intermission is open. Below is modeled as **two halves around the
> intermission**, since that's the only fixed constraint (Leon = 6th = first
> after intermission). Rename/re-split when the real order is set.

### Order (RANDOM placeholder -- rearrange later; Leon fixed at #6)

| # | Speaker | Talk title | Role |
|---|---------|-----------|------|
| 1 | Travis Tallent | The hidden gems AI can't find | Founder, MountainTowns.com |
| 2 | Chris Ray | Reading climate in the rock rabbits | Research scientist, IBP & INSTAAR/CU Boulder |
| 3 | Maisie Bryant | Unmasking the shadows of social anxiety | Student, Summit Middle School |
| 4 | Oakley Van Oss | Confidence, purpose & belonging through real experience | Construction & welding educator, Summit HS |
| 5 | Wouter Van De Pontseele | Building tomorrow's quantum technology alongside yesterday's mines | Professor, Colorado School of Mines |
| -- | **Intermission** | | |
| 6 | **Leon Joseph Littlebird** *(pinned)* | The indigenous history of music | Composer, songwriter & performer |
| 7 | Kurt Kionka | "Yes, if": the two words that move mountains | Project Director, CDOT |
| 8 | Anna DeBattiste | The heart of a volunteer | Volunteer, Summit County Rescue Group & CSAR |
| 9 | Jess Smith | Community is forged, not found | Owner, Ark Valley Signs & Sidewalk Monkey |

**Emcee:** Joe Buck (comedian & host) -- opens the show and bridges between
talks; listed once at the top of the run of show, not as a numbered slot.

> Talk titles above are copied from the current `/speakers/` data. **All talk
> titles are provisional and will likely change before the event -- that's
> expected.** Treat them as working titles, not final.

### What the run-of-show data should look like

Add `segment` and `order` to each speaker record so `/program/` and `/speakers/`
can both render the grouping from one source (rather than a second hand-ordered
list that drifts out of sync):

```yaml
# per speaker, in speakers.md front matter (or the _speakers collection)
order: 1            # position in the run of show
segment: "Segment I"   # or "half-1" / "half-2", etc.
```

An intermission marker can live in a tiny `_data/program.yml` or be inferred
(render the intermission after the last speaker of Segment I). Keep it simple.

---

## Part 4 -- Speaker social links

**Site will feature Instagram** primarily (with LinkedIn / website as
secondary). Add a per-speaker `socials` map -- **never one shared row** (the 2025
book shipped every speaker's socials as one person's handles; don't repeat that).
The existing `facets/social-row.html` include already renders instagram /
linkedin / facebook / youtube icons; a plain website link can sit beside it as
text.

Links found by research (**verify the "likely" ones before publishing; some
speakers legitimately have none**):

| Speaker | Instagram | LinkedIn | Website | Notes |
|---------|-----------|----------|---------|-------|
| Leon Joseph Littlebird | `@leon.littlebird` (verified) | `/in/leon-littlebird-2161806` (likely) | littlebirdmusic.com (verified) | also YouTube, Facebook |
| Jess Smith | *personal: none* | none | arkvalleysigns.com / sidewalkmonkey.com | Business IGs only: `@arkvalleysignco`, `@sidewalk_monkey_signs` -- decide whether to feature business over personal |
| Oakley Van Oss | none | none | none | No public personal profiles found -- likely omit socials |
| Wouter Van De Pontseele | none | `/in/woutervdp` (verified) | wouter-vdp.github.io (verified) | Mines faculty page; GitHub; Scholar |
| Maisie Bryant | none | none | none | **Minor -- intentionally no socials.** Correct to leave blank. |
| Anna DeBattiste | none | none (withheld -- same-name risk) | none | Org byline: learn.coloradosar.org author page; affiliations SCRG / CSAR |
| Travis Tallent | `@tallentspeaks` (likely) | `/in/travistallent` (verified) | mountaintowns.com (verified) | X `@tallentspeaks`; verify IG before publishing |
| Chris Ray | none | none | instaar.colorado.edu/people/chris-ray (verified) | X `@pikaresearch` (verified, self-linked); Scholar |
| Kurt Kionka | none | `/in/kurt-k-7016521` (likely -- partial name) | none | Verify LinkedIn; CDOT project page confirms role |
| Joe Buck (emcee) | none found | none | none | Every online "Joe Buck" is someone else (sportscaster/musician); likely a stage name. **Ask Joe directly for handles.** |

**Action items:** confirm Travis's Instagram and Kurt's LinkedIn; ask organizers
for Joe Buck's handles; decide Jess Smith personal-vs-business; leave Maisie
blank by design.

---

## Part 5 -- Day-of essentials (improvised; tweak later)

Web-native sections the print book lacked but a phone program needs. Draft copy
below -- treat as starting points.

### Schedule at a glance
- **Doors:** 2:30 PM
- **Talks:** 3:00 - 6:00 PM (two halves with one intermission)
- **Alpenglow Dinner:** 6:30 - 9:00 PM at Bar Down (ticketed in advance; not
  sold day-of)

### Getting there & parking

**Main event -- Riverwalk Center**
150 W Adams Ave, Breckenridge, CO 80424.
Park at the **South Gondola Parking Structure**, 80 North Park Ave, Breckenridge,
CO 80424 (free; short walk to the Riverwalk Center).
[Directions](https://www.google.com/maps/dir/?api=1&destination=Riverwalk+Center+150+W+Adams+Ave+Breckenridge+CO+80424)

**Alpenglow Dinner -- Bar Down Tavern**
1979 Ski Hill Rd (Grand Lodge on Peak 7, base of Peak 7), Breckenridge, CO 80424.
Park at the **Breck Park Stables Garage**, 1700 Ski Hill Rd, Breckenridge, CO
80424.
[Directions](https://www.google.com/maps/dir/?api=1&destination=Bar+Down+Tavern+1979+Ski+Hill+Rd+Breckenridge+CO+80424)

### Restrooms
Restrooms are **hard to find**, so call this out clearly (worth its own section,
not buried in fine print). They are **outside the main entrance and to the left,
up the ramp.** Consider a small map/diagram or an arrow graphic in the final
design, and repeat the directions near the schedule so people spot them during
the intermission.

### The bar
There is a bar at the event. *(Add hours -- e.g. open before the show and during
intermission -- and whether it's cash/card once confirmed.)* We **may** have a
**signature cocktail** this year; if so, name it and give a one-line description
here. Treat the signature cocktail as tentative until confirmed.

### Accessibility (improvised -- confirm with venue)
- Riverwalk Center is wheelchair accessible; accessible restrooms on site
  (see Restrooms above for where they are).
- For seating accommodations or assistive listening, find a volunteer in a
  TEDxBreckenridge shirt or email info@tedxbreckenridge.com ahead of time.

### House rules / code of conduct (improvised)
- Please silence phones during talks.
- Photos are welcome; **please don't record video or audio of the talks** --
  official recordings will be posted after the event (per TED rules).
- Be kind. TEDxBreckenridge is an inclusive, all-ages space.

### Tag us (Instagram)
Share your day: tag **@tedxbreckenridge** and use **#TEDxBreckenridge**.
No year- or theme-specific hashtag -- just `#TEDxBreckenridge`.

### Support / donate
TEDxBreckenridge is a 501(c)3 run entirely by local volunteers.
[Donate](/donate/) -- native link, no QR code.

### Alpenglow Dinner (informational -- not a sales pitch)
Dinner tickets are **not available on the day of the show**, so this section is
purely a heads-up for people who already have a seat -- where to go and when, not
an ad to buy in. Do **not** include a price, a "buy" CTA, or "add it to your
ticket." Suggested copy:

> If you're joining us for the Alpenglow Dinner, the conversation continues at
> Bar Down (base of Peak 7) from 6:30-9 PM, presented by The Imperial Hotel &
> Private Residences. Directions and parking are above.

(For attendees without a dinner ticket, this simply lets them know it's
happening; there's nothing to purchase.)

---

## Part 6 -- Sponsor ads (contractual deliverable)

**This supersedes the earlier "drop all advertiser placements" decision.** We
sold sponsors dedicated ad space in the program, so the digital program must
carry real ad slots -- not just the logo wall. Full logo wall stays *in
addition* to these ads (it's the recognition strip; ads are the promised
placements).

### What we promised, by tier

| Tier | Sponsor(s) | Promised print size | Web ad slot |
|------|-----------|---------------------|-------------|
| Lead (premier) | Imperial Hotel & Private Residences | Full page | **Lead ad** -- largest slot |
| Anchor | The Summit Foundation; Summit Mountain Rentals | Half page | **Anchor ad** -- mid slot (one per anchor) |
| Supporting | Mountain Comfort Furnishings | Quarter page | **Supporting ad** -- smaller slot |

*(Community and corporate tiers were not promised ad space -- they stay on the
logo wall only. Confirm if that's wrong.)*

### Sizing approach

- The print program was physically larger than a phone screen, so a literal
  "half page" / "quarter page" doesn't translate. **We can make the web ad slots
  larger than a strict half/quarter** to give sponsors equivalent (or better)
  value than they'd have gotten in print.
- **For now: build placeholders**, one per promised slot, labeled `lead`,
  `anchor`, `supporting`. They should be responsive boxes at a chosen aspect
  ratio, clearly marked as ad placeholders, so we can eyeball relative sizes on
  a real phone.
- Once we settle the placeholder sizes on-device, **freeze the dimensions** and
  hand exact specs to sponsors (pixel dimensions + aspect ratio + safe-area +
  file format -- see below). Sponsors then supply finished artwork we drop in.

### Placeholder / ad-slot data model (proposed)

Ads are sponsor-supplied images (like a print ad), not templated layouts, so keep
it simple -- a small `_data/program_ads.yml` (or a block in the event/program
front matter):

```yaml
ads:
  - tier: lead          # lead | anchor | supporting
    sponsor: "Imperial Hotel & Private Residences"
    image: /assets/images/program-ads/imperial-lead.jpg   # placeholder until supplied
    url: https://imperialbreckenridge.com/
    alt: "Imperial Hotel & Private Residences"
  - tier: anchor
    sponsor: "The Summit Foundation"
    image: /assets/images/program-ads/summit-foundation-anchor.jpg
    url: https://summitfoundation.org/
    alt: "The Summit Foundation"
  # ...one entry per promised slot
```

A single `program-ad` include renders a slot at the size for its `tier`, links to
the sponsor, uses the supplied artwork, and falls back to a labeled placeholder
box when `image` is missing. One size definition per tier = DRY; change a tier's
size in one place.

### Placement on the page

Interleave ads down the run of show the way the print book interleaved advertiser
spreads -- but sparingly, so the mobile program stays scannable:

- **Lead ad:** one prominent placement (e.g. after the run of show, before the
  sponsor wall -- or between the two halves).
- **Anchor ads:** interspersed, one after each half, or grouped in an "Our
  Sponsors" band.
- **Supporting ad:** with the anchors or near the logo wall.

Keep ads visually distinct from editorial content (a subtle "Sponsor" / "Ad"
label) and lazy-load ad images -- they must not block the run of show on a slow
connection.

### Spec sheet to send sponsors (fill in once sizes are frozen)

- Exact pixel dimensions (@2x for retina) + aspect ratio, per tier
- Safe-area / bleed guidance (none needed for web, but note min text size)
- Accepted formats (JPG/PNG; SVG for logo-type ads) and max file size
- Color note: ads sit on a **dark** page background -- warn sponsors whose
  artwork assumes white, or provide a padded plate

---

## Part 7 -- Thank-yous (current; the site's team page is out of date)

The live `/team/` page still shows the 2025 roster. The accurate 2026
acknowledgements are below (source: organizers, this session). **Not yet
applied** to `team.md` -- captured here for when the page work happens.

### Team
- Jason Ardell
- Jill Marek -- *license holder*
- Leah Rybak
- Angie Hildebrand
- Tina Kuo
- Aaron Williams
- Shinu Thomas
- Alaina Perkins
- Meri Louko
- Ali Pry
- Cait McCluski
- Ashley Girodo
- Molly Ren
- Lynn McChesney
- ...and our day-of volunteers and Summit High School students

### Speaker Coaches (led by Jenn Kaye)
- Jenn Kaye -- *lead*
- Andy Scantland
- Heather Day
- Sarah Messina
- Stephanie Ralph
- Tina Kuo

### Video
- Mike Murphy and his team at postcorptv

### Board of Directors
- Thayer Hirsh
- Laura Penney
- David Servinsky
- Jill Marek

---

## Part 8 -- Proposed `/program/` page structure

Mobile-first order, top to bottom (composes existing Facets includes):

1. **Header** -- theme (Kaleidoscope), date, time, venue in one glance
2. **Sticky jump nav** (`fk-yearnav` pattern) -- Run of Show / Getting There /
   Info
3. **Run of show** -- emcee at top, then ordered talks grouped by half with an
   intermission marker; each entry = speaker name + talk title + link to full
   bio on `/speakers/` (keeps `/program/` light for fast mobile load)
4. **Getting there & parking** -- both venues, both parking garages, map links
5. **Day-of info** -- schedule, restrooms, the bar, accessibility, house rules,
   tag-us, donate
6. **Alpenglow Dinner** callout
7. **Sponsor ads** -- lead / anchor / supporting slots (Part 6), interleaved
   sparingly (lead ad prominent; anchors/supporting near the sponsor wall)
8. **Sponsor wall** (existing include) + donate CTA (existing pattern)

### Mobile-first requirements
- Above the fold answers "what's next"; run of show reachable in one tap.
- Touch targets >= 44x44px; strong contrast (dim-room legible; don't lean on
  faint theme tints for critical text).
- Optimized/lazy images; core agenda is text/HTML so a cached load still shows
  the schedule if signal drops mid-event.
- Works at 320px, no horizontal scroll.
- **No heavy embeds** -- map is a *link*, not an embedded iframe, on the program
  page.

---

## Part 9 -- Explicitly out of scope

- **Visual design / theme styling** -- a design is still to be chosen.
- **Live pages** -- this session produced only this doc; `_config.yml` and
  `team.md` were left untouched.
- **Third-party advertiser pages, QR codes, merch/swag** -- dropped for 2026.
  (Sponsor ads are **in scope** -- see Part 6 -- and are a separate thing from
  third-party advertiser pages.)

---

## Open questions for the team

1. **Real run of show:** final speaker order and segment names (current order is
   random except Leon at #6).
2. **Socials to verify/collect:** Travis's Instagram, Kurt's LinkedIn, Joe
   Buck's handles; Jess Smith personal-vs-business decision.
3. **Segments vs. halves:** three named segments, or two halves split by the
   intermission?
4. **Day-of facts to confirm:** doors time, accessibility specifics, venue wifi,
   bar hours/payment, and whether there's a signature cocktail (name +
   description).
5. **Partners:** any mission-aligned partners needing feature space beyond the
   sponsor wall this year?
6. **Sponsor ad sizes:** agree the placeholder sizes on a real phone, then freeze
   exact dimensions per tier (lead / anchor / supporting) to send to sponsors.
   Confirm only premier/anchor/supporting get ads (not community/corporate).
