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
    <style>
      .blog-posts {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(min(100%, 500px), 1fr));
        gap: 48px;
        margin-bottom: 48px;
      }

      .blog-post {
        display: flex;
        flex-direction: column;
        background: #fff;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05), 0 2px 4px rgba(0, 0, 0, 0.03);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        padding-bottom: 0;
        border-bottom: none;
      }

      .blog-post:hover {
        transform: translateY(-4px);
        box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1), 0 4px 8px rgba(0, 0, 0, 0.06);
      }

      .blog-post-image {
        position: relative;
        width: 100%;
        height: 320px;
        overflow: hidden;
        background: linear-gradient(135deg, #f5f5f5 0%, #e8e8e8 100%);
      }

      .blog-post-image::after {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(to bottom, rgba(0,0,0,0) 0%, rgba(0,0,0,0.1) 100%);
        opacity: 0;
        transition: opacity 0.3s ease;
      }

      .blog-post:hover .blog-post-image::after {
        opacity: 1;
      }

      .blog-post-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.5s ease;
      }

      .blog-post:hover .blog-post-image img {
        transform: scale(1.08);
      }

      .blog-post-content {
        display: flex;
        flex-direction: column;
        padding: 32px;
        flex: 1;
      }

      .blog-post-meta {
        display: flex;
        gap: 12px;
        align-items: center;
        margin-bottom: 16px;
        font-size: 13px;
        color: var(--stone);
        text-transform: uppercase;
        letter-spacing: 0.5px;
      }

      .blog-post-date {
        font-weight: 600;
      }

      .blog-post-author {
        font-style: normal;
        opacity: 0.8;
      }

      .blog-post-title {
        font-size: 24px;
        line-height: 1.3;
        margin: 0 0 16px 0;
      }

      .blog-post-title a {
        color: var(--ted-black);
        text-decoration: none;
        border-bottom: none;
        transition: color 0.2s ease;
      }

      .blog-post-title a:hover {
        color: var(--teal);
      }

      .blog-post-excerpt {
        font-size: 16px;
        line-height: 1.6;
        color: var(--stone);
        margin: 0 0 20px 0;
        flex: 1;
      }

      .blog-post-link {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        font-size: 15px;
        font-weight: 600;
        color: var(--teal);
        text-decoration: none;
        border-bottom: none;
        transition: all 0.2s ease;
        align-self: flex-start;
      }

      .blog-post-link:hover {
        color: var(--terracotta);
        gap: 12px;
      }

      @media (max-width: 1024px) {
        .blog-posts {
          grid-template-columns: 1fr;
        }
      }

      @media (max-width: 640px) {
        .blog-post-image {
          height: 240px;
        }

        .blog-post-content {
          padding: 24px;
        }

        .blog-post-title {
          font-size: 20px;
        }
      }
    </style>

    <div class="blog-posts">
      <article class="blog-post">
        <a href="https://www.tedxbreckenridge.com/blog/why-attend-tedxbreckenridge-instinct" target="_blank" class="blog-post-image">
          <img src="{{ '/assets/images/blog-instinct.jpg' | relative_url }}" alt="TEDxBreckenridge INSTINCT event">
        </a>
        <div class="blog-post-content">
          <div class="blog-post-meta">
            <span class="blog-post-date">September 22, 2023</span>
            <span class="blog-post-author">by Leah Rybak</span>
          </div>
          <h2 class="blog-post-title">
            <a href="https://www.tedxbreckenridge.com/blog/why-attend-tedxbreckenridge-instinct" target="_blank">Why Attend TEDxBreckenridge INSTINCT</a>
          </h2>
          <p class="blog-post-excerpt">Discover why our INSTINCT event was an unforgettable experience bringing together ideas worth spreading in the heart of the Rockies.</p>
          <a href="https://www.tedxbreckenridge.com/blog/why-attend-tedxbreckenridge-instinct" target="_blank" class="blog-post-link">Read more →</a>
        </div>
      </article>

      <article class="blog-post">
        <a href="https://www.tedxbreckenridge.com/blog/haqrw9f3agcrqdvjkgyja65o7ol8th" target="_blank" class="blog-post-image">
          <img src="{{ '/assets/images/blog-adventure-fest.jpg' | relative_url }}" alt="Adventure Fest event">
        </a>
        <div class="blog-post-content">
          <div class="blog-post-meta">
            <span class="blog-post-date">August 18, 2023</span>
            <span class="blog-post-author">by Leah Rybak</span>
          </div>
          <h2 class="blog-post-title">
            <a href="https://www.tedxbreckenridge.com/blog/haqrw9f3agcrqdvjkgyja65o7ol8th" target="_blank">Adventure Fest: Connection, Exploration, and Inspiration</a>
          </h2>
          <p class="blog-post-excerpt">Read about our most recent TEDxBreckenridge event!</p>
          <a href="https://www.tedxbreckenridge.com/blog/haqrw9f3agcrqdvjkgyja65o7ol8th" target="_blank" class="blog-post-link">Read more →</a>
        </div>
      </article>

      <article class="blog-post">
        <a href="https://www.tedxbreckenridge.com/blog/support-tedxbreckenridge" target="_blank" class="blog-post-image">
          <img src="{{ '/assets/images/blog-support-nonprofits.png' | relative_url }}" alt="Support TEDxBreckenridge">
        </a>
        <div class="blog-post-content">
          <div class="blog-post-meta">
            <span class="blog-post-date">July 20, 2023</span>
            <span class="blog-post-author">by Leah Rybak</span>
          </div>
          <h2 class="blog-post-title">
            <a href="https://www.tedxbreckenridge.com/blog/support-tedxbreckenridge" target="_blank">5 Reasons to Support Local Nonprofits</a>
          </h2>
          <p class="blog-post-excerpt">Click to learn more about why you should support local nonprofits!</p>
          <a href="https://www.tedxbreckenridge.com/blog/support-tedxbreckenridge" target="_blank" class="blog-post-link">Read more →</a>
        </div>
      </article>

      <article class="blog-post">
        <a href="https://www.tedxbreckenridge.com/blog/tedx-club-b-like-breckenridge-rtzh6" target="_blank" class="blog-post-image">
          <img src="{{ '/assets/images/blog-club-series.jpg' | relative_url }}" alt="TEDxBreckenridge Club Series">
        </a>
        <div class="blog-post-content">
          <div class="blog-post-meta">
            <span class="blog-post-date">July 5, 2023</span>
            <span class="blog-post-author">by Leah Rybak</span>
          </div>
          <h2 class="blog-post-title">
            <a href="https://www.tedxbreckenridge.com/blog/tedx-club-b-like-breckenridge-rtzh6" target="_blank">The TEDxBreckenridge Club Series</a>
          </h2>
          <p class="blog-post-excerpt">Check out the recap from the last TEDxBreckenridge Club event!</p>
          <a href="https://www.tedxbreckenridge.com/blog/tedx-club-b-like-breckenridge-rtzh6" target="_blank" class="blog-post-link">Read more →</a>
        </div>
      </article>
    </div>

    <div style="margin-top: 80px; padding: 48px; background: var(--cream); border-radius: 8px; text-align: center;">
      <h3 style="margin-bottom: 16px;">Stay Updated</h3>
      <p style="margin-bottom: 24px;">Join our mailing list for event announcements, speaker reveals, and community stories.</p>
      <a href="/#newsletter" class="btn btn-primary">Join Our Mailing List</a>
    </div>
  </div>
</div>
