#!/usr/bin/env python3
"""Pull the comparison results out of the saved Databricks notebook (.ipynb) into summary.json.

Usage: nb_extract.py NOTEBOOK.ipynb [-o summary.json]

Cells are found by what they contain, not by index, because cell numbers move between
notebook versions. Output keys:
  counts          mhub_records, rdp_records, matched (when those cells have outputs)
  compared        total_rows from the per-section summary (singleton records compared)
  sections        {section: {differing, pct}}   from the `field_summary = reduce(...)` cell
  record_summary  perfect_match_rows, rows_with_differences, avg_mismatch_count
  drilldown       {section: {field: mismatched_rows}} from every `<x>_field_summary` cell
  samples         {section: {rows_in_output, header, rows[:50]}} from `<x>_exploded` display cells
  warnings        anything that could not be found
"""
import json, re, sys, argparse

def tables(cell):
    """All HTML tables in a cell's outputs, as lists of rows of plain text."""
    res = []
    for o in cell.get('outputs', []):
        h = ''.join(o.get('data', {}).get('text/html', []))
        rows = []
        for tr in re.findall(r'<tr>(.*?)</tr>', h, re.S):
            rows.append([re.sub(r'<[^>]+>', '', x).strip() for x in re.findall(r'<t[hd][^>]*>(.*?)</t[hd]>', tr, re.S)])
        if rows: res.append(rows)
    return res

def text_out(cell):
    s = ''
    for o in cell.get('outputs', []):
        s += ''.join(o.get('text', [])) or ''.join(o.get('data', {}).get('text/plain', []))
    return s.strip()

def num(x):
    try: return int(str(x).replace(',', ''))
    except ValueError:
        try: return float(str(x).replace(',', ''))
        except ValueError: return x

def main():
    ap = argparse.ArgumentParser(); ap.add_argument('nb'); ap.add_argument('-o', default='summary.json')
    a = ap.parse_args()
    nb = json.load(open(a.nb, encoding='utf8'))
    out = dict(counts={}, sections={}, record_summary={}, drilldown={}, samples={}, warnings=[], notebook=a.nb)
    for i, c in enumerate(nb['cells']):
        if c['cell_type'] != 'code': continue
        src = ''.join(c['source']).strip()
        if src.startswith('%skip'): continue
        t = tables(c)
        # simple count cells
        for pat, key in (('df_mhub.count()', 'mhub_records'), ('df_xocs.count()', 'rdp_records'), ('matched_df.count()', 'matched')):
            if src == pat and text_out(c):
                out['counts'][key] = num(re.sub(r'.*?(\d[\d,]*)\s*$', r'\1', text_out(c).splitlines()[-1]))
        if 'field_summary = reduce(' in src and t:
            h = t[0][0]; fi, mi, ti, pi = h.index('field'), h.index('mismatched_rows'), h.index('total_rows'), h.index('mismatch_pct')
            for r in t[0][1:]:
                if r[fi].startswith('match_'): r[fi] = r[fi][6:]
                out['sections'][r[fi]] = dict(differing=num(r[mi]), pct=num(r[pi]))
                out['compared'] = num(r[ti])
        if 'record_summary = comparison_df.agg(' in src and t:
            out['record_summary'] = {k: num(v) for k, v in zip(t[0][0], t[0][1])}
        m = re.match(r'(\w+?)_field_summary\s*=', src)
        if m and t:
            h = t[0][0]; key = h[0]  # 'field' or 'difference_type'
            out['drilldown'][m.group(1)] = {r[0]: num(r[-1]) for r in t[0][1:]}
        m = re.search(r'display\((\w+?)_exploded', src)
        if m and t:
            out['samples'][m.group(1)] = dict(header=t[0][0], rows_in_output=len(t[0]) - 1, rows=t[0][1:51])
    # fall back: matched count from compared if missing
    for need in ('sections', 'record_summary'):
        if not out[need]: out['warnings'].append(f'no {need} found - was the summary cell run and saved with output?')
    if 'compared' not in out: out['warnings'].append('no compared total found')
    # sections may be keyed with a suffix like "_mismatch"; normalise
    out['sections'] = {re.sub(r'(_mismatch|_match)$', '', k): v for k, v in out['sections'].items()}
    json.dump(out, open(a.o, 'w'), indent=1)
    print('compared', out.get('compared'), '| sections', len(out['sections']), '| drilldowns', len(out['drilldown']),
          '| samples', len(out['samples']), '| warnings', out['warnings'])

if __name__ == '__main__': main()
