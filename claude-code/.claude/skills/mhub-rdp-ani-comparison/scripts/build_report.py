import html, re, json, argparse
_ap = argparse.ArgumentParser(description='Build the MHUB vs RDP ANI review page (HTML fragment for the Artifact tool).')
_ap.add_argument('--summary', help='summary.json from nb_extract.py; overrides all counts and percentages')
_ap.add_argument('--out', default='mhub-rdp-ani-review.html')
_ARGS = _ap.parse_args()

def esc(s):
    return html.escape(s, quote=False)

TAGS = {
    'real': ('Likely real', 'real'),
    'artefact': ('Comparison artefact', 'art'),
    'doc': ('Documented difference', 'doc'),
    'mixed': ('Mixed causes', 'mix'),
    'xml': ('More XML wanted', 'xml'),
}
TOTAL = 88420931

SECTIONS = [
 ('affiliations', 73476906, '83.10', 83.10, ['mixed']),
 ('bibliography', 64771094, '73.25', 73.25, ['doc', 'mixed']),
 ('authors', 34874121, '39.44', 39.44, ['mixed']),
 ('doc_level_metadata', 22641229, '25.61', 25.61, ['real', 'xml']),
 ('classifications', 7994990, '9.04', 9.04, ['doc', 'mixed']),
 ('correspondences', 4088021, '4.62', 4.62, ['real']),
 ('source', 3444407, '3.90', 3.90, ['mixed']),
 ('grantlist', 2971327, '3.36', 3.36, ['real']),
 ('descriptors', 243291, '0.28', 0.28, ['real']),
 ('title', 227201, '0.26', 0.26, ['mixed']),
 ('publication_metadata', 223659, '0.25', 0.25, ['doc']),
 ('abstract', 209399, '0.24', 0.24, ['mixed']),
 ('author_affiliation_links', 139285, '0.16', 0.16, ['real']),
 ('conferenceinfo', 15166, '0.02', 0.02, ['artefact']),
 ('bibliographic_metadata', 10232, '0.01', 0.01, ['real']),
 ('author_keywords', 10193, '0.01', 0.01, ['real']),
 ('chemicalgroup', 9462, '0.01', 0.01, ['real']),
 ('process_metadata', 6768, '0.01', 0.01, ['doc']),
 ('manufacturergroup', 2654, '<0.01', 0.0, ['real']),
 ('tradenamegroup', 2624, '<0.01', 0.0, ['mixed']),
 ('sequencebanks', 19, '<0.01', 0.0, ['artefact']),
]

# --- refresh counts from a new notebook run -------------------------------------------------
# Tags and narrative below describe the 2026-11-04 run. When --summary is given, only the numbers
# change; sections that are new get the 'More XML wanted' tag and an empty narrative to fill in.
SUMMARY = json.load(open(_ARGS.summary)) if _ARGS.summary else None
if SUMMARY:
    _tags = {n: t for n, _, _, _, t in SECTIONS}
    TOTAL = SUMMARY['compared']
    _sec = sorted(SUMMARY['sections'].items(), key=lambda kv: -kv[1]['differing'])
    SECTIONS = [(n, v['differing'], ('<0.01' if v['pct'] < 0.005 else f"{v['pct']:.2f}"), v['pct'], _tags.get(n, ['xml'])) for n, v in _sec]
    _missing = [n for n, *_ in SECTIONS if n not in globals().get('D', {})]

D = {}

D['affiliations'] = dict(
 lead="The 83% is mostly one undocumented difference: RDP does not write `afid` and `dptid` as attributes on `<affiliation>`. A smaller set of affiliations has real data differences.",
 shows=[
  "Drill-down rows (not records): organization 177.9M, country 173.0M, city 92.5M, source-text 79.9M, city-group 65.3M, postal-code 52.6M, address-part 45.4M, state 16.0M, text 4.2M. They exceed the 73.5M differing records because each unmatched affiliation counts on both sides.",
  "Of the 1,000 displayed drill-down rows, 986 are one-sided (496 missing in MHUB, 490 missing in RDP).",
 ],
 raw=[
  "MHUB writes `afid` on `<affiliation>` in 55 of 69 reviewed EIDs. RDP does so in 1 (0000000495). The notebook's own comment says RDP has no top-level `afid` / `dptid`, so this difference reaches the section-level comparison.",
  "Of 177 aligned affiliations in the 69 EIDs, 157 (89%) are identical once the `afid` / `dptid` attributes and the `<country>` element are ignored and ids are compared as one flat set.",
  "Department ids: in 0000003798 and 0000023242 (reviewed earlier) RDP writes the department id as an extra `<affiliation-id afid=...>`. In 0000037994 RDP lacks department 109457413 and holds 152948879 where MHUB has 130783625. In 0001064507 RDP has no `<affiliation-id>` at all.",
  "Content differences in 12 affiliations: 0000000495 (RDP merges two `<organization>` elements into one string), 105003747735 (RDP holds an unparsed `<text>` where MHUB has parsed `city` and `source-text`), and 105002826767 (different record versions, see the bibliography section).",
  "RDP lacks one or all affiliations in 0000376560 (third affiliation), 0005398668 (all) and 0015818613 (all, and the author-group is empty).",
  "Drill-down artefacts confirmed: in 0000008499 and in the two Prague addresses of 0000000495 both sides are identical, so the 'crossed' values come from the empty or shared join key.",
 ],
 assess="Not covered by either Confluence page apart from the `<country>` element. The attribute difference needs a decision from the RDP team. The department-id, missing-id, merged-organization and dropped-affiliation cases look like real differences.",
 change=[
  "Compare ids as one sorted set of `afid` and `dptid` values, and ignore the `afid` / `dptid` attributes on `<affiliation>`. If RDP confirms this is intended, add it to the Expected differences page.",
  "Use the same id set as the drill-down join key, and for affiliations with no ids key on organization, city-group and address-part instead of an empty key.",
  "Keep department-id loss (0000037994) and missing ids (0001064507) as reported differences.",
  "Report distinct EIDs per field instead of exploded rows.",
 ],
 evidence=['0000037994','0000008499','0000000495','0001064507','0000376560','0005398668','0015818613','105003747735'],
)

D['bibliography'] = dict(
 lead="Confirmed: RDP has no `refd-itemcitation` anywhere, which the Expected differences page says to ignore. Two further notebook issues inflate the section, and a few real differences remain.",
 shows=[
  "The section check compares the whole bibliography JSON, order-sensitive. The only exclusion is `refd_itemcitation.websites.type`.",
  "The drill-down compares only each reference's `pos` and `itemids`: 267,399 itemid differences and 11,871 presence differences across all data, about 279K against 64.8M flagged records.",
  "In the displayed 975 itemid rows, about 70% are SGR value differences with the same id types (for example MHUB 85081485859 against RDP 84870735877, 27 rows).",
 ],
 raw=[
  "`refd-itemcitation`: MHUB has 1,341 of them in 43 of the 69 EIDs. RDP has none in any EID.",
  "Item id order: in 5 EIDs RDP lists the same ids in a different order (MHUB `DOI, FRAGMENTID, SGR`; RDP `FRAGMENTID, DOI, SGR`). That is 130 of 1,257 references. The drill-down sorts ids, the section check does not, so the section check flags them.",
  "Real id differences (7 of 1,257 references): MHUB lists two distinct `ARTNUM` values and RDP keeps one (105001473443, two references); `ABSTRACTNUMBER` only in MHUB (105032224172); `DOI` and `ARTNUM` only in RDP (85096337656, an RDP S200 record). So the earlier 'duplicate ARTNUM' reading was wrong for 105001473443: the values are distinct and RDP drops the extra ones.",
  "Reference text: RDP `ref-website` `e-address` type is `url` where MHUB has `email` (6 EIDs, SCAL-165). Reference titles in 0000073683 and 0000814091 are double-escaped in RDP (see the cross-cutting section).",
  "Record versions differ in 105002826767 (MHUB reference list from 2025-09-02: 40 references, RDP 45 with only 34 in common) and 105011184443 (44 against 45).",
  "SGR differences (0000330985, 0000624442, 0000899145, 0000817135): in all four the `ref-info` text (title, authors, source, year) is identical and only the SGR differs, so the same cited work has a different SGR in each source. MHUB's `refd-itemcitation` resolves its SGR to the same `eid` (for example 2-s2.0-84916592350). Which SGR is current cannot be read from the XML.",
 ],
 assess="`refd-itemcitation` is documented and should be excluded. Itemid order is a notebook artefact. SGR differences, dropped extra `ARTNUM` values and dropped `ABSTRACTNUMBER` are not documented. The SGR differences look like the same work held under different SGRs (for example after a merge of duplicate records), which the SGR data owner would need to confirm. Version drift explains some reference-list differences.",
 change=[
  "Add `\"bibliography\": {\"refd_itemcitation\"}` to `section_deep_exclude`. The field name comes from the notebook's own default-values list and is untested.",
  "Sort reference itemids before the section comparison, as the drill-down already does.",
  "Extend the drill-down to every `ref-info` field, not only `itemids`.",
  "Compare the MHUB and RDP record versions (MHUB `syndication-timestamp` against the RDP source snapshot) and flag records where they differ.",
  "Re-run, then review what remains.",
 ],
 evidence=['105002826767','105011184443','105001473443','85096337656','105032224172','0000073683','0000814091'],
)

