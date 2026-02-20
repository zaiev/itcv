// ====================================
// Tufte-inspired CV Template for Typst
// ====================================

#let title-font = ("Roboto Slab", "Palatino")
#let body-font  = ("Helvetica Neue", "Helvetica", "Arial")
#let accent     = rgb("#1DAEDA")

#let photo-size = 2.4cm
#let label-col  = 3.0cm
#let gap-col    = 0.6cm
#let col-offset = label-col + gap-col

#let title-text(size: 12pt, weight: "bold", body) = text(
  font: title-font, size: size, weight: weight, body,
)

#let round-photo(path, size: 4cm) = box(
  width: size, height: size,
  clip: true, radius: size / 2,
  image(path, width: size, height: size, fit: "cover"),
)

#let note-label(body) = align(right,
  text(
    font: title-font,
    size: 6.5pt,
    weight: "semibold",
    fill: rgb("#bbb"),
    tracking: 0.6pt,
    upper(body),
  )
)

#let labelled(label, content, top-offset: 1.5pt) = grid(
  columns: (label-col, gap-col, 1fr),
  rows: auto,
  pad(top: top-offset, note-label(label)),
  [],
  content,
)

#let linked-item(item, size: 9pt) = {
  if type(item) == str {
    text(size: size, item)
  } else {
    link("https://" + item.url, text(fill: accent, size: size, item.text))
  }
}

#let cv(data) = {

  set page(
    paper: "a4",
    margin: (left: 2.2cm, right: 2.6cm, top: 2.4cm, bottom: 2.4cm),
    footer: align(right, context text(size: 8pt, fill: rgb("#aaa"), counter(page).display("1 of 1", both: true))),
  )

  set text(
    font: body-font,
    size: 10pt,
    lang: data.at("lang", default: "en"),
  )

  set par(justify: false, leading: 0.65em, spacing: 0.8em)

  grid(
    columns: (label-col, gap-col, 1fr),
    gutter: 0pt,
    align: (top, top, top),

    {
      if "photo" in data and data.photo != none and data.photo != "" {
        v(-1em)
        align(right, round-photo("images/" + data.photo, size: photo-size))
      }
    },

    [],

    {
      title-text(size: 26pt, weight: "bold", data.name)

      if "who" in data {
        linebreak()
        v(0.45em)
        for w in data.who {
          title-text(size: 11pt, weight: "bold",
            text(fill: rgb("#555"), w))
            linebreak()
        }
      }

      if "address" in data {
        v(0.45em)
        for a in data.address {
          text(size: 8pt, fill: rgb("#777"), a)
          linebreak()
        }
      }

      let items = (
        link("mailto:" + data.email, text(fill: accent, size: 8pt, data.email)),
      )
      if "social_urls" in data {
        for u in data.social_urls {
          items.push(link("https://" + u, text(fill: accent, size: 8pt, u)))
        }
      }
      items.join(text(size: 8pt, fill: rgb("#bbb"), " · "))

      if "personal_urls" in data {
        linebreak()
        data.personal_urls.map(u =>
          link("https://" + u, text(fill: accent, size: 8pt, u))
        ).join(text(size: 8pt, fill: rgb("#bbb"), " · "))
      }

    },
  )

  if "intro" in data {
    v(0.9em)
    grid(
      columns: (col-offset, 1fr),
      align: top,
      [],
      {
        for i in data.intro {
          text(size: 9.5pt, fill: rgb("#333"), i)
          v(0.3em)
        }
      }
    )
  }

  v(1.5em)
  line(length: 100%, stroke: 0.3pt + rgb("#ddd"))
  v(1.5em)

  if "natural_languages" in data or "programming_languages" in data {
    labelled("Languages", {
      if "natural_languages" in data {
        text(size: 8.5pt, data.natural_languages.join("  ·  "))
      }
      if "programming_languages" in data {
        linebreak()
        text(size: 8.5pt, data.programming_languages.join(""))
      }
    })
    v(0.7em)
  }

  if "stack" in data {
    labelled("Stack", {
      for s in data.stack {
        text(size: 8.5pt, s)
        linebreak()
      }
    })
    v(0.7em)
  }

  if "projects" in data {
    labelled("Projects", {
      for p in data.projects {
        linked-item(p, size: 8.5pt)
        linebreak()
      }
    })
    v(0.7em)
  }

  if "talks" in data {
    labelled("Talks", {
      for t in data.talks {
        linked-item(t, size: 8.5pt)
        linebreak()
      }
    })
    v(0.7em)
  }

  v(1.5em)
  line(length: 100%, stroke: 0.3pt + rgb("#ddd"))
  v(1.5em)

  grid(
    columns: (col-offset, 1fr),
    [],
    title-text(size: 16pt, weight: "bold", "Experience"),
  )
  v(0.85em)

  if "experience" in data {
    for job in data.experience {
      labelled(job.years, {
        if "employer" in job {
          title-text(size: 10pt, weight: "bold", job.employer)
          text(
            size: 8.5pt,
            fill: rgb("#666"),
            "  \u{2013}  " + job.at("city", default: ""),
          )
          linebreak()
        }
        text(size: 8.5pt, style: "italic", fill: rgb("#555"), job.job)

        if "details" in job {
          v(0.45em)
          for d in job.details {
            text(size: 8.5pt, d)
            v(0.15em)
          }
        }

        if "stack" in job {
          v(0.35em)
          text(size: 7.5pt, fill: rgb("#aaa"), job.stack.join(", "))
        }
      })
      v(1.1em)
    }
  }

}
