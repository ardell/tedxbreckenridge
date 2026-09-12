---
layout: page
title: Meet our Speakers
permalink: /speakers/
description: Meet the 2026 TEDxBreckenridge speakers — voices from our mountain community and beyond, each carrying an idea worth spreading in Breckenridge, Colorado.
full_width: true
eyebrow: The 2026 Lineup
subtitle: Meet the thinkers, makers, and neighbors taking the red dot in 2026.
---

<nav class="fk-yearnav" aria-label="Jump to section">
  <div class="fk-yearnav-inner">
    <span class="fk-yearnav-label">Jump to</span>
    <a href="#speakers">Speakers</a>
    <a href="#emcee">Emcee</a>
  </div>
</nav>

{% assign speaker_list = site.data.speakers.speakers | sort: "order" %}
{% for speaker in speaker_list %}
{% assign is_flip = forloop.index0 | modulo: 2 %}
{% if is_flip == 0 %}{% assign band = 'parchment' %}{% else %}{% assign band = 'white' %}{% endif %}
<section class="fk-band fk-band-{{ band }}" id="{{ speaker.slug }}">
  <div class="fk-band-inner">
    {% if forloop.first %}<span id="speakers"></span>{% endif %}
    <div class="fk-spk-row{% if is_flip == 1 %} fk-spk-flip{% endif %}">
      <div class="fk-spk-portrait-wrap">
        <div class="fk-spk-portrait">
          <span class="fk-spk-num" aria-hidden="true">{{ speaker.order | prepend: '0' | slice: -2, 2 }}</span>
          <img src="{{ speaker.image | relative_url }}" alt="{{ speaker.name }}" loading="lazy"{% if speaker.crop %} style="object-position:{{ speaker.crop }}"{% endif %}>
        </div>
      </div>
      <div class="fk-spk-body">
        <div class="fk-spk-eyebrow">Speaker</div>
        <h2 class="fk-spk-name">{% if speaker.title %}{{ speaker.title }} {% endif %}{{ speaker.name }}</h2>
        <div class="fk-spk-theme">{{ speaker.theme }}</div>
        <div class="fk-spk-role">{{ speaker.role }}</div>
        <div class="k-spectrum k-spectrum-pill fk-spk-rule" aria-hidden="true"></div>
        <div class="fk-prose" style="max-width: 62ch;">
          {% for para in speaker.bio %}<p>{{ para }}</p>{% endfor %}
        </div>
        {% if speaker.book %}
        <div class="fk-spk-book">
          <div class="fk-spk-book-label">Book Recommendation</div>
          <div class="fk-spk-book-title">{{ speaker.book.title }}</div>
          <div class="fk-spk-book-author">by {{ speaker.book.author }}</div>
        </div>
        {% endif %}
      </div>
    </div>
  </div>
</section>
{% endfor %}

{% assign emcee_band = speaker_list.size | modulo: 2 %}
{% if emcee_band == 0 %}{% assign band = 'parchment' %}{% else %}{% assign band = 'white' %}{% endif %}
<section class="fk-band fk-band-{{ band }}" id="emcee">
  <div class="fk-band-inner">
    <div class="fk-spk-row{% if emcee_band == 1 %} fk-spk-flip{% endif %}">
      <div class="fk-spk-portrait-wrap">
        <div class="fk-spk-portrait">
          <img src="{{ '/assets/images/speakers/joe-buck.jpg' | relative_url }}" alt="Joe Buck" loading="lazy">
        </div>
      </div>
      <div class="fk-spk-body">
        <div class="fk-spk-eyebrow">Your Emcee</div>
        <h2 class="fk-spk-name">Joe Buck</h2>
        <div class="fk-spk-role">Comedian &amp; host</div>
        <div class="k-spectrum k-spectrum-pill fk-spk-rule" aria-hidden="true"></div>
        <div class="fk-prose" style="max-width: 62ch;">
          <p>Born and raised under the Miami sun, Joe Buck brings the warmth, energy, and rhythm of his hometown into every interaction. After a few detours and travels, Joe planted roots in Colorado, where the mountains -- and his loyal hiking pup -- keep him grounded. When he's not on stage, Joe's heart is with the community, dedicating his time to local nonprofits and philanthropic work.</p>
          <p>With a mix of charm, relatability, and quick wit, Joe Buck takes audiences on a ride that feels less like a comedy show and more like catching up with a friend who always has the best stories.</p>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="fk-band fk-band-sand">
  <div class="fk-band-inner">
    {% include facets/cta.html
       tone="warm"
       eyebrow="Have an idea worth spreading?"
       title="The next voice on the red dot could be yours"
       text="Applications to speak at TEDxBreckenridge open each spring. Tell us the idea you can't stop thinking about."
       primary_label="Apply to Speak"
       primary_url="/speak/"
       secondary_label="How it works"
       secondary_url="/speak/" %}
  </div>
</section>

<section class="fk-band fk-band-white">
  <div class="fk-band-inner">
    <div class="fk-band-head">
      <div class="fk-band-eyebrow">Five Years of Ideas</div>
      <h2 class="fk-band-title">Past speakers</h2>
    </div>
    <div class="fk-prose" style="max-width: 780px;">
      <p>Since our inaugural event in 2020, TEDxBreckenridge has featured more than 50 speakers sharing ideas worth spreading from the heart of the Rockies. <a href="/talks/">Watch all talks</a> or learn more about <a href="/about/">our mission and values</a>.</p>
      <h4>2025 · Metamorphosis</h4>
      <p>Drew Petersen · Melanie Ash · Thayer Hirsh · Lauren Panasewicz · Gabriella Zheleznyak · Grace Klein · Patrick Murphy · Ellen Petry Leanse · Keila Perez Lopez · Erfa Alani · Andrew Young</p>
      <h4>2023 · Instinct</h4>
      <p>Kara Napolitano · Michael Ballard · Christopher Fisher · Andy Thorn · Tony Molina · Isabelle Amigues · Eligar Sadeh · Sarah Rubinson Levy · Garrett Scharton · Kenzie Reichert · George Gerchow</p>
      <h4>2022 · Integrate</h4>
      <p>Harold Tan · David Servinsky · Liliana Baylon · Jennifer Toda · Jacob Vos · Shanaynay Music · Monica Harris · Sherry Walling · Hallie Jaeger · Debbie Marielle · Haley Littleton</p>
      <h4>2021 · Expand</h4>
      <p>Anita Bangale · Douglas Vakoch · Christopher Leidli · Rachel Cronin · Sherry Hess · Stephanie Ralph · Dixie Chamness · Diane Schroeder · Jennifer Rae Getz · Don Ruggles</p>
      <h4>2020 · Connection</h4>
      <p>Stacy Smith · Ashley Hughes · Jeff Haugland · Jenna &amp; Jordan McMurtry · Lisa Lee · Jaci Ohayon · Sean Hansen · Lucas Cantor · Ashlie Weisel · Leigh Girvin</p>
    </div>
  </div>
</section>