D['authors'] = dict(
 lead="The biggest author difference is systematic: RDP's `preferred-name` is always a copy of the author's own name. Other differences include a join artefact and some real losses.",
 shows=[
  "Drill-down rows: given_name_pn 53.1M, indexed_name_pn 49.8M, initials_pn 18.6M, author presence 678K, surname_pn 594K, authorseq 367K, indexed_name 172K, surname 102K, initials 74K, collaboration 73.6K, orcid 61.9K, given_name 44K, e_address 34K, degrees 15.8K, type 1.5K.",
 ],
 raw=[
  "RDP `preferred-name` has the same initials, indexed-name and surname as the main author name for 501 of 501 authors. For MHUB this holds for 438 of 503 (87%). Where MHUB differs, its preferred name is a profile form such as `Reddy K.` for an author printed as `Reddy K.M.` (0000005452).",
  "Other preferred-name differences: RDP adds `<ce:suffix>Jr.</ce:suffix>` to the preferred name (0000037994), formats given names as `D.L.` where MHUB has `D. L.`, and carries no preferred given-name when the main author has none (0000000495).",
  "`authorseq` swap in 0000683096 is a join artefact: both sides have two authors with the same `auid` (55664637300) in the same order.",
  "0001064507: MHUB has two entries for one `auid`, with an e-address on only the second. RDP puts the e-address on both.",
  "0000768447: author 3 has `auid` 7402587158 in MHUB (`date-locked` 2026-07-02) and 57201708469 in RDP, same name. 0000927742: author 3 has `auid` 60431438900 in MHUB (`date-locked` 2026-07-14) and 57191014881 in RDP. Both MHUB values carry a recent lock date, so RDP may not reflect a manual author reassignment.",
  "0000927742: the indexed name is `Goßnitzer E.` in MHUB and `Gossnitzer E.` in RDP while the surname is `Gößnitzer` in both. Both drop the umlaut and RDP also writes `ß` as `ss`.",
  "0015818613: RDP's author-group is empty, so three authors are lost.",
 ],
 assess="Not covered by either Confluence page. RDP has no profile-preferred names, which explains the bulk of the counts. The empty author-group and the `auid` difference are real; the `authorseq` rows are an artefact.",
 change=[
  "Report `*_pn` differences as a separate category, so the other 15 author fields are visible.",
  "Ask the RDP team whether preferred-name is meant to be the profile name; if not, add the behaviour to the Expected differences page.",
  "Join authors on position within the group and `auid`, not `auid` alone, so duplicate `auid`s do not cross.",
  "Check whether RDP picks up `date-locked` author reassignments; if not, flag `auid` differences where MHUB has a recent lock.",
  "Keep empty author-groups and `auid` differences as reported differences.",
 ],
 evidence=['0000005452','0000035028','0000683096','0000768447','0000927742','0001064507','0015818613','0000037994'],
)

D['doc_level_metadata'] = dict(
 lead="The drill-down covers only item ids. The raw XML shows real id differences in both directions.",
 shows=[
  "The drill-down compares `itemids` per idtype as sorted distinct sets. Over its displayed 1,000 rows `MEDL` missing in RDP is by far the most common difference (about 800 rows), then `SCOPUS` and `SRC-OCC-ID`.",
 ],
 raw=[
  "0000265152: MHUB has `MEDL` 13319207, RDP does not.",
  "0000625920: MHUB has `SCOPUS` 20151784181 and `SRC-OCC-ID`, RDP has neither.",
  "0000021787: RDP has `SCOPUS` 20093492641 that MHUB lacks.",
  "0024844290: RDP has `EMBIO` 1990009722 that MHUB lacks, and its `dbcollection` list has `EMBIO` and no `SCOPUS`.",
  "RDP carries fewer source-database ids: in 0000914421 it lacks `CPX`, `REAXYS`, `REAXYSCAR` and `SRC-OCC-ID`; in 0001844546 it lacks `CABS`, `EMBIO`, `REAXYSCAR` and `SRC-OCC-ID`; in 0030039314 it lacks `EMBASE`, `MOSYEA`, `REAXYSCAR` and `SCOPUS`. `REAXYSCAR` is missing in RDP in 3 of 3 records that have it. The matching `dbcollection` entries (`CPX`, `REAXYS`, `REAXYSCAR`, `CABS`, `EMBIO`) are missing too.",
  "RDP keeps `CAR-ID`, `PUI`, `SCOPUS`, `SCP`, `SGR`, `SNCHEM` and `SNCABS`.",
  "Item id order differs in every examined record (MHUB starts with `PUI`, RDP with `CAR-ID`). The notebook sorts them.",
 ],
 assess="RDP appears to carry only a subset of the source-database ids that MHUB carries (`MEDL`, `REAXYS`, `REAXYSCAR`, `CPX`, `CABS`, `EMBASE`, `MOSYEA`), and sometimes drops `SCOPUS` or `SRC-OCC-ID`. RDP-only `SCOPUS` and `EMBIO` ids appear in other records. None of this is documented; only `CAR-ID` and `SRC-OCC-ID` are documented as tolerated when RDP-only. If RDP deliberately omits third-party product ids, the comparison should ignore those idtypes.",
 change=[
  "Add an idtype-level summary over all rows, not the 1,000 displayed.",
  "Extend the drill-down to the non-id fields of `doc_level_metadata`.",
  "Ask the RDP team whether RDP intentionally omits `MEDL`, `REAXYS`, `REAXYSCAR`, `CPX`, `CABS`, `EMBASE` and `MOSYEA`. If it does, ignore those idtypes (and their `dbcollection` entries); if RDP-only `SCOPUS` and `EMBIO` are fine, add them to the tolerated list.",
 ],
 evidence=['0000265152','0000625920','0000021787','0024844290','0000914421','0001844546','0030039314'],
)

