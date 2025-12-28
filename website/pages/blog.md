---
layout: default
title: Blog
permalink: /blog/
description: Stories, updates, and insights from TEDxBreckenridge. Read about our events, speakers, community impact, and ideas worth spreading in Summit County.
---

<div class="page">
  <div class="page-header">
    <div class="page-header-content">
      <h1>Blog</h1>
      <p>Stories, updates, and insights from TEDxBreckenridge</p>
    </div>
  </div>

  <div class="page-content">
    <div class="blog-posts">
      {% for post in site.posts %}
      <article class="blog-post">
        <a href="{{ post.url | relative_url }}" class="blog-post-image">
          <img src="{{ post.image | relative_url }}" alt="{{ post.title }}" loading="lazy">
        </a>
        <div class="blog-post-content">
          <div class="blog-post-meta">
            <span class="blog-post-date">{{ post.date | date: "%B %d, %Y" }}</span>
            {% if post.author %}
            <span class="blog-post-author">by {{ post.author }}</span>
            {% endif %}
          </div>
          <h2 class="blog-post-title">
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </h2>
          <p class="blog-post-excerpt">{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
          <a href="{{ post.url | relative_url }}" class="blog-post-link">Read more →</a>
        </div>
      </article>
      {% endfor %}
    </div>

    <div class="blog-cta">
      <h3>Stay Updated</h3>
      <p>Join our mailing list for event announcements, speaker reveals, and community stories.</p>
      <a href="/#mailing-list" class="btn btn-primary">Join Our Mailing List</a>
    </div>
  </div>
</div>
