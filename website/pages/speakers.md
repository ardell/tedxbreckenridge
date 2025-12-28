---
layout: page
title: Speakers
permalink: /speakers/
description: Meet the speakers at TEDxBreckenridge 2026. Discover thinkers, doers, and innovators sharing ideas worth spreading in Breckenridge, Colorado.
---

## 2026 Speakers

Our speaker lineup will be announced soon. We're curating an exceptional group of thinkers, doers, and innovators to share their ideas with our community. Have an idea worth spreading? <a href="/speak/">Apply to speak at TEDxBreckenridge 2026</a>.

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

## Past Speakers

Since our inaugural event in 2020, TEDxBreckenridge has featured 53 speakers sharing ideas worth spreading from the heart of the Rockies. [Watch all talks](/talks/) or learn more about <a href="/about/">our mission and values</a>.

### 2025: METAMORPHOSIS
Drew Petersen • Melanie Ash • Thayer Hirsh • Lauren Panasewicz • Gabriella Zheleznyak • Grace Klein • Patrick Murphy • Ellen Petry Leanse • Keila Perez Lopez • Erfa Alani • Andrew Young

### 2023: INSTINCT
Kara Napolitano • Michael Ballard • Christopher Fisher • Andy Thorn • Tony Molina • Isabelle Amigues • Eligar Sadeh • Sarah Rubinson Levy • Garrett Scharton • Kenzie Reichert • George Gerchow

### 2022: INTEGRATE
Harold Tan • David Servinsky • Liliana Baylon • Jennifer Toda • Jacob Vos • Shanaynay Music • Monica Harris • Sherry Walling • Hallie Jaeger • Debbie Marielle • Haley Littleton

### 2021: EXPAND
Anita Bangale • Douglas Vakoch • Christopher Leidli • Rachel Cronin • Sherry Hess • Stephanie Ralph • Dixie Chamness • Diane Schroeder • Jennifer Rae Getz • Don Ruggles

### 2020: CONNECTION
Stacy Smith • Ashley Hughes • Jeff Haugland • Jenna & Jordan McMurtry • Lisa Lee • Jaci Ohayon • Sean Hansen • Lucas Cantor • Ashlie Weisel • Leigh Girvin