D['classifications'] = dict(
 lead="ASJC and `classification-code` naming are documented. RDP never emits SUBJABBR, and recent records can lose whole classification groups.",
 shows=[
  "Drill-down rows: ASJC 4.88M, GEOCLASS 3.22M, CPXCLASS 17.9K, FLXCLASS 15.0K, EMCLASS 11.9K, SUBJECT 2.1K, CABSCLASS 268, ENCOMPASSCLASS 252, WTACLASS 2.",
 ],
 raw=[
  "ASJC (0000002834): RDP has `2207` and `2102` in addition to MHUB's `2208`. This is SCAL-246.",
  "GEOCLASS (0000685601): MHUB `<classification-code>Related Topics</classification-code>`, RDP `<classification>Related Topics</classification>`. This is SCAL-333.",
  "CPXCLASS (0022154205): MHUB holds bare `<classification>714</classification>`, RDP holds code plus description. In 0000685601 both sides already use code plus description. So MHUB's form varies by record and RDP standardises it, the reverse direction from SCAL-333.",
  "EMCLASS (0015798482): MHUB has an empty `<classification/>`, RDP omits the element. This is an empty-element artefact.",
  "SUBJABBR is present in MHUB in 69 of 69 EIDs and in RDP in 0. It is not among the drill-down fields, so the 9% rate suggests the parsed struct does not carry it.",
  "105011513558 and 105011521595: RDP has only ASJC. MHUB also has CPXCLASS and FLXCLASS (and GEOCLASS in 105011513558). Both are recent records, and RDP is at S300/new in both.",
  "EMCLASS (0016653769): MHUB writes code plus description, RDP writes the code only. So RDP is richer than MHUB for CPXCLASS and poorer for EMCLASS.",
  "SUBJECT is present in MHUB in 12 of 81 EIDs and in RDP in 13 of 81, so neither side emits it consistently. In 0016653769 RDP has SUBJECT (`Health`, `Life Sciences`) where MHUB has only SUBJABBR (`MEDI`).",
 ],
 assess="ASJC and the GEOCLASS naming are documented (SCAL-246 and SCAL-333) but not filtered in the notebook. EMCLASS `[]` against null is a false positive. Missing classification groups on 105011513558 look like a real loss on recent records.",
 change=[
  "Add switchable exclusions for ASJC (SCAL-246) and the `classification` / `classification_code` naming (SCAL-333), following the `IGNORE_XFAB_DEFAULTS` pattern.",
  "Normalise empty arrays and empty elements to null.",
  "Confirm with the RDP team that the CPXCLASS and EMCLASS forms, the absence of SUBJABBR, and the missing CPXCLASS and FLXCLASS on recent records are intended.",
 ],
 evidence=['0000002834','0000685601','0022154205','0015798482','105011513558','0016653769','105011521595'],
)

D['correspondences'] = dict(
 lead="RDP drops every correspondence element that has no person. This explains the e-address and affiliation rows.",
 shows=[
  "Drill-down rows: e-address 4.41M, affiliation.country 1.56M, organization 1.08M, source-text 586K, city-group 475K, city 355K, address-part 312K, postal-code 211K, state 96K; person fields (indexed-name 7.8K, initials 3.6K, surname 1.1K, given-name 932, degrees 147, suffix 73).",
  "The displayed rows have the empty key `||` and the value on the MHUB side only.",
 ],
 raw=[
  "In the 69 EIDs, MHUB has 14 correspondence elements with no `<person>` (an affiliation only, or an e-address only). RDP has none of those 14.",
  "All 43 MHUB correspondence elements that have a `<person>` are kept by RDP.",
  "Examples: 0000000634 and 0000151045 (affiliation only), 0004697568 (e-address only).",
 ],
 assess="Not documented. The consistency (14 of 14 dropped, 43 of 43 kept) suggests deliberate behaviour in RDP, which would belong on the Expected differences page. If it is not deliberate, it is a data loss.",
 change=[
  "Ask the RDP team whether dropping person-less correspondence is intended. If yes, ignore person-less MHUB correspondence in the comparison.",
  "Key correspondences on person name instead of the empty key.",
 ],
 evidence=['0000000634','0000151045','0004697568'],
)

D['source'] = dict(
 lead="Several separate patterns: an ordering artefact, documented ISSN and URL type differences, and undocumented changes to publisher, country and source type.",
 shows=[
  "Drill-down rows: contributor-groups 2.41M, sourcetitle 488K, isbns 369K, type 82.9K, websites 52.2K, country 45.0K, publisher 13.1K, translated_sourcetitle 6.7K, issns 6.2K, article_number 896, volumetitle 395, srcid 218, translated_sourcetitle_lang 137, codencode 94, bib_text 86, issuetitle 59.",
 ],
 raw=[
  "contributor-groups: 0000526998 has the same three editors in the reverse order, and 0001626428 has the same 13 editors in a different order. Every group has `seq=\"1\"`, so order carries no meaning. This is an artefact.",
  "Publisher: RDP adds `<affiliation><organization>…</organization></affiliation>` to `<publisher>` in 24 of 69 EIDs. RDP drops `<publisheraddress>` in 2 (0008309793, 0003938606). The publisher e-address `type` is `url` in RDP and `email` in MHUB (0000526998).",
  "Website: `type` `email` against `url` (SCAL-165). In 0002804707 the URL also changes from `http://` to `https://`.",
  "Source `type`: RDP adds `type=\"j\"` where MHUB has none (0008309793, 1 of 69). Source `country`: RDP omits it in 0014172465 and 0014278639 (2 of 69).",
  "sourcetitle (0013710656): MHUB's `<sourcetitle xfab-added=\"true\">` is absent in RDP. The notebook already ignores `date_text` when `xfab-added=\"true\"`, but not this.",
  "`issn` without `type` against `type=\"print\"`: SCAL-282, already ignored by the notebook.",
  "0000228609: RDP has a `translated-sourcetitle`, a `website` and a `publisher` that MHUB lacks, so RDP is richer here.",
 ],
 assess="The ISSN `type` and website `type` differences are documented. Ordering is an artefact. The publisher affiliation added by RDP, the dropped `publisheraddress`, the added source `type`, and dropped `country` are not documented.",
 change=[
  "Sort `contributor-groups` before comparing.",
  "Extend the `xfab-added=\"true\"` rule to `sourcetitle`, and the `type` exclusion to publisher `e-address`.",
  "Ignore the ISBN `length` attribute (SCAL-355).",
  "Ask the RDP team about the publisher affiliation, the dropped `publisheraddress` and the dropped `country`.",
 ],
 evidence=['0000228609','0000526998','0001626428','0008309793','0013710656','0002804707','0014278639','0014172465','0003938606'],
)

D['grantlist'] = dict(
 lead="RDP drops grant ids that contain a space or `#`. Plain ids are kept.",
 shows=[
  "Drill-down rows: grants 2.96M, grant-text 15.3K.",
 ],
 raw=[
  "Dropped (3 of 3): `BNS 82-0723` (0001463671), `#MH46586` (0005372091), `N 25-42-00018` (105001473443).",
  "Kept (3 of 3): `PB95-0103`, `218328` and `220540`, `80NSSC20M0016`.",
  "Grants in the reverse order (0002958980) are an ordering artefact.",
  "Grant text with markup (105003747735): RDP double-escapes the `<a href=…>` text (see the cross-cutting section).",
  "`complete=\"y\"` and the grant-text `xml:lang` are absent in RDP: documented defaults.",
 ],
 assess="Dropping the ids with a space or `#` is not documented and loses data. The three dropped ids are not a complete test, but the split is clean.",
 change=[
  "Keep grant-id differences as reported differences, split by sub-field.",
  "Sort grants before comparing.",
  "Report the RDP behaviour so it can be fixed or documented.",
 ],
 evidence=['0001463671','0005372091','105001473443','0002958980','105003747735'],
)

