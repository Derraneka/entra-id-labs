# Meridian Defense Solutions — Organization Profile

> The fictional environment every lab in this repository is built against.
> Consistent context is what turns a set of clicks into an architecture.

---

## Company snapshot

| | |
|---|---|
| **Industry** | Aerospace & defense contracting |
| **Headquarters** | San Antonio, TX |
| **Size** | ~250 employees |
| **Customers** | U.S. Department of Defense, prime contractors |
| **Data types** | CUI, ITAR-controlled technical data, program-specific classified work |
| **Workforce model** | Hybrid — on-site secure facility, remote corporate staff, on-site subcontractors |

---

## Why this environment is hard

These constraints drive nearly every design decision in the labs:

1. **Cleared vs. uncleared personnel.** Not everyone with a badge can see everything. Clearance status is an identity attribute that must gate access, and it changes over time.
2. **Contractors and subcontractors share the tenant.** External identities need scoped, expiring, reviewable access — never permanent membership.
3. **CUI handling obligations.** Access controls must produce audit evidence, not just work.
4. **Program compartmentalization.** Membership in Program A should not imply visibility into Program B.
5. **Legacy engineering applications.** Some line-of-business tools predate modern auth and resist federation.
6. **Turnover is real.** Offboarding must be immediate and complete — a stale account on a cleared program is a reportable event.

---

## Departments

| Department | Code | Notes |
|---|---|---|
| Executive | `EXEC` | Small, high-value targets |
| Engineering | `ENG` | Largest group; ITAR data access |
| Program Management | `PMO` | Cross-program visibility |
| Contracts & Compliance | `CTR` | Audit and reporting owners |
| Information Technology | `IT` | Source of privileged accounts |
| Human Resources | `HR` | Authoritative source for lifecycle events |

---

## Employee types

| Type | Attribute value | Access posture |
|---|---|---|
| Full-time employee | `Employee` | Standard corporate access |
| Cleared employee | `Employee` + clearance attribute | Program resource access |
| Contractor | `Contractor` | Scoped, time-bound |
| Subcontractor / external | `Guest` | Access package only, review required |
| Service account | `Service` | No interactive sign-in, excluded from user policies |

---

## Privileged access tiers

| Tier | Scope | Control model |
|---|---|---|
| **Tier 0** | Global Administrator, Privileged Role Administrator | PIM eligible only · approval + MFA + justification · no standing access |
| **Tier 1** | Workload admins (User, Application, Security Administrator) | PIM eligible · MFA + justification |
| **Tier 2** | Helpdesk, scoped to administrative units | Permanent assignment, AU-scoped, reviewed quarterly |
| **Break-glass** | 2 accounts, Global Administrator | Excluded from CA · FIDO2 only · alerted on every sign-in |

---

## Key personas

Used consistently across labs for testing and validation.

| Persona | Role | Tests for |
|---|---|---|
| **Marcus Vale** | VP Engineering, cleared | Executive risk profile, program access |
| **Priya Raman** | Senior Systems Engineer, cleared, remote | Remote access + device compliance |
| **Dana Whitfield** | IT Helpdesk Technician | Tier 2 scoped delegation |
| **Colin Reyes** | IT Security Engineer | Tier 1 PIM activation flows |
| **Tomas Ferrer** | Contractor, Engineering, 6-month term | Time-bound access, expiration |
| **Ana Delgado** | Subcontractor (external / B2B guest) | Guest governance, access reviews |
| **svc-provisioning** | Service account | Policy exclusion handling |

---

## Standing business rules

These are the requirements the labs are written to satisfy.

**Authentication**
- All interactive users must satisfy phishing-resistant MFA.
- Legacy authentication protocols are blocked tenant-wide.
- Privileged roles require FIDO2 or equivalent for activation.

**Authorization**
- Access is granted by group membership, never by direct assignment.
- Group membership is driven by HR attributes wherever possible.
- No standing privileged access above Tier 2.

**Lifecycle**
- Joiner: access provisioned automatically from department + employee type.
- Mover: department change recalculates access within one sync cycle.
- Leaver: account disabled, sessions revoked, licenses reclaimed same day.

**Governance**
- Privileged role assignments reviewed quarterly.
- Guest access reviewed every 90 days; auto-removed if not attested.
- All access decisions must be reconstructible from audit logs.

---

## Naming conventions

Applied across every lab for consistency.

| Object | Pattern | Example |
|---|---|---|
| Security group | `SG-<Dept>-<Purpose>` | `SG-ENG-ITAR-Data` |
| Dynamic group | `DG-<Attribute>-<Value>` | `DG-EmployeeType-Contractor` |
| Conditional Access policy | `CA<##>-<Audience>-<Control>-<Target>` | `CA03-AllUsers-RequireMFA-AllApps` |
| Administrative unit | `AU-<Dept>` | `AU-Engineering` |
| Access package | `AP-<Program>-<Role>` | `AP-Falcon-Engineer` |
| Named location | `NL-<Type>-<Name>` | `NL-Trusted-SanAntonioHQ` |

---

<sub>Meridian Defense Solutions is entirely fictional. All personas, programs, and data are synthetic and exist only within an isolated Microsoft Entra ID lab tenant.</sub>
