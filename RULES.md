# POS Classifier Rules

Rules are scored using the Wilson lower-bound confidence interval. Each rule contributes positive or negative votes to a POS category; the category with the highest Wilson score wins. Rules are grouped below by part of speech and type.

---

## Lexical Exceptions

Words whose surface form would mislead morphological rules. These are checked first and carry high weight.

| Word | Boosted POS | Penalised POS | Boost | Penalty |
|------|-------------|---------------|-------|---------|
| unless | conjunction | adjective | +8 | -8 |
| nevertheless | conjunction | adjective | +8 | -8 |
| during | preposition | verb | +8 | -8 |
| until | preposition | verb | +8 | -8 |
| after | preposition | noun | +8 | -8 |
| under | preposition | adjective | +8 | -8 |
| toward / towards | preposition | adverb | +8 | -8 |
| very | adverb | noun | +8 | -8 |
| late | adjective | verb | +8 | -8 |
| likewise | adverb | verb | +8 | -8 |
| otherwise | adverb | verb | +8 | -8 |
| clockwise | adverb | verb | +8 | -8 |
| however | conjunction | — | +8 | — |
| moreover | conjunction | — | +8 | — |
| never | adverb | noun | +8 | -4 |
| then | adverb | verb | +8 | -4 |
| inward / inwards | adverb | adjective | +8 | -4 |
| outward / outwards | adverb | verb | +8 | -4 |
| over | preposition | noun | +8 | -4 |
| into | preposition | adjective | +8 | -4 |
| wooden | adjective | verb | +8 | -8 |
| little | adjective | noun | +8 | -4 |
| only | — | noun | — | -8 |
| research | noun | verb | +8 | -4 |
| well | adverb + interjection | — | +4 / +3 | — |

---

## Noun

### Morphological — Positive

| Pattern | Example | Score |
|---------|---------|-------|
| `-tion`, `-sion` suffix | nation, tension | +4 |
| `-ness` suffix | happiness, darkness | +4 |
| `-ment` suffix | movement, statement | +4 |
| `-ity`, `-ty` suffix | equality, ability | +4 |
| `-ist` suffix | artist | +4 |
| `-ism` suffix | tourism | +4 |
| `-hood` suffix | childhood | +4 |
| `-ship` suffix | friendship | +4 |
| `-dom` suffix | freedom | +4 |
| `-ance`, `-ence` suffix | distance, presence | +3 |
| `-ery`, `-ry` suffix | bakery, entry | +3 |
| Starts with capital letter | London, Alice | +2 |
| 5+ letter word ending in `-er` | teacher, player | +3 |
| 3+ letter word ending in `-or` | actor, doctor | +3 |
| 5+ letter word ending in `-ar` | scholar, cellar | +2 |

### Morphological — Negative

| Pattern | Score |
|---------|-------|
| `-ly` suffix | -3 |

### Positional — Positive

| Context | Score |
|---------|-------|
| Previous word is a determiner | +4 |
| Previous word is an adjective | +3 |
| Previous word is an adjective and word before that is a determiner | +4 |
| Previous word is a verb and word before that is a verb | +3 |
| Capitalised word and previous word is a verb | +3 |
| Previous word is a verb and sentence ends | +3 |
| Previous word is a preposition | +3 |
| Word two positions back is a determiner and previous word is not a noun | +3 |
| Previous word is a possessive pronoun (my, your, his, its, our, their) | +4 |

### Positional — Negative

| Context | Score |
|---------|-------|
| Previous word is a non-possessive pronoun | -3 |

### Next-Word

| Context | Guard | Score |
|---------|-------|-------|
| Next word is an auxiliary | pronoun_pos == 0, prev word is not "to" | +4 |

---

## Pronoun

### Lexical

| Words | Score |
|-------|-------|
| I, he, she, it, we, they, you | +4 |
| me, him, her, us, them | +4 |
| my, your, his, its, our, their | +4 |
| myself, yourself, himself, herself, itself, ourselves, themselves | +4 |
| who, whom, whose, which, that | +3 |

### Positional — Negative

| Context | Score |
|---------|-------|
| Previous word is a determiner | -3 |

---

## Verb

### Morphological — Positive

