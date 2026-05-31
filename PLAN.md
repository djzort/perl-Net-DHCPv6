# perlcritic status

**Zero violations** across `lib/`; **t/ excluded** from
`ProhibitMagicNumbers` (test data uses raw numeric literals).

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

### New policies added (0 violations in lib/)
- `ControlStructures::ProhibitReturnInMappingBlock` (commit 1d51902)
- `ControlStructures::ProhibitInlineDo` (commit 1d51902)
- `ValuesAndExpressions::ProhibitMagicNumbers` — 277 violations fixed
  across 125 lib files; t/ excluded (current commit)
- `BuiltinFunctions::ProhibitForeach` (commit 2d97c1b)
- `RegularExpressions::ProhibitCaptureWithoutTest` (commit 2d97c1b)
- `Subroutines::ProhibitExplicitReturnUndef` (commit 2d97c1b)
- `ValuesAndExpressions::ProhibitMixedBooleanOperators` (commit 2d97c1b)
- `ValuesAndExpressions::RequireInterpolationOfMetachars` (commit 2d97c1b)
- `Bangs::ProhibitCommentedOutCode` (commit 008586a)
- `Community::AmpersandSubCalls` (commit 008586a)
- `Community::IndirectObjectNotation` (commit 008586a)
- `InputOutput::RequireCheckedOpen` (commit 008586a)
- `InputOutput::RequireCheckedSyscalls` (commit 008586a)
- `ErrorHandling::RequireCarping` (commit 8125c05)
- `ErrorHandling::RequireCheckingReturnValueOfEval` (commit 8125c05)
- `References::RequireSigils` (commit 8125c05)
- `ErrorHandling::RequireCarping` (commit 8125c05)
- `ErrorHandling::RequireCheckingReturnValueOfEval` (commit 8125c05)
- `InputOutput::ProhibitTwoArgOpen` (commit 73e3979)
- `InputOutput::RequireBriefOpen` (commit 73e3979)
- `InputOutput::RequireEncodingWithUTF8Layer` (commit 73e3979)
- `RegularExpressions::ProhibitUselessTopic` (commit 73e3979)
- `Subroutines::RequireArgUnpacking` (commit 73e3979)
- `Subroutines::ProhibitBuiltinHomonyms` (commit 0bf589e)
- `TestingAndDebugging::ProhibitNoStrict` (commit 0bf589e)
- `ValuesAndExpressions::ProhibitMismatchedOperators` (commit 0bf589e)
- `ValuesAndExpressions::ProhibitImplicitNewlines` (commit 0913b92)
- `ValuesAndExpressions::ProhibitLongChainsOfMethodCalls` (commit 0913b92)
- `ValuesAndExpressions::ProhibitNoisyQuotes` (commit 0913b92)
- `RegularExpressions::ProhibitUnusualDelimiters` (commit 0913b92)
- `RegularExpressions::ProhibitFixedStringMatches` (commit 5809169)

### Infrastructure
- `.perlcriticrc` converted to `only = 1` — explicit policy list only

## Code Review Findings

### Real Bugs

| Severity | File | Issue |
|---|---|---|
| **Medium** | `Option/PdExclude.pm:14-24` | `prefix_length=0` ⇒ `$addr_len=0` ⇒ `$addr` truncated to empty ⇒ `unless $addr` (falsy) throws false "requires address" croak |
| Low | `Option/NtpServer.pm` | Named `NtpServer` but implements SNTP Servers (code 31). Option 56 (`$OPTION_NTP_SERVER`) has no module — falls through to Generic |

### CI-Blocking

| File | Issue | Fix |
|---|---|---|
| `dist.ini` | `[Covenant]` requires `AUTHOR_PLEDGE` file which doesn't exist | Create the file or remove the plugin |
| `.github/workflows/test.yml` | CI matrix only covers 5.36/5.42, but minimum declared is 5.024 | Add a 5.24 (or 5.26) entry to the matrix |

### Test Coverage Gaps

| File | Gap |
|---|---|
| `OptionList.pm:99-100` | Trailing-garbage branch in `try_from_bytes` never tested |
| `OptionList.pm:88-94` | Non-X exception fallback (option class throws non-X, parse continues as Generic) never tested |
| `t/006-streaming.t` | Streaming helpers only tested with DUID-LLT — no EN, LL, UUID, or unknown DUID types |
| `t/002-duid.t` | `DUID::length()` method never tested |
| `t/003-option.t` | Multiple options with same code not tested; `type()` on parsed options never tested |
| `t/004-packet.t` | `msg_type_name()` alias never tested; relay truncation error never tested |
| All `t/1xx-pcap-*.t` | No round-trip (re-encode) tests — only decode + field checks |
| `t/103-pcap-ntp-server.t` | NtpServer accessed via `->data` (Generic) instead of `->servers` — class parsing never exercised from PCAP |
| `t/104-pcap-aftr-name.t` | AftrName accessed via `->data` (Generic) instead of `->domain_name` |
| `t/008-warnings.t` | Only one option class checked for clean-warning construction |

### Code Quality

| File | Issue |
|---|---|
| All 13 `Message/*.pm` | `use` ordering: `Constants` (C) listed after `Packet` (P) — should be alphabetical |
| `Option/VendorOpts.pm` | No `sub_options()` accessor — parsed sub-options hidden behind `data()` |
| `Option/IAPD.pm`, `Option/IAPrefix.pm`, etc. | No validation that `iaid`, `t1`, `t2`, `prefix_length`, lifetimes fit in 32-bit `pack 'N'` — negative ints or strings produce garbage silently |
| `Option/IAPD.pm:22` | `$args{options}` not type-checked — passing raw bytes instead of `OptionList` crashes |
| `Option/*.pm` ~8 files | Redundant `as_bytes()` overrides producing identical output to base class |
| `t/lib/Test/Net/DHCPv6.pm` | `is_hexstr` exported but never called anywhere — dead code |

### Config

| File | Issue | Status |
|---|---|---|
| `.gitignore` | Missing trailing newline | ✅ `b3ca1cf` |
| `.editorconfig` | Says `.gitignore` should have `insert_final_newline = false` — fixed by b3ca1cf | ✅ `b3ca1cf` |
| `.perlcriticrc` | Exists with 192 policies but `[Test::Perl::Critic]` in `dist.ini` is commented out — dead config | |
| `AGENTS.md` | Missing `Ref::Util` from dependency list (used in 14 files) | |
