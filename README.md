# claude-mem Cursor Project Enabler

This repository provides a **single-file, deterministic way** to enable
[`claude-mem`](https://github.com/thedotmack/claude-mem) for **any Cursor project**
without global hacks, broken environment variables, or Cursor guessing the wrong
project root.

It solves a real problem:

> Cursor often runs hooks from `~/.cursor` instead of the actual project.
> This causes tools like claude-mem to incorrectly attribute activity to `$HOME`
> or `.cursor` instead of the real repository.

This repo fixes that **once and for all**.

---

## What This Does

- Adds a **per-project `.cursor/` folder**
- Installs a **wrapper hook** that:
  - Forces the correct project root
  - Forwards Cursor hook payloads to claude-mem
- Ensures **each project gets its own claude-mem session**
- Works with **multiple projects simultaneously**
- Requires **zero claude-mem reinstalls**

---

## Requirements

Before using this, you must already have:

- Cursor installed
- `claude-mem` installed and running **globally**
- The claude-mem worker listening locally (default):
