---
description: Start, stop, and manage local development server for previewing changes.
quick_summary: "Commands: /serve start|stop|restart|status. Auto-detects framework."
requires_mcp: []
recommends_mcp: []
---

# /serve - Development Server Management

**Goal**: Manage local development server for live preview of your application.

## Commands

// turbo-all

```
/serve           - Show current status
/serve start     - Start development server
/serve stop      - Stop server
/serve restart   - Restart server
```

## Usage Examples

### Start Server

```
/serve start

Response:
🚀 Starting server...
   Detecting project type...

✅ Server ready!
   URL: http://localhost:3000
   Type: Next.js
```

### Status Check

```
/serve

Response:
=== Server Status ===

🌐 URL: http://localhost:3000
📁 Project: c:/Projects/agentic-toolkit
🏷️ Type: Next.js
💚 Status: Running
```

### Stop Server

```
/serve stop

Response:
⏹️ Stopping server...
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
