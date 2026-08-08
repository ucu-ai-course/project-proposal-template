# Semester Project Proposal Template — "Artificial Intelligence" Course (UCU)

A LaTeX template for writing your semester project proposal.

## Getting started in Overleaf

1. Open the template project and click **Copy Project**.
2. Edit only [`main.tex`](main.tex) — the metadata at the top of the file and
   the section content. Don't touch `ucuproposal.cls`.
3. Overleaf will automatically detect the XeLaTeX engine from the
   `% !TeX program = xelatex` line at the top of `main.tex`.
4. Click **Recompile**. Check the compilation log (`Logs and output
   files`) — warnings about exceeding the text length or an incorrect
   percentage sum in the contribution statement will show up there.

## Getting started locally

You'll need XeLaTeX and Biber (included in any modern TeX Live or MacTeX
distribution). To compile:

```bash
latexmk main.tex
```

`.latexmkrc` is already configured for XeLaTeX + Biber, no extra flags
needed. To remove compilation artifacts:

```bash
latexmk -c
```

## What you can and cannot change

**Don't change**: fonts, page margins, font sizes, colors, the structure
and order of the title page elements, or the `ucuproposal.cls` file. All
of this already follows UCU's brand guidelines and has been verified.

**Don't delete sections** of the main text, even if one seems irrelevant
to your project — in that case, write one sentence explaining why it
doesn't apply.

**Do edit**: only the text and metadata in `main.tex` (title, team,
mentor, track, repository, date, section content) and `references.bib`.

## Scope

Title page (1) + main text (1–2) + list of references (no limit) =
3 pages of core material maximum. If the main text exceeds 2 pages,
compilation **does not fail**, but the log will show a warning:
`WARNING: Основний текст перевищує 2 сторінки`. Trim the text until the
warning disappears.

## Fonts

Body text — **Charis SIL**, headings and title page — **Fira Sans**.
Both are included in standard TeX Live (packages `charissil` and `fira`)
and available in Overleaf with no extra setup. If a typeface isn't
installed, the class **explicitly warns about it in the compilation log**
and falls back to a substitute font (`DejaVu Serif` / `DejaVu Sans`) —
there's no silent substitution.

## Tip

Check that the template compiles without errors or warnings **a week
before the deadline** — this leaves time to fix things if something goes
wrong (e.g. you forgot one of the required title page elements).

## Example

A fully filled-in (fictional) example is in the [`example/`](example/)
folder: [`example.tex`](example/example.tex) and the compiled
[`example.pdf`](example/example.pdf).
