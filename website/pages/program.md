---
layout: program
title: Program
permalink: /program/
description: The TEDxBreckenridge 2026 "Kaleidoscope" program — run of show, speakers, sponsors, and everything you need on the day at the Riverwalk Center in Breckenridge, Colorado.
ticket_popup: false
sponsor_wall: false

# Run of show + speaker bios come from _data/speakers.yml (shared with the
# /speakers/ page). Order is a placeholder; Leon opens the second half.

# ---- Sponsor ad slots (placeholders; sizes TBD) ----
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

<!-- ============ Jump nav ============ -->
<nav class="ep-jump" aria-label="Program sections">
  <div class="ep-jump-inner">
    <a class="ep-chip" href="#run-of-show">Run of show</a>
    <a class="ep-chip" href="#sponsors">Sponsors</a>
    <a class="ep-chip" href="#getting-there">Getting there</a>
    <a class="ep-chip" href="#day-of">Day-of info</a>
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

<!-- ============ Run of show ============ -->
<section id="run-of-show" class="ep-section">
  <div class="emission emission--strip emission--warm" aria-hidden="true"></div>
  <div class="ep-shell" style="padding-top:var(--space-40)">
    <p class="ep-kicker">The lineup</p>
    <h2 class="ep-heading">Run of show</h2>
    <p class="ep-measure" style="color:var(--text-body);margin:0 0 var(--space-24)">Nine speakers, in the order they'll take the stage. Tap any name to read their bio.</p>

    {% assign emcee = site.data.speakers.emcee %}
    {% if emcee %}
    <details class="ros__emcee ros__panel">
      <summary>
        <span class="ros__emcee-label">Your emcee</span>
        <span class="ros__emcee-name">{{ emcee.name }}</span>
        <span class="ros__emcee-role">{{ emcee.role }}</span>
        <span class="ros__toggle" aria-hidden="true"></span>
      </summary>
      <div class="ros__bio">
        <div class="ros__bio-inner">
          {% if emcee.image %}<img class="ros__headshot" src="{{ emcee.image | relative_url }}" alt="{{ emcee.name }}" loading="lazy">{% endif %}
          {% for para in emcee.bio %}<p>{{ para }}</p>{% endfor %}
        </div>
      </div>
    </details>
    {% endif %}

    {% assign talks = site.data.speakers.speakers | sort: "order" %}
    {% assign shown_break = false %}
    <ol class="ros">
      {% for t in talks %}
        {% if t.half == 2 and shown_break == false %}
          <li class="ros__break" aria-label="Intermission">
            <span class="rule" aria-hidden="true"></span>
            <span class="lbl">Intermission</span>
            <span class="rule" aria-hidden="true"></span>
          </li>
          {% assign shown_break = true %}
        {% endif %}
      <li class="ros__item">
        <details class="ros__panel" id="{{ t.slug }}">
          <summary class="ros__row">
            <span class="ros__i">{{ t.order | prepend: '0' | slice: -2, 2 }}</span>
            <span class="ros__main">
              <span class="ros__name">{% if t.title %}{{ t.title }} {% endif %}{{ t.name }}</span>
              <span class="ros__talk">{{ t.theme }}</span>
              <span class="ros__role">{{ t.role }}</span>
            </span>
            <span class="ros__toggle" aria-hidden="true"></span>
          </summary>
          <div class="ros__bio">
            <div class="ros__bio-inner">
              <img class="ros__headshot" src="{{ t.image | relative_url }}" alt="{{ t.name }}" loading="lazy"{% if t.crop %} style="object-position:{{ t.crop }}"{% endif %}>
              {% for para in t.bio %}<p>{{ para }}</p>{% endfor %}
              {% if t.socials %}
              <div class="ros__social">
                {% for s in t.socials %}
                <a href="{{ s.url }}" target="_blank" rel="noopener noreferrer" aria-label="{{ t.name }} on {{ s.type }}">
                  {% include facets/social-icon.html type=s.type px=18 %}
                </a>
                {% endfor %}
              </div>
              {% endif %}
            </div>
          </div>
        </details>
      </li>
      {% endfor %}
    </ol>
  </div>
</section>

<!-- ============ Sponsor ads ============ -->
<section class="ep-section">
  <div class="ep-shell">
    <p class="ep-kicker reveal">With thanks to</p>
    <h2 class="ep-heading reveal">Our sponsors</h2>

    {% assign lead_ads = page.sponsor_ads | where: "tier", "lead" %}
    {% assign anchor_ads = page.sponsor_ads | where: "tier", "anchor" %}
    {% assign supporting_ads = page.sponsor_ads | where: "tier", "supporting" %}

    <div class="ep-ads">
      {% for ad in lead_ads %}{% include program-ad.html ad=ad %}{% endfor %}
      {% for ad in anchor_ads %}{% include program-ad.html ad=ad %}{% endfor %}
      {% for ad in supporting_ads %}{% include program-ad.html ad=ad %}{% endfor %}
    </div>
  </div>
</section>

