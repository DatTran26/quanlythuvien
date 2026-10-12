---
title: Fix-manual-barcode-dialog-crash
date: 2026-10-11
summary: Dispose the manual-code controller with the dialog.
---

# Fix-manual-barcode-dialog-crash

## What happened
Manual code entry on the scan screen crashed with _dependents.isEmpty because the TextEditingController was disposed while the dialog route was still animating out.

## Decision
Own the controller in _ManualCodeDialog and dispose it from State.dispose.

## Next steps
Hot restart and retry Nhap tay on the emulator.

> Historical work record — not durable authority. Prefer docs/specs/ADRs for current decisions.
