---
layout: default
title: Contact
permalink: /contact/
description: Get in touch with TEDxBreckenridge. Apply to speak, volunteer, sponsor, or reach out with questions. Connect with our community of local volunteers.
---

<div class="page">
  <div class="page-header">
    <div class="page-header-content">
      <h1>Get in Touch</h1>
      <p>Connect with our community of volunteers, thinkers, and doers</p>
    </div>
  </div>

  <div class="page-content">
    <div style="max-width: 700px; margin: 0 auto 80px; text-align: center;">
      <p style="font-size: 1.25rem; line-height: 1.7; color: var(--charcoal);">TEDxBreckenridge is run entirely by local volunteers passionate about bringing ideas worth spreading to Summit County. Whether you want to get involved, share your story, or support our mission, we'd love to hear from you.</p>
    </div>

    <h2 style="text-align: center; margin-bottom: 48px;">Ways to Connect</h2>

    <div class="contact-options">
      <div class="contact-option">
        <div class="contact-option-icon">💡</div>
        <h3>Share Your Idea</h3>
        <p>Have an idea worth spreading? We're looking for speakers who can inspire, challenge, and move our community.</p>
        <a href="https://tedxbreckenridge.com/speak" target="_blank" class="contact-option-link">Apply to Speak →</a>
      </div>

      <div class="contact-option">
        <div class="contact-option-icon">🙌</div>
        <h3>Join the Team</h3>
        <p>Help us create something special. From event planning to speaker coaching, there's a place for every skill.</p>
        <a href="https://tedxbreckenridge.com/volunteer" target="_blank" class="contact-option-link">Volunteer →</a>
      </div>

      <div class="contact-option">
        <div class="contact-option-icon">🤝</div>
        <h3>Become a Partner</h3>
        <p>Support local ideas and connect your business with our engaged community of curious minds.</p>
        <a href="https://tedxbreckenridge.com/sponsor" target="_blank" class="contact-option-link">Explore Sponsorship →</a>
      </div>
    </div>

    <div class="contact-form-section">
      <div class="contact-form-intro">
        <h2>Questions or Comments?</h2>
        <p>Drop us a line and we'll get back to you soon. Real humans read every message.</p>
      </div>

      <form class="contact-form" action="https://formspree.io/f/YOUR_FORM_ID" method="POST">
        <div class="form-row">
          <div class="form-group">
            <label for="name">Your Name</label>
            <input type="text" id="name" name="name" placeholder="Jane Smith" required>
          </div>

          <div class="form-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" placeholder="jane@example.com" required>
          </div>
        </div>

        <div class="form-group">
          <label for="subject">What's on your mind?</label>
          <input type="text" id="subject" name="subject" placeholder="General question, media inquiry, partnership..." required>
        </div>

        <div class="form-group">
          <label for="message">Your Message</label>
          <textarea id="message" name="message" rows="5" placeholder="Tell us more..." required></textarea>
        </div>

        <button type="submit" class="btn btn-primary" style="width: 100%;">Send Message</button>
      </form>
    </div>

    <div class="contact-social">
      <h3>Find Us Online</h3>
      <p>Follow along for speaker announcements, event updates, and behind-the-scenes stories from the mountains.</p>
      <div class="social-links">
        <a href="https://instagram.com/{{ site.social.instagram }}" target="_blank" class="social-link">
          <span class="social-icon">📷</span>
          <span class="social-label">Instagram</span>
        </a>
        <a href="https://youtube.com/{{ site.social.youtube }}" target="_blank" class="social-link">
          <span class="social-icon">▶️</span>
          <span class="social-label">YouTube</span>
        </a>
        <a href="https://www.flickr.com/photos/tedxbreckenridge/" target="_blank" class="social-link">
          <span class="social-icon">📸</span>
          <span class="social-label">Flickr</span>
        </a>
      </div>
    </div>
  </div>
</div>
