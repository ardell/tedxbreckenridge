---
layout: page
title: Past Events
subtitle: A look back at ideas worth spreading
permalink: /past-events/
description: Browse past TEDxBreckenridge events including Salon gatherings and main events. Watch talks and relive the moments that inspired our community.
---

<div class="grid-gap-24">
{% assign past_events = site.events | where_exp: "event", "event.date < site.time" | sort: "date" | reverse %}

{% if past_events.size > 0 %}
{% for event in past_events %}
<div class="event-card">
    <div class="event-card-image">
        <img src="{{ event.image | relative_url }}" alt="{{ event.title }}" loading="lazy">
    </div>
    <div class="event-card-content">
        <div class="section-eyebrow">{% if event.event_type == "salon" %}TEDxBreckenridge Salon{% else %}Main Event{% endif %}</div>
        <h3 class="text-charcoal"><a href="{{ event.url }}">{{ event.title }}</a></h3>
        <p>{{ event.description | truncate: 200 }}</p>
        <p class="text-stone card-meta">
            <strong>{{ event.date | date: '%B %-d, %Y' }}</strong><br>
            {{ event.venue_name }}, {{ event.venue_city }}
        </p>
        <div class="btn-group">
            <a href="{{ event.url }}" class="btn btn-secondary">View Event</a>
        </div>
    </div>
</div>
{% endfor %}
{% else %}
<div class="card-white">
    <p>No past events to display yet. Check back after our upcoming events!</p>
    <div class="mt-24">
        <a href="/events/" class="btn btn-primary">View Upcoming Events</a>
    </div>
</div>
{% endif %}
</div>

<div class="cta-block">
    <p class="text-stone">Want to watch talks from past events?</p>
    <a href="/talks/" class="btn btn-primary">Watch All Talks</a>
</div>
