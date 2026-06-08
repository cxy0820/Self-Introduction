const accent = document.querySelector(".cursor-accent");
const root = document.documentElement;

if (accent) {
  window.addEventListener("pointermove", (event) => {
    accent.style.left = `${event.clientX}px`;
    accent.style.top = `${event.clientY}px`;
    root.style.setProperty("--pointer-x", `${(event.clientX / window.innerWidth) * 100}%`);
    root.style.setProperty("--pointer-y", `${(event.clientY / window.innerHeight) * 100}%`);
  });

  window.addEventListener("pointerleave", () => {
    accent.style.opacity = "0";
  });

  window.addEventListener("pointerenter", () => {
    accent.style.opacity = "1";
  });
}

const observer = new IntersectionObserver(
  (entries) => {
    for (const entry of entries) {
      if (!entry.isIntersecting) continue;
      entry.target.classList.add("is-visible");
      observer.unobserve(entry.target);
    }
  },
  { threshold: 0.18 }
);

for (const element of document.querySelectorAll(".reveal")) {
  observer.observe(element);
}

for (const card of document.querySelectorAll(".interactive-card")) {
  card.addEventListener("click", () => {
    card.classList.toggle("is-open");
  });
}

const copyButton = document.querySelector("#copy-email");
const copyStatus = document.querySelector("#copy-status");

if (copyButton && copyStatus) {
  copyButton.addEventListener("click", async () => {
    try {
      await navigator.clipboard.writeText("ncheng820@gmail.com");
      copyStatus.textContent = "Email copied.";
    } catch {
      copyStatus.textContent = "Copy failed. Email: ncheng820@gmail.com";
    }
  });
}
