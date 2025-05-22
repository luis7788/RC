#import "meta.typ" as meta

#let cover(
    title: meta.titulo,
    subtitle: meta.subtitulo,
    theme: meta.tema,
    department: meta.departamento,
    degree: meta.curso,
    semester: meta.semestre,
    school: meta.universidade,
    place: meta.lugar,
    authors: meta.autores,
    datetime: meta.data
) = {
    v(1cm)
    align(center, image(meta.globals.logo, width: 26%) + text(0.82em, weight: 100, school) + v(1mm) + text(0.82em, weight: 100, place))

    v(5mm)
    upper(align(center, text(font: meta.globals.font, 1.55em, weight: 600, title)))

    v(5mm)
    smallcaps(align(center, text(font: meta.globals.font, 1.38em, weight: 500, subtitle)))

    v(5mm)
    align(center, text(font: meta.globals.font, 1.40em, weight: 500, theme))

    v(15mm)
    align(center, text(0.9em, weight: 100, department))
    align(center, text(0.9em, weight: 100, degree + " " + semester))

    v(15mm)
    align(center, text(0.9em, weight: 100, "Equipa de Trabalho:") + v(1mm) + text(1.1em, weight: 100, (
        for author in authors [
            #(author + v(1mm))
        ]
    )))

    v(15mm)
    align(center, text(font: meta.globals.font, 1.2em, weight: 300, datetime))

    pagebreak()
}