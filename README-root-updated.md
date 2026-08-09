<h1 align="center">Microsoft Entra ID — Enterprise IAM Labs</h1>

<p align="center">
  <em>Hands-on identity engineering in a production-style tenant for a simulated<br>
  defense contractor: <strong>Meridian Defense Solutions</strong></em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Microsoft-Entra%20ID-0078D4?style=flat-square&logo=microsoftazure&logoColor=white" alt="Entra ID">
  <img src="https://img.shields.io/badge/License-P2-5E5E5E?style=flat-square" alt="P2">
  <img src="https://img.shields.io/badge/Exam-SC--300-orange?style=flat-square" alt="SC-300">
</p>

---

## What this is

Most IAM lab write-ups stop at "here's where you click." These don't.

Each lab starts from a **business requirement** at a fictional defense contractor, gets implemented end to end, and is validated with evidence pulled from sign-in and audit logs. Every write-up documents what broke and why the design decision went the way it did.

Four questions each lab answers:

| Question | Section |
|---|---|
| What business problem does this solve? | **The requirement** |
| Can you configure it correctly? | **Implementation** |
| Can you prove it works? | **Validation** |
| Do you understand the failure modes? | **Gotchas & takeaways** |

Environment, personas, and standing business rules → [`docs/meridian-defense-solutions.md`](docs/meridian-defense-solutions.md)

---

## Labs

| Lab | Focus | Key artifact |
|:--|:--|:--|
| [2.3 — Mover: Attribute-Driven Access Recalculation](02-identity-lifecycle/lab-2-03/) | Dynamic groups, privilege creep, JML | Department change that removed and granted access with no ticket |
| [4.1 — Conditional Access Baseline](04-conditional-access/lab-4-01/) | Legacy auth block, admin MFA, workforce MFA | Report-only rollout that caught a user who'd have been locked out |
| [5.1 — PIM: Eliminating Standing Global Administrator](05-privileged-identity-management/lab-5-01/) | Just-in-time privilege, activation audit | Migration sequence that forces a two-person operation |

*More in progress.*

---

## Skills demonstrated

**Identity lifecycle** · Joiner/Mover/Leaver design · attribute-driven dynamic membership · privilege creep remediation · automation boundaries

**Access control** · Conditional Access policy design · report-only deployment methodology · break-glass exclusion strategy · persona-based policy architecture

**Authentication** · MFA enforcement · legacy protocol remediation · phishing-resistant migration planning

**Privileged access** · Just-in-time activation · PIM role configuration · standing privilege elimination · activation audit evidence

**Governance** · Least privilege · audit evidence collection · NIST 800-53 / CMMC control mapping

---

## About

Built by **Derra Hewlett** — U.S. Air Force veteran (10 years, cyber operations) working in Identity and Access Management.

**Certifications** · Okta Certified Administrator · Okta Certified Professional · CompTIA Security+ (SY0-701) · Microsoft SC-300 *(in progress)*
**Education** · M.S. Cybercrime Investigation · B.S. Criminal Justice
**Clearance** · Active TS/SCI

---

<sub>All environments, users, and organizations here are fictional and built in an isolated lab tenant. No production or client data is represented.</sub>
