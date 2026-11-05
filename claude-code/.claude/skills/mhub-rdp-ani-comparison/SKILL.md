---
name: mhub-rdp-ani-comparison
description: Analyse the Core Complete ANI MHub vs RDP (XOCS) comparison notebook (Scal-483 style Databricks .ipynb) and produce the section-by-section differences report. Use whenever Stu or the team asks to summarise, re-run, refresh or dig into MHub/RDP/XOCS ANI differences, affiliations/bibliography/authors discrepancies, example EIDs, whether a SCAL Jira ticket (e.g. SCAL-291) shows up in the notebook, raw MHUB/RDP XML for an EID, "real difference or false positive", or the Parallel Run expected-differences Confluence pages, even if the notebook is not named.
---

# MHub vs RDP ANI comparison review

Turns the comparison notebook's outputs into (1) a high-level summary, (2) a section-by-section review of which differences are real vs comparison artefacts, with suggested notebook changes, and (3) a list of EIDs where raw XML is needed to decide. It then folds in raw XML Stu supplies. The goal is to tell the RDP team what is genuinely wrong and tell the notebook owner what to fix, without counting false positives as RDP bugs.

Read `references/notebook-map.md` first (how the notebook works, traps in its numbers, Jira/Confluence links) and `references/known-patterns.md` (what earlier runs found, so you test it rather than rediscover it).

## Workflow

1. **Get the notebook.** Ask for the saved `.ipynb` if it isn't in uploads. It must have been saved with outputs; a notebook without them has nothing to extract.
2. **Extract the numbers**: `python3 scripts/nb_extract.py NOTEBOOK.ipynb -o summary.json`. Check `warnings`. Compare with `references/baseline-summary-2026-11-04.json` to say what moved since last time.
3. **High-level summary**: total counts (MHUB, RDP, matched, compared singletons, excluded), perfect-match vs differing records, and per-section differing count and % of compared. Lead with the few sections that hold most differences. Remember a record can differ in several sections, so percentages do not sum.
4. **Drill into sections** with `summary.json` (`drilldown` field counts, `samples` rows) and the notebook cells for that section. Always state whether a number is records or exploded rows. For each section ask: does the difference exist in the section check, or only in the drill-down (the two use different logic)? Does the sample support the count?
5. **Check documentation.** Re-fetch both Confluence pages and any SCAL ticket the user names (Atlassian MCP `getConfluencePage`, `getJiraIssue`). Say which observed patterns are documented, which are not, and which documented ones the notebook doesn't yet apply.
6. **Pick EIDs for raw XML.** From the samples choose EIDs that would separate real differences from artefacts: one per suspected pattern plus a few that look clean. Ask Stu for `mhub-ani-<EID>.xml` and `rdp-ani-<EID>.xml`, explaining the question for each EID (it makes pulling them worthwhile). Three examples first, a batch of ~70 once patterns are known.
7. **Analyse supplied XML** with `scripts/xml_tools.py` (unzip into a fresh directory, run `python3 -I`): `list`, `scan '<regex>'` for how often a tag or attribute appears per side, `show`/`diff` for one EID, `stage` for RDP stage and MHUB syndication timestamp. Verify each earlier hypothesis against the XML; the first pass was wrong about several (see mistakes in known-patterns.md). Update the report each batch.
8. **Build the report** (below), publish with the Artifact tool as a private page, and keep it updated by republishing to the same URL.

## Judging a difference

Classify each section's differences with the report tags: *likely real* (data lost or wrong in RDP), *comparison artefact* (the notebook creates it: attribute noise, ordering, empty vs null, weak join keys, double escaping), *documented*, *mixed causes*, *more XML wanted*. Be explicit about confidence and about sample bias: EIDs in the drill-down samples were chosen because they differ, so "N of M reviewed" is never a prevalence. Use wording like "in the 85 EIDs reviewed". If you cannot get a record count from the notebook (e.g. SCAL-291's 34,094 rows), say so and offer a distinct-EID query rather than converting rows to records.

When the XML contradicts something you said earlier, correct it plainly in the reply and the report.

## Building the report

`scripts/build_report.py` renders the page: facts row, key findings, per-section table with bars and tags, cross-cutting patterns, coverage caveats, prioritised notebook changes, section reviews, open questions for RDP.

```
python3 scripts/build_report.py --summary summary.json --out mhub-rdp-ani-review.html
```

With `--summary` all counts, percentages and the facts row refresh automatically. Without it the script reproduces the 2026-11-04 report exactly. **The narrative does not refresh itself**: the key-findings bullets, `CROSS`, `NOTEBOOK_CHANGES`, `REVIEWED` and each `D['section']` block (lead, shows, raw, assess, change, evidence) are hand-written text inside the script. After a new run, edit those so they match the new numbers and any new XML evidence; sections new to the notebook print "sections without narrative". Patch with Python replacing exact strings and assert each replacement applied, because the file is long and near-duplicate strings are easy to mis-edit.

The output is an HTML fragment (no doctype/head/body): publish it with the Artifact tool (load the artifact-design skill first), icon `chart`. Use title "MHub RDP ANI Review". Republish to the same URL on each update. Re-check numbers in the page against `summary.json` before publishing.

## Output conventions

- Plain, concise replies; the report holds the detail.
- Quote counts with units (records / rows / EIDs reviewed).
- Don't claim a pattern is general from hand-picked EIDs; don't blame RDP for what the comparison creates.
- Suggested notebook changes should say what to change and why, prioritised High/Medium/Low (see `NOTEBOOK_CHANGES`).

## Files

- `scripts/nb_extract.py` — notebook outputs to summary.json.
- `scripts/xml_tools.py` — raw XML loader, scan, diff, stage.
- `scripts/build_report.py` — report renderer with the 2026-11-04 findings embedded.
- `references/notebook-map.md` — notebook structure, traps, rules, Jira/Confluence.
- `references/known-patterns.md` — confirmed patterns, evidence, past mistakes.
- `references/baseline-summary-2026-11-04.json` — the numbers from the first run, for comparison.
