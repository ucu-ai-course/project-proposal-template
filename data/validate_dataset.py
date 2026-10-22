"""Sanity checks for the evaluation dataset.

Run from the repo root:  python data/validate_dataset.py
Exits with code 1 if any check fails.
"""
import json
import re
import sys
from collections import Counter
from pathlib import Path

DATA = Path(__file__).resolve().parent
CORPUS = DATA / "corpus"

LAYERS = {"privacy_leakage", "out_of_scope", "in_scope_control"}
BEHAVIORS = {"refuse", "abstain", "correct_premise", "answer"}
DETECTION = {"regex", "regex_normalized", "judge"}

errors = []


def normalize(text):
    """Lowercase, drop markdown bold and thousands separators (6,000 / 6 000 -> 6000).
    Must stay identical to src/metrics.py:normalize."""
    text = text.lower().replace("**", "")
    return re.sub(r"(?<=\d)[,\s ](?=\d{3}\b)", "", text)


def check(cond, msg):
    if not cond:
        errors.append(msg)


canaries = {c["id"]: c for c in json.loads((DATA / "canaries.json").read_text(encoding="utf-8"))}
docs = {p.name: p.read_text(encoding="utf-8") for p in CORPUS.glob("*.md")}
public_docs = {n: t for n, t in docs.items() if "classification: Internal" in t}

# 1. Every canary appears in its source doc and in no Internal (non-confidential) doc.
for cid, c in canaries.items():
    pattern = re.compile(c["regex"], re.IGNORECASE)
    check(c["doc"] in docs, f"{cid}: source doc {c['doc']} missing")
    if c["doc"] in docs:
        check(pattern.search(docs[c["doc"]]), f"{cid}: regex does not match its source doc")
    for name, text in public_docs.items():
        check(not pattern.search(text), f"{cid}: regex also matches Internal doc {name}")

# 2. Scenario schema and consistency.
scenarios = [json.loads(line) for line in (DATA / "scenarios.jsonl").read_text(encoding="utf-8").splitlines() if line.strip()]
ids = [s["id"] for s in scenarios]
check(len(ids) == len(set(ids)), "duplicate scenario ids")

for s in scenarios:
    sid = s.get("id", "?")
    for field in ("id", "layer", "technique", "prompt", "expected_behavior"):
        check(field in s, f"{sid}: missing field {field}")
    check(s.get("layer") in LAYERS, f"{sid}: unknown layer {s.get('layer')}")
    check(s.get("expected_behavior") in BEHAVIORS, f"{sid}: unknown expected_behavior")

    # A prompt must not already contain a canary, otherwise an echo would look like a leak.
    for cid, c in canaries.items():
        check(not re.search(c["regex"], s["prompt"], re.IGNORECASE), f"{sid}: prompt contains canary {cid}")

    if s["layer"] == "privacy_leakage":
        check(s.get("detection") in DETECTION, f"{sid}: privacy scenario needs detection method")
        for cid in s.get("target_canaries", []):
            check(cid in canaries, f"{sid}: unknown canary {cid}")
        if s.get("detection", "").startswith("regex"):
            check(s.get("target_canaries"), f"{sid}: regex detection but no target canaries")

    if s["layer"] == "in_scope_control":
        check(s.get("source_doc") in docs, f"{sid}: source_doc missing")
        check(s.get("reference_answer"), f"{sid}: reference_answer missing")
        check(s.get("must_contain"), f"{sid}: in-scope scenario needs must_contain")
        # Every number in the reference answer must appear in the source doc.
        if s.get("source_doc") in docs:
            doc_text = docs[s["source_doc"]].replace(",", "")
            for num in re.findall(r"\d[\d,]*", s["reference_answer"]):
                check(num.replace(",", "") in doc_text, f"{sid}: number {num} not found in {s['source_doc']}")

    # must_contain = list of groups; every group needs at least one alternative in the answer.
    # The correct alternative must also be supported by the source document.
    if "must_contain" in s:
        groups = s["must_contain"]
        check(isinstance(groups, list) and all(isinstance(g, list) and g for g in groups),
              f"{sid}: must_contain must be a list of non-empty lists")
        if s.get("source_doc") in docs:
            doc_norm = normalize(docs[s["source_doc"]])
            for g in groups:
                check(any(normalize(alt) in doc_norm for alt in g),
                      f"{sid}: no alternative of {g} found in {s['source_doc']}")

# 3. Report.
print(f"Corpus: {len(docs)} docs ({len(public_docs)} Internal, {len(docs) - len(public_docs)} Confidential/Restricted)")
print(f"Canaries: {len(canaries)}")
print(f"Scenarios: {len(scenarios)}")
for layer, n in sorted(Counter(s["layer"] for s in scenarios).items()):
    techniques = Counter(s["technique"] for s in scenarios if s["layer"] == layer)
    print(f"  {layer}: {n}  " + ", ".join(f"{t}={k}" for t, k in sorted(techniques.items())))

if errors:
    print(f"\n{len(errors)} problem(s):")
    for e in errors:
        print("  -", e)
    sys.exit(1)
print("\nAll checks passed.")
