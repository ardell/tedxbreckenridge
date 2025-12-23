---
layout: page
title: Speakers
permalink: /speakers/
---

## 2026 Speakers

Our speaker lineup will be announced soon. We're curating an exceptional group of thinkers, doers, and innovators to share their ideas with our community.

{% if site.speakers.size > 0 %}
<div class="speakers-grid">
  {% for speaker in site.speakers %}
  <div class="speaker-card">
    <a href="{{ speaker.url }}">
      {% if speaker.image %}
      <img src="{{ speaker.image }}" alt="{{ speaker.title }}">
      {% endif %}
      <h3>{{ speaker.title }}</h3>
      <p class="speaker-tagline">{{ speaker.tagline }}</p>
    </a>
  </div>
  {% endfor %}
</div>
{% else %}
<p class="coming-soon">Speaker announcements coming soon!</p>
{% endif %}

## Become a Speaker

Interested in speaking at TEDxBreckenridge? We welcome applications from passionate individuals with ideas worth spreading.

<a href="/contact/" class="btn btn-primary">Submit Your Idea</a>
