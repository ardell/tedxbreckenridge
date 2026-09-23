---
layout: program
title: Program
permalink: /program/
description: The TEDxBreckenridge 2026 "Kaleidoscope" program — run of show, speakers, sponsors, and everything you need on the day at the Riverwalk Center in Breckenridge, Colorado.
ticket_popup: false
sponsor_wall: false

# Run of show + speaker bios come from _data/speakers.yml (shared with the
# /speakers/ page). Nine speakers split across the intermission: five before
# (half 1), four after (half 2). Leon opens the second half.

# ---- Sessions ----
# The two named sessions, before and after intermission. `half` ties each one
# to the matching speaker segment (half 1 / half 2 in speakers.yml).
sessions:
  - half: 1
    name: Hidden in Plain Sight
    blurb: "The most valuable things are often the ones we walk right past. In this opening session, our speakers turn their attention to what the algorithms overlook, what history buried, and what we hide even from ourselves -- from overlooked mountain towns and quantum breakthroughs rising beside old mines, to the community we build and the anxieties we mask. Come ready to look closer."
  - half: 2
    name: View from the Summit
    blurb: "Reach the top and the view changes everything. In our closing session, speakers trace the long climb of tradition, service, and stubborn ambition -- the ancestral roots of music, the quiet heroism of volunteers, decades of listening to a changing climate, and the two words that move mountains. It's a wider perspective, earned one step at a time."

# ---- Sponsor ad slots (placeholders; sizes TBD) ----
# Placed by hand through the program (not looped) so each lands in a specific
# spot: Imperial before the show, the anchors around the two talk segments,
# and the supporting slot near the close.
sponsor_ads:
  - tier: lead
    sponsor: Imperial Hotel &amp; Private Residences
    url: "https://imperialbreckenridge.com/"
  - tier: anchor
    sponsor: The Summit Foundation
    url: "https://summitfoundation.org/"
  - tier: anchor
    sponsor: Summit Mountain Rentals
  - tier: supporting
    sponsor: Mountain Comfort Furnishings

# ---- Day-of info ----
info_rows:
  - { label: Doors, value: "2:00 PM" }
  - { label: Talks, value: "3:00 – 6:00 PM" }
  - { label: Venue, value: "Riverwalk Center" }
  - { label: Alpenglow Dinner, value: "6:30 – 9:00 PM" }
---

{%- assign ev = site.event -%}
{%- assign lead_ad = page.sponsor_ads | where: "tier", "lead" | first -%}
{%- assign anchor_ads = page.sponsor_ads | where: "tier", "anchor" -%}
{%- assign anchor_ad_1 = anchor_ads[0] -%}
{%- assign anchor_ad_2 = anchor_ads[1] -%}
{%- assign supporting_ad = page.sponsor_ads | where: "tier", "supporting" | first -%}

<!-- ============ Jump nav ============ -->
<nav class="ep-jump" aria-label="Program sections">
  <div class="ep-jump-inner">
    <a class="ep-chip" href="#mission">About</a>
    <a class="ep-chip" href="#sponsors">Sponsors</a>
    <a class="ep-chip" href="#run-of-show">Run of Show</a>
    <a class="ep-chip" href="#good-to-know">Good to Know</a>
    <a class="ep-chip" href="#donate">Donate</a>
  </div>
</nav>

<!-- ============ Hero ============ -->
<header class="ep-shell ep-section" style="padding-top:0">
  <div class="ep-hero-lockup">
    <img src="{{ '/assets/images/logos/tedx-breckenridge-logo-white.svg' | relative_url }}"
         alt="TEDxBreckenridge" width="280" height="86">
  </div>
  <div class="emission emission--hero emission--full ep-hero-band" aria-hidden="true"></div>
  <h1 class="ep-hero-title glow-heading">Kaleidoscope</h1>
  <p class="ep-hero-date">{{ ev.date }} · {{ ev.time }}</p>
  <p class="ep-hero-venue">{{ ev.venue }}</p>
</header>

