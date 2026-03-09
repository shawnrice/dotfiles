---
description: Toggle MCP servers on/off globally (list, enable, disable)
argument-hint: "[list | enable <name> | disable <name>]"
allowed-tools:
  - Read
  - Write
  - Edit
---

You are implementing the `/mcp-toggle` command. This command manages which MCP servers are active in Claude Code by toggling entries between a permanent catalog and the user config file.

## Files

- **Catalog** (read-only): `~/.claude/mcp-catalog.json` — permanent registry of all available MCP server configs. NEVER modify this file.
- **User config** (read-write): `~/.claude.json` — the root-level `mcpServers` key contains currently active servers.

## Instructions

1. **Read both files.** Read `~/.claude/mcp-catalog.json` and `~/.claude.json`. If the catalog file doesn't exist, tell the user to create it and show the expected format. If `~/.claude.json` doesn't exist, treat it as `{}`.

2. **Parse the action from `$ARGUMENTS`:**
   - Empty, `list`, or no recognizable action → **list**
   - `enable <name>` → **enable**
   - `disable <name>` → **disable**

3. **Execute the action:**

### List
Show a table of all servers in the catalog with their enabled/disabled status:
```
| Server | Status   |
|--------|----------|
| quip   | enabled  |
| stripe | disabled |
```
A server is "enabled" if its name exists as a key in the root-level `mcpServers` in `~/.claude.json`. Otherwise it's "disabled". No files are modified.

### Enable `<name>`
- If `<name>` is not in the catalog, show an error: `Server "<name>" not found in catalog. Available: <list of catalog keys>`
- If `<name>` is already in `~/.claude.json` `mcpServers`, say it's already enabled.
- Otherwise, copy the server's full config object from the catalog into `~/.claude.json` under `mcpServers.<name>`. Create the `mcpServers` key if it doesn't exist.
- Write the updated `~/.claude.json` with 2-space indentation and a trailing newline.
- **Preserve all other keys** in `~/.claude.json` (numStartups, projects, oauthAccount, etc.).
- Tell the user: "Enabled **<name>**. Restart Claude Code (`/exit` then relaunch) for changes to take effect."

### Disable `<name>`
- If `<name>` is not in the catalog, show an error: `Server "<name>" not found in catalog. Available: <list of catalog keys>`
- If `<name>` is not in `~/.claude.json` `mcpServers` (or `mcpServers` doesn't exist), say it's already disabled.
- Otherwise, delete the `<name>` key from `~/.claude.json` `mcpServers`.
- If `mcpServers` is now empty, remove the `mcpServers` key entirely from `~/.claude.json`.
- Write the updated `~/.claude.json` with 2-space indentation and a trailing newline.
- **Preserve all other keys** in `~/.claude.json`.
- Tell the user: "Disabled **<name>**. Restart Claude Code (`/exit` then relaunch) for changes to take effect."

## Important rules
- NEVER modify `~/.claude/mcp-catalog.json`. It is the source of truth.
- Always preserve all existing keys in `~/.claude.json` that are not `mcpServers`.
- Use `JSON.parse` / `JSON.stringify` mentally — ensure valid JSON output with 2-space indent and trailing newline.
- When writing `~/.claude.json`, use the Write tool (not Edit) to write the complete file content, to avoid partial-edit issues with JSON.
