<!--
Spec template. Copy this file for a new project and fill every placeholder
(<...>). Structure only: the content of a spec belongs to the project, never
to the template. Each wave is an autonomous file under
specs/wave-NN-<slug>/README.md that references this document.
-->

# <Project> — Spec

> <One-line pitch: what the product is, and for whom.>

---

## 1. Vision

<What the product is, who it serves, its core value proposition, and the shape
of the experience — one short paragraph.>

---

## 2. Stack

| Layer | Technology |
|---|---|
| Frontend | <...> |
| Backend | <...> |
| Auth | <...> |
| Data | <...> |
| Database | <...> |
| Deployment | <...> |

<Keep only the rows that apply. Pin a version when it is a constraint rather
than an implementation detail (<e.g. "Python 3.12+">).>

---

## 3. Key concepts

<The domain vocabulary and rules every wave depends on. One subsection per
concept: what it is, its lifecycle, who may act on it. This is the shared
reference for the whole spec, so keep it precise and stable.>

### <Concept>

<Definition, purpose, and its relationships to the other concepts.>

### <Concept> lifecycle

| Status | Description |
|---|---|
| **<status>** | <meaning> |

### Permissions by authentication state

| Action | Anonymous | Authenticated | <role> |
|---|---|---|---|
| <action> | ✅ / ❌ | ✅ / ❌ | ✅ / ❌ |

---

## Waves

The spec is split into waves, each covering one functional domain. Every wave
is an autonomous file that references this main spec.

### Maturation process

Before implementation starts, a wave must be **mature**: no technical or
functional unknown left.

**Maturity checklist:**

| Criterion | Description |
|---|---|
| **Clear scope** | What to implement — and what not to — is explicit |
| **Dependencies identified** | Required waves and external systems are known |
| **Data available** | Sources exist and are reachable |
| **APIs documented** | Every consumed API is documented |
| **Data model defined** | Tables, columns, relations are fixed |
| **Edge cases listed** | Limits are identified, with proposed handling |
| **No technical blocker** | No spike remains |
| **UI/UX validated** | Layout and interactions are defined |

**Wave statuses:**

| Status | Description |
|---|---|
| 🔜 To specify | Spec being written |
| ✅ Specified | Spec complete, not yet mature |
| 🟡 Mature | Ready for implementation |
| 🔧 In progress | Implementation underway |
| ✅ Done | Shipped |

### Wave table

| Wave | Topic | Status |
|---|---|---|
| [Wave 01 — <topic>](wave-01-<slug>/README.md) | <scope> | 🔜 To specify |

### Future personas

<Personas not yet covered by a wave, the needs they will bring, and the model
changes they imply.>

| Persona | Expected needs |
|---|---|
| **<persona>** | <...> |

---

## 4. Pain points & addressing ideas

<Problems in the target domain, grounded in user complaints or structural
market issues — not in this project's backlog. One subsection per pain point,
pairing the problem with candidate ways to address it.>

### 4.1 <Pain point>

**Pain point**: <what is broken, and for whom — with evidence where possible.>

**Addressing ideas**:

- <idea>
- <idea>

---

## 5. MVP (v0.1)

<The smallest shippable slice: scope in, scope out.>

1. **Backend**:
   - <...>

2. **Frontend**:
   - <...>

3. **Out of MVP scope**:
   - <...>

---

## 6. Useful commands

```bash
# <stack>
<commands>

# Root (full gate)
make ci
```

---

## 7. Next steps

1. [ ] <...>
2. [ ] <...>
