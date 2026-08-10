<h1 align="center">Microsoft Entra ID — Enterprise IAM Labs</h1>


<p align="center">
  <em>Hands-on identity engineering in a production-style tenant for a simulated<br>
  defense contractor: <strong>Meridian Defense Solutions</strong></em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Microsoft-Entra%20ID-0078D4?style=flat-square&logo=microsoftazure&logoColor=white" alt="Entra ID">
  <img src="https://img.shields.io/badge/License-P2-5E5E5E?style=flat-square" alt="P2">
  <img src="https://img.shields.io/badge/Exam-SC--300-orange?style=flat-square" alt="SC-300">
  <img src="https://img.shields.io/badge/Labs-9-success?style=flat-square" alt="9 labs">
</p>

---

## What this is

Most IAM lab write-ups stop at "here's where you click." These don't.

Each lab starts from a **business requirement** at a fictional defense contractor, gets implemented end to end, and is validated with evidence pulled from sign-in logs, audit records, or raw protocol output. Every write-up documents what broke, what the portal wouldn't allow, and why each design decision went the way it did.

Four questions each lab answers:

| Question | Section |
|---|---|
| What business problem does this solve? | **The requirement** |
| Can you configure it correctly? | **Implementation** |
| Can you prove it works? | **Validation** |
| Do you understand the failure modes? | **Gotchas & takeaways** |

Environment, personas, and standing business rules → [`meridian-defense-solutions.md`](meridian-defense-solutions.md)

---

## Labs

### Identity Lifecycle

| Lab | Focus | Key finding |
|:--|:--|:--|
| [2.1 — Joiner and Leaver](lab-2-01/) | Provisioning, session revocation, audit evidence | Measured a 2m41s window where a disabled account still held valid tokens |
| [2.3 — Mover](lab-2-03/) | Dynamic groups, privilege creep | A department transfer changed nothing until membership became attribute-driven |
| [2.4 — Offboarding Automation with Microsoft Graph API](lab-2-04/) | PowerShell, Graph REST API, evidence artifacts | Closed the 2m41s exposure window to 0.463s — a 348× reduction |
### Access Control

| Lab | Focus | Key finding |
|:--|:--|:--|
| [4.1 — Conditional Access Baseline](lab-4-01/) | Legacy auth block, admin MFA, workforce MFA | Report-only caught a user who would have been locked out on enforcement |

### Privileged Access

| Lab | Focus | Key finding |
|:--|:--|:--|
| [5.1 — PIM](lab-5-01/) | Just-in-time privilege, activation audit | Eligible and active assignments can't overlap, forcing a two-person migration |

### Application Integration

| Lab | Focus | Key finding |
|:--|:--|:--|
| [6.1 — SAML 2.0 Integration](lab-6-01/) | Claims, transformations, certificate rollover | A transformation on an empty attribute fails the entire assertion, not just the claim |

### Governance

| Lab | Focus | Key finding |
|:--|:--|:--|
| [7.1 — Entitlement Management: Access Packages](lab-7-01/) | Self-service request, approval, external identity governance | A real guest identity proved the `userType` guardrail from Lab 2.3 actually holds |
| [7.2 — Access Reviews](lab-7-02/) | Quarterly certification, evidence export | Recommendations measure sign-in activity, not business need |

### Monitoring & Response

| Lab | Focus | Key finding |
|:--|:--|:--|
| [8.2 — Identity Protection](lab-8-02/) | Risk-based Conditional Access | Secure Score scores report-only as zero — it penalizes safe deployment |

---

## A design argument running through the labs

These aren't eight independent tutorials. Several build on a single distinction established early and paid off repeatedly:

> **Derived access is a fact. Approved access is a decision.**

- **[Lab 2.1](lab-2-01/)** draws the line: department membership is derived from an attribute; CAD file share access was granted by a human.
- **[Lab 2.3](lab-2-03/)** proves why it matters: when Dana transfers, derived access recalculates itself and approved access deliberately persists — because automation can't know whether her project finished.
- **[Lab 7.2](lab-7-02/)** closes the loop: if automation won't revoke approved access, quarterly certification must, or "we don't automate that" quietly becomes "we never revoke that."
- **[Lab 6.1](lab-6-01/)** extends it outward: the same department attribute becomes a SAML claim, so the application authorizes from the directory's source of truth instead of maintaining a copy that drifts.
- **[Lab 2.4](lab-2-04/)** marks the other boundary: where the *timing* is the vulnerability rather than the judgement, automation isn't optional. A manual offboarding left tokens live for 2m41s; a script closed it to 0.463s.
---

## Skills demonstrated
**Automation** · PowerShell scripting · Microsoft Graph API · REST endpoint integration · structured evidence generation · idempotent runbooks

**Identity lifecycle** · Joiner/Mover/Leaver design · attribute-driven dynamic membership · privilege creep remediation · session revocation · automation boundaries

**Access control** · Conditional Access policy architecture · report-only deployment methodology · break-glass exclusion strategy · risk-based access control · persona-based policy design

**Privileged access** · Just-in-time activation · PIM role configuration · standing privilege elimination · activation audit evidence

**Federation** · SAML 2.0 · claims and claim transformations · assertion troubleshooting · certificate lifecycle and rollover · NameID format trade-offs

**Governance** · Access certification · reviewer model design · least privilege · audit evidence collection · NIST 800-53 / CMMC control mapping

---

## Repository structure

```
entra-id-labs/
├── meridian-defense-solutions.md    Org profile, personas, business rules
├── lab-2-01/                        Joiner and Leaver
├── lab-2-03/                        Mover
├── lab-2-04/                        Offboarding automation (PowerShell + Graph API)
├── lab-4-01/                        Conditional Access baseline
├── lab-5-01/                        Privileged Identity Management
├── lab-6-01/                        SAML 2.0 SSO
├── lab-7-01/                        Entitlement management / access packages
├── lab-7-02/                        Access reviews
└── lab-8-02/                        Identity Protection
```

Each lab folder contains a `README.md` write-up and a `screenshots/` directory of configuration and validation evidence. Lab 2.4 also includes a `scripts/` directory.
```

Each lab folder contains a `README.md` write-up and a `screenshots/` directory of configuration and validation evidence.

---

## About

Built by **Derra Hewlett** — U.S. Air Force veteran (10 years, cyber operations) working in Identity and Access Management.

**Certifications** · Okta Certified Administrator · Okta Certified Professional · CompTIA Security+ (SY0-701) · Microsoft SC-300 *(in progress)*
**Education** · M.S. Cybercrime Investigation · B.S. Criminal Justice
**Clearance** · Active TS/SCI

---

<sub>All environments, users, and organizations here are fictional and built in an isolated lab tenant. No production or client data is represented.</sub>
