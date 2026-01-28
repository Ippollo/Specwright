---
description: Start, stop, and manage local development server for previewing changes.
requires_mcp: []
recommends_mcp: []
---

# /preview - Development Server Management

**Goal**: Manage local development server for live preview of your application.

## Commands

```
/preview           - Show current status
/preview start     - Start development server
/preview stop      - Stop server
/preview restart   - Restart server
```

## Usage Examples

### Start Server

```
/preview start

Response:
🚀 Starting preview...
   Detecting project type...

✅ Preview ready!
   URL: http://localhost:3000
   Type: Next.js
```

### Status Check

```
/preview

Response:
=== Preview Status ===

🌐 URL: http://localhost:3000
📁 Project: c:/Projects/agentic-toolkit
🏷️ Type: Next.js
💚 Status: Running
```

### Stop Server

```
/preview stop

Response:
⏹️ Stopping preview server...
✅ Server stopped.
```

## Supported Frameworks

- **Next.js**: `npm run dev`
- **Vite**: `npm run dev`
- **Create React App**: `npm start`
- **Vue**: `npm run serve`
- **Generic**: `npm run dev` or `npm start`

## Port Conflicts

If the default port is in use:

```
⚠️ Port 3000 is in use.

Options:
1. Start on port 3001
2. Specify different port
3. Cancel

Which one? (default: 1)
```