D['descriptors'] = dict(
 lead="RDP lacks whole descriptor groups on some records, mostly MSH. Case differences are rare.",
 shows=[
  "Drill-down rows by group: DRG 233.7K, MED 218.2K, MSH 36.9K, CFL 20.3K, CMH 16.8K, CCV 16.3K, GDE 9.6K, RGI 4.8K, MKW 1.1K, CLU 936, PCV 875, FDE 462, MUD 368, SPC 196, WDE 54.",
 ],
 raw=[
  "Among 34 EIDs with descriptors, group types differ in 12.",
  "`MSH` is in MHUB and not in RDP in 6 (0001299207, 0006676157, 0007292851, 0018634925, 0018704783, 0024844290). 1542314769 has `MSH` in RDP only.",
  "Recent records: RDP lacks `DRG` and `MED` in 105001495826 and 105003974223, and lacks `CCV`, `CFL`, `CMH`, `GDE`, `RGI` in 105011513558.",
  "The type code swaps in both directions: MHUB `CLU` against RDP `CFL` (0022154205), MHUB `CFL` against RDP `CLU` (34548063771).",
  "Case: only 0022154205 differs by case alone (`COMPUTER ARCHITECTURE` against `Computer architecture`).",
  "0016902339: RDP double-escapes `<` in a term.",
  "`weight` and `candidate` are absent in RDP: documented defaults.",
 ],
 assess="Missing groups are not documented and look like real losses, especially for recent records. The `CLU` / `CFL` swap in both directions needs an explanation. Case is not a significant driver.",
 change=[
  "Report group-level presence (which group types are missing) separately from term-level differences.",
  "De-duplicate `links` within a term, as elsewhere in the notebook.",
  "Ask the RDP team why `MSH` is missing and what controls `CLU` against `CFL`.",
 ],
 evidence=['0001299207','0018634925','0022154205','34548063771','105001495826','105003974223','105011513558','0016902339'],
)

D['title'] = dict(
 lead="The raw XML shows an RDP double-escaping bug, some missing language attributes, and two drill-down artefacts.",
 shows=[
  "Drill-down rows: title_xml_lang 185.8K, title 43.8K, title_original 8.0K, title presence 1.1K.",
 ],
 raw=[
  "Double escaping (0000814091): MHUB `(&lt;10 μm)`, RDP `(&amp;lt;10 μm)`. The RDP value decodes to the literal text `&lt;`.",
  "Spacing (0000121614): RDP inserts a space between adjacent inline elements (`N<inf>4</inf> <sup>+</sup>`).",
  "`xml:lang` and `language` (0014172465): present in MHUB, absent in RDP, where RDP also has no status `stage`. RDP records without a `stage` attribute appear in 10 of 69 EIDs.",
  "Empty original-language title (0021725989): MHUB has an empty Polish `<titletext original=\"y\" xml:lang=\"pol\"/>`, RDP omits it.",
  "`title_original` y/n swaps are position artefacts: the section check sorts titles and the drill-down does not.",
 ],
 assess="The `language` attribute is documented but `xml:lang` is not. Double escaping is not documented and looks like a bug. The `title_original` rows are drill-down artefacts.",
 change=[
  "Sort titles in the drill-down as the section check does.",
  "If `xml:lang` on `titletext` is another XFAB default, add it to `xfab_default_exclude` and the Expected differences page.",
  "Report double-escaped text as a named category (see the cross-cutting section).",
  "Normalise whitespace between inline elements.",
 ],
 evidence=['0000814091','0000121614','0014172465','0021725989'],
)

D['publication_metadata'] = dict(
 lead="Publication year follows SCAL-337 in 2 of 3 reviewed records. Day and month defaults are not documented.",
 shows=[
  "Drill-down rows: publicationyear 214.3K, publication_date 13.4K.",
 ],
 raw=[
  "0000305389 and 0000413251: MHUB `publicationyear` 1996 but `publicationdate` 1997 (inconsistent). RDP has 1997 in both. This matches SCAL-337 (about 235K records).",
  "0007295062: MHUB 1996 (both fields), RDP 1997 (both fields). Both are internally consistent and nothing in the XML says which is right.",
  "0022154205: MHUB has `<month>01</month><day>01</day>` with an `xfab-added=\"true\"` date text. RDP has the year only and the original date text `Nov 12`.",
 ],
 assess="SCAL-337 is documented. The year difference in 0007295062 and the month and day defaults are not covered. MHUB's `xfab-added=\"true\"` flag marks the defaulted values.",
 change=[
  "Add a switchable exclusion for the SCAL-337 `publicationyear` differences.",
  "When MHUB's date text has `xfab-added=\"true\"`, compare only the year, as for `ait:date-sort`.",
 ],
 evidence=['0000305389','0000413251','0007295062','0022154205'],
)

D['abstract'] = dict(
 lead="Mostly order and whitespace. The publisher copyright difference is structural.",
 shows=[
  "Drill-down rows: abstract 270.0K, perspective 85.4K, abstract_original 27.4K, publishercopyright 9.7K, presence 144.",
 ],
 raw=[
  "Abstract order differs (0016221040, 0003938606, 105009308414), which swaps `original` and `perspective` values when joined by position. The section check does not sort abstracts either.",
  "Spacing (0000755730): `UO22+` against `UO2 2+`. RDP adds a space between inline elements.",
  "Publisher copyright (105009308414): MHUB has one copyright per abstract. RDP gives every abstract the same concatenated string (`Copyright © 2025 JLE.© 2025 John Libbey. All rights reserved.`).",
 ],
 assess="Order differences are artefacts. The copyright change is not documented and may be intended.",
 change=[
  "Pair abstracts by `xml:lang` and `perspective`, not position, in both the section check and the drill-down.",
  "Normalise whitespace between inline elements.",
 ],
 evidence=['0016221040','0003938606','0000755730','105009308414'],
)

D['author_affiliation_links'] = dict(
 lead="Differences follow RDP's missing affiliations and authors.",
 shows=[
  "Drill-down: value_mismatch 830,013; missing in RDP 3,334; missing in MHUB 187 (author-level rows).",
  "The notebook already applies SCAL-480 before comparing.",
 ],
 raw=[
  "0000376560: RDP lacks the third affiliation, so the author has two links, not three.",
  "0005398668: the author-group has no affiliation in RDP, so MHUB's `[1]` becomes `[0]`.",
  "0015818613: RDP's author-group has no authors, so there are no links.",
 ],
 assess="These look like real losses. They are separate from SCAL-469 (RDP drops the duplicate no-affiliation group).",
 change=[
  "Split the drill-down into extra, missing and replaced links, to separate SCAL-469 from real loss.",
  "Report distinct EIDs.",
 ],
 evidence=['0000376560','0005398668','0015818613'],
)

D['conferenceinfo'] = dict(
 lead="The confevent differences are an MHUB double-escaped ampersand (3 of 3 reviewed). RDP is correct. Smaller formatting differences and an empty element make up the rest.",
 shows=[
  "Drill-down rows: confevent 15,040, confpublication 144.",
 ],
 raw=[
  "0014363760, 0014372073 and 0014630110: MHUB double-escapes the ampersand (`&amp;amp;`) in the conference name (for example `Chem &amp;amp; Process Eng`). RDP is correct (`&amp;`). This is the reverse of the RDP double escaping, and all three reviewed confevent differences are this.",
  "34548063771: `procpagecount` `2279p` against `2279`.",
  "84873023491: `procpartno` `1of1` against `1 of 1`. RDP adds an empty `<confsponsors><confsponsor/></confsponsors>`.",
  "`confsponsors complete=\"y\"` is absent in RDP: documented default.",
 ],
 assess="The 15,040 confevent differences are very likely the MHUB double escape, which is an MHUB data problem and not an RDP difference. The `procpagecount` and `procpartno` differences are not documented; RDP looks to be cleaning values. The empty sponsor element is an artefact.",
 change=[
  "Compare conference names with a single level of entity decoding, or report MHUB double-escaped `&amp;amp;` as a named MHUB-side category.",
  "Normalise `procpagecount` and `procpartno` or record them as expected differences.",
  "Ignore empty `confsponsor` elements.",
 ],
 evidence=['0014363760','0014372073','0014630110','34548063771','84873023491'],
)

