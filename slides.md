---
title: Armored Type Safety with Iron
subtitle: Scala Matters, Paris
date: November 28th, 2023
---

# Who are we?

## 

:::::: columns
::: column
![Valentin Bergeron](images/vbergeron.png){.img_right .portrait}

- Engineering Team Lead
- Backend Blockchain

![](images/ledger-logo.svg){.ledger}
  
:::
::: column
![Raphaël Lemaitre](images/rlemaitre.jpeg){.img_right .portrait}

- Senior Staff Software Engineer
- Backend Blockchain

![](images/ledger-logo.svg){.ledger}
  
:::
::::::

# Rationale

##

Suppose you find this code in your codebase

```scala
case class IBAN(
  countryCode: String,
  checkDigits: String,
  bankCode: String,
  branchCode: String,
  accountNumber: String,
  nationalCheckDigit: String
)
```

##

This looks good

```scala
val iban = IBAN("FR", "14", "20041", "01005", "0500013M026", "06")
```

. . .

Until you find something like this

```scala
val shuffled = IBAN("0500013M026", "FR", "06", "14", "20041", "01005")
```

. . .

Then, you even try

```scala
val wtf = IBAN("🇫🇷", "✅", "🏦", "🌳", "🧾", "🤡")
```

# How can we do better?

## Maybe with Type aliases?

##

```scala
type CountryCode = String
type CheckDigits = String
type BankCode = String
type BranchCode = String
type AccountNumber = String
type NationalCheckDigit = String

case class IBAN(
  countryCode: CountryCode,
  checkDigits: CheckDigits,
  bankCode: BankCode,
  branchCode: BranchCode,
  accountNumber: AccountNumber,
  nationalCheckDigit: NationalCheckDigit
)
```

##

:::::::::::::: {.columns}
::: {.column width="50%}
### 👍 Pros

- Legibility
:::
::: {.column width="50%}
### 👎 Cons

- Substitutions are possible
- No validation
:::
::::::::::::::


## So, maybe with value classes?

##

```scala
case class CountryCode(value: String) extends AnyVal

case class CheckDigits(value: String) extends AnyVal

case class BankCode(value: String) extends AnyVal

case class BranchCode(value: String) extends AnyVal

case class AccountNumber(value: String) extends AnyVal

case class NationalCheckDigit(value: String) extends AnyVal
```

##

This looks good

```scala
val iban = IBAN(
  CountryCode("FR"),
  CheckDigits("14"),
  BankCode("20041"),
  BranchCode("01005"),
  AccountNumber("0500013M026"),
  NationalCheckDigit("06")
)
```

And this cannot compile anymore

```scala {.scala .compilation-error}
val shuffled = IBAN(
  AccountNumber("0500013M026"),
  CountryCode("FR"),
  NationalCheckDigit("06"),
  CheckDigits("14"),
  BankCode("20041"),
  BranchCode("01005")
)
```

##

But this one still compiles

```scala
val wtf = IBAN("🇫🇷", "✅", "🏦", "🌳", "🧾", "👍")
```

## Let's add validation

##

```scala
case class CountryCode(value: String) extends AnyVal:
  require(value.length == 2, "Country code must be 2 characters")

case class CheckDigits(value: String) extends AnyVal:
  require(value.length == 2, "Check digits must be 2 characters")

case class BankCode(value: String) extends AnyVal:
  require(value.length == 5, "Bank code must be 5 characters")

case class BranchCode(value: String) extends AnyVal:
  require(value.length == 5, "Branch code must be 5 characters")

case class AccountNumber(value: String) extends AnyVal:
  require(value.length == 11, "Account number must be 11 characters")

case class NationalCheckDigit(value: String) extends AnyVal:
  require(value.length == 2, "National check digit must be 2 characters")

```

## Feedback loop {auto-animate=true auto-animate-easing=ease-in-out}

How much time do we need to find a bug?

## Feedback loop {auto-animate=true auto-animate-easing=ease-in-out}

:::: {.r-stack}
::: {data-id="box1" .circle style="background: #ca3c66; width: 700px; height: 700px;"}
:::
::::

In production

## Feedback loop {auto-animate=true auto-animate-easing=ease-in-out}

:::: {.r-stack}
::: {data-id="box1" .circle style="background: #ca3c66; width: 700px; height: 700px;"}
:::
::: {data-id="box2" .circle style="background: #db6a8f; width: 600px; height: 600px;"}
:::
::::

In staging

## Feedback loop {auto-animate=true auto-animate-easing=ease-in-out}

:::: {.r-stack}
::: {data-id="box1" .circle style="background: #ca3c66; width: 700px; height: 700px;"}
:::
::: {data-id="box2" .circle style="background: #db6a8f; width: 600px; height: 600px;"}
:::
::: {data-id="box3" .circle style="background: #e8aabe; width: 400px; height: 400px;"}
:::
::::

Integration tests


## Feedback loop {auto-animate=true auto-animate-easing=ease-in-out}

:::: {.r-stack}
::: {data-id="box1" .circle style="background: #ca3c66; width: 700px; height: 700px;"}
:::
::: {data-id="box2" .circle style="background: #db6a8f; width: 600px; height: 600px;"}
:::
::: {data-id="box3" .circle style="background: #e8aabe; width: 400px; height: 400px;"}
:::
::: {data-id="box4" .circle style="background: #a7e0e0; width: 200px; height: 200px;"}
:::
::::

Unit tests

## Feedback loop {auto-animate=true auto-animate-easing=ease-in-out}

:::: {.r-stack}
::: {data-id="box1" .circle style="background: #ca3c66; width: 700px; height: 700px;"}
:::
::: {data-id="box2" .circle style="background: #db6a8f; width: 600px; height: 600px;"}
:::
::: {data-id="box3" .circle style="background: #e8aabe; width: 400px; height: 400px;"}
:::
::: {data-id="box4" .circle style="background: #a7e0e0; width: 200px; height: 200px;"}
:::
::: {data-id="box5" .circle style="background: #4aa3a2; width: 100px; height: 100px;"}
:::
::::

Compilation time

# Something smarter and with less boilerplate?

# Meet Iron

## What is Iron?

Type constraint library in Scala 3 []{.devicon-scala-plain .colored} created by Raphaël Fromentin.

It enables binding constraints to a specific type.


## What is a constraint?

## Constrained types

## Composition

## Validation

## Constrained Opaque Types

No implementation leak

## Before / After

# Iron ![](images/scalalove-logo.svg){.logo} Ecosystem

## Runtime

- Cats
- ZIO

## API

- Tapir
- Circe
- Jsoniter
- ZIO Json

## Databases

- doobie
- skunk

## Configuration

- Ciris

## Tests

Scalacheck

# Takeaways


# Thank you!

![[slides available at https://iron.rlemaitre.com/](https://iron.rlemaitre.com/)](images/slides-url.svg)