| Pattern | Example | Score |
|---------|---------|-------|
| `-ing` suffix | running, eating | +3 |
| `-ed` suffix | jumped, walked | +3 |
| `-ize`, `-ise` suffix | organize, realise | +4 |
| `-ify`, `-fy` suffix | simplify, clarify | +4 |
| `re-` prefix (3+ letters after prefix) | rebuild, restart | +3 |
| `de-` prefix (3+ letters after prefix) | decode, defrost | +3 |
| `un-` prefix (3+ letters after prefix) | unlock, unpack | +3 |
| `mis-` prefix (3+ letters after prefix) | mislead, misuse | +3 |
| `out-` prefix (3+ letters after prefix) | outrun, outgrow | +3 |
| 4+ letter word ending in `-en` | widen, shorten | +3 |
| 5+ letter word ending in `-ate` | create, generate | +3 |

### Morphological — Negative

| Pattern | Score |
|---------|-------|
| `-tion`, `-ness`, `-ment` suffix | -3 |

### Positional — Positive

| Context | Guard | Score |
|---------|-------|-------|
| Previous word is a non-possessive pronoun | — | +4 |
| Previous word is a noun | preposition_pos == 0, conjunction_pos == 0 | +4 |
| Previous word is an auxiliary | — | +4 |
| Previous word is a verb | `-ing` suffix | +4 |
| Previous word is an adverb, word before that is a pronoun | — | +4 |
| Previous word is preposition "to" | — | +5 |

### Positional — Negative

| Context | Score |
|---------|-------|
| Previous word is a determiner | -6 |
| Word two positions back is a determiner | -4 |

### Morphological + Positional — Negative

| Pattern | Context | Guard | Score |
|---------|---------|-------|-------|
| `-ing` suffix | Previous word is an adverb | Previous-previous word is not an auxiliary | -2 |

This prevents attributive `-ing` adjectives (e.g. *sparkling water*, *running water*) from being pulled toward verb when they follow an adverb. The auxiliary guard preserves progressive constructions like *is quickly running* where the adverb slots between an auxiliary and a true verb.

### Next-Word

| Context | Guard | Score |
|---------|-------|-------|
| Next word is a preposition | preposition_pos == 0, conjunction_pos == 0, determiner_pos == 0 | +4 |
| Next word is an adverb | preposition_pos == 0, conjunction_pos == 0, determiner_pos == 0 | +2 |
| Next word is a pronoun | pronoun_pos == 0, preposition_pos == 0, conjunction_pos == 0, determiner_pos == 0 | +3 |

---

## Auxiliary

Auxiliaries are resolved deterministically — they skip the scoring system entirely and are emitted directly.

### Lexical

| Words |
|-------|
| is, was, has, have, will, can, must, shall, may, would, could, should |

---

## Determiner

Determiners are resolved deterministically — they skip the scoring system entirely and are emitted directly.

### Lexical

| Words | Score |
|-------|-------|
| the, a, an, this, these, those | +4 |

---

## Adjective

### Morphological — Positive

| Pattern | Example | Score |
|---------|---------|-------|
| `-ful` suffix | careful, helpful | +4 |
| `-less` suffix | helpless, careless | +4 |
| `-ous`, `-ious` suffix | famous, curious | +4 |
| `-ive`, `-ative` suffix | active, creative | +4 |
| `-able`, `-ible` suffix | capable, flexible | +4 |
| `-ish` suffix | reddish, childish | +4 |
| `-worthy` suffix | trustworthy | +4 |
| `-al`, `-ial` suffix | formal, partial | +3 |
| `-ic`, `-ical` suffix | comic, logical | +3 |
| `-some` suffix | awesome, handsome | +3 |
| `un-` prefix | unhappy, unclear | +3 |
| `in-`, `im-` prefix | inactive, impossible | +3 |
| `ir-`, `il-` prefix | irregular, illegal | +3 |
| `non-` prefix | non-toxic | +3 |
| `anti-` prefix | anti-social | +3 |
| `hyper-` prefix | hypersensitive | +3 |
| 4+ letter word ending in `-er` (comparative) | bigger, faster | +2 |
| 4+ letter word ending in `-est` (superlative) | biggest, fastest | +2 |

### Morphological — Negative

| Pattern | Score |
|---------|-------|
| `-ly` suffix | -4 |

### Positional — Positive