D['bibliographic_metadata'] = dict(
 lead="RDP records at stage S200 have no volume, issue or pages (5 of 5). One further record lacks an article number at S300.",
 shows=[
  "Drill-down rows: volume 9,908, issue 9,050, firstpage 8,623, lastpage 8,458, article_number 896, pages 54, supplement 41.",
 ],
 raw=[
  "105011184443, 85123473429, 105014098929, 105018063113 and 85096337656: RDP has status `stage=\"S200\" state=\"new\"` and no `<volisspag>`. MHUB is S300 with volume, issue and pages. Some of these RDP records also lack `translated-sourcetitle`, and 85096337656 has less parsed reference text.",
  "85038268008: RDP lacks `<article-number>` and is at S300.",
  "RDP is S200 in 5 of the 85 reviewed EIDs, and all 5 lack `<volisspag>`. MHUB is never S200.",
 ],
 assess="Not documented. S200 in RDP goes with missing volume, issue and pages in every reviewed case, so S200 appears to mean a less complete record. The notebook ignores `stage`, so S200 records cannot be separated from the rest.",
 change=[
  "Add RDP `stage` to the output and report differences by stage, so S200 records are separate.",
  "Ask the RDP team what S200 means, whether S200 records are expected to be incomplete, and whether they will be completed before go-live.",
 ],
 evidence=['105011184443','85123473429','105014098929','105018063113','85096337656','85038268008'],
)

D['author_keywords'] = dict(
 lead="Double escaping in RDP, and keywords missing entirely on one recent record.",
 shows=[
  "Drill-down rows: author-keyword 17.6K, presence 1.2K, original 711.",
 ],
 raw=[
  "0000073683: MHUB `Solid-state &lt;sup&gt;13&lt;/sup&gt;C NMR` (single escape), RDP `&amp;lt;sup&amp;gt;…` (double escape).",
  "0000141336: MHUB `&#xE2;&#x88;&#x92;`, RDP `&#xE2;&amp;#x88;&amp;#x92;`.",
  "105001215810: RDP has no `<author-keywords>` at all.",
  "1542314769: RDP drops `original=\"y\"` and `xml:lang`.",
 ],
 assess="Double escaping is not documented. `xml:lang` is a documented default. `original=\"y\"` is not documented. Missing keywords on 105001215810 look like a real loss.",
 change=[
  "Report double-escaped text as a named category.",
  "Add `original` to the ignore list only if the RDP team confirms it is a default.",
 ],
 evidence=['0000073683','0000141336','105001215810','1542314769'],
)

D['chemicalgroup'] = dict(
 lead="RDP keeps only the `esbd` chemicals and drops the `nlm` group.",
 shows=[
  "Drill-down rows: presence 8,504, chemical 3,533.",
 ],
 raw=[
  "0001299207: MHUB has `<chemicals source=\"esbd\">` and `<chemicals source=\"nlm\">` (Blood Coagulation Factors, Platelet Factor 4). RDP has only the `esbd` group.",
  "0007292851: MHUB has only an `nlm` group, so RDP has no `<chemicalgroup>`.",
  "105001495826 and 105003974223: RDP lacks the whole chemicalgroup on these recent records.",
 ],
 assess="Not documented. The notebook ignores `chemicals@source` as an XFAB default, but dropping the `nlm` group is a loss of data, not a default.",
 change=[
  "Do not ignore whole `nlm` groups. Report them as missing groups.",
  "Ask the RDP team whether `nlm` chemicals are meant to be dropped.",
 ],
 evidence=['0001299207','0007292851','105001495826'],
)

D['process_metadata'] = dict(
 lead="The remaining year differences are MHUB inconsistencies. RDP's sort date agrees with the publication year.",
 shows=[
  "Drill-down: `ait_date_sort.year` 6,768. Before the year-only rule the notebook found about 8.9M mismatched `ait_date_sort` rows, mostly MHUB month `12` against RDP `01`.",
 ],
 raw=[
  "105020928196: MHUB `date-sort` 2021, publication year 2022. RDP `date-sort` 2022.",
  "85000336165: MHUB `date-sort` 2021, publication year and date 2001. RDP `date-sort` 2001-11-01.",
 ],
 assess="Same family as SCAL-280 and SCAL-337: RDP derives the sort date from the publication data and MHUB holds an inconsistent value. Likely acceptable, though the exact rule is not on the Confluence pages.",
 change=[
  "Treat these as the SCAL-337 family and filter them with the `publicationyear` exclusion.",
 ],
 evidence=['105020928196','85000336165'],
)

D['manufacturergroup'] = dict(
 lead="Missing on recent records, title-cased in RDP, and duplicated in MHUB.",
 shows=[
  "Drill-down rows: presence 2,272, manufacturers 581.",
 ],
 raw=[
  "105001495826 and 105003974223: RDP has no `<manufacturergroup>`.",
  "0006676157: MHUB `eli lilly`, RDP `Eli Lilly` (also in a different order).",
  "0015898118: MHUB lists `riemerschmid` twice. The section check removes duplicates.",
 ],
 assess="Missing groups on recent records look like a real loss. Title casing is not documented. Duplicates are the known MHUB bug.",
 change=[
  "De-duplicate in the drill-down.",
  "Report case-only differences separately.",
 ],
 evidence=['105001495826','105003974223','0006676157','0015898118'],
)

D['tradenamegroup'] = dict(
 lead="Missing on recent records, and duplicates that the section check already removes.",
 shows=[
  "Drill-down rows: presence 2,654, trademanuitems 537.",
 ],
 raw=[
  "105001495826 and 105003974223: RDP has no `<tradenamegroup>`.",
  "0015439482: MHUB lists `gastrografine` and `hytrast` twice, RDP once each, in a different order.",
 ],
 assess="Duplicates are the known MHUB bug. Missing groups on recent records look real.",
 change=[
  "De-duplicate in the drill-down.",
 ],
 evidence=['105001495826','105003974223','0015439482'],
)

D['sequencebanks'] = dict(
 lead="Only 19 records differ at section level. The drill-down's 192,760 comes from order and a default attribute.",
 shows=[
  "Drill-down: value_mismatch 192,760; missing in RDP 20. The displayed rows differ only in the order of the sequence numbers.",
 ],
 raw=[
  "0012534354: MHUB writes `type=\"referenced\"` (a documented default) and RDP omits it. The numbers are in a different order.",
 ],
 assess="The section check ignores order and the default attribute (documented). The drill-down is an artefact.",
 change=[
  "Sort and de-duplicate `sequence_numbers` in the drill-down, and drop `type` when it is the default.",
 ],
 evidence=['0012534354'],
)

