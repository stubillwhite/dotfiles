# Patterns confirmed in raw XML (2026-11-04 run, 85 EIDs)

Counts come from hand-picked EIDs (chosen because they show differences), so they are **not prevalence figures** for the 88M records. Re-test each pattern on new XML before repeating it. Full wording, evidence EIDs and per-section assessment are in the `CROSS`, `NOTEBOOK_CHANGES` and `D[...]` blocks of `scripts/build_report.py`.

| Pattern | Evidence | Section | Status |
|---|---|---|---|
| `afid` / `dptid` attributes on `<affiliation>` omitted by RDP | MHUB 55 of 69 EIDs, RDP 1; 157 of 177 affiliation pairs identical once ignored (plus `<country>`) | affiliations | Undocumented. Dominates the 83% figure; the section check fails on attributes alone |
| `refd-itemcitation` | MHUB 1,341 elements in 43 EIDs, RDP 0 in 69 | bibliography | Documented, not applied in notebook |
| `SUBJABBR` classification | MHUB 69/69, RDP 0 | classifications | Undocumented |
| Correspondence with no `<person>` | 14/14 dropped by RDP | correspondences | Undocumented |
| `preferred-name` equals main name | RDP 501/501 authors, MHUB 438/503 | authors | Undocumented; drives given/indexed/initials counts |
| Double escaping of `<`, `>`, `&#x..;` | RDP 8 EIDs; MHUB double-escapes `&` in conference names (3/3) | title, descriptors, author_keywords, grantlist, conferenceinfo | Undocumented |
| Grant ids with space or `#` dropped | 3/3 | grantlist | Undocumented |
| Publisher `<affiliation>` added, `<publisheraddress>` dropped | 24 EIDs / 2 | source | Undocumented |
| Order-only differences | contributor-groups, abstracts, grants, manufacturers, tradenames, itemids order in 130 of 1,257 refs | several | Comparison artefact: sort first |
| RDP stage S200 or missing | 5/85 S200, all without volisspag | bibliographic_metadata | Notebook ignores stage |
| Source-db ids missing in RDP | REAXYSCAR 3/3; also REAXYS, CPX, CABS, EMBIO, EMBASE, MOSYEA, MEDL | process/doc_level | Undocumented |
| `nlm` chemical group, MSH descriptor groups dropped | seen in samples | chemicalgroup, descriptors | Undocumented |
| Recent records missing enhancement groups | 105001495826, 105003974223, 105011513558 | descriptors etc. | Undocumented |
| Version drift (MHUB syndication-timestamp older than RDP snapshot) | 105002826767, 105011184443 | bibliography, affiliations | Not a comparison rule |
| Same cited work, different SGR | 0000330985, 0000624442, 0000899145, 0000817135 (4/4) | bibliography | Open question for RDP |
| Duplicate `auid` entries in MHUB, e-address copied to both by RDP | 0001064507 (SCAL-291) | authors | Open; count unknown |

## Mistakes made on first pass (do not repeat)
- 0000023708 looked like a content difference but was a **key mismatch**, check join keys first.
- "Duplicate ARTNUM" was really distinct values dropped by RDP.
- A flat-department-id hypothesis did not hold for 37994 or 1064507.
- EIDs are 10-digit zero-padded in file names (`0001064507`); 12-digit Scopus-style ids like `105011184443` are not padded.
