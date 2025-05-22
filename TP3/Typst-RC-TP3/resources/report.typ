#import "meta.typ" as meta
#import "capa.typ" as capa

#let base-header(data) = {
    metadata((marker: "PAGE-START"))
    set block(spacing: 0pt, clip: false)
    set par(leading: 0.4em)
    data
}

#let base-footer(data) = {
    set block(spacing: 0pt, clip: false)
    set par(leading: 0.4em)
    data
    metadata((marker: "PAGE-END"))
}

#let header(
    hasLine: true,
) = base-header[
    #set text(weight: 1)
    #grid(columns: (auto, 1fr), rows: auto)[
        #set align(left + bottom)
        #context {
            let loc = here()
            let post-headings = query(selector(heading.where(level: 1, outlined: true)).after(loc))
            let heading-found = none
            if post-headings != () and post-headings.first().location().page() == loc.page() {
                heading-found = post-headings.first()
            } else {
                let prev-headings = query(selector(heading.where(level: 1, outlined: true)).before(loc))
                if prev-headings != () {
                    heading-found = prev-headings.last()  
                }
            }

            if heading-found != none and heading-found.numbering != none {
                heading-found.body
            }
        }
    ][
        #set align(right + bottom)
        #context {
            let headings = query(heading.where(outlined: true))
            let first-numbered-heading = headings.at(0, default: none)

            let numbering = "i"
            if first-numbered-heading != none {
                if here().page() == first-numbered-heading.location().page() {
                counter(page).update(1)
                }
                if first-numbered-heading.location().page() <= here().page() {
                numbering = "1"
                }
            }

            context {
                counter(page).display(numbering)
            }
        }
    ]
    #v(8pt)
    #if hasLine {
        line(length: 100%, stroke: 0.4pt)
    }
]

#let footer(
    hasLine: true,
) = base-footer[
    #set text(style: "italic", weight: 1)
    #if hasLine {
        line(length: 100%, stroke: 0.4pt)
    }
    #v(8pt)
    #grid(columns: (auto, 1fr), rows: auto)[
        #set align(left + top)
        #meta.curso
    ][
        #set align(right + top)
        #meta.tema
    ]
]

#let index(
    title: "Índice",
    header: header(),
    hasHeader: false,
    footer: footer(),
    hasFooter: false,
) = [
    #set page(
        header: (if (hasHeader) {
            header
        }),
        footer: (if (hasFooter) {
            footer
        }),
        margin: (top: 3.5cm)
    )
    #outline(
        title: title
    )
]

#let styling(
    header: header(),
    hasHeader: true,
    footer: footer(),
    hasFooter: true,
    margins: (top: 3.5cm),
    body
) = [
    #set document(title: meta.titulo, author: meta.autores, date: datetime.today())
    #capa.cover()
    #set heading(numbering: meta.globals.titleNumbering)
    #set text(font: meta.globals.font, size: meta.globals.fontSize)
    #set page(
    header: (if (hasHeader) {
        header
    }),
    footer: (if (hasFooter) {
        footer
    }),
    margin: margins
    )
    #set text(lang: meta.globals.lang, region: meta.globals.region, hyphenate: true)
    #set heading(numbering: meta.globals.titleNumbering)
    #set par(leading: 0.5em, justify: true, linebreaks: "optimized")
    #set math.equation(numbering: meta.globals.equationsNumbering)
    #show figure.where(kind: table): set block(width: 80%)
    #show figure.where(kind: image): set block(width: 80%)
    #body
]