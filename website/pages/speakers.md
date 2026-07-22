---
layout: page
title: Meet our Speakers
permalink: /speakers/
description: Meet the 2026 TEDxBreckenridge speakers — voices from our mountain community and beyond, each carrying an idea worth spreading in Breckenridge, Colorado.
full_width: true
eyebrow: The 2026 Lineup
subtitle: Voices from our mountain community and beyond — each carrying an idea worth spreading. Every perspective is a facet; together they form the kaleidoscope.
speakers:
  - name: Leon Joseph Littlebird
    theme: The indigenous history of music
    role: Composer, songwriter & performer
    image: /assets/images/speakers/leon-littlebird.jpg
    bio:
      - Leon's passion for music and his ancestral histories inspired him at a very young age to research and study the origins of music.
      - As a composer, songwriter, and consummate performer, he is well known for his Native American flute styles and for concerts with world-class musicians and symphony orchestras.
      - His storytelling on "The Indigenous History of Music" has reached hundreds of audiences all over the country. He has also spent over a decade as a public speaker.
  - name: Jess Smith
    theme: Community is forged, not found
    role: Owner, Ark Valley Signs & Sidewalk Monkey
    image: /assets/images/speakers/jess-smith.jpg
    bio:
      - Jess Smith is a fourth-generation Salidan and the owner of two businesses rooted in the town that raised her&#58; Ark Valley Signs, a custom sign shop serving the region, and Sidewalk Monkey, a national e-commerce brand.
      - Raised by a game warden and a gardener, Jess has a particular love of place — and of story. She was a high school intern at the local daily, The Mountain Mail, a communications agent for the Utah Department of Natural Resources, and graduated with a B.A. in Communications with honors from Westminster College in Salt Lake City.
      - She continues to work at the intersection of craft, commerce, and community, running her businesses and her letterpress.
  - name: Oakley Van Oss
    theme: Confidence, purpose & belonging through real experience
    role: Construction & welding educator, Summit High School
    image: /assets/images/speakers/oakley-van-oss.jpg
    bio:
      - Oakley Van Oss is an educator, mentor, and advocate for creating opportunities where students can discover who they are and what they can become.
      - With 27 years of experience teaching in public high schools, he has designed and led learning experiences ranging from wilderness expeditions on the Green and Upper Colorado Rivers to international adventures in Costa Rica, Nicaragua, Peru, and Ecuador.
      - At Summit High School, Oakley serves as a construction and welding educator and the unofficial chief volunteer wrangler, cat herder, and trades promoter — building bridges between students, community members, and industry partners. His passion is helping young people find confidence, purpose, and belonging through authentic experiences and meaningful relationships.
  - name: Wouter Van De Pontseele
    theme: Listening for rare particles at the quantum frontier
    role: Professor, Colorado School of Mines
    image: /assets/images/speakers/wouter-van-de-pontseele.jpg
    bio:
      - Professor Wouter Van De Pontseele leads the Quantum Technologies at the Sensitivity Frontier group at the Colorado School of Mines, which develops superconducting sensors and cryogenic instrumentation to search for rare particle interactions.
      - A key project is the CURIE low-background facility, where the group is creating an ultra-quiet environment for sensitive experiments — supported by collaborations with industry partners such as Maybell Quantum and national labs such as NIST.
      - Before settling in Colorado, Wouter performed research at the intersection of particle physics, data science, and quantum sensing at the University of Oxford, Harvard University, and MIT.
  - name: Anna DeBattiste
    theme: The heart of a volunteer
    role: Volunteer, Summit County Rescue Group & Colorado Search and Rescue Association
    image: /assets/images/speakers/anna-debattiste.jpg
    bio:
      - Anna joined Summit County Rescue Group as a volunteer rescuer in 2002. At the time she was paying exorbitant amounts of money to participate in expedition-length adventure races, and she realized she could be cold, miserable, and exhausted for free — and for a purpose instead.
      - Today she also volunteers for the Colorado Search and Rescue Association (CSAR), doing public communications and education, conference planning, fundraising, member resources, collaboration forums, and whatever else no one else wants to do.
      - She is a small business owner but spends the bulk of her time on her volunteer work. She lives in Silverthorne, Colorado.
  - name: Travis Tallent
    theme: The hidden gems AI can't find
    role: Founder, MountainTowns.com
    image: /assets/images/speakers/travis-tallent.jpg
    bio:
      - Travis Tallent has spent the last decade helping the world's biggest brands — including Aspen Snowmass, Microsoft, LEGO, adidas, and Capital One — win in the age of AI search.
      - Along the way he noticed something&#58; the algorithms reshaping how the world finds everything left rural mountain communities behind.
      - Now he's the founder of MountainTowns.com, a community and membership pass connecting explorers with the hidden-gem businesses AI can't find.
  - name: Chris Ray
    theme: Reading climate in the rock rabbits
    role: Research scientist, Institute for Bird Populations & INSTAAR, CU Boulder
    image: /assets/images/speakers/chris-ray.jpg
    bio:
      - Chris Ray is a research scientist with two institutes&#58; the Institute for Bird Populations in California and the Institute of Arctic and Alpine Research at the University of Colorado Boulder. She studies trends in animal populations, focusing on the effects of climate change.
      - Her 39-year study of the "rock rabbits" (American pikas) helps us understand how small mammals respond to climate and other forces shaping where they live and how they behave. She also studies the rocky habitats pikas use to endure some of the harshest weather on the planet.
      - Like a pika, Chris lives in a stone house high in the Rockies — but the resemblance stops there, as she spends most days on the computer helping her students with their research and estimating population trends, with one eye on the wildlife outside her window.
  - name: Kurt Kionka
    theme: "Yes, if: the two words that move mountains"
    role: Project Director, Colorado Department of Transportation
    image: /assets/images/speakers/kurt-kionka.jpg
    bio:
      - Kurt Kionka is the Project Director for the Colorado Department of Transportation (CDOT), where he leads the massive I-70 Floyd Hill to Veterans Memorial Tunnels Project — transforming a congested, weather-battered eight-mile stretch of the I-70 Mountain Corridor and modernizing how Coloradans travel.
      - With over 23 years of multi-disciplinary experience at CDOT, Kurt's journey began in 2003 as a student intern doing public outreach for the I-70 corridor in Denver. Since then he has steered numerous complex infrastructure challenges, most notably leading the high-stakes US 36 Emergency Rebuild in 2019.
      - A proud Colorado native, Kurt earned his B.S. in Civil Engineering from Colorado State University. When he isn't managing multi-million dollar highway projects, he is exploring his home state with his wife and two children — skiing, visiting state parks, and enjoying the Denver Zoo. Fun fact&#58; in 2001 he won the Showcase Showdown on The Price is Right.
---

{% for speaker in page.speakers %}
{% assign is_flip = forloop.index0 | modulo: 2 %}
{% if is_flip == 0 %}{% assign band = 'parchment' %}{% else %}{% assign band = 'white' %}{% endif %}
<section class="fk-band fk-band-{{ band }}">
  <div class="fk-band-inner">
    <div class="fk-spk-row{% if is_flip == 1 %} fk-spk-flip{% endif %}">
      <div class="fk-spk-portrait-wrap">
        <div class="fk-spk-portrait">
          <span class="fk-spk-num" aria-hidden="true">{{ forloop.index | prepend: '0' | slice: -2, 2 }}</span>
          <img src="{{ speaker.image | relative_url }}" alt="{{ speaker.name }}" loading="lazy">
        </div>
      </div>
      <div class="fk-spk-body">
        <div class="fk-spk-eyebrow">Speaker</div>
        <h2 class="fk-spk-name">{{ speaker.name }}</h2>
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
