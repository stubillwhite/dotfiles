# Notebook map and comparison method

Notebook: `Scal_-483__Added_new_cols_Mhub_-Generic-MHUB_Xocs_migrated_analysis.ipynb` (Databricks, Core Complete ANI).
Cell numbers below are from the 2026-11-04 run. Cell numbers move; `scripts/nb_extract.py` finds cells by content.

## What it does
1. **Extract** (cells ~3-34): parses MHUB (MHUB/XFAB enriched ANI XML, parquet under `s3://sccontent-ani-parquet-prod/<date>/`) and RDP (XOCS round-tripped XML, "three-column" outputs) into JSON-structured columns with XMLUtils XQuery. Writes Delta tables `mhub_...parsed` / `xocs_...parsed`.
2. **Join** (cells ~43-61): matches on EID into `mhub_clone_xocs_migrated_<date>_matched`.
3. **Section checks** (cells ~65-78): `comparison_df` has one `match_<section>` boolean per section, built by comparing whole-section JSON after normalisations (`norm_json`). Only **singleton** records are compared (no `PUIsecondary` id): 88.4M compared, 24.0M excluded.
4. **Summaries**: cell 78 = per-section differing counts (`field_summary`, columns field/matched_rows/mismatched_rows/total_rows/match_pct/mismatch_pct); cell 79 = record summary (perfect_match_rows, rows_with_differences, avg_mismatch_count).
5. **Drill-downs** (cells ~83-167): one block per section, each with `<x>_exploded` (a displayed sample, typically 10,000 rows) and `<x>_field_summary` (exact counts per field). `aal` = author_affiliation_links, `ak` = author_keywords, `sb` = sequencebanks.

## Things that mislead if you forget them
- Drill-down counts are **exploded rows** (authors, references, affiliations), not records. 34,094 `e_address` rows is not 34,094 EIDs.
- Drill-down cells use **their own logic**, which can differ from the section check (sequencebanks: 192,760 drill-down rows vs 19 records at section level; bibliography and doc_level_metadata drill-downs only cover `itemids`).
- The `*_exploded` display is a sample; a rare field can show one row (SCAL-291 `e_address`: 1 row in 10,000 shown vs 34,094 in the summary).
- Section-level counts are real record differences; the 83% affiliations figure stands even though drill-down rows are inflated.
- The notebook ignores RDP `stage` (S200 vs S300) and MHUB `syndication-timestamp` (version drift between snapshots).
- MHUB and RDP may have been parsed on different dates (2026-10-06 vs 2026-11-03): check before blaming RDP.
- Several cells are `%skip` (EID summary, PUI union, SCAL-480 tests): not run, so they have no output.

## Rules already in the notebook
- SCAL-480: `aff_seq=0` author-affiliation links.
- `date_text` ignored only when `xfab-added="true"`.
- Section-level exclusions: `section_deep_exclude`, `xfab_default_exclude`, switch `IGNORE_XFAB_DEFAULTS`; currently `refd_itemcitation.websites.type` only. `e_address_type` is excluded as an XFAB default, `e_address` itself is not.

## Jira / Confluence
- Expected differences: https://elsevier.atlassian.net/wiki/spaces/RDP/pages/119603075416994/Parallel+Run+-+Expected+differences
- Data discrepancies for go-live: https://elsevier.atlassian.net/wiki/spaces/RDP/pages/119603080595188/Parallel+Run+-+Data+discrepancies+for+go-live
- Documented differences seen: SCAL-246 (ASJC), 333 (classification vs classification-code), 337 (publication year), 355 (ISBN length), 282 (ISSN type), 165 (e-address type), 469 (duplicate no-affiliation author group), 464/462 (XFAB defaults). `refd-itemcitation` is documented as ignorable but not yet applied in the notebook.
- SCAL-291 (RDP adds e_address to author; example EID 0001064507): MHUB has two entries for one `auid`, e-address only on the second; RDP copies it to both. Record count unknown; needs a distinct-EID query on the matched table.
- Fetch pages with the Atlassian MCP (`getConfluencePage`, `getJiraIssue`), and re-read them each run because the lists change.