| Context | Guard | Score |
|---------|-------|-------|
| Previous word is a determiner | next word is a noun | +3 |
| Previous word is an adverb | — | +3 |
| Previous word is an auxiliary | — | +5 |
| Previous word is a possessive pronoun (my, your, his, its, our, their) | next word is a noun | +3 |

### Positional — Negative

| Context | Score |
|---------|-------|
| Previous word is a pronoun and next word is not a noun | -3 |
| Previous word is a noun | -2 |

### Next-Word

| Context | Guard | Score |
|---------|-------|-------|
| Next word is a noun | determiner_pos == 0, preposition_pos == 0, pronoun_pos == 0, conjunction_pos == 0 | +4 |

---

## Adverb

### Morphological — Positive

| Pattern | Example | Score |
|---------|---------|-------|
| `-ly` suffix | quickly, slowly | +5 |
| `-ward`, `-wards` suffix | backward, upwards | +4 |
| `-wise` suffix | clockwise, likewise | +5 |
| `-ways` suffix | sideways, always | +3 |

### Lexical

| Words | Score |
|-------|-------|
| always, never, often, rarely, sometimes, usually | +4 |
| now, then, soon, today, yesterday | +4 |
| already, still, almost, nearly, just, barely, hardly | +4 |
| how | +4 |
| very, quite, rather | +3 |

### Positional — Positive

| Context | Score |
|---------|-------|
| Previous word is a verb | +3 |
| Previous word is an adjective | +3 |

### Positional — Negative

| Context | Score |
|---------|-------|
| Previous word is a determiner | -4 |

### Next-Word

| Context | Guard | Score |
|---------|-------|-------|
| Next word is an adjective | preposition_pos == 0, conjunction_pos == 0, determiner_pos == 0 | +2 |
| Next word is an adjective and previous word is a determiner | — | -4 |

---

## Preposition

### Lexical

| Words | Score |
|-------|-------|
| in, on, at, by, for, with, of, from, to, up, down, off, over, under, into, onto, about, between, past, near, beside, behind, above, below, despite, except, via | +4 |
| across, along, through, toward, towards | +4 |
| before, after, during, since, until, till, within | +3 |

---

## Conjunction

### Lexical

| Words | Score |
|-------|-------|
| and, but, or, nor, yet, so | +4 |
| because, although, while, if, unless, when | +4 |
| however, therefore, moreover, nevertheless, furthermore, thus, hence | +4 |
| either, neither, both, whether | +3 |

### Morphological — Negative

| Pattern | Score |
|---------|-------|
| `-tion`, `-ness`, `-ing` suffix | -4 |

---

## Interjection

### Lexical

| Words | Score |
|-------|-------|
| oh, wow, hey, ouch, ah, ugh, yikes, hurray, alas, hmm, huh, um, uh, gosh, bravo, hooray | +4 |
| yes, no | +3 |
| word ending in `!` | +3 |

### Morphological — Negative

| Pattern | Score |
|---------|-------|
| `-tion`, `-ment`, `-ing`, `-ed` suffix | -3 |

---

## Number

Rules that apply only when the current token begins with a digit.

### Morphological — Positive

| Pattern | Predicted POS | Score | Counter |
|---------|--------------|-------|---------|
| Ordinal suffix (`-st`, `-nd`, `-rd`, `-th`) | adjective | +8 | noun -8 |
| Digit(s) + hyphen + letters (e.g. `5-bedroom`) | adjective | +6 | noun -4 |

### Positional — Positive

| Context | Predicted POS | Confidence | Score |
|---------|--------------|------------|-------|
| Previous word is `is`, `was`, or `equals` | noun | Very high | +8 |
| Previous word is an arithmetic operator (`+` `-` `=` `/`) | noun | Very high | +8 |
| Previous word is a capitalised noun, no connector | noun | Very high | +8 |
| Previous word is a determiner and next word is a noun | adjective | Very high | +8 |
| Previous word is a preposition | noun | High | +6 |
| Next word is a noun, previous word is not a determiner, no preposition context | determiner | High | +6 |
| Start of sentence and next word is a verb | noun | High | +6 |
| Previous word is a determiner and next word is absent or sentence ends | noun | High | +6 |
| Previous word is a preposition and next word is a noun (unit of measure) | noun | Medium | +4 |
| Start of sentence and next word is not a verb | noun | Medium | +4 |
