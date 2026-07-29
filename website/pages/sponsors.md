---
layout: page
title: Our Sponsors
subtitle: Every talk on the red dot, every Salon around Summit County, and every video that leaves this valley is made possible by the organizations below.
permalink: /sponsors/
description: Meet the businesses, foundations, and nonprofits whose support makes TEDxBreckenridge possible — from our premier partner to the local companies behind every Salon.
full_width: true
header_tone: warm
eyebrow: Our Sponsors
# This page already lists every sponsor, so the pre-footer wall would repeat it.
sponsor_wall: false
---

{% comment %}
  Every tier below reads from _data/sponsors.yml — the same roster the
  sponsor-wall pre-footer uses — so sponsors are only ever added in one place.
  Card size steps down by tier: xl for premier, lg for anchor, md for
  community, sm for corporate.
{% endcomment %}
{% assign premier = site.data.sponsors | where: "tier", "premier" %}
{% assign anchor = site.data.sponsors | where: "tier", "anchor" %}
{% assign community = site.data.sponsors | where: "tier", "community" %}
{% assign corporate = site.data.sponsors | where: "tier", "corporate" %}

{% if premier.size > 0 %}
<section class="fk-band fk-band-white">
  <div class="fk-band-inner">
    <div class="fk-band-head">
      <div class="fk-band-eyebrow">Premier Sponsor</div>
      <h2 class="fk-band-title">Our lead partner</h2>
    </div>
    {% for sponsor in premier %}
      {% include facets/sponsor-card.html sponsor=sponsor size="xl" %}
    {% endfor %}
  </div>
</section>
{% endif %}

{% if anchor.size > 0 %}
<section class="fk-band fk-band-parchment">
  <div class="fk-band-inner">
    <div class="fk-band-head">
      <div class="fk-band-eyebrow">Anchor Sponsor</div>
      <h2 class="fk-band-title">Anchoring the season</h2>
    </div>
    {% for sponsor in anchor %}
      {% include facets/sponsor-card.html sponsor=sponsor size="lg" alt=true %}
    {% endfor %}
  </div>
</section>
{% endif %}

{% if community.size > 0 %}
<section class="fk-band fk-band-white">
  <div class="fk-band-inner">
    <div class="fk-band-head">
      <div class="fk-band-eyebrow">Community Sponsors</div>
      <h2 class="fk-band-title">The businesses of Summit County</h2>
      <p class="fk-band-lede">Local companies and nonprofits who put their name behind a stage in their own backyard.</p>
    </div>
    <div class="sponsor-grid sponsor-grid-community">
      {% for sponsor in community %}
        {% include facets/sponsor-card.html sponsor=sponsor size="md" %}
      {% endfor %}
    </div>
  </div>
</section>
{% endif %}

{% if corporate.size > 0 %}
<section class="fk-band fk-band-parchment">
  <div class="fk-band-inner">
    <div class="fk-band-head">
      <div class="fk-band-eyebrow">Corporate Sponsors</div>
      <h2 class="fk-band-title">Creative partners</h2>
    </div>
    <div class="sponsor-grid sponsor-grid-corporate">
      {% for sponsor in corporate %}
        {% include facets/sponsor-card.html sponsor=sponsor size="sm" alt=true %}
      {% endfor %}
    </div>
  </div>
</section>
{% endif %}

<section class="fk-band fk-band-warm fk-band-slant">
  <div class="fk-band-inner">
    {% include facets/cta.html
       tone="warm"
       eyebrow="Ready to partner?"
       title="Put your name alongside theirs"
       text="Sponsorship covers a full year — the main event on October 3 plus every Salon gathering around Summit County. In-kind support is welcome too."
       primary_label="Become a Sponsor"
       primary_url="/sponsor/"
       secondary_label="Contact Us"
       secondary_url="/contact/" %}
  </div>
</section>
