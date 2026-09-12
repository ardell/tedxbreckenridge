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
     THE EMISSION BAND — pixel-identical to the stage deck.
     ----------------------------------------------------------
     The deck draws the band in a native 1920×300 canvas: 19 glow
     lines at exact px positions/widths, each with its own blur,
     hue, --lo/--hi and slow oscillation clock, over a faint
     spectrum continuum and a 6px dark ruling. We reproduce that
     canvas verbatim in an .emission__stage and SCALE it to the
     container (--escale = width / 1920). Uniform scaling keeps
     every ratio — line widths, gaps, blur radii, ruling pitch —
     exactly as the slides at any display width, so desktop and
     mobile look the same and both match the deck.

     We animate each line's opacity between its --lo and --hi with
     a raised cosine — the deck's `kline` keyframe — but via JS so
     EMISSION.speed gives one adjustable speed knob.
  ============================================================ */
  var EMISSION = { speed: 1.0, stageW: 1920 };
  window.EMISSION = EMISSION;

  // The 19 lines, VERBATIM from the stage deck (stage-deck.html), in the
  // native 1920px coordinate system. [left, width, blur, spread, hue, lo, dur, delay]
  var HI = 0.92; // deck uses --hi:0.92 for every line
  var LINES = [
    [96, 5, 26, 13, "#c84a1a", 0.30, 19, -3],
    [144, 2, 12, 6, "#d2551b", 0.34, 24, -7],
    [230, 9, 44, 22, "#e87a1e", 0.38, 31, -11],
    [298, 3, 16, 8, "#e87a1e", 0.30, 17, -15],
    [384, 2, 10, 5, "#ef8f26", 0.34, 27, -19],
    [490, 11, 52, 26, "#f2a93b", 0.38, 22, -23],
    [576, 3, 14, 7, "#f2a93b", 0.30, 34, -27],
    [662, 2, 10, 5, "#f0bb4a", 0.34, 15, -31],
    [768, 7, 36, 18, "#e8c55a", 0.38, 29, -35],
    [854, 2, 12, 6, "#e8c55a", 0.30, 21, -39],
    [979, 3, 14, 7, "#d9c766", 0.34, 26, -43],
    [1104, 2, 10, 5, "#bcc276", 0.38, 18, -47],
    [1210, 6, 30, 15, "#95bb8c", 0.30, 32, -51],
    [1315, 2, 12, 6, "#6fb2a1", 0.34, 23, -55],
    [1440, 8, 40, 20, "#3f97a0", 0.38, 16, -59],
    [1536, 3, 16, 8, "#1a7a6d", 0.30, 28, -63],
    [1661, 10, 48, 24, "#1a7a6d", 0.34, 20, -67],
    [1766, 2, 12, 6, "#165f57", 0.38, 25, -71],
    [1853, 4, 20, 10, "#1a7a6d", 0.30, 30, -75]
  ];

  var isEven = function (el) { return /emission--even/.test(el.className); };

  function buildStage(el) {
    if (el.querySelector(".emission__stage")) return el.querySelector(".emission__stage");
    var stage = document.createElement("div");
    stage.className = "emission__stage";
    var cont = document.createElement("div"); cont.className = "continuum";
    var rule = document.createElement("div"); rule.className = "ruling";
    stage.appendChild(cont);
    stage.appendChild(rule);
    for (var i = 0; i < LINES.length; i++) {
      var L = LINES[i], gi = document.createElement("i");
      gi.style.left = L[0] + "px";
      gi.style.width = L[1] + "px";
      gi.style.background = L[4];
      gi.style.boxShadow = "0 0 " + L[2] + "px " + L[3] + "px " + L[4];
      gi.style.opacity = L[5]; // start at lo
      stage.appendChild(gi);
    }
    el.appendChild(stage);
    return stage;
  }

  // Keep --escale in sync with the container width.
  function sizeBand(el) {
    el.style.setProperty("--escale", el.clientWidth / EMISSION.stageW);
  }

  var bands = [];
  root.querySelectorAll(".emission").forEach(function (el) {
    var stage = buildStage(el);
    sizeBand(el);
    var lineEls = stage.querySelectorAll("i");
    // Sponsors band is frozen (TED rule): hold mid intensity, no animation.
    if (isEven(el) || reduce) {
      for (var i = 0; i < lineEls.length; i++) {
        lineEls[i].style.opacity = ((LINES[i][5] + HI) / 2).toFixed(3);
      }
      return;
    }
    var speed = parseFloat(el.getAttribute("data-speed"));
    bands.push({ lineEls: lineEls, bandSpeed: isNaN(speed) ? 1 : speed });
  });

  window.addEventListener("resize", function () {
    root.querySelectorAll(".emission").forEach(sizeBand);
  }, { passive: true });

  if (bands.length && !reduce) {
    var raf;
    var start = performance.now();
    var tick = function (now) {
      var t = ((now - start) / 1000) * EMISSION.speed;
      for (var bi = 0; bi < bands.length; bi++) {
        var band = bands[bi], bs = band.bandSpeed;
        for (var li = 0; li < band.lineEls.length; li++) {
          var lo = LINES[li][5], dur = LINES[li][6], delay = LINES[li][7];
          // raised cosine == the deck's kline keyframe (0/100%→lo, 50%→hi),
          // with the line's own duration and (negative) delay for phase.
          var u = 0.5 - 0.5 * Math.cos((2 * Math.PI * (t * bs - delay)) / dur);
          band.lineEls[li].style.opacity = (lo + (HI - lo) * u).toFixed(3);
        }
      }
      raf = requestAnimationFrame(tick);
    };
    raf = requestAnimationFrame(tick);
    document.addEventListener("visibilitychange", function () {
      if (document.hidden) cancelAnimationFrame(raf);
      else raf = requestAnimationFrame(tick);
    });
  }

  /* ---------------------------------------------------------- */
  /* 2 · Content and bands are always visible — no scroll reveals.
     People pull this up during the show; fading content in on
     scroll is distracting. */

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
