---
layout: page
title: Upcoming Events
subtitle: Ideas worth spreading in Summit County
permalink: /events/
redirect_from:
  - /attend
  - /attend/
description: Upcoming TEDxBreckenridge events including Salon gatherings and our annual main event. Join us for inspiring talks and meaningful connections in the heart of the Rockies.
full_width: true
eyebrow: Attend
---

<section class="fk-band fk-band-white">
  <div class="fk-band-inner">
    {% assign upcoming_events = site.events | where_exp: "event", "event.date >= site.time" | sort: "date" %}
    {% if upcoming_events.size > 0 %}
    <div class="fk-stack">
      {% for event in upcoming_events %}
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
      <div class="fk-card-body"><p>No upcoming events at this time. Join our mailing list to be notified when new events are announced.</p></div>
      <div style="margin-top: var(--space-16);">
        <a href="/#mailing-list" class="k-btn k-btn-primary">Join Our Mailing List</a>
      </div>
    </div>
    {% endif %}
  </div>
</section>

<section class="fk-band fk-band-sand fk-band-sm">
  <div class="fk-band-inner">
    {% include facets/cta.html
       tone="sand"
       eyebrow="Catch up"
       title="Looking for past events?"
       text="Browse five years of TEDxBreckenridge talks, Salons, and gatherings."
       primary_label="View Past Events"
       primary_url="/past-events/" %}
  </div>
</section>
