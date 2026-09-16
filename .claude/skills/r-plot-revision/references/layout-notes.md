# Layout notes

## Use the right geometry

Treat a composed figure as nested allocations: the outer canvas, the subplot areas, and each subplot's title block, plotting region, tables, legend, and notes. A large right margin may arise from an oversized table column or unused viewport, even when all four declared margins match. Fix the responsible allocation before changing the whole canvas.

Use one outer-padding value in physical units for all four sides. Within it, use consistent panel gaps and component spacing, with enough room for the longest labels. Equal outer padding does not require equal widths for a short row-label column and a long confidence-interval column.

For ggplot2/patchwork, distinguish child `plot.margin` from the margin of the final composition. Apply tag styling and positioning at the level that actually owns each subplot. Tags should belong to whole subplots, not to every table or spacer component. Avoid fixing a title collision by moving tags into data coordinates.

For grid, gtable, or base-graphics forest plots, inspect viewport allocations, text extents, and table-column widths. Avoid arbitrary figure-wide horizontal shifts when the defect is an internal column gap. Check the first and last columns for clipping after any width reduction.

For patchwork errors involving `& theme(...)`, verify the installed package behavior, object class, and actual sourced file. Consider explicit child themes and final annotation styling if the evidence supports that correction. Do not apply a historical workaround without diagnosing the current error.

## Reference design

The user's reference figure is a two-column, three-row forest-plot composition. Each subplot has a modest plain letter at its upper-left, a left-aligned title and subtitle, study labels, estimates, adjacent numeric columns, and notes below the axis. Reuse that hierarchy when relevant. Do not copy its numerical results, treatment labels, exact whitespace, or bold table headings as universal requirements.

The explicit requirements are equal outer padding, adequate internal gaps, readable modest panel letters, and plain titles/subtitles/tags. The reference is not proof that its visible margins already satisfy every requirement.

## Common revision decisions

| Observation | Targeted response |
|---|---|
| Tag collides with a title | Reserve a tag position within the subplot allocation and shift or pad the title block; keep tag size modest. |
| Legend collides with subtitle | Increase the local subtitle-to-legend gap or allocate a legend row; inspect total panel height. |
| A long legend crowds a panel | Use requested multirow or per-panel legends, preserving color semantics. |
| CI heading touches weight heading | Widen their local gap or rebalance column widths; preserve adequate plotting-region width. |
| Table rows drift from estimates | Use shared row positions and compatible vertical scales, including header and footer allocations. |
| Figure becomes too narrow to read | Restore enough width or rebalance internal columns; do not simply shrink all text. |
| PDF differs from preview image | Check export device, dimensions, fonts, and clipping on the actual PDF. |
| Real labels exceed synthetic labels | Include representative long labels and realistic value widths in preview inputs; verify supplied actual labels when available. |
| Same remote error persists | Verify file names, source order, and stale session objects before proposing another patch. |

Use meaningful checks rather than tests that merely assert the theme settings you just wrote. A rendering and focused inspection are essential evidence for visual corrections.
