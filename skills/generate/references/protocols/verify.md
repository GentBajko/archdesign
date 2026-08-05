# verify — read-only trust report

No writes. Two parts:

1. **Staleness**: for each topic file, read its stamp and `paths_covered`,
   run `git diff --stat <stamp>..HEAD -- <globs>`, and report a table:
   topic | stamp | files changed since | verdict (current / stale /
   stamp unreachable).
2. **Pointer drift**: sample ≥5 `file:line` pointers across different
   topic files, check each against the source, and report hits/misses
   with the drifted lines' new locations when findable.

End with one sentence: whether the reference can be trusted as-is, needs
`/archdesign:generate` (refresh), or needs `/archdesign:generate rebuild`.
