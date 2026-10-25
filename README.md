# wastebasket-pihole-blocklist

A personal Pi-hole blocklist for domains that the big lists miss or don't carry yet. It's meant to run alongside:

- [HaGeZi Multi Pro](https://github.com/hagezi/dns-blocklists) (Adblock format)
- [HaGeZi Threat Intelligence Feeds](https://github.com/hagezi/dns-blocklists) (Adblock format)
- [OISD Big](https://oisd.nl)

Everything here was either missed by those lists or caught by them too late, so this one stays small.

## Use it in Pi-hole

Add this URL under **Lists** in the Pi-hole web UI, then run **Tools → Update Gravity**:

```
https://raw.githubusercontent.com/Hitman10666/wastebasket-pihole-blocklist/main/blocklist.txt
```

Requires Pi-hole v6 or later, which understands Adblock-style entries.

## Format

One entry per line:

```
||example.com^
```

`||domain^` blocks the domain **and every subdomain under it**. For example, `||tilljoyfully.com^` also blocks `0.tilljoyfully.com` through `9.tilljoyfully.com`, so no regex is needed. Lines starting with `!` are comments.

## Adding a domain

1. Find the domain in the Pi-hole **Query Log**.
2. Add `||thedomain.com^` under the matching section in `blocklist.txt`. Use the registrable domain (`tilljoyfully.com`), not a numbered subdomain.
3. Commit and push. Pi-hole picks it up at its next gravity update, or right away if you run **Update Gravity**.

## Sections

| Section | What goes there |
|---|---|
| Ads / ad networks | Ad servers and ad networks |
| Ad reinsertion / anti-adblock | Rotating throwaway domains used to sneak ads past blockers (seen on reuters.com) |
| Tracking / telemetry | Analytics, error reporting, app telemetry |
| Previously manual entries | Entries migrated from Pi-hole's manual denylist and regex list |
| Malware / phishing / scareware | Malicious or deceptive sites |
| Scams / warez | "Free hacks" generators, cracked-software sites |