CROSS = [
 ("`afid` / `dptid` attributes on `<affiliation>`", "MHUB 55 of 69 EIDs, RDP 1", "affiliations", "Undocumented", 'real'),
 ("`refd-itemcitation`", "MHUB 1,341 elements in 43 EIDs, RDP 0 in all 69", "bibliography", "Documented, not applied in the notebook", 'doc'),
 ("`SUBJABBR` classification", "MHUB 69 of 69 EIDs, RDP 0", "classifications", "Undocumented", 'real'),
 ("Correspondence with no `<person>`", "14 of 14 dropped by RDP; 43 of 43 with a person kept", "correspondences", "Undocumented", 'real'),
 ("`preferred-name` equals the main author name", "RDP 501 of 501 authors; MHUB 438 of 503", "authors", "Undocumented", 'real'),
 ("Double escaping of `<`, `>` and `&#x..;` in text", "RDP in 8 EIDs; MHUB in 1 (conference name, `&`)", "title, descriptors, author_keywords, grantlist, bibliography, conferenceinfo", "Undocumented, looks like a bug", 'real'),
 ("Grant ids with a space or `#`", "3 of 3 dropped; 3 of 3 plain ids kept", "grantlist", "Undocumented", 'real'),
 ("Publisher `<affiliation>` added; `<publisheraddress>` dropped", "Added in 24 EIDs; address dropped in 2", "source", "Undocumented", 'real'),
 ("Order-only differences", "contributor-groups, abstracts, grants, manufacturers, tradenames, sequence numbers, and itemids in 130 of 1,257 references", "several", "Notebook artefact", 'artefact'),
 ("RDP `stage` S200 or missing", "S200 in 5 of 85 EIDs, all 5 without volume, issue or pages; no `stage` in 10 of 69 EIDs; MHUB always S300", "bibliographic_metadata, title, bibliography", "Stage default documented; S200 not", 'mixed'),
 ("Source-database ids missing in RDP", "`REAXYSCAR` missing in 3 of 3 records that have it; also `REAXYS`, `CPX`, `CABS`, `EMBIO`, `EMBASE`, `MOSYEA`, `MEDL`", "doc_level_metadata", "Undocumented", 'real'),
 ("Author `auid` differs where MHUB has a recent `date-locked`", "2 of 2 (0000768447, 0000927742)", "authors", "Undocumented", 'mixed'),
 ("Recent records missing enhancement groups", "105001495826, 105003974223 (descriptors, manufacturers, tradenames, chemicals); 105011513558 (descriptors, classifications); 105001215810 (keywords)", "several", "Undocumented", 'real'),
 ("Record version drift", "105002826767 (MHUB 2025-09-02) and 105011184443", "bibliography, affiliations", "Not a comparison rule", 'mixed'),
]

NOTEBOOK_CHANGES = [
 ("High", "Exclude `refd_itemcitation` from the bibliography comparison", "Documented on the Expected differences page, and confirmed: RDP has none in all 69 EIDs."),
 ("High", "Ignore the `afid` / `dptid` attributes on `<affiliation>` and compare ids as one sorted set", "The attribute difference alone separates MHUB and RDP in 55 of 69 EIDs. Confirm with the RDP team first and add it to the Expected differences page."),
 ("High", "Sort order-insensitive lists in the section check", "Reference itemids (130 of 1,257 references), contributor-groups, abstracts, grants. The drill-down already sorts some of these."),
 ("High", "Make every drill-down apply the same rules as its section check", "Sequencebanks reports 192,760 mismatches for 19 records, and tradenames, manufacturers, titles, abstracts and descriptors drill-downs overstate in the same way."),
 ("High", "Extend drill-downs for bibliography and doc_level_metadata beyond `itemids`", "Together they cover about 279K reference differences against 64.8M flagged records."),
 ("Medium", "Add RDP `stage` and record version to the output", "Report differences by stage, and compare MHUB `syndication-timestamp` against the RDP source snapshot, to separate incomplete or older records."),
 ("Medium", "Add switchable exclusions for accepted differences", "ASJC (SCAL-246), `classification` against `classification_code` (SCAL-333), `publicationyear` (SCAL-337), ISBN `length` (SCAL-355). Follow the `IGNORE_XFAB_DEFAULTS` pattern."),
 ("Medium", "Report named categories for patterns", "Preferred-name copies, double-escaped text, missing groups, dropped grant ids, person-less correspondence, so each can be counted and decided separately."),
 ("Medium", "Normalise empty elements and empty arrays to null", "EMCLASS `[]`, empty `confsponsor`, empty `titletext`."),
 ("Medium", "Extend the `xfab-added=\"true\"` rule", "`sourcetitle`, and month and day in `publicationdate`."),
 ("Medium", "Fix weak join keys", "Correspondences key on `||`; no-id affiliations share an empty key; authors with a duplicate `auid`; bibliography joins on `pos`."),
 ("Low", "Align parse dates and re-run the unmatched-EID analysis", "MHUB was parsed on 2026-10-06 and RDP on 2026-11-03. The EID summary and PUI cells are skipped (`%skip`)."),
]

REVIEWED = ('85 EIDs', 'Reviewed as raw MHUB and RDP XML in three batches (69, 12 and 4). Counts that say "of 69" come from scans of the first batch; "of 81" covers the first two; "of 85" covers all three. I chose the EIDs from the drill-down samples because they show differences, so these are not prevalence figures for the 88M compared records.')

def code(s):
    return re.sub(r'`([^`]+)`', r'<code>\1</code>', esc(s))

def li(items):
    return '<ul>' + ''.join(f'<li>{code(i)}</li>' for i in items) + '</ul>'

def tag_html(keys):
    return ''.join(f'<span class="tag t-{TAGS[k][1]}">{esc(TAGS[k][0])}</span>' for k in keys)

def eidchips(eids):
    return ' '.join(f'<code>{e}</code>' for e in eids)

def sec_html(s):
    name, n, pct_s, pct, tags = s
    d = D.get(name) or dict(lead='No narrative yet for this section (new or unreviewed in the notebook).', shows=[], raw=[], assess='', change=[], evidence=[])
    more = ''
    if d.get('more'):
        rows = ''.join(f'<tr><td class="eid"><code>{e}</code></td><td>{code(q)}</td></tr>' for e, q in d['more'])
        more = f'<div class="xmlbox"><h4>Further raw XML wanted</h4><div class="tw"><table class="xt"><thead><tr><th>EID</th><th>Question</th></tr></thead><tbody>{rows}</tbody></table></div></div>'
    return f'''<article class="sec" id="s-{name}">
<header class="sec-h"><div class="sec-t"><h3><code>{name}</code></h3><div class="tags">{tag_html(tags)}</div></div>
<div class="sec-n"><b>{n:,}</b> records differ <span>{pct_s}% of {TOTAL:,}</span></div></header>
<p class="lead">{code(d['lead'])}</p>
<div class="cols">
<div class="col"><h4>What the notebook shows</h4>{li(d['shows'])}<h4>What the raw XML shows</h4>{li(d['raw'])}<p class="small ev">EIDs reviewed: {eidchips(d['evidence'])}</p></div>
<div class="col"><h4>Assessment</h4><p>{code(d['assess'])}</p><h4>Suggested notebook changes</h4>{li(d['change'])}</div>
</div>
{more}
</article>'''

rows = []
for name, n, pct_s, pct, tags in SECTIONS:
    w = max(pct, 0.6)
    rows.append(
        f'<tr><td><a href="#s-{name}"><code>{name}</code></a></td>'
        f'<td class="num">{n:,}</td><td class="num">{pct_s}%</td>'
        f'<td class="bar"><i style="width:{w}%"></i></td><td class="tg">{tag_html(tags)}</td></tr>')
table_rows = ''.join(rows)
sections = ''.join(sec_html(s) for s in SECTIONS)
changes = ''.join(
    f'<tr><td class="pri p-{p.lower()}">{p}</td><td><b>{code(t)}</b></td><td>{code(d)}</td></tr>'
    for p, t, d in NOTEBOOK_CHANGES)
cross = ''.join(
    f'<tr><td>{code(a)}</td><td>{code(b)}</td><td>{code(c)}</td><td><span class="tag t-{TAGS[t][1] if t in TAGS else "xml"}">{esc(dstat)}</span></td></tr>'
    for a, b, c, dstat, t in CROSS)

# further XML requests
more_all = []
more_x = ''.join(
    f'<tr><td class="eid"><code>{e}</code></td><td><a href="#s-{n}"><code>{n}</code></a></td><td>{code(q)}</td></tr>' for e, n, q in more_all)
eid_list = '\n'.join(e for e, n, q in more_all)

