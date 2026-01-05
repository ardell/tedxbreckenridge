---
layout: page
title: Upcoming Events
subtitle: Ideas worth spreading in Summit County
permalink: /events/
description: Upcoming TEDxBreckenridge events including Salon gatherings and our annual main event. Join us for inspiring talks and meaningful connections in the heart of the Rockies.
---

<div class="grid-gap-24">
{% assign now = site.time | date: '%Y-%m-%d' %}
{% assign upcoming_events = site.events | where_exp: "event", "event.date >= site.time" | sort: "date" %}

{% if upcoming_events.size > 0 %}
{% for event in upcoming_events %}
{% include format-time.html time=event.start_time %}
<div class="event-card">
    <div class="event-card-image">
        <img src="{{ event.image | relative_url }}" alt="{{ event.title }}" loading="lazy">
    </div>
    <div class="event-card-content">
        <div class="section-eyebrow">{% if event.event_type == "salon" %}TEDxBreckenridge Salon{% else %}Main Event{% endif %}</div>
        <h3 class="text-red"><a href="{{ event.url }}">{{ event.title }}</a></h3>
        <p>{{ event.description | truncate: 200 }}</p>
        <p class="text-stone card-meta">
            <strong>{{ event.date | date: '%B %-d, %Y' }}{% if event.start_time %} • {{ formatted_time }}{% endif %}</strong><br>
            {{ event.venue_name }}, {{ event.venue_city }}
        </p>
        <div class="btn-group">
            <a href="{{ event.url }}" class="btn btn-primary">Learn More</a>
        </div>
    </div>
</div>
{% endfor %}
{% else %}
<div class="card-white">
    <p>No upcoming events at this time. Join our mailing list to be notified when new events are announced.</p>
    <div class="mt-24">
        <a href="/#mailing-list" class="btn btn-primary">Join Our Mailing List</a>
    </div>
</div>
{% endif %}
</div>

<div class="cta-block">
    <p class="text-stone">Looking for past events?</p>
    <a href="/past-events/" class="btn btn-secondary">View Past Events</a>
</div>
