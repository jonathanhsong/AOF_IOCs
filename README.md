# Offensive AI agent IOC feed

Daily mirror of the [offensive.agency](https://www.offensive.agency/api) feeds: IPs and domains of offensive AI agent consoles exposed on the Internet.

Data by **ONYPHE**, licensed **CC BY 4.0**. Keep this attribution in anything derived from it.

## Layout

| Path | Contents |
|---|---|
| `feeds/ips.txt`, `feeds/domains.txt` | Plain IOC lists, active hosts only (last 7 days), CDN fronts excluded |
| `feeds/hosts.csv`, `feeds/hosts.ndjson` | Full host records |
| `feeds/stix.json` | STIX 2.1 bundle |
| `feeds/misp.json` | MISP event (`to_ids` set on confirmed hosts only) |
| `feeds/suricata.rules` | One signature per agent, SIDs from 9400000 |
| `changes/YYYY-MM-DD.json` | Daily delta: hosts that appeared and hosts that left |
| `meta/status.json` | Source health and freshness |

Git history is the full IOC history: `git log -p feeds/ips.txt`.

A listed IP is an exposed agent console. That says nothing about who runs it or why. Treat it as a hunting and enrichment lead, not grounds to block on its own.

## Usage

The feeds update daily at about 10:30 UTC. No auth is needed:

```bash
curl -fsSL https://raw.githubusercontent.com/jonathanhsong/AOF_IOCs/main/feeds/ips.txt
curl -fsSL https://raw.githubusercontent.com/jonathanhsong/AOF_IOCs/main/feeds/domains.txt
curl -fsSL https://raw.githubusercontent.com/jonathanhsong/AOF_IOCs/main/feeds/stix.json
curl -fsSL https://raw.githubusercontent.com/jonathanhsong/AOF_IOCs/main/feeds/misp.json
curl -fsSL https://raw.githubusercontent.com/jonathanhsong/AOF_IOCs/main/feeds/suricata.rules
```

Or clone it and pull daily:

```bash
git clone https://github.com/jonathanhsong/AOF_IOCs.git
```

The upstream source is the [offensive.agency API](https://www.offensive.agency/api). This repo adds daily snapshots, git history and change deltas.
