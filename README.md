# Token Bridge

Token Bridge is a small example project that demonstrates a cross-network token bridge stack.
It includes smart contracts (Foundry), a React + Vite frontend, and an indexer using TypeScript + Prisma to track bridge transactions.

The repository is organized into three primary workspaces:

- `contracts/` — Solidity contracts, tests and Forge/Foundry config.
- `frontend/` — React + TypeScript UI built with Vite.
- `indexer/` — TypeScript indexer using Bun/Node and Prisma to persist events/transactions.

This README shows how to build, test and run each component locally.

## Quicklinks

- Contracts: `contracts/` (Foundry)
- Frontend: `frontend/` (Vite + React)
- Indexer: `indexer/` (TypeScript + Prisma)

## Prerequisites

- Git
- Node.js (>= 18) or Bun (optional, the indexer contains a `bun.lock`)
- Foundry (forge, anvil, cast) — see https://book.getfoundry.sh/
- A PostgreSQL database for the indexer (or a compatible provider and a `DATABASE_URL`)

Note: the project mixes common Ethereum tooling (Foundry) with a modern frontend (Vite) and a lightweight TypeScript indexer. Use the toolchain you prefer, but the instructions below assume either npm (Node.js) or Bun where noted.

## Repository layout

Top-level:

```
contracts/      # Solidity contracts and Foundry config
frontend/       # Vite + React frontend
indexer/        # TypeScript indexer + Prisma schema
utils/          # shared utilities (if any)
README.md       # this file
```

### Important files

- `contracts/src/BridgeToken.sol` — core bridge token contract used by tests and scripts.
- `contracts/src/MockToken.sol` — local mock token for testing.
- `contracts/foundry.toml` — Foundry configuration.
- `frontend/package.json` — contains `dev`, `build`, `preview` scripts.
- `indexer/prisma/schema.prisma` — Prisma schema used by the indexer. Requires `DATABASE_URL` and `DIRECT_URL` env vars.

## Setup

Clone the repo and install tools.

1. Clone

```bash
git clone <repo-url> && cd token_bridge
```

2. Install Foundry (if not installed)

Follow the official guide: https://book.getfoundry.sh/

3. Install frontend deps (Node / npm example)

```bash
cd frontend
npm install
# then in another shell: npm run dev
```

If you prefer Bun:

```bash
cd frontend
bun install
bun dev
```

4. Install indexer deps

The indexer contains a `bun.lock`. You can use Bun or Node. Examples below use npm (Node) and Bun where appropriate.

With npm (Node + npx):

```bash
cd indexer
npm install
npx prisma generate
```

With Bun:

```bash
cd indexer
bun install
bunx prisma generate
```

## Environment variables

Create `.env` files in the component directories as needed. Common variables the repo expects:

- For the indexer (`indexer/`):

  - `DATABASE_URL` — Postgres connection string used by Prisma
  - `DIRECT_URL` — optional direct URL used by Prisma for migrations

- For the frontend (`frontend/`):

  - `VITE_RPC_URL` or `VITE_<NETWORK>_RPC` — RPC endpoint used by the UI to talk to chains

- For Foundry/Deploy scripts:
  - `PRIVATE_KEY` and `RPC_URL` — used by `forge script` when deploying to testnets/mainnet

Add variables to `.env` in each folder or export them in your shell before running tools.

## Running components

### Contracts (Foundry)

From the `contracts/` folder:

```bash
cd contracts
forge build        # compile
forge test         # run unit tests
anvil              # run local node (optional)
```

You can run deploy scripts using `forge script` with `--rpc-url` and `--private-key`.

### Frontend (Vite + React)

From `frontend/`:

```bash
cd frontend
npm install
npm run dev        # opens Vite dev server
```

Build for production:

```bash
npm run build
npm run preview
```

### Indexer (TypeScript + Prisma)

The indexer watches chains and writes transaction details to the database.

1. Ensure `DATABASE_URL` and `DIRECT_URL` are set.
2. Generate Prisma client and run migrations:

```bash
cd indexer
npx prisma generate
npx prisma migrate deploy   # or `prisma migrate dev` for development
```

3. Run the indexer (Bun can run TypeScript directly):

With Bun:

```bash
bun index.ts
```

With Node (you may need to compile or run with ts-node):

```bash
npm run build   # if a build step exists
node dist/index.js
# or: npx ts-node index.ts (install ts-node and typescript as needed)
```

The indexer uses Prisma models defined in `indexer/prisma/schema.prisma` to store `TransactionDetails`, `NetworkStatus`, and `Nonce` entries.

## Tests

- Contracts: `cd contracts && forge test`
- Frontend: use your preferred test runner (no tests included by default)
- Indexer: write unit tests or run integration checks against a test database

## Development notes

- The repo uses Foundry for Solidity development. Follow the Foundry docs for best practices on running tests, snapshots and forking mainnet.
- The frontend is minimal and uses `wagmi`, `viem`, and `connectkit` for wallet/chain interactions.
- The indexer relies on Prisma. Keep `prisma` and `@prisma/client` versions in sync when updating dependencies.
