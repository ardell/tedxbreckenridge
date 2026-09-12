/* ============================================================
   Emission program — progressive enhancement.
   The page is fully readable with JS disabled. This adds:
     1. the animated emission band (the signature device)
     2. scroll reveals
     3. sticky-nav state + active jump-nav chip
   ============================================================ */
(function () {
  "use strict";

  var root = document.querySelector(".emission-program");
  if (!root) return;

  var reduce =
    window.matchMedia &&
    window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  /* ----------------------------------------------------------
     THE EMISSION ANIMATION — matches the stage deck exactly.
     ----------------------------------------------------------
     The band has three fixed layers (in emission.css): a faint
     spectrum continuum, a 6px dark diffraction ruling over it (the
     always-visible field of thin coloured lines), and 19 glowing
     <i> lines at fixed positions/hues. We animate only each glow
     line's INTENSITY: exactly like the deck's `kline` keyframe,
     every line oscillates on its own slow clock between its --lo
     and --hi (never near-black — lo ≈ 0.3), independently, so at
     any instant some are bright and some dim. The one difference
     from the pure-CSS deck is that JS drives it, which buys us a
     single adjustable speed knob.

     Tuning: EMISSION.speed scales every line's period (higher =
     faster). Override per band with `data-speed` on the element.
  ============================================================ */
  var EMISSION = { speed: 1.0 };
  window.EMISSION = EMISSION; // expose for live tuning in the console

  // Per-profile [lo, hi] intensity envelope, matching the deck's profiles.
  // Every glow line stays at least `lo` (so the band never reads empty) and
  // pulses toward `hi`. `slice` biases which part of the spectrum burns
  // brightest (warm = left half, cool = right half); lines outside it use
  // the dim [dlo, dhi] range — same idea as emission.css's profile rules.
  var PROFILES = {
    full: { lo: 0.34, hi: 0.98 },
    warm: { lo: 0.34, hi: 0.98, dlo: 0.1, dhi: 0.3, slice: [0, 9] },
    cool: { lo: 0.34, hi: 0.98, dlo: 0.1, dhi: 0.3, slice: [10, 18] },
    dim: { lo: 0.16, hi: 0.4 },
    even: { lo: 0.42, hi: 0.62, frozen: true } // sponsors — no motion (TED rule)
  };

  function profileOf(el) {
    var m = el.className.match(/emission--(full|warm|cool|dim|even)/);
    return PROFILES[m ? m[1] : "dim"];
  }

  function rand(a, b) {
    return a + Math.random() * (b - a);
  }

  function initBand(el) {
    // Build the 19 <i> lines if not already present.
    if (!el.children.length) {
      var frag = document.createDocumentFragment();
      for (var n = 0; n < 19; n++) frag.appendChild(document.createElement("i"));
      el.appendChild(frag);
    }
    var lineEls = el.querySelectorAll("i");
    var profile = profileOf(el);
    var speed = parseFloat(el.getAttribute("data-speed"));
    var bandSpeed = isNaN(speed) ? 1 : speed;

    // JS owns opacity — stop the CSS keyframe fallback.
    el.classList.add("js-emit");

    // Give each line its own [lo,hi], period and phase (independent clocks,
    // like the deck's per-line animation-duration / -delay).
    var oscs = [];
    for (var i = 0; i < lineEls.length; i++) {
      var lo = profile.lo,
        hi = profile.hi;
      if (profile.slice) {
        var inSlice = i >= profile.slice[0] && i <= profile.slice[1];
        if (!inSlice) {
          lo = profile.dlo;
          hi = profile.dhi;
        }
      }
      oscs.push({
        lo: lo,
        hi: hi,
        period: rand(15, 34), // seconds, like the deck's 15–34s durations
        phase: rand(0, Math.PI * 2)
      });
      // frozen bands: set the mid value once and never animate
      if (profile.frozen || reduce) {
        lineEls[i].style.opacity = ((lo + hi) / 2).toFixed(3);
      }
    }

    if (profile.frozen || reduce) return null;
    return { lineEls: lineEls, oscs: oscs, bandSpeed: bandSpeed };
  }

  var bands = [];
  root.querySelectorAll(".emission").forEach(function (el) {
    var b = initBand(el);
    if (b) bands.push(b);
  });

  if (bands.length && !reduce) {
    var raf;
    var start = performance.now();

    var tick = function (now) {
      var t = ((now - start) / 1000) * EMISSION.speed; // seconds, speed-scaled
      for (var bi = 0; bi < bands.length; bi++) {
        var band = bands[bi];
        var bs = band.bandSpeed;
        for (var li = 0; li < band.oscs.length; li++) {
          var o = band.oscs[li];
          // 0..1 raised cosine — identical shape to the deck's kline keyframe
          var u = 0.5 - 0.5 * Math.cos((t * bs * 2 * Math.PI) / o.period + o.phase);
          band.lineEls[li].style.opacity = (o.lo + (o.hi - o.lo) * u).toFixed(3);
        }
      }
      raf = requestAnimationFrame(tick);
    };
    raf = requestAnimationFrame(tick);

    // Pause when the tab is hidden (saves battery); resume seamlessly.
    document.addEventListener("visibilitychange", function () {
      if (document.hidden) {
        cancelAnimationFrame(raf);
      } else {
        raf = requestAnimationFrame(tick);
      }
    });
  }

  /* ---------------------------------------------------------- */
  /* 2 · Content is always visible — no scroll-triggered reveals.
     People pull this up during the show; fading content in as they
     scroll is distracting. The emission bands stay lit from the
     start too (no per-strip warm-up). */
  root.querySelectorAll(".emission").forEach(function (el) {
    el.classList.add("is-in");
  });

  /* ---------------------------------------------------------- */
  /* 2b · Animate the speaker/emcee bio accordions.
     Native <details> snaps open. We collapse the bio with a
     grid-rows 0fr↔1fr transition: on open, add [open] then let the
     row grow; on close, shrink the row first, then remove [open]
     after the transition so the content stays visible while it eases. */
  if (!reduce) {
    root.querySelectorAll("details.ros__panel").forEach(function (d) {
      d.classList.add("js-details");
      var summary = d.querySelector("summary");
      var bio = d.querySelector(".ros__bio");
      if (!summary || !bio) return;

      summary.addEventListener("click", function (e) {
        e.preventDefault();
        if (d.classList.contains("is-busy")) return;
        d.classList.add("is-busy");

        if (d.open) {
          // CLOSING: currently at 1fr → force 0fr to transition down,
          // then drop [open] when the row finishes collapsing.
          var onClose = function () {
            bio.removeEventListener("transitionend", onClose);
            d.open = false;
            d.classList.remove("is-collapsed", "is-busy");
          };
          bio.addEventListener("transitionend", onClose);
          requestAnimationFrame(function () {
            d.classList.add("is-collapsed"); // forces 0fr → animates
          });
          setTimeout(onClose, 500); // fallback
        } else {
          // OPENING: reveal at 0fr, then next frame release to 1fr.
          d.classList.add("is-collapsed");
          d.open = true;
          var onOpen = function () {
            bio.removeEventListener("transitionend", onOpen);
            d.classList.remove("is-busy");
          };
          bio.addEventListener("transitionend", onOpen);
          requestAnimationFrame(function () {
            requestAnimationFrame(function () {
              d.classList.remove("is-collapsed"); // 0fr → 1fr, animates
            });
          });
          setTimeout(onOpen, 500); // fallback
        }
      });
    });
  }

  /* 3 · Sticky nav state past 120px. */
  var nav = root.querySelector(".ep-jump");
  if (nav) {
    var onScroll = function () {
      nav.classList.toggle("is-stuck", window.scrollY > 120);
    };
    window.addEventListener("scroll", onScroll, { passive: true });
    onScroll();
  }

  /* 4 · Active jump-nav chip. */
  var chips = Array.prototype.slice.call(root.querySelectorAll(".ep-chip"));
  if (chips.length && "IntersectionObserver" in window) {
    var byId = {};
    chips.forEach(function (chip) {
      var id = (chip.getAttribute("href") || "").replace("#", "");
      if (id) byId[id] = chip;
    });
    var setActive = function (id) {
      chips.forEach(function (c) {
        c.classList.toggle("is-active", c === byId[id]);
      });
    };
    var sectionObs = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (e) {
          if (e.isIntersecting && byId[e.target.id]) setActive(e.target.id);
        });
      },
      { rootMargin: "-45% 0px -45% 0px", threshold: 0 }
    );
    Object.keys(byId).forEach(function (id) {
      var sec = document.getElementById(id);
      if (sec) sectionObs.observe(sec);
    });
  }
})();
