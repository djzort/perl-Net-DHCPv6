# perlcritic status

**Zero violations** across `lib/` and `t/`.

```
perlcritic --profile .perlcriticrc --verbose "%p\n" lib/ t/ 2>&1 | \
  grep -v 'source OK' | grep -vE '^\s*$' | sort | uniq -c | sort -rn
```

(no output — all source OK)

## Resolved

### Bulk policy sweeps
- `Modules::RequireExplicitInclusion` — 71 violations across 60 files (commit 8f59537)
- `Subroutines::ProhibitCallsToUndeclaredSubs` — 1357 violations across 18 files (commit 1e0ac49)
- `Subroutines::ProhibitCallsToUnexportedSubs` — 3 violations (2 files, commit 7ddf16c)
- `Bangs::ProhibitVagueNames` — 90 violations across 57 files (commit 559722c)
- `Variables::NameReuse` — 18 violations across 8 lib files (commit 4b68c93)
- `ValuesAndExpressions::ProhibitEscapedCharacters` — 53 violations across 11 files (commit ec6f5e0)
- `CodeLayout::RequireTrailingCommaAtNewline` — 23 violations (6 test files, commit 02f92bd)
- `Modules::ProhibitModuleShebang` — 76 violations (all .pm files, commit 7afca29)
- `Miscellanea::ProhibitUselessNoCritic` — 71 violations across 5 test files (commit baa0aa1)

### Single-policy/edge fixes
- `References::ProhibitDoubleSigils` — 4 violations (commit 0c8b13c)
- `Subroutines::RequireFinalReturn` — 1 violation (commit d13f221)
- `Variables::ProhibitPunctuationVars` — 1 violation (commit 06a0e8a)
- `Variables::RequireInitializationForLocalVars` — 1 violation (commit c055ac4)

### New policies added (0 violations)
- `ControlStructures::ProhibitReturnInMappingBlock` (commit 1d51902)
- `ControlStructures::ProhibitInlineDo` (commit 1d51902)

### Infrastructure
- `.perlcriticrc` converted to `only = 1` — explicit policy list only
