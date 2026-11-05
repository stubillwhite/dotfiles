#!/usr/bin/env python3
"""Helpers for comparing raw MHUB and RDP ANI XML for the same EID.

Expected file names (as supplied in the upload zips): mhub-ani-<EID>.xml and rdp-ani-<EID>.xml
(older single uploads were mhub-ani-<EID>.xml / rdp-ani-<EID>.xml in any folder; pass --dir).
Always unzip uploads into a fresh directory and run with `python3 -I` or from another directory.

CLI:
  xml_tools.py DIR list                      EIDs found in DIR
  xml_tools.py DIR show EID PART             print PART (head|tail|iteminfo|pi|author-group|...) from both sides
  xml_tools.py DIR diff EID                  per-section serialised diff; flags equal / differs / ignoring-known-noise
  xml_tools.py DIR scan PATTERN              count EIDs where a tag/attribute appears on each side (regex; use '<affiliation [^>]*afid=' for the afid attribute, 'refd-itemcitation' for refs)
  xml_tools.py DIR stage                     RDP stage and MHUB syndication-timestamp per EID

Also importable: load(dir, eid), ser(elem, drop=()), kids(e, name), findall(e, name), ln(tag).
"""
import sys, re, glob, os
from xml.etree import ElementTree as ET

def ln(t): return t.split('}')[-1]

def load(d, eid):
    out = {}
    for s in ('mhub', 'rdp'):
        root = ET.fromstring(open(os.path.join(d, f'{s}-ani-{eid}.xml'), 'rb').read())
        br = [x for x in root.iter() if ln(x.tag) == 'bibrecord'][0]
        item = [x for x in root.iter() if ln(x.tag) == 'item' and any(ln(c.tag) == 'bibrecord' for c in x)][0]
        pi = [c for c in item if ln(c.tag) == 'process-info']
        out[s] = dict(root=root, br=br,
                      head=[c for c in br if ln(c.tag) == 'head'][0],
                      tail=([c for c in br if ln(c.tag) == 'tail'] or [None])[0],
                      iteminfo=[c for c in br if ln(c.tag) == 'item-info'][0],
                      pi=pi[0] if pi else None)
    return out

def ser(e, drop=(), drop_attrs=()):
    """Canonical one-line serialisation: sorted attributes, no whitespace noise. drop = tag names to omit."""
    if e is None: return 'None'
    def attrs(x):
        return ''.join(f' {ln(k)}="{v}"' for k, v in sorted(x.attrib.items()) if ln(k) not in drop_attrs)
    def r(x):
        t = ln(x.tag)
        if t in drop: return ''
        inner = (x.text or '').strip() + ''.join(k for k in (r(c) for c in x) if k)
        inner += ''.join((c.tail or '').strip() for c in x)
        return f'<{t}{attrs(x)}>{inner}</{t}>' if inner else f'<{t}{attrs(x)}/>'
    return r(e)

def kids(e, name): return [c for c in e if ln(c.tag) == name] if e is not None else []
def findall(e, name): return [c for c in e.iter() if ln(c.tag) == name] if e is not None else []

def eids(d):
    return sorted({re.search(r'-ani-(\d+)\.xml$', f).group(1) for f in glob.glob(os.path.join(d, 'mhub-ani-*.xml'))}
                  & {re.search(r'-ani-(\d+)\.xml$', f).group(1) for f in glob.glob(os.path.join(d, 'rdp-ani-*.xml'))})

# Known representation noise (see references/known-patterns.md). Used by `diff` to separate noise from the rest.
NOISE_DROP = ('refd-itemcitation',)
NOISE_ATTRS = ('afid', 'dptid')

def cmd_diff(d, eid):
    x = load(d, eid)
    parts = [('head', lambda s: s['head']), ('tail', lambda s: s['tail']), ('item-info', lambda s: s['iteminfo']), ('process-info', lambda s: s['pi'])]
    for name, f in parts:
        a, b = ser(f(x['mhub'])), ser(f(x['rdp']))
        a2, b2 = ser(f(x['mhub']), NOISE_DROP, NOISE_ATTRS), ser(f(x['rdp']), NOISE_DROP, NOISE_ATTRS)
        status = 'equal' if a == b else 'differs only by known noise (afid/dptid, refd-itemcitation)' if a2 == b2 else 'DIFFERS'
        print(f'{name:14} {status}')
    for ag_name in ('author-group', 'source', 'abstracts', 'citation-info', 'enhancement'):
        a = [ser(e) for e in findall(x['mhub']['head'], ag_name)]; b = [ser(e) for e in findall(x['rdp']['head'], ag_name)]
        print(f'  head/{ag_name:14} mhub x{len(a)} rdp x{len(b)} {"equal" if a == b else "differs"}')

def main():
    if len(sys.argv) < 3: print(__doc__); return
    d, cmd, *rest = sys.argv[1:]
    if cmd == 'list': print('\n'.join(eids(d)))
    elif cmd == 'show':
        eid, part = rest
        x = load(d, eid)
        for s in ('mhub', 'rdp'):
            print('--', s)
            for e in (x[s].get(part) and [x[s][part]]) or findall(x[s]['root'], part): print(ser(e)); print()
    elif cmd == 'diff': cmd_diff(d, rest[0])
    elif cmd == 'scan':
        pat = rest[0]; m = r = 0; hit = []
        for e in eids(d):
            tx = {s: open(os.path.join(d, f'{s}-ani-{e}.xml'), encoding='utf8').read() for s in ('mhub', 'rdp')}
            cm, cr = len(re.findall(pat, tx['mhub'])), len(re.findall(pat, tx['rdp']))
            m += bool(cm); r += bool(cr)
            if cm or cr: hit.append((e, cm, cr))
        print(f'{pat}: MHUB in {m}, RDP in {r} of {len(eids(d))} EIDs'); [print(' ', h) for h in hit[:40]]
    elif cmd == 'stage':
        for e in eids(d):
            tx = {k: open(os.path.join(d, f'{k}-ani-{e}.xml'), encoding='utf8').read() for k in ('mhub', 'rdp')}
            st = {k: re.findall(r'<(?:\w+:)?status[^>]*stage="([^"]*)"', tx[k]) for k in tx}
            ts = re.findall(r'syndication-timestamp>([^<]*)<', tx['mhub'])
            print(e, 'stage mhub', st['mhub'] or '-', 'rdp', st['rdp'] or '-', '| mhub syndication', ts[:1] or '-')

if __name__ == '__main__': main()
