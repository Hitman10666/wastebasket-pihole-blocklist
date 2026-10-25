# wastebasket-pihole-lists

Personal Pi-hole block and allow lists, for domains that the big lists miss or don't carry yet. It's meant to run alongside:

- [HaGeZi Multi Pro](https://github.com/hagezi/dns-blocklists) (Adblock format)
- [HaGeZi Threat Intelligence Feeds](https://github.com/hagezi/dns-blocklists) (Adblock format)
- [OISD Big](https://oisd.nl)

Everything here was either missed by those lists or caught by them too late, so these lists stay small.

## Use it in Pi-hole

Add this URL under **Lists** in the Pi-hole web UI, then run **Tools → Update Gravity**:

```
https://raw.githubusercontent.com/Hitman10666/wastebasket-pihole-lists/main/blocklist.txt
```

Requires Pi-hole v6 or later, which understands Adblock-style entries.

### Allowlist

`allowlist.txt` holds domains that must never be blocked. Add it on the same **Lists** page, but as an **allowlist** rather than a blocklist:

```
https://raw.githubusercontent.com/Hitman10666/wastebasket-pihole-lists/main/allowlist.txt
```

Entries in an allowlist override every blocklist. A plain `example.com` line allows only that exact name. `@@||example.com^` allows the domain and all its subdomains.

## Format

One entry per line:

```
||example.com^
```

`||domain^` blocks the domain **and every subdomain under it**. For example, `||tilljoyfully.com^` also blocks `0.tilljoyfully.com` through `9.tilljoyfully.com`, so no regex is needed. Lines starting with `!` are comments.

## Adding a domain

### The easy way: the form

1. Open the repo's **Actions** tab (works in the GitHub mobile app too) and pick **Add domain**.
2. Tap **Run workflow** and fill in:
   - **Domain**: paste it however you have it. `https://8.word.com/page`, `*.word.com` and `||word.com^` all get cleaned up.
   - **Which list**: blocklist or allowlist.
   - **Match type**: *wildcard* covers the domain and every subdomain. *Exact* covers only that one name.
   - **Note** (optional): why you added it.
3. Hit **Run workflow**. The run's summary shows whether it was added, skipped as a duplicate, or rejected. It also warns if the domain is on the other list.

New entries go under the "Added via GitHub form" heading at the bottom of each list.

For the rotating ad domains, add the registrable domain (`tilljoyfully.com`) as a wildcard, not a numbered subdomain like `8.tilljoyfully.com`.

### By hand

Edit the file on GitHub and add a line in the right section, then commit.

Either way, Pi-hole picks the change up at its next gravity update (daily, about 4:40am), or right away if you run **Tools → Update Gravity**.

## Sections

| Section | What goes there |
|---|---|
| Ads / ad networks | Ad servers and ad networks |
| Ad reinsertion / anti-adblock | Rotating throwaway domains used to sneak ads past blockers (seen on reuters.com) |
| Tracking / telemetry | Analytics, error reporting, app telemetry |
| Previously manual entries | Entries migrated from Pi-hole's manual denylist and regex list |
| Malware / phishing / scareware | Malicious or deceptive sites |
| Scams / warez | "Free hacks" generators, cracked-software sites |
