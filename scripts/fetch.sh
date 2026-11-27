#!/usr/bin/env bash
# Pull offensive.agency feeds into ./feeds, plus daily status and change delta.
# A failed or invalid download never overwrites the last good copy.
set -uo pipefail

API="https://www.offensive.agency/api/v1"
FEEDS=(ips.txt domains.txt hosts.csv hosts.ndjson stix.json misp.json suricata.rules)
UA="private-threat-feed-sync/1.0 (+github-actions)"
TODAY=$(date -u +%F)
YESTERDAY=$(date -u -d yesterday +%F)

mkdir -p feeds changes meta
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
failed=0

fetch() { # url dest
  curl -fsSL --retry 3 --retry-delay 15 --max-time 180 -A "$UA" -o "$2" "$1"
}

valid() { # file
  [[ -s "$1" ]] || return 1
  case "$1" in
    *.ndjson) jq -c . "$1" >/dev/null 2>&1 ;;
    *.json)   jq empty "$1" >/dev/null 2>&1 ;;
    *)        return 0 ;;
  esac
}

for f in "${FEEDS[@]}"; do
  if fetch "$API/feeds/$f" "$tmp/$f" && valid "$tmp/$f"; then
    mv "$tmp/$f" "feeds/$f"
    echo "ok   $f ($(wc -l < "feeds/$f") lines)"
  else
    echo "::warning::$f failed or invalid; keeping previous copy"
    failed=1
  fi
done

# Freshness/health metadata
if fetch "$API/status" "$tmp/status.json" && valid "$tmp/status.json"; then
  mv "$tmp/status.json" meta/status.json
else
  echo "::warning::status fetch failed"; failed=1
fi

# Daily delta: hosts that appeared / left the active window
if fetch "$API/changes?since=$YESTERDAY" "$tmp/changes.json" && valid "$tmp/changes.json"; then
  mv "$tmp/changes.json" "changes/$TODAY.json"
else
  echo "::warning::changes fetch failed"; failed=1
fi

exit $failed