def _fact(v, label): return f'<div class="fact"><b>{v}</b><span>{label}</span></div>'
if SUMMARY:
    _c, _r = SUMMARY['counts'], SUMMARY['record_summary']
    _tot = SUMMARY['compared']
    _facts = [(f"{_c.get('mhub_records', 0):,}", 'MHUB records'), (f"{_c.get('rdp_records', 0):,}", 'RDP (XOCS) records'), (f"{_c.get('matched', 0):,}", 'Matched on EID'),
              (f"{_tot:,}", 'Compared (singletons, no PUIsecondary)'), (f"{_r['perfect_match_rows']:,}", f"Perfect match, {_r['perfect_match_rows']*100/_tot:.1f}% of compared"),
              (f"{_r['rows_with_differences']:,}", f"At least one difference, {_r['rows_with_differences']*100/_tot:.1f}%"), (f"{_r['avg_mismatch_count']}", 'Average differing sections per record')]
else:
    _facts = [('112,442,054', 'MHUB records'), ('112,428,415', 'RDP (XOCS) records'), ('112,396,597', 'Matched on EID'), ('88,420,931', 'Compared (singletons, no PUIsecondary)'),
              ('4,572,588', 'Perfect match, 5.2% of compared'), ('83,848,343', 'At least one difference, 94.8%'), ('2.44', 'Average differing sections per record')]
facts_html = chr(10).join(_fact(v, l) for v, l in _facts)

