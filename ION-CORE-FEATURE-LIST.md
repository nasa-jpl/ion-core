# ION Core Feature List

**ION Core Version:** 4.2.0-b
**Last Update:** 2026-07-10
**Based on:** ION-DTN `ion-open-source-4.2.0-b`

This document lists the features and components included in this release of ION Core, organized by category. Only features that are actually built and installed are listed; planned and unsupported items have been removed.

## Table of Contents

- [Core Infrastructure (ICI)](#core-infrastructure-ici)
- [Bundle Protocol v7 (BPv7)](#bundle-protocol-v7-bpv7)
- [BP Extension Blocks](#bp-extension-blocks)
- [Custody Transfer & Compressed Bundle Reporting](#custody-transfer--compressed-bundle-reporting)
- [IPN Naming Scheme](#ipn-naming-scheme)
- [Licklider Transmission Protocol (LTP)](#licklider-transmission-protocol-ltp)
- [Convergence Layer Adapters (CLAs)](#convergence-layer-adapters-clas)
- [CFDP (CCSDS File Delivery Protocol)](#cfdp-ccsds-file-delivery-protocol)
- [Load-and-Go](#load-and-go)
- [Restart](#restart)
- [Application Utilities](#application-utilities)
- [Diagnostic Utilities](#diagnostic-utilities)
- [Bundle Copy (bpcp)](#bundle-copy-bpcp)
- [Test Tools and Simulators](#test-tools-and-simulators)
- [Regression Tests](#regression-tests)
- [Manual Pages](#manual-pages)
- [Build Configuration](#build-configuration)
- [References](#references)

---

## Core Infrastructure (ICI)

| Component | Description |
|-----------|-------------|
| `ionadmin` | ION node administration utility |
| `ionwarn` | ION resource usage warnings |
| `rfxclock` | Contact / range plan event clock |
| `ionrestart` | Coordinated ION subsystem restart |
| `ionstart` | Bring up an ION node from configuration files |
| `ionstart.awk` | Helper used by `ionstart` |
| `ionstop` | Graceful ION node shutdown |
| `killm` | Force-kill ION processes and clear IPC state |

## Bundle Protocol v7 (BPv7)

| Component | Description |
|-----------|-------------|
| `bpadmin` | BP administration utility |
| `bpclm` | BP convergence-layer manager daemon |
| `bpclock` | BP timer / housekeeping daemon |
| `bptransit` | BP transit (forwarding) daemon |

## BP Extension Blocks

| Block | Default | Description |
|-------|---------|-------------|
| BPQ (Quality of Service) | enabled | Bundle priority extension; built into bundles produced locally (`BPQ_EXT`) |
| IMC (Multicast) | enabled | Interplanetary Multicast extension (`IMC_EXT` + `ENABLE_IMC`; the `ENABLE_IMC` gate is new in 4.2.0) |
| MEB (Metadata) | always on | Metadata extension; processed for received bundles |
| HCB (Hop Count) | always on | Hop-count extension; processed for received bundles |
| BIB (Bundle Integrity) | always on | BPSec integrity block; processed for received bundles |
| BCB (Bundle Confidentiality) | always on | BPSec confidentiality block; processed for received bundles |
| PNB (Previous Node) | optional | Enable via `EXT_FLAGS` in `build-list.mk` |
| BAE (Bundle Age) | optional | Enable via `EXT_FLAGS` in `build-list.mk` |
| SNW (Spray and Wait) | optional | Enable via `EXT_FLAGS` in `build-list.mk` |
| CTEB (Custody Transfer) | always on | Custody-transfer extension block (see [Custody Transfer & CRS](#custody-transfer--compressed-bundle-reporting)) |
| CREB (Compressed Reporting) | always on | Compressed-reporting extension block (see [Custody Transfer & CRS](#custody-transfer--compressed-bundle-reporting)) |

> **BSL (BPSec Library):** ION 4.2.0 introduces a new BPSec Library subsystem (`bpv7/bsl/`), built only when `USING_BSL=1`. ION-Core keeps `USING_BSL=0` and does **not** bundle BSL in this release; BSL support is planned for a release after ION-Core 4.2.1. BIB/BCB integrity and confidentiality blocks continue to be processed via ION's native BPSec path.

## Custody Transfer & Compressed Bundle Reporting

New in 4.1.4. Implements the CCSDS Orange Book "Compressed Bundle Status Reporting and Custody Signaling" specification on top of BPv7.

| Component | Description |
|-----------|-------------|
| Custody Transfer (CT) | Bundle custody handoff with Compressed Custody Signal (CCS) for release |
| Compressed Reporting Signal (CRS) | Aggregated alternative to traditional BPv7 status reports |
| `cbrcustodytest` | Test/diagnostic utility that exercises the CT and CRS APIs |
| `cbr` library | Public C API (see man page `cbr(3)`) used by applications that opt into custody transfer or CRS |

## IPN Naming Scheme

| Component | Description |
|-----------|-------------|
| `ipnadmin` | IPN scheme administration utility |
| `ipnadminep` | IPN endpoint administration helper |
| `ipnfw` | IPN-scheme bundle forwarder |

Both 2-part (`ipn:node.service`) and 3-part / FQNN (`ipn:allocator.node.service`) endpoint identifiers are supported.

## Licklider Transmission Protocol (LTP)

| Component | Description |
|-----------|-------------|
| `ltpadmin` | LTP administration utility |
| `ltpclock` | LTP timer / housekeeping daemon |
| `ltpmeter` | LTP transmission metering daemon |
| `ltpdeliv` | LTP delivery daemon |
| `ltpcli` | LTP convergence-layer input adapter for BP |
| `ltpclo` | LTP convergence-layer output adapter for BP |
| `udplsi` | UDP-based LTP link service input |
| `udplso` | UDP-based LTP link service output |

## Convergence Layer Adapters (CLAs)

At least one CLA must be selected at build time.

| CLA | Components | Notes |
|-----|------------|-------|
| LTP | `ltpcli`, `ltpclo`, `udplsi`, `udplso` | Recommended for long-delay / lossy links |
| UDP | `udpcli`, `udpclo` | Simple datagram CLA |
| STCP | `stcpcli`, `stcpclo` | Simple TCP CLA |

## CFDP (CCSDS File Delivery Protocol)

| Component | Description |
|-----------|-------------|
| `cfdpadmin` | CFDP administration utility |
| `cfdpclock` | CFDP timer / housekeeping daemon |
| `cfdptest` | CFDP test driver |
| `bputa` | BP-based CFDP UT-Adapter |

## Load-and-Go

| Component | Description |
|-----------|-------------|
| `lgsend` | Send a load-and-go command over BP |
| `lgagent` | Receive and execute load-and-go commands |

## Restart

| Component | Description |
|-----------|-------------|
| `ionrestart` | Coordinated restart utility (also listed under ICI) |

## Application Utilities

| Component | Description |
|-----------|-------------|
| `bpsource` | Send bundles from stdin |
| `bpsink` | Receive bundles and write payloads to stdout |
| `bping` | DTN-aware ping over BP |
| `bpecho` | Echo responder for `bping` |
| `bpsendfile` | Send a file as one or more bundles |
| `bprecvfile` | Receive bundles and write payload to a file |
| `bpchat` | Interactive bundle chat |
| `bptrace` | Send a bundle with status-report flags set |
| `bpcancel` | Cancel a previously sent bundle |
| `bplist` | List bundles in the local SDR |

## Diagnostic Utilities

| Component | Description |
|-----------|-------------|
| `bpstats` | Snapshot BP statistics to `ion.log` |
| `bpcounter` | Count received bundles |
| `bpdriver` | Bundle traffic driver for performance testing |
| `bpinspect` | Inspect bundles in the local SDR with filter / output options |
| `bptracker` | Track bundle status reports |
| `bpwatch` | Bundle-level watch/monitor utility (new in 4.2.0) |
| `ionwatch` | ION daemon status monitor (ICI, BP, LTP, optional CFDP/DTPC/BSSP) |
| `ltpwatch` | LTP session status monitor (export / import sessions) |
| `ltpstats` | Snapshot LTP statistics to `ion.log` |
| `psmwatch` | Inspect PSM (shared-memory) state |
| `sdrwatch` | Inspect SDR (persistent storage) state |
| `cbrcustodytest` | Custody-transfer / CRS diagnostic (see Custody Transfer section) |

## Bundle Copy (bpcp)

| Component | Description |
|-----------|-------------|
| `bpcp` | scp-like file copy over BP |
| `bpcpd` | bpcp daemon (peer side) |

## Test Tools and Simulators

| Component | Description |
|-----------|-------------|
| `owltsim` | One-Way Light Time simulator (link-delay simulator) |

## Regression Tests

The `make test` target runs the following tests against the local build:

| Test | Verifies |
|------|----------|
| `demos/bench-cfdp` | CFDP throughput / behavior over LTP |
| `demos/bench-ltp` | LTP throughput / behavior |
| `demos/bench-stcp` | STCP throughput / behavior |
| `bping` | BP round-trip via `bping`/`bpecho` over UDP CLA |
| `bptrace_terminal_test` | BP status-report exercise via `bptrace`/`bpsink` over LTP |
| `issue-352-bpcp-ltp` | `bpcp` regression over LTP |
| `issue-352-bpcp-stcp` | `bpcp` regression over STCP |
| `cbr-ct-orange-book/custody-simple` | End-to-end custody transfer with CCS-based release |
| `cbr-ct-orange-book/crs-simple` | Compressed Reporting Signal (CRS) status reporting |

## Manual Pages

Both build methods install man pages for every program in the build (section 1) plus concept pages (section 3):

- Section 1: one man page per program built (e.g. `bpadmin(1)`, `ltpcli(1)`, `cbrcustodytest(1)`).
- Section 3: `cbr(3)` — Custody Transfer and Compressed Bundle Reporting library.

## Build Configuration

Two build paths are supported. Both produce the same set of components.

- **Method 1 (recommended): CMake.** Reads `build-list.cmake`. Uses ION-DTN's source files in place from the `external/ION-DTN` submodule.
- **Method 2 (legacy): Makefile + `extract.sh`.** Reads `build-list.mk`. Symlinks ION-DTN sources into a flat `src/` layout before building.

Components can be added or removed by editing `build-list.cmake` (Method 1) or `build-list.mk` (Method 2). Extension blocks are toggled via `EXT_FLAGS` in `build-list.mk`.

## References

- ION-DTN repository: https://github.com/nasa-jpl/ION-DTN
- ION-Core repository: https://github.com/nasa-jpl/ion-core-dev
- Submodule workflow: [docs/SUBMODULE-WORKFLOW.md](docs/SUBMODULE-WORKFLOW.md)
- CCSDS Orange Book — Compressed Bundle Status Reporting and Custody Signaling (basis for the CT/CRS feature)
