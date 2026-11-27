# Private threat feed: offensive AI agents

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

## Read-only access from another machine

Use a deploy key, which only works on this one repo:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/threatfeed_ro -N "" -C "threatfeed read-only"
```

Then go to repo **Settings → Deploy keys → Add deploy key** and paste the `.pub` file. Leave **Allow write access unchecked**.

`~/.ssh/config` (port 443 gets through most corporate firewalls):

```
Host github-threatfeed
  HostName ssh.github.com
  Port 443
  User git
  IdentityFile ~/.ssh/threatfeed_ro
  IdentitiesOnly yes
```

```bash
git clone git@github-threatfeed:OWNER/REPO.git
git pull   # daily
```

If you need HTTPS or tooling without a clone, use a fine-grained PAT instead. Set it to **Only select repositories → this repo**, with **Contents: Read-only** and an expiry date:

```bash
curl -fsSL -H "Authorization: Bearer $PAT" \
  https://raw.githubusercontent.com/OWNER/REPO/main/feeds/ips.txt
```
