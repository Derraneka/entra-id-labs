# Phase 4 — Conditional Access

> Conditional Access is where identity stops being a directory and starts being a security control.
> This phase builds Meridian's policy set from an empty tenant to a defensible Zero Trust posture.

---

## Design principles applied

**1. One policy, one purpose.** Policies that try to do three things are impossible to troubleshoot and impossible to safely modify. Each policy here has a single control objective.

**2. Report-only before enforcement.** Every policy ships in report-only mode, is measured against real sign-in data, and is only enforced once the impact is known. No policy goes straight to On.

**3. Exclusions are deliberate and documented.** Break-glass accounts and service principals are excluded by design, not by accident — and every exclusion is justified in writing.

**4. Named consistently.** `CA<##>-<Audience>-<Control>-<Target>` so any admin can read the policy list top to bottom and understand the posture without opening a single policy.

**5. Layered, not stacked.** Grant controls, session controls, and risk conditions are separated so that a change to one dimension doesn't silently alter another.

---

## Policy set built in this phase

| Policy | Purpose |
|---|---|
| `CA01-BreakGlass-Exclusion-Baseline` | Emergency access preservation |
| `CA02-AllUsers-BlockLegacyAuth-AllApps` | Eliminate protocols that bypass MFA |
| `CA03-AllUsers-RequireMFA-AllApps` | Baseline phishing-resistant MFA |
| `CA04-Admins-RequireCompliantDevice-AllApps` | Privileged tier device trust |
| `CA05-Contractors-RequireMFA-BlockUntrustedLocations` | External workforce restriction |
| `CA06-AllUsers-SignInRisk-RequireMFA` | Risk-based step-up |
| `CA07-AllUsers-UserRisk-RequirePasswordChange` | Compromised credential remediation |
| `CA08-Guests-SessionControls-AllApps` | External session limitation |

*(Final list confirmed per lab.)*

---

## Labs

| # | Lab | Focus |
|:--|:--|:--|
| [4.1](lab-4-01/) | Baseline and policy naming framework | Structure before policy |
| [4.2](lab-4-02/) | MFA enforcement with report-only rollout | Safe deployment method |
| [4.3](lab-4-03/) | Device compliance and hybrid join | Device as a condition |
| [4.4](lab-4-04/) | Location, risk, and session controls | Contextual access |
| [4.5](lab-4-05/) | Admin tier protection and legacy auth block | Hardening the top |

---

## What this phase proves

- Ability to translate a written security requirement into an enforceable policy
- Understanding of the **order of evaluation** and how policies combine
- Safe change management in a system where a mistake locks out the entire tenant
- Use of the **What If tool**, report-only insights, and sign-in logs as validation evidence
- Awareness of the failure modes: lockout, exclusion drift, legacy client bypass, guest breakage

---

## SC-300 objectives covered

Aligned to *Implement access management for apps* and *Plan and implement identity governance*:

- Plan and implement Conditional Access policies
- Configure session management with Conditional Access
- Implement device-based Conditional Access
- Implement sign-in and user risk policies
- Monitor and troubleshoot Conditional Access with What If and sign-in logs
