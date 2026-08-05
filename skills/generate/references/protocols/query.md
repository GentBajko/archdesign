# query <question> — cited Q&A

1. From the DESIGN.md index, pick the topics the question touches.
2. Run the `verify` staleness test on just those topics; refresh any
   that are stale before answering.
3. Answer from the docs, citing the doc sections and the `file:line`
   pointers they carry. Spot-check pointers you rely on.
4. If the docs cannot answer, say so explicitly, answer from targeted
   code reading instead, and name which topic file should have covered
   it — that gap is a template bug worth reporting to the user.