<!-- ============ Sponsor wall ============ -->
<section id="sponsors" class="ep-section">
  <div class="emission emission--strip emission--even" aria-hidden="true"></div>
  <div class="ep-shell" style="padding-top:var(--space-40)">
    <p class="ep-kicker reveal">The full roster</p>
    <h2 class="ep-heading reveal">Thank you to everyone who makes this possible</h2>

    {% assign tiers = "premier,anchor,supporting,community,corporate" | split: "," %}
    {% assign tier_labels = "Premier,Anchor,Supporting,Community,Creative" | split: "," %}
    {% for tier in tiers %}
      {% assign tier_sponsors = site.data.sponsors | where: "tier", tier %}
      {% if tier_sponsors.size > 0 %}
      <div class="ep-tier ep-tier--{{ tier }} reveal">
        <p class="ep-tier__label">{{ tier_labels[forloop.index0] }}</p>
        <div class="ep-plates">
          {% for s in tier_sponsors %}
          {% assign logo = s.wall_logo | default: s.logo %}
          {% assign fname = logo | split: "/" | last %}
          {% assign cls = "" %}
          {% if fname == "evo3-workspace-logo-white.png" %}{% assign cls = "is-white" %}{% endif %}
          {% if fname == "arapahoe-basin-horizontal.svg" %}{% assign cls = "is-opaque-plate" %}{% endif %}
          {% if s.url %}
          <a class="plate" href="{{ s.url }}" target="_blank" rel="noopener noreferrer">
            <img src="{{ logo | relative_url }}" alt="{{ s.name }}" class="{{ cls }}" loading="lazy">
          </a>
          {% else %}
          <div class="plate">
            <img src="{{ logo | relative_url }}" alt="{{ s.name }}" class="{{ cls }}" loading="lazy">
          </div>
          {% endif %}
          {% endfor %}
        </div>
      </div>
      {% endif %}
    {% endfor %}
  </div>
</section>

<!-- ============ Getting there ============ -->
<section id="getting-there" class="ep-section">
  <div class="emission emission--strip emission--cool" aria-hidden="true"></div>
  <div class="ep-shell" style="padding-top:var(--space-40)">
    <p class="ep-kicker reveal">Wayfinding</p>
    <h2 class="ep-heading reveal">Getting there &amp; parking</h2>

    <div class="ep-block reveal">
      <h3>Main event — Riverwalk Center</h3>
      <p>150 W Adams Ave, Breckenridge, CO 80424.<br>
      Park at the <strong>South Gondola Parking Structure</strong>, 80 North Park Ave — a short walk to the venue.</p>
      <p><a class="ep-maplink" href="https://www.google.com/maps/dir/?api=1&amp;destination=Riverwalk+Center+150+W+Adams+Ave+Breckenridge+CO+80424" target="_blank" rel="noopener noreferrer">Directions to the Riverwalk Center →</a></p>
    </div>

    <div class="ep-block reveal">
      <h3>Alpenglow Dinner — Bar Down Tavern</h3>
      <p>1979 Ski Hill Rd (Grand Lodge on Peak 7), Breckenridge, CO 80424.<br>
      Park at the <strong>Breck Park Stables Garage</strong>, 1700 Ski Hill Rd.</p>
      <p><a class="ep-maplink" href="https://www.google.com/maps/dir/?api=1&amp;destination=Bar+Down+Tavern+1979+Ski+Hill+Rd+Breckenridge+CO+80424" target="_blank" rel="noopener noreferrer">Directions to Bar Down →</a></p>
      <p style="color:var(--text-secondary);font-size:15px">If you're joining us for the Alpenglow Dinner, the conversation continues at Bar Down from 6:30–9 PM, presented by The Imperial Hotel &amp; Private Residences. (Dinner is ticketed in advance.)</p>
    </div>
  </div>
</section>

<!-- ============ Day-of info ============ -->
<section id="day-of" class="ep-section">
  <div class="ep-shell">
    <p class="ep-kicker reveal">On the day</p>
    <h2 class="ep-heading reveal">Good to know</h2>

    <div class="ep-info reveal">
      {% for row in page.info_rows %}
      <div class="ep-info__row">
        <span class="ep-info__label">{{ row.label }}</span>
        <span class="ep-info__value">{{ row.value }}</span>
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

    <div class="ep-social-cta reveal">
      <p class="tag">#TEDxBreckenridge</p>
      <a class="handle" href="https://www.instagram.com/tedxbreckenridge/" target="_blank" rel="noopener noreferrer">
        {% include facets/social-icon.html type="instagram" px=20 %}@tedxbreckenridge
      </a>
    </div>
  </div>
</section>

<!-- ============ Footer ============ -->
<footer class="ep-footer">
  <img class="ep-footer__rosette" src="{{ '/assets/images/kaleidoscope/kaleidoscope-mark.svg' | relative_url }}" alt="" aria-hidden="true">
  <div class="ep-shell">
    <img class="ep-footer__lockup" src="{{ '/assets/images/logos/tedx-breckenridge-logo-white.svg' | relative_url }}" alt="TEDxBreckenridge" width="130">
    <p class="ep-footer__blurb">TEDxBreckenridge is a 501(c)3 nonprofit, run entirely by local volunteers, bringing ideas worth spreading to Summit County. <a href="/donate-local-nonprofit-in-breckenridge/">Donate</a> · <a href="/speakers/">Speakers</a> · <a href="/team/">Team</a></p>
    <p class="ep-footer__license">OPERATED UNDER LICENSE FROM TED</p>
  </div>
</footer>
