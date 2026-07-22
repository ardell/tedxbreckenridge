---
layout: page
title: Past Events
subtitle: A look back at ideas worth spreading
permalink: /past-events/
description: Browse past TEDxBreckenridge events including Salon gatherings and main events. Watch talks and relive the moments that inspired our community.
full_width: true
eyebrow: Archive
---

<section class="fk-band fk-band-white">
  <div class="fk-band-inner">
    {% assign past_events = site.events | where_exp: "event", "event.date < site.time" | sort: "date" | reverse %}
    {% if past_events.size > 0 %}
    <div class="fk-stack">
      {% for event in past_events %}
      {% if event.event_type == "salon" %}{% assign tag = "Salon Events" %}{% else %}{% assign tag = "Main Event" %}{% endif %}
      {% assign ev_month = event.date | date: "%b" %}
      {% assign ev_day = event.date | date: "%d" %}
      {% assign ev_blurb = event.description | truncate: 160 %}
      {% include facets/event-card.html
         url=event.url
         image=event.image
         month=ev_month
         day=ev_day
         tag=tag
         title=event.title
         blurb=ev_blurb
         alt=event.title %}
      {% endfor %}
    </div>
    {% else %}
    <div class="fk-card fk-center">
      <div class="fk-card-body"><p>No past events to display yet. Check back after our upcoming events!</p></div>
      <div style="margin-top: var(--space-16);">
        <a href="/events/" class="k-btn k-btn-primary">View Upcoming Events</a>
      </div>
    </div>
    {% endif %}
  </div>
</section>

<section class="fk-band fk-band-sand fk-band-sm">
  <div class="fk-band-inner">
    {% include facets/cta.html
       tone="sand"
       eyebrow="Watch &amp; rewatch"
       title="Want to watch talks from past events?"
       text="Explore our full archive of talks from five years of TEDxBreckenridge."
       primary_label="Watch All Talks"
       primary_url="/talks/" %}
  </div>
</section>
