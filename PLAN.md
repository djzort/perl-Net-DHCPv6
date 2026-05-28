# Remaining perlcritic violations

```
perlcritic --profile .perlcriticrc --verbose "%p\n" lib/ t/ 2>&1 | \
  grep -v 'source OK' | grep -vE '^\s*$' | sort | uniq -c | sort -rn
```

| Count | Policy |
|---|---|
| 71 | `Miscellanea::ProhibitUselessNoCritic` |

### Resolved
- `Variables::NameReuse` — 18 violations across 8 lib files (commit 4b68c93)
- `Bangs::ProhibitVagueNames` — 90 violations across 57 files (commit 559722c)
- `Subroutines::ProhibitCallsToUnexportedSubs` — 3 violations (2 files, commit 7ddf16c)
- `Subroutines::ProhibitCallsToUndeclaredSubs` — 1357 violations across 18 files (commit 1e0ac49)
- `Modules::RequireExplicitInclusion` — 71 violations across 60 files (commit 8f59537)
- `Variables::RequireInitializationForLocalVars` — 1 violation in `eg/dhcpv6-decode` (commit c055ac4)
- `ValuesAndExpressions::ProhibitEscapedCharacters` — 53 violations across 11 files (commit ec6f5e0)
- `Variables::ProhibitPunctuationVars` — 1 violation (t/extract_pcap.pl, commit 06a0e8a)
- `CodeLayout::RequireTrailingCommaAtNewline` — 23 violations (6 test files, commit 02f92bd)
- `Modules::ProhibitModuleShebang` — 76 violations (all .pm files, commit 7afca29)
- `Subroutines::RequireFinalReturn` — 1 violation (t/030-constants-coverage.t, commit d13f221)
- `References::ProhibitDoubleSigils` — 4 violations (t/008-warnings.t, t/003-option.t, t/extract_pcap.pl, commit 0c8b13c)