<!-- ============ Mission & values ============ -->
<section id="mission" class="ep-section ep-section--banded ep-section--textured">
  <div class="emission emission--strip emission--warm" aria-hidden="true"></div>
  <div class="ep-shell">
    <p class="eyebrow reveal">Why we're here</p>
    <h2 class="ep-heading reveal">Our mission</h2>
    <p class="ep-measure reveal" style="color:var(--text-body);margin:0 0 var(--space-24)">TEDxBreckenridge is a 501(c)(3) nonprofit, run entirely by local volunteers. We create a platform for innovative ideas and meaningful conversations that inspire positive change in Summit County and beyond — amplifying local voices and bringing diverse perspectives together to strengthen our community and add to the global conversation.</p>

    <div class="ep-block reveal">
      <h3>What we value</h3>
      <ul class="ep-measure" style="color:var(--text-body);padding-left:1.1em;margin:0">
        <li><strong>Innovation</strong> — celebrating bold ideas that challenge conventional wisdom and open new possibilities.</li>
        <li><strong>Community</strong> — building connections across diverse perspectives, backgrounds, and experiences.</li>
        <li><strong>Authenticity</strong> — honoring genuine voices and making space for honest, vulnerable storytelling.</li>
        <li><strong>Sustainability</strong> — stewarding our mountain home so it thrives for generations to come.</li>
      </ul>
    </div>

    <div class="ep-social-cta ep-social-cta--row reveal">
      <p class="tag">Follow along</p>
      <a class="handle" href="https://instagram.com/{{ site.social.instagram }}" target="_blank" rel="noopener noreferrer" aria-label="TEDxBreckenridge on Instagram (opens in new window)">
        {% include facets/social-icon.html type="instagram" px=20 %}Instagram
      </a>
      <a class="handle" href="https://youtube.com/{{ site.social.youtube }}" target="_blank" rel="noopener noreferrer" aria-label="TEDxBreckenridge on YouTube (opens in new window)">
        {% include facets/social-icon.html type="youtube" px=20 %}YouTube
      </a>
      <a class="handle" href="https://facebook.com/{{ site.social.facebook }}" target="_blank" rel="noopener noreferrer" aria-label="TEDxBreckenridge on Facebook (opens in new window)">
        {% include facets/social-icon.html type="facebook" px=20 %}Facebook
      </a>
      <a class="handle" href="https://www.flickr.com/photos/tedxbreckenridge/" target="_blank" rel="noopener noreferrer" aria-label="TEDxBreckenridge on Flickr (opens in new window)">
        {% include facets/social-icon.html type="flickr" px=20 %}Flickr
      </a>
    </div>
  </div>
</section>

<!-- ============ Imperial (lead) ad ============ -->
{% if lead_ad %}
<section class="ep-section ep-section--ad">
  <div class="ep-shell">
    <div class="ep-ads">
      {% include program-ad.html ad=lead_ad %}
    </div>
  </div>
</section>
{% endif %}

<!-- ============ Emcee ============ -->
{% assign emcee = site.data.speakers.emcee %}
{% if emcee %}
<section id="emcee" class="ep-section ep-section--banded">
  <div class="emission emission--strip emission--dim" aria-hidden="true"></div>
  <div class="ep-shell">
    <p class="eyebrow reveal">Your host for the afternoon</p>
    <h2 class="ep-heading reveal">The emcee</h2>
    <ol class="ros">
      {% include program-run-of-show-item.html t=emcee variant="emcee" %}
    </ol>
  </div>
</section>
{% endif %}