page = f'''<title>MHub RDP ANI Review</title>
<meta name="claude:viewport-fit-sides" content="cover">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Serif:wght@500;600&display=swap">
<style>
/* Layout: single reading column, summary first, one bordered block per section, data tables scroll inside their own box. */
:root {{
  --bg:#f4f6f7; --surface:#ffffff; --fg:#14212b; --muted:#566673; --line:#d6dee3;
  --accent:#0d6b73; --accent-soft:#e1f0f1;
  --real:#a8402c; --real-bg:#f8e6e1; --art:#8a6200; --art-bg:#f6ecd0;
  --doc:#255ea3; --doc-bg:#e2ecf8; --mix:#5b4a99; --mix-bg:#ebe7f6; --xml:#4a5a66; --xml-bg:#e7ecef;
  --code-bg:#eaeff2;
  --f-body:"IBM Plex Sans",system-ui,-apple-system,"Segoe UI",sans-serif;
  --f-head:"IBM Plex Serif",Georgia,serif;
  --f-mono:"IBM Plex Mono",ui-monospace,Menlo,Consolas,monospace;
}}
@media (prefers-color-scheme: dark) {{ :root:not([data-theme="light"]) {{
  --bg:#0f171d; --surface:#16212a; --fg:#e4ebef; --muted:#9aabb7; --line:#2a3945;
  --accent:#58c1c9; --accent-soft:#16363a;
  --real:#f0a090; --real-bg:#3a1f1a; --art:#e5c36a; --art-bg:#37290d;
  --doc:#8db8ee; --doc-bg:#17283e; --mix:#bdb0ef; --mix-bg:#262040; --xml:#b3c1cb; --xml-bg:#222f39;
  --code-bg:#1f2d37; color-scheme: dark; }} }}
:root[data-theme="dark"] {{
  --bg:#0f171d; --surface:#16212a; --fg:#e4ebef; --muted:#9aabb7; --line:#2a3945;
  --accent:#58c1c9; --accent-soft:#16363a;
  --real:#f0a090; --real-bg:#3a1f1a; --art:#e5c36a; --art-bg:#37290d;
  --doc:#8db8ee; --doc-bg:#17283e; --mix:#bdb0ef; --mix-bg:#262040; --xml:#b3c1cb; --xml-bg:#222f39;
  --code-bg:#1f2d37; color-scheme: dark; }}
body {{ background:var(--bg); color:var(--fg); font:15px/1.55 var(--f-body); margin:0;
  padding-left:max(16px, env(safe-area-inset-left, 0px)); padding-right:max(16px, env(safe-area-inset-right, 0px)); padding-block:28px 64px; }}
.wrap {{ max-width:1040px; margin:0 auto; display:flex; flex-direction:column; gap:36px; }}
h1,h2,h3,h4 {{ margin:0; text-wrap:balance; }}
h1 {{ font:600 32px/1.15 var(--f-head); letter-spacing:-.01em; }}
h2 {{ font:600 22px/1.25 var(--f-head); padding-bottom:8px; border-bottom:2px solid var(--fg); }}
h3 {{ font:600 17px/1.3 var(--f-body); }}
h4 {{ font:600 11px/1.3 var(--f-body); text-transform:uppercase; letter-spacing:.08em; color:var(--muted); margin:14px 0 6px; }}
p {{ margin:0; max-width:70ch; }}
code {{ font:13px var(--f-mono); background:var(--code-bg); padding:1px 5px; border-radius:3px; overflow-wrap:anywhere; }}
td code {{ white-space:nowrap; overflow-wrap:normal; }}
td.wrapc code {{ white-space:normal; overflow-wrap:anywhere; }}
a {{ color:var(--accent); }}
.kicker {{ font:500 12px var(--f-mono); color:var(--muted); letter-spacing:.04em; }}
.intro {{ display:flex; flex-direction:column; gap:10px; }}
.sub {{ color:var(--muted); max-width:72ch; }}
.facts {{ display:grid; grid-template-columns:repeat(auto-fit,minmax(190px,1fr)); gap:1px; background:var(--line); border:1px solid var(--line); }}
.fact {{ background:var(--surface); padding:12px 14px; min-width:0; }}
.fact b {{ display:block; font:600 22px/1.2 var(--f-mono); font-variant-numeric:tabular-nums; }}
.fact span {{ font-size:12.5px; color:var(--muted); }}
.block {{ display:flex; flex-direction:column; gap:14px; min-width:0; }}
.findings {{ margin:0; padding-left:20px; max-width:75ch; }}
.findings li {{ margin:6px 0; }}
.tw {{ overflow-x:auto; border:1px solid var(--line); background:var(--surface); }}
table {{ border-collapse:collapse; width:100%; font-size:14px; }}
th {{ text-align:left; font:600 11px/1.3 var(--f-body); text-transform:uppercase; letter-spacing:.07em; color:var(--muted); padding:9px 12px; border-bottom:1px solid var(--line); white-space:nowrap; }}
td {{ padding:8px 12px; border-bottom:1px solid var(--line); vertical-align:top; }}
tr:last-child td {{ border-bottom:0; }}
td.num {{ text-align:right; font:13.5px var(--f-mono); font-variant-numeric:tabular-nums; white-space:nowrap; }}
td.bar {{ width:22%; min-width:90px; vertical-align:middle; }}
td.bar i {{ display:block; height:8px; background:var(--accent); }}
td.tg {{ min-width:190px; }}
td.eid {{ white-space:nowrap; }}
.tag {{ display:inline-block; font:500 11.5px/1.2 var(--f-body); padding:3px 7px; border-radius:3px; margin:0 5px 3px 0; white-space:nowrap; }}
.t-real {{ color:var(--real); background:var(--real-bg); }} .t-art {{ color:var(--art); background:var(--art-bg); }}
.t-doc {{ color:var(--doc); background:var(--doc-bg); }} .t-mix {{ color:var(--mix); background:var(--mix-bg); }}
.t-xml {{ color:var(--xml); background:var(--xml-bg); }}
.legend {{ display:flex; flex-wrap:wrap; gap:6px 14px; font-size:13px; color:var(--muted); }}
.note {{ border-left:3px solid var(--accent); background:var(--accent-soft); padding:10px 14px; max-width:78ch; font-size:14px; }}
.caveats {{ margin:0; padding-left:20px; max-width:78ch; }} .caveats li {{ margin:6px 0; }}
.sec {{ background:var(--surface); border:1px solid var(--line); padding:18px 20px; display:flex; flex-direction:column; gap:10px; min-width:0; }}
.sec-h {{ display:flex; justify-content:space-between; gap:12px 24px; flex-wrap:wrap; align-items:flex-start; }}
.sec-t {{ display:flex; flex-direction:column; gap:6px; min-width:0; }}
.sec-t h3 code {{ font-size:16px; background:none; padding:0; }}
.sec-n {{ text-align:right; font-size:13px; color:var(--muted); }}
.sec-n b {{ font:600 17px var(--f-mono); color:var(--fg); font-variant-numeric:tabular-nums; }}
.sec-n span {{ display:block; }}
.lead {{ font-weight:500; }}
.cols {{ display:grid; grid-template-columns:repeat(auto-fit,minmax(min(100%,380px),1fr)); gap:4px 28px; }}
.col {{ min-width:0; }}
.col ul {{ margin:0; padding-left:18px; }} .col li {{ margin:5px 0; font-size:14.5px; }}
.col p {{ font-size:14.5px; }}
.ev {{ margin-top:8px; }} .ev code {{ margin-right:2px; }}
.xmlbox {{ margin-top:4px; }}
.xt {{ font-size:13.5px; }}
.pri {{ font:600 12px var(--f-body); text-transform:uppercase; letter-spacing:.06em; white-space:nowrap; }}
.p-high {{ color:var(--real); }} .p-medium {{ color:var(--art); }} .p-low {{ color:var(--muted); }}
button {{ font:500 13px var(--f-body); background:var(--accent); color:var(--surface); border:0; padding:7px 12px; border-radius:3px; cursor:pointer; }}
button:focus-visible, a:focus-visible {{ outline:2px solid var(--accent); outline-offset:2px; }}
textarea {{ width:100%; box-sizing:border-box; font:13px/1.5 var(--f-mono); background:var(--surface); color:var(--fg); border:1px solid var(--line); padding:10px; min-height:120px; }}
.row {{ display:flex; gap:10px; align-items:center; flex-wrap:wrap; }}
.small {{ font-size:13px; color:var(--muted); }}
</style>
<div class="wrap">
<section class="intro">
<div class="kicker">Core Complete ANI / MHUB against RDP / notebook run 2026-11-04</div>
<h1>MHub and RDP ANI Comparison Review</h1>
<p class="sub">Analysis of the Scal-483 comparison notebook and 85 raw MHUB and RDP XML records: where the two sources differ, which differences look real, and what to change in the notebook. Notebook figures come from its own output. Sample patterns come from the first 1,000 displayed rows of each drill-down.</p>
</section>

<section class="block" id="summary">
<h2>High-level summary</h2>
<div class="facts">
{facts_html}
</div>
<ul class="findings">
<li>Four sections hold nearly all the differences: affiliations (83.1%), bibliography (73.3%), authors (39.4%) and doc_level_metadata (25.6%).</li>
<li>Raw XML shows the two largest are mostly caused by representation differences. In bibliography it is `refd-itemcitation`, which the Expected differences page says to ignore. In affiliations it is RDP omitting the `afid` and `dptid` attributes (MHUB has them in 55 of 69 reviewed EIDs, RDP in 1).</li>
<li>Authors are dominated by preferred names: RDP's preferred name is a copy of the author's own name in all 501 reviewed authors.</li>
<li>RDP records at stage S200 (5 of 85) all lack volume, issue and pages. The notebook ignores `stage`, so they cannot be separated.</li>
<li>Real data differences found: RDP drops person-less correspondence (14 of 14), grant ids with a space or `#` (3 of 3), the `nlm` chemical group, and MSH descriptor groups. It also lacks whole enhancement groups on some recent records. It double-escapes `&lt;`, `&gt;` and `&amp;#x..;` in text in 8 of 69 EIDs.</li>
<li>Several drill-downs overstate or understate the section result. Sequencebanks shows 192,760 mismatches for 19 records. Bibliography and doc_level_metadata drill-downs cover only item ids.</li>
</ul>
<h3>Records with differences, by section</h3>
<p class="small">Percentages are of the {TOTAL:,} compared records. A record can differ in several sections.</p>
<div class="tw"><table>
<thead><tr><th>Section</th><th>Records differing</th><th>%</th><th></th><th>Assessment</th></tr></thead>
<tbody>{table_rows}</tbody></table></div>
<div class="legend">{tag_html(['real'])} data lost or wrong in RDP &nbsp; {tag_html(['artefact'])} the comparison creates the difference &nbsp; {tag_html(['doc'])} covered by the Confluence pages &nbsp; {tag_html(['mixed'])} several causes &nbsp; {tag_html(['xml'])} more XML would help</div>
</section>

<section class="block" id="patterns">
<h2>Patterns confirmed in the raw XML</h2>
<p class="small">{esc(REVIEWED[1])}</p>
<div class="tw"><table><thead><tr><th>Pattern</th><th>Evidence in the reviewed EIDs</th><th>Sections</th><th>Status</th></tr></thead><tbody>{cross}</tbody></table></div>
</section>

<section class="block" id="coverage">
<h2>What the comparison does not cover</h2>
<ul class="caveats">
<li>The comparison excludes 23,975,666 matched records (21.3%) that have a `PUIsecondary` id. Their differences are not measured. The PUI and PUIsecondary comparison cells are skipped in the notebook.</li>
<li>MHUB has 45,457 records with no RDP match and RDP has 31,818 with no MHUB match, if EIDs are unique in both. The EID summary cells are skipped, so these are not analysed.</li>
<li>MHUB was parsed on 2026-10-06 and RDP on 2026-11-03, four weeks apart. In the raw XML, 105002826767 carries an MHUB version from 2025-09-02 and an RDP version delivered 2026-10-30, with different reference lists.</li>
<li>Drill-down field counts are exploded rows, not records, so they can exceed the section's record count.</li>
<li>Only 1,000 rows of each drill-down are displayed. Pattern percentages from the drill-downs come from those rows.</li>
</ul>
</section>

<section class="block" id="changes">
<h2>Suggested notebook changes, by priority</h2>
<div class="tw"><table><thead><tr><th>Priority</th><th>Change</th><th>Why</th></tr></thead><tbody>{changes}</tbody></table></div>
<div class="note">Several changes depend on decisions outside the notebook: whether RDP's omitted `afid` / `dptid` attributes, copied preferred names, dropped person-less correspondence, dropped grant ids and missing groups are intended. Decisions that accept a difference belong on the Expected differences page.</div>
</section>

<section class="block" id="sections">
<h2>Section-by-section review</h2>
<p class="small">Ordered by number of differing records. Each block gives the notebook evidence, the raw XML evidence, an assessment and suggested notebook changes.</p>
{sections}
</section>

<section class="block" id="xml">
<h2>Raw XML status and open questions</h2>
<p>The 85 reviewed EIDs settled the questions I had. No further raw XML is needed for now. New questions from the RDP team or from the notebook re-run would justify another batch.</p>
<h3>Questions for the RDP team</h3>
<ul class="findings">
<li>Is it intended that RDP omits the `afid` and `dptid` attributes on `&lt;affiliation&gt;`, and writes department ids as extra `afid` values in some records?</li>
<li>Is RDP's `preferred-name` meant to equal the author's own name, or should it carry the profile name?</li>
<li>Is dropping correspondence with no person, grant ids that contain a space or `#`, the `nlm` chemical group, MSH descriptors and third-party product ids (`REAXYS`, `REAXYSCAR`, `CPX`, `CABS`, `EMBASE`, `MOSYEA`, `MEDL`) intended?</li>
<li>What does stage S200 mean, and will S200 records be completed before go-live?</li>
<li>Why does RDP double-escape `&lt;`, `&gt;` and `&amp;#x..;` in text fields?</li>
<li>Which SGR is current when MHUB and RDP differ for the same cited work (0000330985, 0000624442, 0000899145, 0000817135)?</li>
</ul>
</section>
</div>

'''

page = re.sub(r'`([^`]+)`', r'<code>\1</code>', page)
open(_ARGS.out, 'w', encoding='utf-8').write(page)
print('wrote', _ARGS.out, len(page), 'chars')
if SUMMARY:
    print('sections without narrative:', [n for n, *_ in SECTIONS if n not in D] or 'none')