<!-- ============ Sponsor wall ============ -->
<section id="sponsors" class="ep-section ep-section--banded">
  <div class="emission emission--strip emission--even" aria-hidden="true"></div>
  <div class="ep-shell">
    <p class="eyebrow reveal">With thanks to</p>
    <h2 class="ep-heading reveal">The sponsors who make today possible</h2>

    {% assign tiers = "premier,anchor,supporting,community,corporate" | split: "," %}
    {% assign tier_labels = "Premier,Anchor,Supporting,Community,Creative" | split: "," %}
    {% for tier in tiers %}
      {% assign tier_sponsors = site.data.sponsors | where: "tier", tier %}
      {% if tier_sponsors.size > 0 %}
      <div class="ep-tier ep-tier--{{ tier }} reveal">
        <p class="eyebrow">{{ tier_labels[forloop.index0] }}</p>
        <div class="ep-plates">
          {% for s in tier_sponsors %}
          {%- comment -%}
            Neutralize each logo for the dark plate off its tone (the same
            single-source field the sponsor wall and Sponsors page read from
            _data/sponsors.yml), rather than per-filename. -dk/-inv/-as-is are
            transparent-mark logos flattened or left to read light; -mu/-rev
            carry their own opaque or filled background, so they are inverted to
            read white on the plate instead of being flattened to a white blob.

            program_logo / program_tone let a sponsor supply a dark-ground
            variant just for this plate (e.g. Imperial's approved white reverse
            lockup), leaving the card and marquee on their own logo + tone.

            The name prints under each plate so hard-to-read logos are still
            legible; strip a trailing trademark symbol so it doesn't clutter the
            small caption (the full name stays in the logo's alt text).
          {%- endcomment -%}
          {% assign logo = s.program_logo | default: s.wall_logo | default: s.logo %}
          {% assign tone = s.program_tone | default: s.tone | default: "dk" %}
          {% assign cls = "plate-logo-" | append: tone %}
          {% assign display_name = s.name | replace: "™", "" | replace: "®", "" | strip %}
          <figure class="ep-plate-fig">
            {% if s.url %}
            <a class="plate" href="{{ s.url }}" target="_blank" rel="noopener noreferrer">
              <img src="{{ logo | relative_url }}" alt="{{ s.name }}" class="{{ cls }}" loading="lazy">
            </a>
            {% else %}
            <div class="plate">
              <img src="{{ logo | relative_url }}" alt="{{ s.name }}" class="{{ cls }}" loading="lazy">
            </div>
            {% endif %}
            <figcaption class="ep-plate-name">{{ display_name }}</figcaption>
          </figure>
          {% endfor %}
        </div>
      </div>
      {% endif %}
    {% endfor %}
  </div>
</section>

<!-- ============ Run of show ============ -->
{% assign talks = site.data.speakers.speakers | sort: "order" %}
{% assign segment1 = talks | where: "half", 1 %}
{% assign segment2 = talks | where: "half", 2 %}
{% assign session1 = page.sessions | where: "half", 1 | first %}
{% assign session2 = page.sessions | where: "half", 2 | first %}

<section id="run-of-show" class="ep-section ep-section--banded">
  <div class="emission emission--strip emission--warm" aria-hidden="true"></div>
  <div class="ep-shell">
    <p class="eyebrow reveal">The lineup</p>
    <h2 class="ep-heading reveal">Run of show</h2>

    <!-- Session 1 header -->
    {% if session1 %}
    {% assign s1_first = segment1 | first %}
    {% assign s1_last = segment1 | last %}
    <div class="ros-session reveal">
      <div class="ros-session-eyebrows">
        <p class="eyebrow">Session one</p>
        <p class="ros-session-range">Talks {{ s1_first.order }}&#8211;{{ s1_last.order }}</p>
      </div>
      <h3 class="ros-session-name">{{ session1.name }}</h3>
      <p class="ros-session-blurb">{{ session1.blurb }}</p>
    </div>
    {% endif %}

    <!-- Segment 1 — before intermission.
         Card edge colour = the talk's slice of the run-of-show spectrum,
         computed from `order` (1–9) so rearranging talks keeps the colours in
         gradient order. Divisor is 9 talks − 1 = 8. -->
    <ol class="ros">
      {% for t in segment1 %}
      {% assign label = t.order | prepend: 'Talk ' %}
      {% assign pct = t.order | minus: 1 | times: 100 | divided_by: 8 %}
      {% include program-run-of-show-item.html t=t label=label pct=pct %}
      {% endfor %}
    </ol>

    <!-- Anchor ad between the two segments -->
    {% if anchor_ad_1 %}
    <div class="ep-ads ep-ads--inline reveal">
      {% include program-ad.html ad=anchor_ad_1 %}
    </div>
    {% endif %}

    <!-- Intermission landmark -->
    <div class="ros-break reveal" role="separator" aria-label="Intermission">
      <span class="rule rule--in" aria-hidden="true"></span>
      <img class="facet" src="{{ '/assets/images/kaleidoscope/kaleidoscope-facet.svg' | relative_url }}"
           alt="" aria-hidden="true" width="20" height="20">
      <span class="rule rule--out" aria-hidden="true"></span>
      <span class="eyebrow">Intermission · 20 minutes</span>
    </div>

    <!-- Session 2 header -->
    {% if session2 %}
    {% assign s2_first = segment2 | first %}
    {% assign s2_last = segment2 | last %}
    <div class="ros-session reveal">
      <div class="ros-session-eyebrows">
        <p class="eyebrow">Session two</p>
        <p class="ros-session-range">Talks {{ s2_first.order }}&#8211;{{ s2_last.order }}</p>
      </div>
      <h3 class="ros-session-name">{{ session2.name }}</h3>
      <p class="ros-session-blurb">{{ session2.blurb }}</p>
    </div>
    {% endif %}

    <!-- Segment 2 — after intermission (same order-driven edge colour) -->
    <ol class="ros">
      {% for t in segment2 %}
      {% assign label = t.order | prepend: 'Talk ' %}
      {% assign pct = t.order | minus: 1 | times: 100 | divided_by: 8 %}
      {% include program-run-of-show-item.html t=t label=label pct=pct %}
      {% endfor %}
    </ol>
  </div>
</section>

<!-- ============ Anchor ad (after the talks) ============ -->
{% if anchor_ad_2 %}
<section class="ep-section ep-section--ad">
  <div class="ep-shell">
    <div class="ep-ads">
      {% include program-ad.html ad=anchor_ad_2 %}
    </div>
  </div>
</section>
{% endif %}

<!-- ============ Good to know ============ -->
<section id="good-to-know" class="ep-section ep-section--banded">
  <div class="emission emission--strip emission--cool" aria-hidden="true"></div>
  <div class="ep-shell">
    <p class="eyebrow reveal">On the day</p>
    <h2 class="ep-heading reveal">Good to know</h2>

    <div class="ep-info reveal">
      {% for row in page.info_rows %}
      <div class="ep-info-row">
        <span class="ep-info-label">{{ row.label }}</span>
        <span class="ep-info-value">{{ row.value }}</span>
      </div>
      {% endfor %}
    </div>

    <div class="ep-block reveal">
      <h3>Restrooms</h3>
      <p>They're a little hidden: head <strong>out the main entrance and to the left, up the ramp</strong>. A good moment to find them is during the intermission.</p>
    </div>

    <div class="ep-block reveal">
      <h3>The bar</h3>
      <p>There's a bar at the event, open before the show and during intermission. We may have a signature Kaleidoscope cocktail this year — details on the day.</p>
    </div>

    <div class="ep-block reveal">
      <h3>House rules</h3>
      <p>Please silence phones during talks. Photos are welcome, but <strong>please don't record video or audio</strong> — official recordings are posted after the event. Be kind: this is an inclusive, all-ages space.</p>
    </div>

    <div class="ep-block reveal">
      <h3>Accessibility</h3>
      <p>The Riverwalk Center is wheelchair accessible with accessible restrooms on site. For seating accommodations or assistive listening, find a volunteer in a TEDxBreckenridge shirt or email <a href="mailto:info@tedxbreckenridge.com">info@tedxbreckenridge.com</a> ahead of time.</p>
    </div>
  </div>
</section>

<!-- ============ Alpenglow Dinner ============ -->
<section id="dinner" class="ep-section ep-section--banded">
  <div class="emission emission--strip emission--warm" aria-hidden="true"></div>
  <div class="ep-shell">
    <p class="eyebrow reveal">For dinner guests</p>
    <h2 class="ep-heading reveal">The Alpenglow Dinner</h2>
    <p class="ep-measure reveal" style="color:var(--text-body);margin:0 0 var(--space-24)">If you're joining us for the Alpenglow Dinner, the conversation continues at Bar Down from 6:30–9 PM, presented by The Imperial Hotel &amp; Private Residences. (Dinner is ticketed in advance.) Here's where to go and where to park.</p>

    <div class="ep-block reveal">
      <h3>Bar Down Tavern</h3>
      <p>1979 Ski Hill Rd (Grand Lodge on Peak 7), Breckenridge, CO 80424.<br>
      Park at the <strong>Breck Park Stables Garage</strong>, 1700 Ski Hill Rd — a short walk to the lodge.</p>
      <p><a class="ep-maplink" href="https://www.google.com/maps/dir/?api=1&amp;destination=Bar+Down+Tavern+1979+Ski+Hill+Rd+Breckenridge+CO+80424" target="_blank" rel="noopener noreferrer">Directions to Bar Down →</a></p>
    </div>
  </div>
</section>

<!-- ============ Supporting ad (near the close) ============ -->
{% if supporting_ad %}
<section class="ep-section ep-section--ad">
  <div class="ep-shell">
    <div class="ep-ads">
      {% include program-ad.html ad=supporting_ad %}
    </div>
  </div>
</section>
{% endif %}

<!-- ============ Donate ============ -->
<section id="donate" class="ep-section ep-section--banded ep-section--textured">
  <div class="emission emission--strip emission--even" aria-hidden="true"></div>
  <div class="ep-shell">
    <p class="eyebrow reveal">Keep ideas worth spreading going</p>
    <h2 class="ep-heading reveal">Support TEDxBreckenridge</h2>
    <p class="ep-measure reveal" style="color:var(--text-body);margin:0 0 var(--space-24)">Every talk on today's stage is produced by volunteers and funded by our community. If today moved you, a donation helps us bring the next round of local voices to the Riverwalk Center stage.</p>
    <div class="ep-btn-row reveal">
      <a class="ep-btn ep-btn--primary" href="https://givebutter.com/tedxbreckenridge?utm_source=website&utm_campaign=tedxbreckenridge.com-program-donate&utm_medium=cta" target="_blank" rel="noopener noreferrer">Donate now</a>
      <a class="ep-btn ep-btn--secondary" href="/donate-local-nonprofit-in-breckenridge/">Learn more</a>
    </div>
  </div>
</section>

<!-- ============ About the team ============ -->
<section id="team" class="ep-section ep-section--banded">
  <div class="emission emission--strip emission--dim" aria-hidden="true"></div>
  <div class="ep-shell">
    <p class="eyebrow reveal">The people behind today</p>
    <h2 class="ep-heading reveal">Made by volunteers</h2>
    <p class="ep-measure reveal" style="color:var(--text-body);margin:0 0 var(--space-24)">TEDxBreckenridge is organized entirely by local volunteers who work year-round to curate speakers, plan events, and build community in Summit County. From speaker coaches and stage managers to designers and day-of production, dozens of people made today happen.</p>
    <div class="ep-btn-row reveal">
      <a class="ep-btn ep-btn--secondary" href="/team/">Meet the team</a>
      <a class="ep-btn ep-btn--secondary" href="/volunteer/">Volunteer with us</a>
    </div>
  </div>
</section>

<!-- ============ Footer ============ -->
<footer class="ep-footer">
  <img class="ep-footer-rosette" src="{{ '/assets/images/kaleidoscope/kaleidoscope-mark.svg' | relative_url }}" alt="" aria-hidden="true">
  <div class="ep-shell">
    <img class="ep-footer-lockup" src="{{ '/assets/images/logos/tedx-breckenridge-logo-white.svg' | relative_url }}" alt="TEDxBreckenridge" width="130">
    <p class="ep-footer-blurb">TEDxBreckenridge is a 501(c)3 nonprofit, run entirely by local volunteers, bringing ideas worth spreading to Summit County. <a href="/donate-local-nonprofit-in-breckenridge/">Donate</a> · <a href="/speakers/">Speakers</a> · <a href="/team/">Team</a></p>
    <p class="ep-footer-license label-micro">OPERATED UNDER LICENSE FROM TED</p>
  </div>
</footer>
