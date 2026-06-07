
-- ════════════════════════════════════════════════════════════
-- DevReady Seed — Batch 1
-- .NET › 1️⃣ C# Basics & OOP › Q1–Q22
-- All answers are dollar-quote safe (no $ inside content).
-- Idempotent: safe to re-run (upserts on question_id).
--
-- PREREQUISITE (run once, ignore error if it already exists):
--   ALTER TABLE answers ADD CONSTRAINT answers_question_id_unique UNIQUE (question_id);
-- ════════════════════════════════════════════════════════════

-- Q1 ─────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
C# is a modern, strongly-typed, object-oriented language built by Microsoft for the .NET platform. It compiles to Intermediate Language (IL) that the CLR runs, giving you memory safety via garbage collection, plus high-level features like LINQ, async/await, generics, and records. Today it powers web APIs, cloud services, and games (Unity).

## 📖 Detailed Explanation
**What it is:** A general-purpose, multi-paradigm language (OOP + functional + imperative) designed by Anders Hejlsberg around 2000.
**Why it exists:** Microsoft needed a type-safe, productive language for .NET combining C++ power with VB-level simplicity.
**How it works internally:** Your .cs files compile to **IL**, packaged into assemblies (.dll/.exe). At runtime the **CLR** uses the **JIT** compiler to turn IL into native machine code, while the **GC** manages memory.
**Benefits:** Type safety, huge BCL, cross-platform (.NET 8), first-class async, strong tooling.
**Drawbacks:** Heavier runtime than Go/Rust; historically Windows-tied (solved by .NET Core+).

## 💻 Code Example
```csharp
public class Employee
{
    public string Name { get; set; }
    public decimal Salary { get; private set; }

    public Employee(string name, decimal salary) => (Name, Salary) = (name, salary);

    public void GiveRaise(decimal amount)
    {
        Salary += amount;
        Console.WriteLine(Name + "'s new salary: " + Salary.ToString("C"));
    }
}

var emp = new Employee("Sidhant", 80000m);
emp.GiveRaise(10000m);
```

## ❓ Follow-Up Questions
- **Q: Is C# compiled or interpreted?** A: Compiled to IL, then JIT-compiled to native code at runtime.
- **Q: What's the latest version?** A: C# 12 on .NET 8.
- **Q: Can C# run on Linux/Mac?** A: Yes, since .NET Core / .NET 5+.

## ⚠️ Common Mistakes
❌ Saying "C# and .NET are the same thing."
✅ C# is the **language**; .NET is the **platform/runtime** it runs on. F# and VB.NET also run on .NET.

## 🎯 Cheat Sheet
- **Definition:** Type-safe OOP language for .NET that compiles to IL
- **Keywords:** CLR, IL, JIT, GC, BCL, assembly, managed code
- **Related:** .NET runtime, ASP.NET Core, Roslyn compiler

## 🏢 Industry Experience Answer
"In my projects C# is the backbone of the backend — ASP.NET Core APIs in Clean Architecture. What I value day-to-day is type safety catching errors at compile time and the async/await model keeping APIs scalable. Records and nullable reference types have genuinely cut null bugs in production."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is C#?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q2 ─────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
C# has two families of types: **value types** (numbers, bool, char, struct, enum) stored on the stack or inline, and **reference types** (class, string, arrays, delegates) stored on the heap with a reference on the stack. Built-in types map to .NET BCL types — int is System.Int32, string is System.String.

## 📖 Detailed Explanation
**Integral:** byte, sbyte, short, ushort, int, uint, long, ulong — whole numbers of varying size/sign.
**Floating point:** float (32-bit), double (64-bit), decimal (128-bit, exact — use for money).
**Other value types:** bool, char, enum, struct, DateTime.
**Reference types:** string, object, class, arrays, dynamic.
**Why decimal for money:** float/double are binary floating point and can't represent 0.1 exactly, causing rounding errors. decimal is base-10 and precise.

## 💻 Code Example
```csharp
int count = 42;              // System.Int32, value type
double price = 19.99;        // 64-bit float
decimal money = 19.99m;      // exact — always for currency
bool isActive = true;
char grade = 'A';
string name = "Sidhant";     // reference type
```

## ❓ Follow-Up Questions
- **Q: float vs double vs decimal?** A: float=32bit, double=64bit (fast, approximate), decimal=128bit (exact, for money).
- **Q: Is string a value or reference type?** A: Reference type, but immutable so it behaves value-like.
- **Q: Default value of an int?** A: 0; for reference types it's null.

## ⚠️ Common Mistakes
❌ Using double for currency calculations.
✅ Use decimal — binary floating point introduces rounding errors in financial math.

## 🎯 Cheat Sheet
- **Value types:** int, double, decimal, bool, char, struct, enum
- **Reference types:** string, object, class, array, delegate
- **Keywords:** stack, heap, System.Int32, precision, decimal for money

## 🏢 Industry Experience Answer
"A real bug I've seen: an invoicing module used double for totals and amounts were off by a cent on large orders. Switching to decimal fixed it instantly. My rule: decimal for anything money-related, double only for scientific/approximate math."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are the basic data types in C#?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q3 ─────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Value types hold their data **directly** and are copied by value — assigning one to another duplicates the data. Reference types hold a **reference (pointer)** to data on the heap, so assignment copies the reference, and both variables point to the same object. This drives how mutation, equality, and method arguments behave.

## 📖 Detailed Explanation
**Value types** (struct, int, bool, enum): stored inline/on stack, copied on assignment, can't be null (unless Nullable<T>).
**Reference types** (class, string, arrays): the variable stores an address; the object lives on the managed heap and is GC-tracked.
**Why it matters:** Passing a struct to a method copies it (changes don't stick); passing a class passes the reference (changes to the object stick).

## 💻 Code Example
```csharp
struct PointVal { public int X; }
class PointRef { public int X; }

var a = new PointVal { X = 1 };
var b = a;        // COPY
b.X = 99;         // a.X is still 1 (value semantics)

var c = new PointRef { X = 1 };
var d = c;        // copies the REFERENCE
d.X = 99;         // c.X is now 99 (both point to same object)
```

## ❓ Follow-Up Questions
- **Q: Where are value types stored?** A: Stack or inline within their container; not always "the stack."
- **Q: Can a value type live on the heap?** A: Yes — e.g., a struct field inside a class lives on the heap.
- **Q: What is boxing?** A: Wrapping a value type in an object to put it on the heap.

## ⚠️ Common Mistakes
❌ "Value types are always on the stack."
✅ A struct that's a field of a class lives on the heap with that object. Stack vs heap is an implementation detail, not a rule.

## 🎯 Cheat Sheet
- **Value type:** copied by value, struct/int/enum, stack-ish
- **Reference type:** copied by reference, class/string/array, heap
- **Keywords:** stack, heap, boxing, copy semantics, managed heap

## 🏢 Industry Experience Answer
"This trips up juniors constantly. I explain it as 'copy vs shortcut' — a value type is a photocopy, a reference type is a shortcut to the same file. It directly affects shared-mutable-state bugs, which is why we prefer immutable records for DTOs now."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are value types and reference types?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q4 ─────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A **class** is a blueprint that defines data (fields/properties) and behavior (methods); an **object** is a concrete instance of that class created at runtime with `new`. The class describes *what* something is; the object is the *actual thing* in memory.

## 📖 Detailed Explanation
**Class:** a reference type template — defines members, encapsulates state and behavior, supports inheritance and polymorphism.
**Object:** an instance allocated on the heap; you can create many objects from one class, each with its own state.
**Analogy:** Class = architectural blueprint; Object = the actual house built from it. One blueprint, many houses.

## 💻 Code Example
```csharp
public class Car                 // class = blueprint
{
    public string Model { get; set; }
    public void Start() => Console.WriteLine(Model + " started");
}

Car car1 = new Car { Model = "Tesla" };  // object (instance)
Car car2 = new Car { Model = "BMW" };    // another, independent object
car1.Start();   // Tesla started
```

## ❓ Follow-Up Questions
- **Q: How many objects can one class create?** A: Unlimited — each `new` makes an independent instance.
- **Q: Where do objects live?** A: On the managed heap; the reference variable is on the stack.
- **Q: What initializes an object?** A: The constructor, called during `new`.

## ⚠️ Common Mistakes
❌ Using "class" and "object" interchangeably.
✅ Class is the definition (compile-time); object is the runtime instance created with `new`.

## 🎯 Cheat Sheet
- **Class:** blueprint, defines members, reference type
- **Object:** runtime instance, lives on heap, created with `new`
- **Keywords:** instance, blueprint, new, constructor, encapsulation

## 🏢 Industry Experience Answer
"In real systems a class like Order defines the shape and rules, and each checkout creates a new Order object. I push the team to put behavior in the class (rich domain model) rather than scattering logic across services that just shuffle data."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is a class and an object?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q5 ─────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A **struct** is a value type (copied by value, usually stack-allocated, no inheritance), while a **class** is a reference type (heap-allocated, supports inheritance, copied by reference). Use structs for small, immutable, short-lived data like coordinates; use classes for almost everything else.

## 📖 Detailed Explanation
**Struct:** value semantics, can't inherit from another struct/class (but can implement interfaces), cheaper for small data, no GC pressure when on the stack.
**Class:** reference semantics, supports inheritance and polymorphism, nullable, GC-managed.
**Guideline (Microsoft):** make a struct only if it's small (≤16 bytes), logically a single value, immutable, and not boxed frequently.

## 💻 Code Example
```csharp
public struct Point      // value type
{
    public int X { get; init; }
    public int Y { get; init; }
}

public class Person      // reference type
{
    public string Name { get; set; }
}

var p1 = new Point { X = 1, Y = 2 };
var p2 = p1;            // full copy — independent
```

## ❓ Follow-Up Questions
- **Q: Can a struct inherit?** A: No class/struct inheritance, but it can implement interfaces.
- **Q: Can a struct be null?** A: Only as Nullable<T> (Point?).
- **Q: When prefer struct?** A: Small, immutable, value-like data created in bulk (points, money).

## ⚠️ Common Mistakes
❌ Making large mutable structs.
✅ Large structs cause expensive copies and subtle mutation bugs — prefer a class, or keep structs small and immutable.

## 🎯 Cheat Sheet
- **Struct:** value type, no inheritance, stack-ish, copy by value
- **Class:** reference type, inheritance, heap, copy by reference
- **Keywords:** value vs reference, boxing, immutability, ≤16 bytes rule

## 🏢 Industry Experience Answer
"I default to classes or records and reach for structs rarely — mostly high-performance hot paths like geometry, or avoiding heap allocations. The one rule I enforce: if it's a struct, make it immutable, because mutable structs cause baffling copy-semantics bugs."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is the difference between struct and class?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q6 ─────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Access modifiers control the visibility of types and members. The main ones: **public** (everywhere), **private** (same type only), **protected** (type + derived types), **internal** (same assembly), **protected internal** (assembly OR derived), and **private protected** (derived within same assembly). They're the foundation of encapsulation.

## 📖 Detailed Explanation
- **public** — no restrictions.
- **private** — default for class members; visible only inside the declaring type.
- **protected** — visible to the type and subclasses.
- **internal** — visible within the same assembly (default for top-level types).
- **protected internal** — protected OR internal (union).
- **private protected** (C# 7.2+) — protected AND internal (intersection).

## 💻 Code Example
```csharp
public class BankAccount
{
    private decimal _balance;          // hidden state
    protected string AccountType;      // for subclasses
    internal int BranchCode;           // same assembly
    public decimal GetBalance() => _balance;   // controlled access
}
```

## ❓ Follow-Up Questions
- **Q: Default modifier for class members?** A: private.
- **Q: Default for top-level classes?** A: internal.
- **Q: protected internal vs private protected?** A: OR vs AND of protected/internal.

## ⚠️ Common Mistakes
❌ Making fields public for convenience.
✅ Keep fields private and expose them through properties — preserves encapsulation and lets you add validation later.

## 🎯 Cheat Sheet
- **Modifiers:** public / private / protected / internal / protected internal / private protected
- **Keywords:** encapsulation, assembly, visibility, default = private
- **Related:** properties, information hiding

## 🏢 Industry Experience Answer
"I use internal heavily to keep an assembly's surface area small — only what truly needs external use is public. In libraries this matters because every public member is a contract you must maintain. Tight access modifiers mean fewer breaking changes later."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are access modifiers in C#?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q7 ─────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Encapsulation is the OOP principle of **bundling data with the methods that operate on it** and **hiding internal state** behind a controlled public interface. In C# you keep fields private and expose them through properties or methods, which lets you enforce invariants and change internals without breaking callers.

## 📖 Detailed Explanation
**What it is:** "Information hiding" — the object guards its own state.
**Why it exists:** Prevents external code from putting an object into an invalid state and decouples the public contract from the implementation.
**How (C#):** private fields + public properties with validation, or methods that mutate state safely.

## 💻 Code Example
```csharp
public class BankAccount
{
    private decimal _balance;   // hidden — can't be set arbitrarily

    public decimal Balance => _balance;   // read-only to outside

    public void Deposit(decimal amount)
    {
        if (amount <= 0) throw new ArgumentException("Must be positive");
        _balance += amount;     // invariant enforced here
    }
}
```

## ❓ Follow-Up Questions
- **Q: How do you encapsulate in C#?** A: Private fields + public properties/methods.
- **Q: Encapsulation vs abstraction?** A: Encapsulation hides *state*; abstraction hides *complexity/implementation*.
- **Q: Why not public fields?** A: You lose validation and the ability to change internals safely.

## ⚠️ Common Mistakes
❌ Exposing a public setter on everything.
✅ Restrict setters (private set, init, or no setter) so state changes go through validated methods.

## 🎯 Cheat Sheet
- **Definition:** bundle data + behavior, hide internal state
- **How:** private fields, public properties/methods, validation
- **Keywords:** information hiding, invariants, access modifiers, properties

## 🏢 Industry Experience Answer
"Encapsulation keeps a domain model trustworthy. In our Order aggregate you can't just set Status = Shipped — you call Ship(), which checks the order is paid first. That one discipline prevents a whole category of invalid-state bugs from ever reaching the database."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is encapsulation?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q8 ─────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Inheritance lets a class (derived/child) acquire the members of another class (base/parent), enabling code reuse and an "is-a" relationship. In C# you inherit with `: BaseClass`, a class can inherit from **one** base class (single inheritance), and you can override base behavior with `virtual`/`override`.

## 📖 Detailed Explanation
**What it is:** A child class reuses and extends a parent's data and behavior.
**Why it exists:** DRY — share common logic in a base type; model real "is-a" hierarchies.
**How:** `class Dog : Animal`. Use `virtual` on base methods and `override` in the child. `base.Method()` calls the parent version.
**Caution:** Favor **composition over inheritance** when the relationship isn't truly "is-a" — deep hierarchies become fragile.

## 💻 Code Example
```csharp
public class Animal
{
    public string Name { get; set; }
    public virtual string Speak() => "...";
}
public class Dog : Animal
{
    public override string Speak() => "Woof";   // customize
}

Animal a = new Dog { Name = "Rex" };
Console.WriteLine(a.Speak());   // Woof (polymorphism)
```

## ❓ Follow-Up Questions
- **Q: Does C# support multiple inheritance?** A: Not for classes; only single. Use interfaces for multiple contracts.
- **Q: virtual vs override?** A: virtual marks a base method as overridable; override provides the new implementation.
- **Q: What does sealed do?** A: Prevents further inheritance/overriding.

## ⚠️ Common Mistakes
❌ Using inheritance just to reuse a few methods.
✅ Prefer composition unless it's a genuine "is-a" relationship — over-inheritance creates rigid hierarchies.

## 🎯 Cheat Sheet
- **Definition:** child acquires base members; "is-a" relationship
- **Syntax:** class Child : Parent, virtual/override, base
- **Keywords:** single inheritance, composition over inheritance, sealed

## 🏢 Industry Experience Answer
"I use inheritance sparingly — mostly a base controller or a base entity with Id/CreatedAt. For behavior reuse I lean on interfaces + DI instead, because composition stays flexible. Deep inheritance trees are some of the hardest code to refactor later."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is inheritance?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q9 ─────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Polymorphism ("many forms") lets the same operation behave differently based on the actual object type. C# has two kinds: **compile-time** (method overloading) and **runtime** (method overriding via virtual/override), where a base-type reference invokes the derived type's implementation.

## 📖 Detailed Explanation
**Runtime (subtype) polymorphism:** a virtual method is resolved at runtime based on the object's real type — the heart of OOP flexibility.
**Compile-time polymorphism:** overloading (same name, different parameters) and generics, resolved at compile time.
**Why it matters:** Write code against a base type/interface and plug in new implementations without changing callers (open/closed principle).

## 💻 Code Example
```csharp
public abstract class Shape { public abstract double Area(); }
public class Circle : Shape { public double R; public override double Area() => Math.PI * R * R; }
public class Square : Shape { public double S; public override double Area() => S * S; }

Shape[] shapes = { new Circle { R = 2 }, new Square { S = 3 } };
foreach (var s in shapes)
    Console.WriteLine(s.Area());   // calls correct override at runtime
```

## ❓ Follow-Up Questions
- **Q: Two types of polymorphism?** A: Compile-time (overloading) and runtime (overriding).
- **Q: How is runtime polymorphism implemented?** A: Via a virtual method table (vtable).
- **Q: Do interfaces enable polymorphism?** A: Yes — program to an interface, swap implementations freely.

## ⚠️ Common Mistakes
❌ Expecting overriding without virtual/override (using new instead).
✅ new *hides* a method (resolved by reference type); override truly *replaces* it (resolved by actual type).

## 🎯 Cheat Sheet
- **Definition:** same operation, different behavior by type
- **Compile-time:** overloading, generics
- **Runtime:** overriding (virtual/override), interfaces, vtable
- **Keywords:** open/closed principle, dynamic dispatch

## 🏢 Industry Experience Answer
"Polymorphism keeps payment processing extensible — an IPaymentProvider interface with Stripe/Razorpay/PayPal implementations. Adding a provider means a new class, zero changes to checkout. That's polymorphism delivering the open/closed principle in production."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is polymorphism?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q10 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Abstraction means exposing **what** an object does while hiding **how** it does it. You model the essential interface and hide implementation detail behind abstract classes or interfaces, so callers depend on a simple contract rather than messy internals.

## 📖 Detailed Explanation
**What it is:** Reducing complexity by surfacing only relevant operations.
**Why it exists:** Lets you change implementations freely and reason about systems at a high level.
**How (C#):** interface (pure contract) or abstract class (partial implementation + abstract members).
**Abstraction vs encapsulation:** Abstraction is about *design* (hiding complexity behind a contract); encapsulation is about *implementation* (hiding state with access modifiers).

## 💻 Code Example
```csharp
public interface INotificationService   // abstraction: what, not how
{
    Task SendAsync(string to, string message);
}

public class EmailService : INotificationService
{
    public Task SendAsync(string to, string message)
    {
        // SMTP details hidden from callers
        return Task.CompletedTask;
    }
}
```

## ❓ Follow-Up Questions
- **Q: Abstraction vs encapsulation?** A: Abstraction hides complexity (design); encapsulation hides state (implementation).
- **Q: How to achieve it in C#?** A: Interfaces and abstract classes.
- **Q: Why does it help testing?** A: You can mock the abstraction in unit tests.

## ⚠️ Common Mistakes
❌ Treating abstraction and encapsulation as the same thing.
✅ Abstraction = "hide complexity behind a contract"; encapsulation = "hide internal state with private fields."

## 🎯 Cheat Sheet
- **Definition:** expose what, hide how — depend on contracts
- **How:** interfaces, abstract classes
- **Keywords:** contract, decoupling, dependency inversion, mockability

## 🏢 Industry Experience Answer
"Abstraction makes our code testable and swappable. Services depend on IEmailSender, not the concrete SMTP class — so tests inject a fake, and prod can switch from SMTP to SendGrid by changing one DI registration. Callers never know or care."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is abstraction?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q11 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
An interface is a pure contract — it declares members (methods, properties, events) that an implementing type **must** provide, without any state. A class can implement **many** interfaces, which is how C# achieves multiple inheritance of behavior. Program to interfaces, not concretions, and your code becomes loosely coupled and testable.

## 📖 Detailed Explanation
**What it is:** A reference type defining "what" a type can do, not "how."
**Why it exists:** Enables polymorphism, dependency injection, and multiple-contract implementation (classes inherit one base but implement many interfaces).
**How it works:** No instance fields/state (until C# 8 default interface methods). Members are implicitly public. The implementing class supplies the bodies.
**Modern note:** C# 8+ allows default implementations and static abstract members.

## 💻 Code Example
```csharp
public interface IRepository<T>
{
    Task<T?> GetByIdAsync(int id);
    Task AddAsync(T entity);
}

public class UserRepository : IRepository<User>
{
    public Task<User?> GetByIdAsync(int id) => Task.FromResult<User?>(null);
    public Task AddAsync(User entity) => Task.CompletedTask;
}
```

## ❓ Follow-Up Questions
- **Q: How many interfaces can a class implement?** A: Unlimited.
- **Q: Can interfaces have fields?** A: No instance fields; C# 8+ allows default method bodies and static members.
- **Q: Why program to an interface?** A: Loose coupling, easy mocking, swappable implementations.

## ⚠️ Common Mistakes
❌ Building one fat interface with many unrelated methods.
✅ Keep interfaces small and focused (Interface Segregation Principle) — many tiny interfaces beat one fat one.

## 🎯 Cheat Sheet
- **Definition:** pure contract, no state, multiple implementation
- **Keywords:** contract, ISP, DI, polymorphism, default methods (C# 8)
- **Related:** abstract class, dependency injection

## 🏢 Industry Experience Answer
"Interfaces are the backbone of our DI setup — every service has an interface so we can mock it in tests and swap implementations via the container. I follow Interface Segregation hard: a class shouldn't implement methods it doesn't use, so I keep interfaces narrow and role-based."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is an interface?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q12 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
An abstract class is a base class that **cannot be instantiated** and may contain both abstract members (no body, must be overridden) and concrete members (shared implementation). Use it when related types share common code *and* a common identity ("is-a"), unlike an interface which is a pure contract.

## 📖 Detailed Explanation
**What it is:** A partially-implemented base type declared with `abstract`.
**Why it exists:** To share state and default behavior across a family of related subclasses while forcing them to implement certain members.
**How it works:** abstract members have no body and must be overridden; the class can also hold fields, constructors, and concrete methods. A class can inherit only **one** abstract class.

## 💻 Code Example
```csharp
public abstract class PaymentProcessor
{
    public abstract Task<bool> ChargeAsync(decimal amount);   // must override

    protected void LogTransaction(decimal amount) =>
        Console.WriteLine("Charged " + amount.ToString("C"));  // shared behavior
}

public class StripeProcessor : PaymentProcessor
{
    public override async Task<bool> ChargeAsync(decimal amount)
    {
        LogTransaction(amount);
        return await Task.FromResult(true);
    }
}
```

## ❓ Follow-Up Questions
- **Q: Can an abstract class have a constructor?** A: Yes — called by derived classes via base().
- **Q: Can it have non-abstract methods?** A: Yes, that's a key advantage over interfaces.
- **Q: Can you instantiate it?** A: No, only its concrete subclasses.

## ⚠️ Common Mistakes
❌ Choosing abstract class when you only need a contract.
✅ If there's no shared implementation/state, use an interface — it's more flexible (multiple implementation).

## 🎯 Cheat Sheet
- **Definition:** non-instantiable base with abstract + concrete members
- **Keywords:** abstract, override, base, single inheritance, shared state
- **Related:** interface, template method pattern

## 🏢 Industry Experience Answer
"I reach for abstract classes when subclasses genuinely share code — like a base PaymentProcessor with common logging/validation, where each provider only overrides the charge logic. If there's no shared implementation, I use an interface. The deciding question: do these share behavior, or just a contract?"
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is an abstract class?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q13 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
An **interface** is a pure contract with no implementation or state, and a class can implement many. An **abstract class** can hold state, constructors, and concrete methods, but a class can inherit only one. Rule of thumb: interface = "can-do" capability; abstract class = "is-a" family with shared code.

## 📖 Detailed Explanation
| Aspect | Interface | Abstract Class |
|---|---|---|
| Instantiation | No | No |
| Multiple inheritance | Yes (many) | No (one) |
| Fields/state | No (instance) | Yes |
| Constructors | No | Yes |
| Concrete methods | C# 8+ defaults only | Yes |
| Access modifiers | Implicitly public | Any |
| Use for | Capability/contract | Shared base + identity |

## 💻 Code Example
```csharp
public interface IFlyable { void Fly(); }          // capability
public abstract class Bird                          // identity + shared code
{
    public string Name { get; set; }
    public void Eat() => Console.WriteLine("Eating");  // shared
    public abstract void MakeSound();                  // must override
}
public class Eagle : Bird, IFlyable
{
    public override void MakeSound() => Console.WriteLine("Screech");
    public void Fly() => Console.WriteLine("Soaring");
}
```

## ❓ Follow-Up Questions
- **Q: Can a class do both?** A: Yes — inherit one abstract class and implement many interfaces.
- **Q: Which supports multiple inheritance?** A: Interfaces.
- **Q: Which can have state?** A: Abstract class.

## ⚠️ Common Mistakes
❌ Defaulting to abstract classes for everything.
✅ Prefer interfaces for flexibility; use an abstract class only when subclasses truly share implementation and identity.

## 🎯 Cheat Sheet
- **Interface:** contract, multiple, no state
- **Abstract class:** shared base, single, has state/constructors
- **Keywords:** is-a vs can-do, ISP, single vs multiple inheritance

## 🏢 Industry Experience Answer
"My model: interface answers 'what can this do?' and abstract class answers 'what is this, and what do these share?' I lean toward interfaces because DI and testing love them, and only introduce an abstract base when I catch myself copy-pasting the same code across siblings."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between interface and abstract class?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q14 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Use an **interface** when you only need a contract, when unrelated types share a capability, or when you need multiple inheritance. Use an **abstract class** when related types share common state and implementation and you want to enforce a base identity. When in doubt, start with an interface — it's more flexible.

## 📖 Detailed Explanation
**Choose interface when:** unrelated classes need the same capability (IDisposable, IComparable); you need DI/mocking; you want multiple contracts; the contract may be implemented by types you don't control.
**Choose abstract class when:** there's meaningful shared code/state; you want a constructor or protected helpers; subclasses are clearly a single family.

## 💻 Code Example
```csharp
// Interface: capability across unrelated types
public interface IAuditable { DateTime CreatedAt { get; } }

// Abstract class: shared identity + code
public abstract class Entity
{
    public int Id { get; init; }
    public DateTime CreatedAt { get; } = DateTime.UtcNow;
    public abstract string Describe();   // each entity must define
}
```

## ❓ Follow-Up Questions
- **Q: Default choice?** A: Interface — maximum flexibility.
- **Q: When abstract class wins?** A: Shared implementation/state + single family.
- **Q: Can you combine?** A: Yes — abstract base + interfaces is a common pattern.

## ⚠️ Common Mistakes
❌ Using an abstract class purely to share a couple of helper methods.
✅ That coupling isn't worth it — extract a helper/composition or use a default interface method instead.

## 🎯 Cheat Sheet
- **Interface:** contract, capability, multiple, DI/testing
- **Abstract class:** shared code+state, single family, base identity
- **Rule:** start with interface, promote to abstract class only for shared implementation

## 🏢 Industry Experience Answer
"I tell my team: reach for an interface first. We only introduce an abstract base when there's real duplicated logic across siblings — like a base Entity with Id and CreatedAt. Combining both (abstract base implementing interfaces) is our most common pattern for domain entities."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'When to use interface vs abstract class?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q15 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Method overloading is defining **multiple methods with the same name but different parameter lists** (type, count, or order) in the same scope. It's resolved at **compile time** based on the arguments you pass — a form of compile-time polymorphism. Return type alone cannot distinguish overloads.

## 📖 Detailed Explanation
**What it is:** Same name, different signatures.
**Why it exists:** Provides intuitive, flexible APIs (Console.WriteLine has ~18 overloads).
**How it works:** The compiler picks the best match via overload resolution. Signature = name + parameters; **return type is not part of the signature**.

## 💻 Code Example
```csharp
public class Calculator
{
    public int Add(int a, int b) => a + b;
    public double Add(double a, double b) => a + b;        // different types
    public int Add(int a, int b, int c) => a + b + c;       // different count
}

var c = new Calculator();
c.Add(2, 3);        // int overload
c.Add(2.5, 3.1);    // double overload
```

## ❓ Follow-Up Questions
- **Q: Can return type alone overload?** A: No — signatures must differ by parameters.
- **Q: Compile-time or runtime?** A: Compile-time (static binding).
- **Q: Is overloading polymorphism?** A: Yes — compile-time (ad-hoc) polymorphism.

## ⚠️ Common Mistakes
❌ Trying to overload by only changing return type.
✅ Won't compile — change parameter type, count, or order instead.

## 🎯 Cheat Sheet
- **Definition:** same name, different parameters, compile-time
- **Keywords:** overload resolution, signature, compile-time polymorphism
- **Related:** overriding (runtime), optional parameters

## 🏢 Industry Experience Answer
"I use overloading to give callers ergonomic options — e.g., Send(string) and Send(string, Attachment[]). But I don't overdo it; too many overloads clutter IntelliSense. Often optional parameters or an options object is cleaner than five overloads."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is method overloading?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q16 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Method overriding redefines a **base class's virtual (or abstract) method in a derived class** using the `override` keyword, providing a new implementation chosen at **runtime** based on the actual object type. It's the core mechanism of runtime polymorphism.

## 📖 Detailed Explanation
**What it is:** Replacing inherited behavior in a subclass.
**Why it exists:** Lets a base-type reference invoke subclass-specific behavior (dynamic dispatch).
**How it works:** Base method marked virtual/abstract; derived uses override. The runtime resolves the call via the type's virtual method table (vtable). base.Method() calls the parent version.

## 💻 Code Example
```csharp
public class Animal { public virtual string Speak() => "..."; }
public class Cat : Animal { public override string Speak() => "Meow"; }

Animal a = new Cat();
Console.WriteLine(a.Speak());   // "Meow" — resolved at runtime
```

## ❓ Follow-Up Questions
- **Q: Keyword to enable overriding?** A: virtual/abstract on base, override on derived.
- **Q: Compile-time or runtime?** A: Runtime (dynamic dispatch).
- **Q: How to call the base version?** A: base.MethodName().

## ⚠️ Common Mistakes
❌ Forgetting virtual on the base, then using new and expecting polymorphism.
✅ new hides (resolved by reference type); override replaces (resolved by actual type). Only override gives true polymorphism.

## 🎯 Cheat Sheet
- **Definition:** redefine virtual/abstract base method, runtime resolution
- **Keywords:** virtual, override, base, vtable, dynamic dispatch
- **Related:** overloading (compile-time), method hiding (new)

## 🏢 Industry Experience Answer
"Overriding powers our extensibility points — a base NotificationHandler defines a virtual Handle(), and each concrete handler overrides it. The dispatcher only knows the base type, yet the right subclass logic runs. That's runtime polymorphism doing the heavy lifting."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is method overriding?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q17 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**Overriding** (override) truly replaces a base virtual method — the call is resolved by the object's **actual type** (runtime). **Hiding** (new) creates a separate method that shadows the base one — the call is resolved by the **reference type** (compile time). Overriding is polymorphic; hiding is not.

## 📖 Detailed Explanation
**Overriding:** requires virtual/abstract base + override derived; one logical method; dynamic dispatch.
**Hiding:** new keyword (or none, with a warning); two separate methods; static dispatch by declared type.
**The key test:** assign the object to a base-typed variable and call the method — overriding runs the derived version, hiding runs whichever matches the declared type.

## 💻 Code Example
```csharp
public class Base { public virtual string Who() => "Base"; public string Tag() => "BaseTag"; }
public class OverrideChild : Base { public override string Who() => "Override"; }
public class HideChild : Base { public new string Tag() => "HideTag"; }

Base a = new OverrideChild();
Console.WriteLine(a.Who());   // "Override"  (runtime — overriding)

Base b = new HideChild();
Console.WriteLine(b.Tag());   // "BaseTag"   (compile-time — hiding!)
Console.WriteLine(((HideChild)b).Tag());  // "HideTag"
```

## ❓ Follow-Up Questions
- **Q: Which is polymorphic?** A: Overriding.
- **Q: What keyword for hiding?** A: new.
- **Q: Why does hiding surprise people?** A: Behavior depends on the declared reference type, not the real object.

## ⚠️ Common Mistakes
❌ Using new to hide when you meant to override.
✅ It produces type-dependent behavior that confuses callers — use override for true polymorphism; reserve new for rare versioning needs.

## 🎯 Cheat Sheet
- **Overriding:** override, runtime, replaces, polymorphic
- **Hiding:** new, compile-time, shadows, by reference type
- **Keywords:** dynamic vs static dispatch, declared vs actual type

## 🏢 Industry Experience Answer
"Hiding is almost always a code smell in my experience — it creates 'why is this calling the wrong method?' bugs that depend on the variable's declared type. I treat a new on a method as a red flag in code review and ask whether override was actually intended."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between method overriding and method hiding?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q18 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**virtual** marks a base method as overridable. **override** provides the replacement in a derived class (runtime dispatch). **new** hides an inherited member with an unrelated one (compile-time, by reference type). virtual+override = polymorphism; new = shadowing.

## 📖 Detailed Explanation
- **virtual:** "this method *can* be overridden." Enables dynamic dispatch.
- **override:** "I am replacing the base virtual/abstract method." Same signature, resolved by actual type.
- **new:** "I'm declaring a *different* member that happens to share a name." Resolved by the declared (reference) type; suppresses the hide warning.

## 💻 Code Example
```csharp
public class Shape
{
    public virtual string Draw() => "Shape";
}
public class Circle : Shape
{
    public override string Draw() => "Circle";   // polymorphic
}
public class Square : Shape
{
    public new string Draw() => "Square";          // hides (not polymorphic)
}

Shape s1 = new Circle(); Console.WriteLine(s1.Draw()); // Circle
Shape s2 = new Square(); Console.WriteLine(s2.Draw()); // Shape (!)
```

## ❓ Follow-Up Questions
- **Q: virtual without override?** A: The base implementation is used.
- **Q: Can you override a non-virtual method?** A: No — base must be virtual/abstract.
- **Q: Does new affect the base method?** A: No, it just shadows it for that type.

## ⚠️ Common Mistakes
❌ Marking everything virtual "just in case."
✅ virtual is a design commitment (an extensibility contract). Make methods virtual deliberately; over-virtualizing invites fragile-base-class problems.

## 🎯 Cheat Sheet
- **virtual:** base, overridable
- **override:** derived, replaces, runtime
- **new:** derived, hides, compile-time
- **Keywords:** dynamic dispatch, shadowing, fragile base class

## 🏢 Industry Experience Answer
"I treat virtual as part of a class's public contract — once it's virtual, subclasses depend on overriding it, so removing it is a breaking change. That's why I keep classes sealed by default and only open up specific methods as virtual when extensibility is genuinely intended."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between virtual, override, and new keywords?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q19 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A `sealed` class **cannot be inherited from**, and a `sealed` override **stops further overriding** down the chain. Seal classes to prevent unintended extension, protect invariants, and enable JIT optimizations (devirtualization). Many framework types like string are sealed.

## 📖 Detailed Explanation
**What it is:** sealed class X {} blocks inheritance; sealed override void M() stops re-overriding.
**Why use it:** Security/correctness (no one can subvert behavior via subclassing), clearer design intent, and a small performance win because the JIT can devirtualize calls.
**Best practice (Framework Design Guidelines):** prefer sealed by default; open for inheritance only when you've designed for it.

## 💻 Code Example
```csharp
public sealed class CurrencyFormatter   // can't be subclassed
{
    public string Format(decimal amount) => amount.ToString("C");
}

public class Base { public virtual void M() {} }
public class Mid : Base { public sealed override void M() {} }  // no further override
// public class Leaf : Mid { public override void M() {} }  // compile error
```

## ❓ Follow-Up Questions
- **Q: Can you seal a method?** A: Only a sealed override — to stop further overriding.
- **Q: Performance benefit?** A: JIT can devirtualize/inline calls on sealed types.
- **Q: Example of a sealed BCL type?** A: string, StringBuilder.

## ⚠️ Common Mistakes
❌ Leaving every class open (default) without thinking about extensibility.
✅ Inheritance is a contract; if you didn't design for it, seal the class to avoid fragile-base-class issues.

## 🎯 Cheat Sheet
- **Definition:** prevents inheritance (class) or further overriding (method)
- **Keywords:** sealed, devirtualization, fragile base class, design intent
- **Related:** virtual/override, immutability

## 🏢 Industry Experience Answer
"I seal classes by default unless I've explicitly designed an extension point. It signals intent, prevents someone subclassing a service and breaking its invariants, and the JIT devirtualization is a free perf bonus on hot paths. Open inheritance should be a deliberate decision, not the default."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is a sealed class and when to use it?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q20 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A `static` class can't be instantiated or inherited — it only holds static members and is loaded once per app domain. Use it for stateless utility/helper methods (like Math or Console). All its members must also be static.

## 📖 Detailed Explanation
**What it is:** static class X {} — a sealed, abstract-by-implication container of static members.
**Why it exists:** Groups related stateless functionality with no need for an instance.
**How it works:** No callable constructor (only an optional static constructor for one-time init); cannot be used as a type for variables/parameters.
**Caution:** Static state is global and shared — can hurt testability and cause thread-safety issues if mutable.

## 💻 Code Example
```csharp
public static class MathHelper
{
    public static int Square(int x) => x * x;
    public static double Pi { get; } = 3.14159;

    static MathHelper() { /* one-time init */ }
}

int result = MathHelper.Square(5);   // no instance needed
```

## ❓ Follow-Up Questions
- **Q: Can a static class have instance members?** A: No, all members must be static.
- **Q: Can it have a constructor?** A: Only a parameterless static constructor for initialization.
- **Q: Can it be inherited?** A: No — implicitly sealed.

## ⚠️ Common Mistakes
❌ Storing mutable shared state in static fields.
✅ Static mutable state is a hidden global — it breaks unit-test isolation and risks race conditions. Keep static classes stateless or thread-safe.

## 🎯 Cheat Sheet
- **Definition:** non-instantiable container of static members
- **Keywords:** static constructor, utility, stateless, sealed+abstract
- **Related:** singleton, extension methods (must be in static class)

## 🏢 Industry Experience Answer
"Static classes are great for pure helpers — formatting, math, extension methods. The trap I warn against is mutable static state; it's an invisible global that wrecks test isolation and causes race conditions under load. If something needs state, it belongs in a DI-registered service."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is a static class?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q21 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**const** is a compile-time constant baked into callers (implicitly static, value types/strings only). **readonly** is set once at runtime — in the declaration or constructor — and can vary per instance. **static** means the member belongs to the type, not an instance. static readonly is the common combo for runtime-computed shared constants.

## 📖 Detailed Explanation
- **const:** value fixed at compile time, inlined into consuming assemblies (so changing it requires recompiling consumers). Only primitives/strings/null.
- **readonly:** assignable only in declaration or constructor; can be any type; evaluated at runtime; per-instance unless also static.
- **static:** one shared copy at the type level, unrelated to mutability.

## 💻 Code Example
```csharp
public class Config
{
    public const int MaxRetries = 3;                  // compile-time, inlined
    public static readonly DateTime StartTime = DateTime.UtcNow;  // runtime, shared
    public readonly Guid InstanceId;                  // per-instance, set in ctor

    public Config() => InstanceId = Guid.NewGuid();
}
```

## ❓ Follow-Up Questions
- **Q: Why can const be risky across assemblies?** A: Its value is inlined into callers; changing it without recompiling them keeps the old value.
- **Q: const vs static readonly?** A: const = compile-time literal; static readonly = runtime value, safe across assemblies.
- **Q: Can readonly fields change?** A: Only inside the constructor.

## ⚠️ Common Mistakes
❌ Exposing a public const in a library that may change.
✅ Use static readonly for public library values so consumers pick up changes without recompiling.

## 🎯 Cheat Sheet
- **const:** compile-time, inlined, primitives only, implicitly static
- **readonly:** runtime, set in ctor, any type, per-instance
- **static:** type-level, shared, about location not mutability

## 🏢 Industry Experience Answer
"The gotcha I've been bitten by: a public const in a shared library. We bumped it, redeployed one service, and another that wasn't recompiled kept the old inlined value. Now in libraries I default to static readonly for anything public; const only for truly fixed internal literals."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between static, const, and readonly?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q22 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A constructor is a special method that initializes a new object, sharing the class name and having no return type. C# supports several types: **default (parameterless)**, **parameterized**, **static** (one-time type init), **private** (factory/singleton), and copy constructors (manual). Constructors can chain with `: this(...)` and `: base(...)`.

## 📖 Detailed Explanation
- **Default/parameterless:** provided automatically if you declare none; initializes to defaults.
- **Parameterized:** takes arguments to set initial state.
- **Static constructor:** runs once before first use, initializes static members (no access modifier, no params).
- **Private constructor:** blocks external instantiation — used for singletons or factory patterns.
- **Copy constructor:** takes an instance of the same type to clone it (written manually in C#).
- **Chaining:** : this() calls another constructor; : base() calls the parent's.

## 💻 Code Example
```csharp
public class Order
{
    public int Id { get; }
    public string Status { get; }

    static Order() { /* static init, runs once */ }

    public Order() : this(0, "New") { }                 // chains to below
    public Order(int id, string status) => (Id, Status) = (id, status);
    public Order(Order other) : this(other.Id, other.Status) { }  // copy
}
```

## ❓ Follow-Up Questions
- **Q: When does a static constructor run?** A: Once, automatically, before the first instance or static access.
- **Q: Why a private constructor?** A: Singleton / factory-only creation.
- **Q: What is constructor chaining?** A: One constructor calling another via : this(...).

## ⚠️ Common Mistakes
❌ Putting heavy logic (DB calls, I/O) in constructors.
✅ Keep constructors fast and exception-light; do expensive/fallible work in a factory method or async initializer.

## 🎯 Cheat Sheet
- **Types:** default, parameterized, static, private, copy
- **Keywords:** : this(), : base(), static constructor, object initialization
- **Related:** factory pattern, singleton, primary constructors (C# 12)

## 🏢 Industry Experience Answer
"My rule: constructors set state, they don't *do* work. No DB calls, no I/O, nothing that can throw unexpectedly — those go in factory methods or async init. For dependencies I use constructor injection, which keeps the object valid the moment it's created and makes requirements explicit."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are constructors and their types?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q23 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A destructor (finalizer) is a special method that the **Garbage Collector calls automatically** before reclaiming an object's memory. In C# it's written as `~ClassName()`. You almost never write one — use `IDisposable` and `using` instead for resource cleanup. Finalizers add GC overhead and run on a background thread at unpredictable times.

## 📖 Detailed Explanation
**What it is:** A method called by the GC before collecting an object — C#'s version of C++'s destructor, but non-deterministic.
**Why it exists:** Last-resort cleanup for unmanaged resources (file handles, OS handles) when the caller forgot to call Dispose().
**How it works:** The CLR places finalizable objects in the finalization queue; a separate Finalizer thread calls them. This delays collection by at least one GC cycle (promotes to Gen1/Gen2).
**Best practice:** Implement the Dispose pattern (IDisposable + finalizer together) only if you hold unmanaged resources directly. Otherwise skip the finalizer entirely.

## 💻 Code Example
```csharp
public class NativeResource : IDisposable
{
    private IntPtr _handle;
    private bool _disposed = false;

    public NativeResource() => _handle = AcquireNativeHandle();

    // Finalizer: safety net if Dispose was never called
    ~NativeResource()
    {
        Dispose(disposing: false);
    }

    public void Dispose()
    {
        Dispose(disposing: true);
        GC.SuppressFinalize(this);  // no need for finalizer now
    }

    protected virtual void Dispose(bool disposing)
    {
        if (!_disposed)
        {
            if (disposing)
            {
                // free managed resources
            }
            ReleaseNativeHandle(_handle);  // always free unmanaged
            _disposed = true;
        }
    }
}
```

## ❓ Follow-Up Questions
- **Q: When does a finalizer run?** A: Non-deterministically — whenever the GC runs, on the Finalizer thread.
- **Q: Should you always write a finalizer?** A: No — only when you hold unmanaged resources directly. For managed resources, use IDisposable only.
- **Q: What does GC.SuppressFinalize do?** A: Removes the object from the finalization queue so the GC can collect it in one pass.

## ⚠️ Common Mistakes
❌ Writing a finalizer for every class "to be safe."
✅ Finalizers degrade GC performance. Only write one when you directly own unmanaged resources; always pair with IDisposable and call GC.SuppressFinalize in Dispose.

## 🎯 Cheat Sheet
- **Definition:** GC-called cleanup method, non-deterministic, ~ClassName()
- **Use:** only for unmanaged resources; pair with IDisposable + GC.SuppressFinalize
- **Keywords:** finalization queue, GC promotion, Dispose pattern, unmanaged resources

## 🏢 Industry Experience Answer
"In practice I almost never write finalizers. We use IDisposable with using blocks for everything. The only time I've written a finalizer was wrapping a legacy COM interop handle — and even then I immediately paired it with GC.SuppressFinalize in Dispose so the finalizer was just a safety net, never the primary path."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are destructors?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q24 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Both `ref` and `out` pass arguments **by reference** (the method can modify the caller's variable). The difference: **ref** requires the variable to be **initialized before passing**; **out** does not require initialization but the method **must assign it before returning**. Use `ref` for read-write; `out` for methods that return multiple values.

## 📖 Detailed Explanation
**ref:** variable must be assigned before the call; method can read and write it.
**out:** variable doesn't need pre-initialization; method must write it before returning (compiler-enforced); caller gets a guaranteed-assigned value back.
**in (C# 7.2):** pass by reference, read-only inside the method — avoids copying large structs without allowing mutation.
**Common use of out:** `int.TryParse(s, out int result)` — returns bool for success, out for the parsed value.

## 💻 Code Example
```csharp
void DoubleIt(ref int value) => value *= 2;       // reads + writes
bool TrySplit(string s, out string left, out string right)
{
    var parts = s.Split('-');
    if (parts.Length == 2) { left = parts[0]; right = parts[1]; return true; }
    left = right = "";
    return false;
}

int x = 5;
DoubleIt(ref x);   // x is now 10

if (TrySplit("hello-world", out string l, out string r))
    Console.WriteLine(l + " / " + r);   // hello / world
```

## ❓ Follow-Up Questions
- **Q: Does ref require initialization?** A: Yes — must be assigned before passing.
- **Q: Does out require initialization?** A: No — but method must assign before returning.
- **Q: What is `in` for?** A: Read-only by-reference — avoids copying large structs.

## ⚠️ Common Mistakes
❌ Using ref when you just want to return an extra value.
✅ out is cleaner for "return multiple values" (like TryParse). If you don't need to read the original value inside the method, out is more expressive.

## 🎯 Cheat Sheet
- **ref:** initialized before call, read+write inside method
- **out:** not initialized before call, must write inside method
- **in:** initialized before call, read-only inside method
- **Keywords:** pass by reference, TryParse pattern, multiple return values

## 🏢 Industry Experience Answer
"I use out constantly via the TryXxx pattern — TryGetValue, TryParse — it's the idiomatic way to handle operations that might fail without throwing exceptions. For ref, I only use it in performance-critical code passing large structs or low-level interop. In most business code you never touch ref."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between ref and out keyword?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q25 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**Value equality** compares whether two objects have the same data/content. **Reference equality** compares whether two variables point to the **same object in memory**. By default, classes use reference equality (Object.Equals checks address); structs and records use value equality. You override `Equals` and `==` to define custom value equality for classes.

## 📖 Detailed Explanation
**Reference equality:** `object.ReferenceEquals(a, b)` — true only if a and b are literally the same heap object.
**Value equality:** overridden `Equals()` and `==` — true if content matches (e.g., two different string objects with identical characters).
**string special case:** string uses value equality by default (interning + overridden Equals).
**Records (C# 9+):** value equality out of the box — two records with identical property values are equal.
**How to implement:** override `Equals(object)` + `GetHashCode()` + `==`/`!=` operators; or implement `IEquatable<T>`.

## 💻 Code Example
```csharp
var a = new List<int> { 1, 2 };
var b = new List<int> { 1, 2 };
var c = a;

Console.WriteLine(object.ReferenceEquals(a, b)); // false (different objects)
Console.WriteLine(object.ReferenceEquals(a, c)); // true (same reference)
Console.WriteLine(a == b);                        // false (List uses reference ==)

string s1 = "hello"; string s2 = "hello";
Console.WriteLine(s1 == s2);                      // true (string value equality)

record Point(int X, int Y);
var p1 = new Point(1, 2); var p2 = new Point(1, 2);
Console.WriteLine(p1 == p2);                      // true (record value equality)
```

## ❓ Follow-Up Questions
- **Q: What does == do by default for classes?** A: Reference equality (same as ReferenceEquals).
- **Q: How do you add value equality to a class?** A: Override Equals + GetHashCode + == operator.
- **Q: Why must you override GetHashCode when overriding Equals?** A: Objects that are equal must have the same hash code — breaking this breaks Dictionary/HashSet.

## ⚠️ Common Mistakes
❌ Using == to compare class instances expecting content comparison.
✅ Override Equals/GetHashCode (or use a record) for value semantics; use == only after overriding or for primitives/strings.

## 🎯 Cheat Sheet
- **Reference equality:** ReferenceEquals, same heap address
- **Value equality:** overridden Equals, same content
- **Built-in value equality:** string, struct, record, primitive types
- **Keywords:** Equals, GetHashCode, IEquatable, record, ReferenceEquals

## 🏢 Industry Experience Answer
"A classic bug: comparing two entity objects with == and expecting true when they have the same Id. Fixed by overriding Equals to compare by Id, and always pairing with GetHashCode. Now we use records for DTOs and value objects — they give correct value equality for free."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Value equality vs reference equality?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q26 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A nullable type allows a value type (which normally can't be null) to also hold `null`. The syntax `int?` is shorthand for `Nullable<int>`. C# 8+ extended this to **nullable reference types** (`string?`) as a compiler opt-in to catch null dereferences statically. Use nullable types when a value is genuinely optional or unknown.

## 📖 Detailed Explanation
**Nullable value types (pre-C# 8):** `int?` wraps `Nullable<T>` with `.HasValue` and `.Value` properties. Unboxing null to a non-nullable throws `InvalidOperationException`.
**Nullable reference types (C# 8+):** enabled via `<Nullable>enable</Nullable>` in csproj. `string` = non-nullable (compiler warns on null assignment); `string?` = explicitly nullable. The compiler tracks flow and warns if you dereference a nullable without a null check.
**Null-forgiving operator:** `x!` suppresses the nullable warning when you're sure x is non-null.

## 💻 Code Example
```csharp
// Nullable value type
int? age = null;
Console.WriteLine(age.HasValue);        // false
Console.WriteLine(age.GetValueOrDefault()); // 0

age = 28;
Console.WriteLine(age.Value);           // 28

// Nullable reference type (C# 8+, nullable enabled)
string? name = null;
int length = name?.Length ?? 0;         // safe: 0

void Greet(string? input)
{
    if (input is null) return;
    Console.WriteLine("Hello " + input);  // compiler knows non-null here
}
```

## ❓ Follow-Up Questions
- **Q: int? vs int difference?** A: int? can be null; int cannot. int? is Nullable<int> under the hood.
- **Q: How do you check a nullable?** A: .HasValue, is null, != null, or pattern matching.
- **Q: What enables nullable reference types?** A: <Nullable>enable</Nullable> in .csproj, or #nullable enable per file.

## ⚠️ Common Mistakes
❌ Accessing .Value on a nullable without checking HasValue first.
✅ Use GetValueOrDefault(), the null-conditional operator ?., or pattern match before accessing .Value.

## 🎯 Cheat Sheet
- **int?:** Nullable<int>, can hold null, has .HasValue and .Value
- **string?:** nullable reference type (C# 8+), compiler-enforced null safety
- **Keywords:** Nullable<T>, HasValue, GetValueOrDefault, nullable enable, null-forgiving !

## 🏢 Industry Experience Answer
"We enabled nullable reference types on all new projects — it's one of the highest-ROI C# features. The compiler tells you exactly which paths could be null, and you either handle them or annotate intentionally. It's eliminated a huge class of NullReferenceException bugs that used to only surface in production."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are nullable types in C# and how does the ? syntax work?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q27 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**`??` (null-coalescing)** returns the left operand if it's not null, otherwise the right. **`?.` (null-conditional)** short-circuits the entire chain and returns `null` if the left side is null, instead of throwing NullReferenceException. Together they make null-safe navigation and defaults concise and readable.

## 📖 Detailed Explanation
**`??` (null-coalescing):** `a ?? b` — returns a if non-null, else b. Great for defaults.
**`??=` (null-coalescing assignment, C# 8):** `a ??= defaultValue` — assigns only if a is currently null.
**`?.` (null-conditional member access):** `obj?.Property` — returns null if obj is null, else Property. Chains: `obj?.A?.B?.C` short-circuits at first null.
**`?[]` (null-conditional indexer):** `list?[0]` — returns null if list is null.

## 💻 Code Example
```csharp
string name = null;
string display = name ?? "Anonymous";        // "Anonymous"
name ??= "Default";                          // assigns "Default" since name is null

class Address { public string City { get; set; } }
class Person  { public Address Address { get; set; } }

Person p = null;
string city = p?.Address?.City ?? "Unknown";  // "Unknown" — no NullReferenceException

int[] nums = null;
int? first = nums?[0];                        // null, not an exception
```

## ❓ Follow-Up Questions
- **Q: What does ?? return if left is not null?** A: The left operand.
- **Q: What does ?. return if the left is null?** A: null (the whole expression short-circuits to null).
- **Q: Can you chain ?.?** A: Yes — obj?.A?.B?.C returns null at the first null in the chain.

## ⚠️ Common Mistakes
❌ Using ?? on value types and expecting it to handle null — value types can't be null unless nullable.
✅ ?? works on nullable value types (int?) and reference types. For non-nullable int, it won't compile.

## 🎯 Cheat Sheet
- **??:** left ?? right — return left if non-null, else right
- **??=:** assign right only if left is null
- **?.:** null-conditional — short-circuit to null instead of throwing
- **?[]:** null-conditional indexer
- **Keywords:** null-safe, null-coalescing, short-circuit, NullReferenceException prevention

## 🏢 Industry Experience Answer
"These two operators eliminated entire categories of null checks from our codebase. Instead of five nested if-null checks to get a city name off an order, it's one line: order?.Customer?.Address?.City ?? 'Unknown'. Far more readable and just as safe — I use them constantly."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is the null coalescing (??) and null-conditional (?.) operator?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q28 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Tuples are lightweight, ordered groupings of values without defining a class. C# 7+ ValueTuple syntax `(Type name, Type name)` gives named fields and lives on the stack. Use them for returning multiple values from a method, local grouping, and LINQ projections — but prefer a named class or record for anything in a public API.

## 📖 Detailed Explanation
**Two kinds:** `System.Tuple<T1,T2>` (old, reference type, .Item1/.Item2) and `System.ValueTuple<T1,T2>` (C# 7+, value type, named fields, deconstruct).
**Deconstruction:** `var (name, age) = GetPerson()` — unpacks the tuple into individual variables.
**Named fields:** `(string Name, int Age)` — fields accessible by name, not just .Item1.
**When to use:** internal/private return values, temporary grouping. Not in public APIs — create a proper type instead.

## 💻 Code Example
```csharp
// Return multiple values — no class needed
(string FirstName, string LastName) SplitName(string full)
{
    var parts = full.Split(' ');
    return (parts[0], parts[1]);
}

var (first, last) = SplitName("Sidhant Kumar");
Console.WriteLine(first);   // Sidhant
Console.WriteLine(last);    // Kumar

// LINQ projection
var summary = orders
    .Select(o => (o.Id, Total: o.Items.Sum(i => i.Price)))
    .ToList();
```

## ❓ Follow-Up Questions
- **Q: Tuple vs record?** A: Tuple for quick private use; record for named, reusable, semantic types with equality.
- **Q: How do you deconstruct a tuple?** A: var (a, b) = myTuple; or (int x, string y) = myTuple;
- **Q: Value vs reference tuple?** A: ValueTuple (C# 7 syntax) is a struct (stack); System.Tuple is a class (heap).

## ⚠️ Common Mistakes
❌ Using tuples in public method signatures.
✅ A named record or class communicates intent and is versioned properly. Tuples in public APIs are cryptic (.Item1/.Item2) and hard to evolve.

## 🎯 Cheat Sheet
- **Definition:** lightweight ordered value grouping, (T1, T2, ...)
- **C# 7 syntax:** ValueTuple, named fields, deconstruction
- **Use:** multiple return values, local grouping, LINQ projections
- **Keywords:** ValueTuple, deconstruct, named fields, record alternative

## 🏢 Industry Experience Answer
"Tuples are great for private helper methods that need to return two or three related values without the ceremony of a class. But any time a tuple crosses a service boundary or shows up in a public method, I replace it with a named record — it's self-documenting and much easier to maintain."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are tuples in C# and when would you use them?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q29 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Pattern matching lets you test a value's **shape, type, and content** in a single, readable expression using `is` patterns and `switch` expressions/statements. Introduced in C# 7 and massively expanded in C# 8–12, it replaces verbose if/else chains and casts with declarative, concise syntax.

## 📖 Detailed Explanation
**Type pattern:** `obj is string s` — tests type and binds the cast variable simultaneously.
**Constant pattern:** `x is 42` or `x is null`.
**Property pattern:** `obj is { Length: > 0 }` — matches on property values.
**Positional pattern:** deconstructs records/tuples.
**Switch expression (C# 8+):** a concise expression form of switch.
**Guard clause (when):** `case X when condition:` for extra filtering.

## 💻 Code Example
```csharp
object shape = new Circle { Radius = 5 };

// switch expression with pattern matching
double area = shape switch
{
    Circle c                   => Math.PI * c.Radius * c.Radius,
    Rectangle { Width: var w, Height: var h } => w * h,
    null                       => throw new ArgumentNullException(nameof(shape)),
    _                          => throw new NotSupportedException()
};

// property pattern + guard
string Classify(int n) => n switch
{
    < 0          => "negative",
    0            => "zero",
    > 0 and < 10 => "small positive",
    _            => "large positive"
};
```

## ❓ Follow-Up Questions
- **Q: What is a discard pattern (_)?** A: Matches anything — the default/catch-all in switch expressions.
- **Q: What is a when guard?** A: An extra boolean condition: case int n when n > 0: ...
- **Q: Does the compiler check exhaustiveness?** A: For switch expressions over enums/discriminated unions it warns on missing cases.

## ⚠️ Common Mistakes
❌ Sticking with long if/else if chains and explicit casts.
✅ Pattern matching is more readable, removes duplicate casts, and the compiler can verify exhaustiveness for you.

## 🎯 Cheat Sheet
- **is patterns:** type, constant, null, property, positional, relational, logical (and/or/not)
- **switch expression:** returns a value, exhaustiveness-checked
- **Keywords:** pattern matching, switch expression, property pattern, type pattern, discard

## 🏢 Industry Experience Answer
"Pattern matching transformed how we handle discriminated-union-like structures. Our notification-type dispatch went from a six-level if/else with casts to a clean switch expression. The compiler now tells us when we've missed a case, which caught a real bug when we added a new notification type."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is pattern matching in C#?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q30 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
The `using` statement guarantees that `Dispose()` is called on an `IDisposable` object when the block exits — even if an exception is thrown. It's syntactic sugar for a try/finally block. Implement `IDisposable` on any class that holds resources needing deterministic cleanup: DB connections, file handles, HTTP clients via factory.

## 📖 Detailed Explanation
**IDisposable:** one method — `void Dispose()`. Called explicitly or via `using` to release resources immediately rather than waiting for the GC/finalizer.
**`using` statement:** wraps usage in a try/finally; Dispose is called at the closing brace.
**`using` declaration (C# 8+):** `using var conn = new SqlConnection(cs);` — Dispose called when the enclosing scope exits.
**Rule:** any class that owns something implementing IDisposable should itself implement IDisposable and Dispose its owned resources.

## 💻 Code Example
```csharp
// Classic using statement
using (var conn = new SqlConnection(connectionString))
{
    conn.Open();
    // use conn
}   // Dispose() called here automatically

// C# 8 using declaration (cleaner)
using var reader = new StreamReader("file.txt");
var content = reader.ReadToEnd();
// Dispose called when method exits
```

## ❓ Follow-Up Questions
- **Q: What does using compile to?** A: try { ... } finally { obj.Dispose(); }
- **Q: What if Dispose throws?** A: The exception from Dispose suppresses the original exception — handle in Dispose carefully.
- **Q: Can you use using with async?** A: Yes — await using for IAsyncDisposable (C# 8+).

## ⚠️ Common Mistakes
❌ Manually calling Dispose() without using — it won't be called if an exception occurs.
✅ Always wrap IDisposable resources in using; the guarantee is watertight even on exceptions.

## 🎯 Cheat Sheet
- **IDisposable:** void Dispose() — deterministic resource cleanup
- **using:** syntactic try/finally ensuring Dispose is called
- **C# 8:** using var — scope-based Dispose at method exit
- **Keywords:** deterministic cleanup, dispose pattern, IAsyncDisposable, await using

## 🏢 Industry Experience Answer
"Using/IDisposable is the first thing I check when reviewing code that touches DB connections, file streams, or HttpClient. Forgetting it under an exception path leaks the resource — connection pool exhaustion is a real production incident I've debugged. The rule is simple: if it has Dispose, wrap it in using."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is the using statement and how does it relate to IDisposable?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q31 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**Named parameters** let you pass arguments in any order by specifying the parameter name at the call site (`Send(to: "x", subject: "y")`). **Optional parameters** have default values and can be omitted at the call site. Together they improve readability, reduce overload proliferation, and make APIs self-documenting.

## 📖 Detailed Explanation
**Optional parameters:** declared with `= defaultValue` in the signature. Must come after required parameters. Default values must be compile-time constants.
**Named arguments:** pass by name instead of position — any order, any combination with positional.
**Named + optional combined:** particularly powerful for methods with many optional settings.
**Caveat:** changing a default value is a source-compatible but binary-incompatible change in libraries — callers compiled with the old default still use the old value.

## 💻 Code Example
```csharp
void SendEmail(string to, string subject = "No Subject", bool isHtml = false, int retries = 3)
{
    Console.WriteLine("Sending to " + to + " | Subject: " + subject);
}

// Various call styles
SendEmail("a@example.com");                              // uses all defaults
SendEmail("a@example.com", "Hello");                    // positional
SendEmail("a@example.com", isHtml: true);               // skip subject, name isHtml
SendEmail(to: "a@example.com", retries: 1, subject: "Hi"); // any order
```

## ❓ Follow-Up Questions
- **Q: Can optional parameters have any type of default?** A: Only compile-time constants (literals, const, default(T), null).
- **Q: What's the order rule for optional parameters?** A: They must come after all required parameters.
- **Q: Named params vs overloads — which is better?** A: Named+optional for simple defaults; overloads when behavior meaningfully differs.

## ⚠️ Common Mistakes
❌ Putting optional parameters before required ones.
✅ Won't compile — required parameters must precede optional ones.

## 🎯 Cheat Sheet
- **Optional:** param = defaultValue, compile-time constant only
- **Named:** argumentName: value at call site
- **Benefits:** fewer overloads, self-documenting calls, flexible ordering
- **Keywords:** default value, named argument, compile-time constant

## 🏢 Industry Experience Answer
"Named and optional parameters significantly cleaned up our service method signatures. Instead of five overloads of a SendNotification method, we have one with clear named parameters for each option. Code reviews got easier because the call site tells you exactly what each argument means."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are named and optional parameters in C#?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q32 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
`string` is **immutable** — every operation (concat, replace, trim) creates a new string object. `StringBuilder` is a **mutable buffer** designed for efficient repeated string modifications. Use `string` for most cases; switch to `StringBuilder` when building a string in a loop or from many pieces.

## 📖 Detailed Explanation
**string:** immutable reference type, interned by CLR, every concatenation allocates a new object. `s + t` in a tight loop = O(n²) allocations.
**StringBuilder:** mutable char buffer, amortized O(1) append. Has Append, Insert, Replace, ToString methods. Not thread-safe.
**Threshold:** string concatenation with + is fine for a handful of fixed pieces. For loops or unknown counts, use StringBuilder.
**Modern alternative:** for simple cases `string.Join`, `string.Concat`, or string interpolation are often optimised by the compiler/JIT.

## 💻 Code Example
```csharp
// Bad — creates hundreds of intermediate strings
string result = "";
for (int i = 0; i < 1000; i++)
    result += i.ToString() + ",";   // 1000 allocations

// Good — single buffer, O(n) appends
var sb = new StringBuilder(4096);   // pre-size when count is known
for (int i = 0; i < 1000; i++)
    sb.Append(i).Append(',');
string result2 = sb.ToString();     // one final allocation
```

## ❓ Follow-Up Questions
- **Q: Is string thread-safe?** A: Yes, because it's immutable — no mutation means no race conditions.
- **Q: Is StringBuilder thread-safe?** A: No — use a separate instance per thread.
- **Q: When is + faster than StringBuilder?** A: Constant-number short concatenations — the compiler may optimize them to a single string.Concat call.

## ⚠️ Common Mistakes
❌ Using StringBuilder for 2–3 fixed concatenations.
✅ Overhead of StringBuilder creation outweighs the benefit for small/fixed counts. Use string interpolation or string.Concat; switch to StringBuilder only when concatenating in loops or with many dynamic pieces.

## 🎯 Cheat Sheet
- **string:** immutable, thread-safe, + allocates new objects
- **StringBuilder:** mutable buffer, efficient loops, ToString() at end
- **Threshold:** use StringBuilder in loops, string for fixed pieces
- **Keywords:** immutability, allocation, O(n) vs O(n²), interning

## 🏢 Industry Experience Answer
"A performance review on a reporting module revealed a string + operator inside a nested loop generating tens of thousands of strings per request. Replacing it with StringBuilder cut memory allocations by 90% and GC pressure dramatically. Now our team rule is simple: if you see + inside a loop, it needs a StringBuilder."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between string and StringBuilder?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q33 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**Object initializers** let you set an object's properties inline after `new` without extra constructor parameters — `new Person { Name = "Sidhant", Age = 28 }`. **Collection initializers** let you populate a collection inline — `new List<int> { 1, 2, 3 }`. Both are syntactic sugar compiled to sequential property sets and Add() calls respectively.

## 📖 Detailed Explanation
**Object initializer:** works on any type with a no-arg (or any) constructor and settable properties. Compiles to: create instance, then set each property. Can be nested for child objects.
**Collection initializer:** works on any type implementing IEnumerable and an `Add` method. Compiles to individual Add calls.
**Index initializers (C# 6):** `new Dictionary<string,int> { ["a"] = 1, ["b"] = 2 }` — uses the indexer setter.
**Required properties (C# 11):** `required` keyword forces a property to be set via initializer.

## 💻 Code Example
```csharp
// Object initializer
var order = new Order
{
    Id = 1,
    Customer = new Customer { Name = "Sidhant" },  // nested
    Status = OrderStatus.Pending
};

// Collection initializer
var tags = new List<string> { "dotnet", "csharp", "api" };

// Dictionary index initializer
var config = new Dictionary<string, int>
{
    ["timeout"] = 30,
    ["retries"] = 3
};

// Required properties (C# 11) — must set via initializer
public class Point { public required int X { get; init; } public required int Y { get; init; } }
var p = new Point { X = 1, Y = 2 };  // OK — required satisfied
```

## ❓ Follow-Up Questions
- **Q: What does an object initializer compile to?** A: Constructor call, then sequential property assignments.
- **Q: Can you use object initializers with immutable properties?** A: Yes — use `init` setter (C# 9) so the property can only be set during initialization.
- **Q: What is `required` (C# 11)?** A: Forces consumers to set the property via an initializer — compile error if omitted.

## ⚠️ Common Mistakes
❌ Confusing object initializers with constructors — initializers run after the constructor.
✅ If order matters (e.g., one property depends on another), set dependencies in the constructor, not via initializer.

## 🎯 Cheat Sheet
- **Object initializer:** new T { Prop = val } — sets properties after construction
- **Collection initializer:** new List<T> { a, b, c } — calls Add() for each element
- **init:** property settable only in initializer (immutable after)
- **required (C# 11):** must be set in initializer
- **Keywords:** syntactic sugar, init, required, index initializer

## 🏢 Industry Experience Answer
"Object and collection initializers are table-stakes C# — I use them everywhere for concise, readable setup. With init-only properties and required members in C# 11 we've moved a lot of validation from constructors into the type system itself, catching missing fields at compile time instead of runtime."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are object initializers and collection initializers?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- ════════════════════════════════════════════════════════════
-- DevReady Seed — Batch 2
-- .NET › 2️⃣ Advanced C# Concepts › Q1–Q25
-- Dollar-quote safe (zero $ inside content). Idempotent upsert.
-- ════════════════════════════════════════════════════════════

-- Q1 ─────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**Boxing** wraps a value type in a heap-allocated object (value type → object). **Unboxing** extracts the value back out (object → value type). Both involve heap allocation and type checking, making them expensive in hot paths. Avoid them by using generics (`List<int>` instead of `ArrayList`) and typed collections.

## 📖 Detailed Explanation
**Boxing:** CLR allocates a new object on the heap, copies the value type's data into it, returns a reference. Any assignment of a value type to `object` or an interface type triggers boxing.
**Unboxing:** explicit cast from object back to the value type; CLR verifies the type first, then copies the value out. Throws InvalidCastException if the type doesn't match.
**Performance cost:** heap allocation + GC pressure + type check. A tight loop boxing millions of ints is measurably slow.
**Main causes:** `ArrayList`, non-generic interfaces, `Console.WriteLine(intValue)` (auto-boxed via object overload — fixed by string interpolation/concatenation), string.Format.

## 💻 Code Example
```csharp
int x = 42;
object boxed = x;          // boxing — heap allocation, copy
int unboxed = (int)boxed;  // unboxing — type check, copy back

// Avoid: ArrayList boxes every int
var list = new ArrayList();
list.Add(1);               // boxes
int val = (int)list[0];    // unboxes

// Prefer: List<int> — no boxing ever
var typed = new List<int>();
typed.Add(1);
int val2 = typed[0];       // direct, zero allocation
```

## ❓ Follow-Up Questions
- **Q: Does List<int> box?** A: No — generics are specialised per value type by the JIT.
- **Q: What interfaces cause boxing on structs?** A: Any non-generic interface implemented by a struct (e.g., IComparable, IDisposable used as interface reference).
- **Q: How do you detect boxing?** A: Profilers (dotMemory, PerfView) or IL inspection — look for `box` opcode.

## ⚠️ Common Mistakes
❌ Using ArrayList, Hashtable, or non-generic collections for value types.
✅ Use generic collections (List<T>, Dictionary<K,V>) — zero boxing, type-safe, and faster.

## 🎯 Cheat Sheet
- **Boxing:** value type → object, heap allocation
- **Unboxing:** object → value type, type check + copy
- **Avoid:** ArrayList, non-generic interfaces, string.Format with value types
- **Keywords:** heap allocation, GC pressure, generics, box IL opcode

## 🏢 Industry Experience Answer
"Boxing bit us in a high-throughput event-processing pipeline that used older non-generic collection types from legacy code. Profiling showed millions of boxing allocations per second driving GC pauses. Migrating to generic collections and Span-based APIs cut GC pressure by 70%. The lesson: profile before assuming, but know where boxing hides."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is boxing and unboxing?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q2 ─────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A **delegate** is a type-safe function pointer — it holds a reference to a method (or methods) with a specific signature and can be invoked like a method. Delegates are the foundation of events, callbacks, LINQ, and lambda expressions in C#. The built-in `Action<T>`, `Func<T,TResult>`, and `Predicate<T>` cover most use cases without defining custom delegate types.

## 📖 Detailed Explanation
**What it is:** A reference type that encapsulates a method reference. Declared with `delegate ReturnType Name(params);`.
**Why it exists:** Enables first-class functions — pass methods as arguments, store them in variables, return them from methods.
**How it works:** The delegate object holds: the method reference + (for instance methods) the target object.
**Built-in delegates:** `Action` (void, 0-16 params), `Func<T, TResult>` (returns TResult), `Predicate<T>` (returns bool).

## 💻 Code Example
```csharp
// Custom delegate
delegate int MathOp(int a, int b);

MathOp add = (a, b) => a + b;
MathOp mul = (a, b) => a * b;
Console.WriteLine(add(3, 4));   // 7
Console.WriteLine(mul(3, 4));   // 12

// Built-in: Func and Action
Func<int, int, int> add2 = (a, b) => a + b;
Action<string> log = msg => Console.WriteLine("LOG: " + msg);
Predicate<int> isEven = n => n % 2 == 0;

// Pass as argument
void Transform(int[] arr, Func<int, int> fn) =>
    Array.ForEach(arr, x => Console.WriteLine(fn(x)));
Transform(new[] { 1, 2, 3 }, x => x * x);   // 1, 4, 9
```

## ❓ Follow-Up Questions
- **Q: What is Func<T, TResult>?** A: A built-in delegate for methods that take T and return TResult.
- **Q: What is Action<T>?** A: A built-in delegate for void methods taking T.
- **Q: What is the relationship between delegates and LINQ?** A: LINQ operators take Func/Predicate delegates — Where, Select, OrderBy all accept lambda-based delegates.

## ⚠️ Common Mistakes
❌ Defining a custom delegate when Action/Func already matches.
✅ Use Action/Func for standard patterns; define a named delegate only when the parameter names convey important domain meaning.

## 🎯 Cheat Sheet
- **Definition:** type-safe function pointer, holds method reference
- **Built-in:** Action (void), Func<T,TResult> (returns value), Predicate<T> (returns bool)
- **Keywords:** callback, first-class function, multicast, event, lambda

## 🏢 Industry Experience Answer
"Delegates power every callback and pipeline in our codebase — Func/Action for strategy injection, Predicate for filtering. I rarely define custom delegates anymore; Func and Action cover 99% of cases. The main time I define a named delegate is when the parameter semantics are important enough to warrant a named type in the domain."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are delegates?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q3 ─────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A **multicast delegate** holds a reference to **multiple methods** in an invocation list. Using `+=` adds a method; `-=` removes one. When you invoke the delegate, it calls each method in the order they were added. Events in C# are built on multicast delegates.

## 📖 Detailed Explanation
**How it works:** every delegate is technically multicast — `Delegate.Combine` builds the invocation list. The last return value is what the delegate call returns (previous ones are discarded), so multicast delegates are most useful for void methods.
**Thread safety:** the delegate reference is immutable (adding/removing creates a new delegate). Thread-safe reads but non-atomic += on the same field — use `Interlocked` for concurrent subscribe/unsubscribe.
**Memory leaks:** if a long-lived object subscribes to an event on a short-lived one, the subscriber stays alive. Use weak event patterns or -= unsubscription.

## 💻 Code Example
```csharp
Action<string> log = msg => Console.WriteLine("Console: " + msg);
log += msg => Console.WriteLine("File: " + msg);
log += msg => Console.WriteLine("DB: " + msg);

log("Order placed");
// Console: Order placed
// File: Order placed
// DB: Order placed

log -= msg => Console.WriteLine("File: " + msg); // won't remove — lambdas aren't equal!
// Correct removal: hold the reference
Action<string> fileLog = msg => Console.WriteLine("File: " + msg);
log += fileLog;
log -= fileLog;   // works
```

## ❓ Follow-Up Questions
- **Q: What is returned when a multicast delegate has a return type?** A: Only the last invoked method's return value.
- **Q: How do you get all return values?** A: Use Delegate.GetInvocationList() and invoke each separately.
- **Q: How are events related to multicast delegates?** A: An event is a restricted multicast delegate — external code can only += or -=, not invoke directly.

## ⚠️ Common Mistakes
❌ Removing a lambda from a multicast delegate by value.
✅ Lambda instances aren't equal by reference — store the lambda in a variable before adding, then use that variable to remove.

## 🎯 Cheat Sheet
- **Definition:** delegate with multiple methods in invocation list
- **+=:** add method, -=: remove method
- **Return:** only last method's return value
- **Keywords:** invocation list, events, Delegate.Combine, memory leak

## 🏢 Industry Experience Answer
"Events are the most common multicast delegate in our production code — UI events, domain event dispatchers. The most important lesson: always unsubscribe (via -=) when a subscriber is disposed, otherwise you hold a GC root and leak the object. We audit all event subscriptions to ensure lifetime matches."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are multicast delegates?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q4 ─────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
An **event** is a member of a class that wraps a multicast delegate and restricts access so that external code can only **subscribe (`+=`) or unsubscribe (`-=`)** — it cannot invoke the event or replace the delegate directly. This encapsulates the publisher's control over when the event fires.

## 📖 Detailed Explanation
**Why events over plain delegates:** if you expose a plain public delegate, any caller can invoke it or overwrite all subscribers with `=`. Events restrict to `+=`/`-=` for external callers — only the declaring class can raise (invoke) the event.
**EventHandler pattern:** use `EventHandler<TEventArgs>` as the standard signature: `void Handler(object sender, TEventArgs e)`.
**Custom EventArgs:** derive from `EventArgs` to carry domain data.
**Raising safely:** check for null before invoking: `MyEvent?.Invoke(this, args)`.

## 💻 Code Example
```csharp
public class OrderService
{
    public event EventHandler<OrderEventArgs> OrderPlaced;

    public void PlaceOrder(Order order)
    {
        // business logic
        OrderPlaced?.Invoke(this, new OrderEventArgs { Order = order });
    }
}

public class OrderEventArgs : EventArgs
{
    public Order Order { get; init; }
}

// Subscriber
var svc = new OrderService();
svc.OrderPlaced += (sender, e) =>
    Console.WriteLine("Order placed: " + e.Order.Id);
```

## ❓ Follow-Up Questions
- **Q: Can external code invoke an event?** A: No — only the declaring class can invoke it.
- **Q: What is EventHandler<T>?** A: The standard built-in delegate for events: void(object sender, T args).
- **Q: How do you raise an event safely?** A: Use ?.Invoke() — null-conditional handles zero subscribers.

## ⚠️ Common Mistakes
❌ Raising an event without a null check: `MyEvent(this, args)` throws if no subscribers.
✅ Always use `MyEvent?.Invoke(this, args)` — safe with zero subscribers.

## 🎯 Cheat Sheet
- **Definition:** restricted multicast delegate — external can only +=/-=
- **Standard pattern:** EventHandler<TEventArgs>
- **Raise:** MyEvent?.Invoke(this, args)
- **Keywords:** publisher, subscriber, EventArgs, encapsulation, null check

## 🏢 Industry Experience Answer
"We use events for domain event dispatching — an OrderService raises OrderPlaced, and listeners like EmailNotifier and InventoryUpdater subscribe. The key discipline: each subscriber is responsible for unsubscribing when disposed; otherwise you get memory leaks in long-running services."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are events?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q5 ─────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A **delegate** is a type-safe function pointer that can be invoked by anyone who holds it. An **event** wraps a delegate and restricts it so external code can only subscribe/unsubscribe — only the publishing class can raise it. Events enforce the publisher-subscriber encapsulation; raw delegates don't.

## 📖 Detailed Explanation
| Aspect | Delegate | Event |
|---|---|---|
| Invocation | Anyone holding it | Only the declaring class |
| Assignment (=) | Anyone | Only the declaring class |
| Subscribe (+=) | Anyone | Anyone |
| Encapsulation | None | Publisher controls raising |
| Common use | Callbacks, LINQ, strategy | Notifications, UI, domain events |

**When to use delegate:** passing a callback as a method parameter; strategy pattern injection.
**When to use event:** notifying multiple subscribers of something that happened — the publisher controls the timing.

## 💻 Code Example
```csharp
// Problem with public delegate — anyone can reset or invoke
public class BadButton { public Action Clicked; }
var btn = new BadButton();
btn.Clicked = () => Console.WriteLine("New subscriber only"); // wipes others!
btn.Clicked.Invoke();   // external code fires it

// Correct: event prevents this
public class GoodButton { public event Action Clicked; public void Click() => Clicked?.Invoke(); }
var btn2 = new GoodButton();
btn2.Clicked += () => Console.WriteLine("A");
btn2.Clicked += () => Console.WriteLine("B");
// btn2.Clicked = ...; // compile error
// btn2.Clicked();      // compile error outside class
btn2.Click();   // A, B — controlled by publisher
```

## ❓ Follow-Up Questions
- **Q: Is event always needed over a delegate?** A: Use event when you want to protect the publisher from external invocation/replacement. Use a plain delegate/Func for callbacks passed as method parameters.
- **Q: Can events be virtual/abstract?** A: Yes — you can override event add/remove accessors.

## ⚠️ Common Mistakes
❌ Exposing a public delegate field instead of an event for notification scenarios.
✅ Subscriber A can overwrite (= null) the delegate, wiping subscriber B. Use event to prevent this.

## 🎯 Cheat Sheet
- **Delegate:** function pointer, anyone can invoke or replace
- **Event:** restricted delegate, only publisher invokes, external only +=/-=
- **Rule:** delegate for callbacks; event for notifications

## 🏢 Industry Experience Answer
"I use the delegate vs event distinction as a design signal in code review. If a public field is a raw delegate in a notification context, I flag it — a malicious or careless subscriber can clear all others. Event enforces the pattern correctly and the compiler enforces the restriction."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between delegate and event?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q6 ─────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A **lambda expression** is an anonymous (inline) function using the `=>` syntax — e.g., `x => x * 2` or `(a, b) => a + b`. Lambdas are compiled to either a delegate instance or an expression tree depending on context. They're the foundation of LINQ, functional programming patterns, and concise callback syntax in C#.

## 📖 Detailed Explanation
**Expression lambda:** `(params) => expression` — single expression, no braces.
**Statement lambda:** `(params) => { statements; }` — multiple statements, needs braces.
**Capture (closures):** lambdas can capture outer variables (fields, locals, method params). The captured variable is lifted to a closure object — be careful with loop variables.
**Expression trees:** when a lambda is assigned to `Expression<Func<T>>` the compiler produces an AST, not executable code (used by EF Core to translate to SQL).

## 💻 Code Example
```csharp
// Expression lambda
Func<int, int> square = x => x * x;
Console.WriteLine(square(5));   // 25

// Statement lambda
Action<string> log = msg => { Console.WriteLine("[LOG] " + msg); };

// LINQ with lambda
var evens = Enumerable.Range(1, 10)
    .Where(n => n % 2 == 0)
    .Select(n => n * n)
    .ToList();   // [4, 16, 36, 64, 100]

// Closure — captures outer variable
int multiplier = 3;
Func<int, int> tripler = x => x * multiplier;  // captures multiplier
multiplier = 10;
Console.WriteLine(tripler(5));  // 50 — uses current value of multiplier!
```

## ❓ Follow-Up Questions
- **Q: What is a closure?** A: A lambda that captures (references) outer variables from its declaring scope.
- **Q: Lambda vs anonymous method?** A: Lambda is more concise; anonymous methods (delegate keyword) are the older, verbose form.
- **Q: When is a lambda compiled to an expression tree?** A: When assigned to Expression<Func<...>> — used by EF Core, LINQ-to-SQL.

## ⚠️ Common Mistakes
❌ Capturing a loop variable in a lambda and expecting it to hold the loop value at capture time.
✅ The lambda captures the variable reference, not its value at that moment. In a for loop, all lambdas share the same variable and see its final value. Fix: capture a local copy inside the loop.

## 🎯 Cheat Sheet
- **Syntax:** x => expr, (a, b) => expr, (a, b) => { stmts; }
- **Compile to:** delegate (IL) or expression tree (Expression<Func<T>>)
- **Closure:** captures outer variable by reference
- **Keywords:** anonymous function, closure, LINQ, expression tree

## 🏢 Industry Experience Answer
"Lambdas are everywhere in our codebase — LINQ queries, middleware registration, DI setup. The one gotcha I always flag in code review is the closure-over-loop-variable trap: capturing the iteration variable means all lambdas see the final loop value. Capture a local copy inside the loop body to avoid it."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are lambda expressions?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q7 ─────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Anonymous methods (C# 2.0) are inline, unnamed methods declared with the `delegate` keyword — e.g., `delegate(int x) { return x * 2; }`. They're largely superseded by lambda expressions (C# 3.0+), which are more concise. You'll encounter anonymous methods in legacy codebases or when you need a body with no parameters and want to discard the signature entirely.

## 📖 Detailed Explanation
**Syntax:** `delegate(params) { body }` or `delegate { body }` (ignores all parameters — useful to subscribe to events and discard args).
**Compared to lambdas:** lambdas are shorter and support expression form; anonymous methods cannot be used as expression trees.
**Where they still appear:** event subscriptions where you want to explicitly ignore event args using parameterless `delegate { }`.
**Capture:** same closure semantics as lambdas.

## 💻 Code Example
```csharp
// Anonymous method (legacy style)
Func<int, int> doubler = delegate(int x) { return x * 2; };
Console.WriteLine(doubler(5));  // 10

// Equivalent lambda (prefer this)
Func<int, int> doublerLambda = x => x * 2;

// Unique use: discard all event args cleanly
button.Click += delegate { Console.WriteLine("Clicked!"); };
// Ignores sender and EventArgs — no need to name them
```

## ❓ Follow-Up Questions
- **Q: Are anonymous methods and lambdas the same?** A: Both produce delegate instances but lambdas are more concise and support expression trees; anonymous methods cannot.
- **Q: When would you choose anonymous method over lambda?** A: Rare — the parameterless `delegate { }` syntax for ignoring event args is the main niche case.
- **Q: Can anonymous methods be expression trees?** A: No — only lambdas assigned to Expression<Func<T>>.

## ⚠️ Common Mistakes
❌ Writing new anonymous methods with `delegate(...)` in modern code.
✅ Use lambdas — they're shorter, cleaner, and support both delegate and expression-tree contexts.

## 🎯 Cheat Sheet
- **Syntax:** delegate(params) { body }
- **Niche use:** delegate { } to ignore all event args
- **Superseded by:** lambda expressions in almost all cases
- **Keywords:** inline method, closure, legacy, C# 2.0

## 🏢 Industry Experience Answer
"I see anonymous methods only in code older than about 2008. In code reviews I recommend replacing them with lambdas for consistency and readability. The one case I still accept them: a parameterless delegate { } on an event subscription where you genuinely want to document that you're ignoring all arguments — it's explicit intent."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are anonymous methods?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q8 ─────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Generics let you write **type-safe, reusable code parameterized over types** — `List<T>`, `Repository<T>`, `Func<T, TResult>`. The type parameter is substituted at compile time (or JIT for value types), giving you full type safety without boxing or casting. Generics are the most important C# feature for writing reusable, performant code.

## 📖 Detailed Explanation
**What it is:** A blueprint parameterized by one or more type parameters (T, TKey, TValue...).
**Why it exists:** Pre-generics, collections used `object` causing boxing and unsafe casts. Generics provide type-safety and zero boxing for value types.
**How it works:** The compiler generates IL with placeholders. The JIT creates specialized native code per value type (int, double each get their own), shares one for all reference types.
**Constraints:** `where T : class`, `where T : struct`, `where T : new()`, `where T : IInterface`, `where T : BaseClass`. Constraints enable calling methods on T.

## 💻 Code Example
```csharp
// Generic repository
public interface IRepository<T> where T : class
{
    Task<T?> GetByIdAsync(int id);
    Task AddAsync(T entity);
}

// Generic method with constraint
public static T Max<T>(T a, T b) where T : IComparable<T>
    => a.CompareTo(b) >= 0 ? a : b;

Console.WriteLine(Max(3, 7));          // 7
Console.WriteLine(Max("apple", "fig")); // fig

// Generic class
public class Pair<TFirst, TSecond>
{
    public TFirst First { get; init; }
    public TSecond Second { get; init; }
}
var p = new Pair<string, int> { First = "Age", Second = 28 };
```

## ❓ Follow-Up Questions
- **Q: What are generic constraints?** A: Restrictions on T (where T : class/struct/new()/Interface) — enable calling specific members on T.
- **Q: What is a generic method vs a generic class?** A: A generic method has its own type parameters; a generic class's type parameter applies to all instance members.
- **Q: Does generic collection box value types?** A: No — List<int> stores ints directly; no boxing.

## ⚠️ Common Mistakes
❌ Using object instead of generics for "flexibility."
✅ object loses type safety and boxes value types. Use generics — same flexibility, compile-time safety, zero boxing.

## 🎯 Cheat Sheet
- **Syntax:** class Foo<T>, method Foo<T>(), where T : constraint
- **Benefits:** type safety, no boxing, code reuse
- **Constraints:** class, struct, new(), IInterface, BaseClass
- **Keywords:** type parameter, constraint, reusable, JIT specialization

## 🏢 Industry Experience Answer
"Generics are the most-used feature in our infrastructure code. Every repository, handler, and service is generic — IRepository<T>, ICommandHandler<TCommand>, IValidator<T>. Constraints let us call domain methods on T safely. Without generics our codebase would have hundreds of duplicate type-specific implementations or an explosion of unsafe object casts."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are generics?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q9 ─────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**Covariance** allows a generic type with a more derived type parameter to be used where a less derived (base) type is expected (`IEnumerable<Dog>` → `IEnumerable<Animal>`). **Contravariance** is the reverse — a base type can be used where a derived type is expected (`Action<Animal>` → `Action<Dog>`). These apply to generic interfaces and delegates with `out`/`in` keywords.

## 📖 Detailed Explanation
**Covariance (`out T`):** T only appears in output positions (return type). Makes the generic type "extend" naturally with the hierarchy. Example: `IEnumerable<out T>` — you can read Animals from a Dog list.
**Contravariance (`in T`):** T only appears in input positions (parameters). Reverses the relationship. Example: `IComparer<in T>` — an Animal comparer can compare Dogs.
**Why the restriction:** if a covariant T appeared in an input position, you could write a Cat into a Dog-typed collection — unsound. The compiler enforces the restrictions.
**Only works for:** reference types in interface/delegate type parameters.

## 💻 Code Example
```csharp
// Covariance: IEnumerable<out T>
IEnumerable<string> strings = new List<string> { "a", "b" };
IEnumerable<object> objects = strings;   // works — covariant

// Contravariance: Action<in T>
Action<object> logObject = obj => Console.WriteLine(obj);
Action<string> logString = logObject;    // works — contravariant

// Custom covariant interface
public interface IProducer<out T> { T Produce(); }
public class DogProducer : IProducer<Dog> { public Dog Produce() => new Dog(); }

IProducer<Animal> animalProducer = new DogProducer();   // covariant
```

## ❓ Follow-Up Questions
- **Q: Which keyword for covariance?** A: out (output/producer position).
- **Q: Which for contravariance?** A: in (input/consumer position).
- **Q: Does this work for classes?** A: No — only generic interfaces and delegates.

## ⚠️ Common Mistakes
❌ Expecting List<Dog> to be assignable to List<Animal>.
✅ List<T> is invariant — neither covariant nor contravariant. Only IEnumerable<T> (out) is covariant. Use IEnumerable<Animal> at the receiving end.

## 🎯 Cheat Sheet
- **Covariance (out):** derived → base assignment; output position only
- **Contravariance (in):** base → derived assignment; input position only
- **Invariant:** no variance (List<T>, most classes)
- **Keywords:** out, in, interface variance, delegate variance

## 🏢 Industry Experience Answer
"Variance trips up most developers until they see the pattern: out = producer (you get T out), in = consumer (you put T in). The classic footgun is trying to assign List<Dog> to List<Animal> — it's invariant and won't compile. Switch the type to IEnumerable<Animal> and covariance handles the rest."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is covariance and contravariance?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q10 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
An **extension method** adds new methods to an existing type **without modifying its source code or subclassing it**. Defined as a static method in a static class with `this T` as the first parameter, it appears as an instance method on T via IntelliSense and call syntax. LINQ is entirely built on extension methods on `IEnumerable<T>`.

## 📖 Detailed Explanation
**Why it exists:** Add utility methods to sealed types (string, int), third-party types, or interfaces you don't own.
**How it works:** The compiler rewrites the call at compile time — `myList.OrderBy(x => x)` becomes `Enumerable.OrderBy(myList, x => x)`. Pure syntactic sugar.
**Rules:** must be in a static, non-nested class; `this` param must be first; brought in by `using` the namespace.
**Interface extension methods:** the most powerful use — add helper methods to any interface without changing the interface definition (e.g., all IEnumerable<T> get Where, Select, etc.).

## 💻 Code Example
```csharp
public static class StringExtensions
{
    public static bool IsNullOrEmpty(this string value) =>
        string.IsNullOrEmpty(value);

    public static string Truncate(this string value, int maxLength) =>
        value.Length <= maxLength ? value : value[..maxLength] + "...";
}

// Usage — looks like instance methods
string name = "Sidhant Kumar";
Console.WriteLine(name.IsNullOrEmpty());          // false
Console.WriteLine(name.Truncate(7));               // Sidhant...

// Extension on interface
public static class CollectionExtensions
{
    public static bool IsNullOrEmpty<T>(this IEnumerable<T> source) =>
        source == null || !source.Any();
}
```

## ❓ Follow-Up Questions
- **Q: Can extension methods access private members?** A: No — they're syntactic sugar on top of static calls; they see only public API.
- **Q: Do they override instance methods?** A: No — instance methods always win; extension methods only apply when no matching instance method exists.
- **Q: How does LINQ use extension methods?** A: System.Linq.Enumerable defines Where, Select, etc. as extension methods on IEnumerable<T>.

## ⚠️ Common Mistakes
❌ Putting extension methods in a non-static class.
✅ The containing class must be static, non-generic, and non-nested — compiler enforces this.

## 🎯 Cheat Sheet
- **Syntax:** public static ReturnType Method(this T target, ...)
- **Rule:** static method in static class, this param first
- **Use:** add methods to types you don't own, build fluent APIs
- **Keywords:** syntactic sugar, LINQ, fluent API, IEnumerable

## 🏢 Industry Experience Answer
"Extension methods are my primary tool for building fluent, readable APIs without touching existing types. We have a rich set of extension methods on IQueryable, string, DateTime, and our domain objects — things like query.ActiveOnly(), date.IsWeekend(). They keep business rules colocated and discoverable via IntelliSense."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is an extension method?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q11 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**Partial classes** split a single class definition across multiple files, all compiled into one class. **Partial methods** declare a method signature in one partial part; the implementation (optional) goes in another — if no implementation exists, both the declaration and all calls are removed by the compiler. Used extensively in code generators (EF Core, WinForms, Blazor).

## 📖 Detailed Explanation
**Partial class:** `partial class Order { }` in multiple files → one class at compile time. All parts must be in the same assembly and namespace.
**Why it exists:** separate generated code from hand-written code so regenerating doesn't overwrite your customizations.
**Partial method (classic):** private, void, no attributes, no out params. If no implementation, calls are elided (zero overhead).
**Extended partial methods (C# 9+):** can be public, have a return type, params, attributes — but must have an implementation if non-private.

## 💻 Code Example
```csharp
// Generated file — Order.Generated.cs
public partial class Order
{
    public int Id { get; set; }
    public decimal Total { get; set; }
    partial void OnTotalChanged(decimal newTotal);  // partial method hook
}

// Hand-written file — Order.cs
public partial class Order
{
    partial void OnTotalChanged(decimal newTotal)   // implementation
    {
        Console.WriteLine("Total changed to " + newTotal.ToString("C"));
    }

    public void UpdateTotal(decimal total)
    {
        Total = total;
        OnTotalChanged(total);   // call — elided if no impl
    }
}
```

## ❓ Follow-Up Questions
- **Q: Can partial classes span assemblies?** A: No — all parts must be in the same assembly.
- **Q: What happens if a partial method has no implementation?** A: The compiler removes the declaration and all call sites — zero IL generated.
- **Q: Where are partial classes commonly used?** A: EF Core entity scaffolding, WinForms designer files, source generators.

## ⚠️ Common Mistakes
❌ Using partial classes just to break up a large class.
✅ That's a smell — the class itself is too large. Use partial only for code-gen separation or where a tool requires it.

## 🎯 Cheat Sheet
- **Partial class:** one logical class, many files, same assembly
- **Partial method:** hook in generated code, optional implementation, elided if absent
- **Use cases:** source generators, EF Core scaffolding, WinForms, Blazor
- **Keywords:** partial, code generation, elision, source generator

## 🏢 Industry Experience Answer
"Partial classes saved us when we moved to EF Core scaffolding. Generated entity files update on schema change; our hand-written partial files add domain logic and navigation helpers that survive regeneration. Without partial, every schema change would overwrite our customizations."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are partial classes and methods?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q12 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A **property** is a member that provides a controlled get/set interface to a field — it looks like a field from the outside but runs code (validation, notification) when accessed or set. An **indexer** lets instances be accessed with array-like syntax (`obj[key]`) by defining `this[T key]`. Both are syntactic sugar over getter/setter methods.

## 📖 Detailed Explanation
**Auto-property:** `public string Name { get; set; }` — compiler generates a backing field automatically.
**Expression-bodied:** `public string Name => _name;` — read-only shorthand.
**init accessor (C# 9):** `public string Name { get; init; }` — settable only during object initialization; then immutable.
**Indexers:** `public T this[int index] { get { ... } set { ... } }` — enables [] syntax; can be overloaded by parameter type.

## 💻 Code Example
```csharp
public class Temperature
{
    private double _celsius;
    public double Celsius
    {
        get => _celsius;
        set
        {
            if (value < -273.15) throw new ArgumentOutOfRangeException();
            _celsius = value;
        }
    }
    public double Fahrenheit => _celsius * 9 / 5 + 32;  // computed, read-only
}

// Indexer
public class WordCount
{
    private readonly Dictionary<string, int> _counts = new();
    public int this[string word]
    {
        get => _counts.TryGetValue(word, out int c) ? c : 0;
        set => _counts[word] = value;
    }
}
var wc = new WordCount();
wc["hello"] = 3;
Console.WriteLine(wc["hello"]);   // 3
```

## ❓ Follow-Up Questions
- **Q: Auto-property vs field — what's the difference?** A: Properties can be overridden, data-bound, and have asymmetric access (get public, set private); fields cannot.
- **Q: What is init?** A: A setter that only works in object initializers — gives you immutable-after-construction semantics.
- **Q: Can you have an indexer with multiple parameters?** A: Yes — `this[int row, int col]` is valid.

## ⚠️ Common Mistakes
❌ Performing heavy operations (DB calls, I/O) in property getters.
✅ Properties should look like field accesses — fast and side-effect-free. Move slow operations to explicit async methods.

## 🎯 Cheat Sheet
- **Property:** get/set, auto-prop, expression-bodied, init, computed
- **Indexer:** this[T key] get/set — array-like access on instances
- **Keywords:** backing field, auto-property, init, computed property, indexer overload

## 🏢 Industry Experience Answer
"Properties with private setters enforce invariants at the boundary — callers read freely, but writing goes through validated code. I use init-only properties on all DTOs and value objects for immutability. Indexers are great for domain-specific access patterns, like our EntityCache that exposes cache[entityId]."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are indexers and properties?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q13 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
`async` marks a method as asynchronous; `await` suspends execution until the awaited Task completes, **without blocking the thread**. This lets a single thread handle many concurrent I/O operations. The compiler rewrites an async method into a state machine. Use async/await for all I/O — DB, HTTP, file — to keep threads free for other work.

## 📖 Detailed Explanation
**async:** method returns Task, Task<T>, or ValueTask<T> (or void for event handlers — avoid otherwise). The keyword itself does nothing at runtime; it's a compiler hint.
**await:** "pause here, release the thread, resume when the Task finishes." Not a thread block — it returns control to the caller.
**State machine:** the compiler generates a struct state machine that resumes execution at the right point after each await.
**Thread context:** in ASP.NET Core there's no SynchronizationContext; continuations run on any thread pool thread. In UI (WPF/WinForms) the context returns to the UI thread by default.

## 💻 Code Example
```csharp
public async Task<User> GetUserAsync(int id, CancellationToken ct = default)
{
    // Thread is free while DB query runs
    var user = await _dbContext.Users.FindAsync(new object[] { id }, ct);
    if (user is null) throw new NotFoundException("User " + id + " not found");

    var profile = await _httpClient.GetFromJsonAsync<Profile>("api/profiles/" + id, ct);
    user.Profile = profile;
    return user;
}
```

## ❓ Follow-Up Questions
- **Q: Does async create a new thread?** A: No — it releases the calling thread during I/O and resumes on an available thread pool thread.
- **Q: What does returning void from async cause?** A: Exceptions can't be observed — use Task instead; void only for event handlers.
- **Q: What is a deadlock with async?** A: .Result or .Wait() on an async method in a context with a SynchronizationContext blocks the thread waiting for itself.

## ⚠️ Common Mistakes
❌ async void — exceptions are swallowed or crash the process.
✅ Always return Task or Task<T>; async void only for event handlers.
❌ Calling .Result or .Wait() on an async method — deadlocks in UI/legacy ASP.NET.
✅ Await all the way up (async all the way).

## 🎯 Cheat Sheet
- **async:** compiler hint, returns Task/Task<T>
- **await:** non-blocking suspension, thread released during I/O
- **State machine:** compiler-generated, resumes at await points
- **Keywords:** Task, ValueTask, async void danger, async all the way, deadlock

## 🏢 Industry Experience Answer
"Async/await is mandatory for all I/O in our APIs. One sync DB call on a high-traffic endpoint exhausts the thread pool under load — async is what makes .NET handle thousands of concurrent requests with tens of threads. The discipline is async all the way: never .Wait() or .Result; that's the deadlock waiting to happen."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are async and await keywords?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q14 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A **Task** represents an ongoing operation — it doesn't imply a thread; it's a promise of future completion. A **Thread** is an OS-level unit of execution with its own stack. Tasks are lightweight (managed by the thread pool); threads are expensive (~1 MB stack). Use Tasks for async I/O and concurrency; use raw threads only for CPU-bound long-running work that needs OS-level control.

## 📖 Detailed Explanation
**Thread:** OS thread, ~1 MB stack, context-switch cost, limited by CPU cores for true parallelism.
**Task:** abstraction over the thread pool; can represent I/O completion (no thread during wait), CPU work queued to thread pool, or continuation chaining. Returned by async methods.
**Thread pool:** manages a pool of threads reused across Tasks — avoids per-task thread creation cost.
**Task.Run:** queues CPU-bound work to the thread pool. Not for I/O (waste a thread waiting).

## 💻 Code Example
```csharp
// Task for async I/O — no thread during the wait
async Task<string> FetchAsync(string url)
{
    var result = await _httpClient.GetStringAsync(url);
    return result;
}

// Task.Run for CPU-bound work
var primes = await Task.Run(() => ComputePrimes(1_000_000));

// Thread for long-running, dedicated work
var thread = new Thread(() =>
{
    while (true) { PollHardware(); Thread.Sleep(100); }
}) { IsBackground = true };
thread.Start();
```

## ❓ Follow-Up Questions
- **Q: Task vs Thread — which uses more memory?** A: Thread (~1 MB stack each); Tasks share pooled threads — far cheaper.
- **Q: Does a Task always have a thread?** A: No — an awaiting async Task holds no thread during I/O.
- **Q: When to use Thread directly?** A: Long-running CPU work, interop that needs a dedicated OS thread, STA threading for COM.

## ⚠️ Common Mistakes
❌ Task.Run wrapping async I/O operations.
✅ Task.Run is for CPU-bound work. Wrapping async I/O in Task.Run wastes a thread pool thread just waiting.

## 🎯 Cheat Sheet
- **Thread:** OS-level, ~1MB stack, expensive, true parallelism
- **Task:** abstraction, thread pool, lightweight, I/O or CPU, chainable
- **Task.Run:** CPU-bound work → thread pool
- **Keywords:** thread pool, async I/O, no thread during wait, concurrency

## 🏢 Industry Experience Answer
"The key insight I share with junior devs: a Task waiting on HTTP/DB holds zero threads — that's the whole scalability win of async. Task.Run is only for CPU work that would otherwise block the caller. Creating raw Threads in modern ASP.NET is almost always wrong — use Task, BackgroundService, or Channel instead."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are tasks and how do they differ from threads?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q15 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**Synchronous** code executes line by line — each call blocks until it completes; the thread is occupied. **Asynchronous** code initiates an operation and releases the thread to do other work; a callback/continuation runs when the operation finishes. Async is essential for I/O-bound work to maximise thread reuse and throughput.

## 📖 Detailed Explanation
**Synchronous:** simple, predictable, but one blocked thread per in-flight operation. Fine for CPU-bound or low-concurrency apps.
**Asynchronous:** non-blocking — thread returns to the pool during I/O. Scales to thousands of concurrent operations with a small thread pool.
**Async ≠ parallel:** async is about freeing threads during waits, not about running on multiple cores simultaneously. CPU-bound parallelism uses Task.Run/PLINQ/Parallel.
**Thread pool:** ASP.NET Core handles each request on a thread pool thread. With sync I/O, all threads block waiting. With async, threads handle other requests while I/O completes.

## 💻 Code Example
```csharp
// Synchronous — blocks thread during DB query
public User GetUserSync(int id)
{
    Thread.Sleep(500);   // simulates DB — thread blocked
    return new User { Id = id };
}

// Asynchronous — releases thread during DB query
public async Task<User> GetUserAsync(int id)
{
    await Task.Delay(500);   // simulates DB — thread free for other work
    return new User { Id = id };
}
```

## ❓ Follow-Up Questions
- **Q: When is synchronous code OK?** A: CPU-bound work, scripts, startup code, or when concurrency isn't needed.
- **Q: Async for CPU-bound?** A: Use Task.Run to offload to thread pool; await the Task.
- **Q: What is async vs parallel?** A: Async = free thread during waits. Parallel = multiple threads running simultaneously.

## ⚠️ Common Mistakes
❌ Making everything async including pure CPU/math methods.
✅ Async adds overhead (state machine allocation). CPU-bound methods that never await aren't async — they just return a completed Task.

## 🎯 Cheat Sheet
- **Sync:** blocking, sequential, simple, one thread per op
- **Async:** non-blocking, thread released during I/O, scalable
- **Async vs parallel:** free thread during wait vs multiple cores
- **Keywords:** thread pool, scalability, async I/O, non-blocking

## 🏢 Industry Experience Answer
"The difference shows up clearly under load testing. A sync API with 100 DB calls can exhaust a thread pool of 100 threads — all blocked waiting. The same async API handles 10,000 concurrent requests with 100 threads because those threads are free during the DB waits. It's the single biggest scalability lever in .NET."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between synchronous and asynchronous programming?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q16 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
`ConfigureAwait(false)` tells the `await` not to capture the current `SynchronizationContext` and resume on it — instead the continuation runs on any available thread pool thread. Use it in **library code** to avoid deadlocks with callers that have a synchronization context (UI, classic ASP.NET). In **ASP.NET Core** it's unnecessary (no sync context), but harmless.

## 📖 Detailed Explanation
**SynchronizationContext:** some environments (WPF, WinForms, classic ASP.NET) have a context that routes continuations back to a specific thread (UI thread or request context). Capturing this context and then blocking (.Wait()) causes deadlock.
**ConfigureAwait(false):** skip the context capture; continuation runs on the thread pool thread that completes the I/O. Faster (no marshal) and avoids deadlock when mixed with blocking callers.
**ASP.NET Core:** has no SynchronizationContext — ConfigureAwait(false) is a no-op but is still used in library code for portability.
**Rule:** in application code (ASP.NET Core, console) — no need. In NuGet library code — always use ConfigureAwait(false).

## 💻 Code Example
```csharp
// Library code — always ConfigureAwait(false)
public async Task<string> FetchDataAsync(string url)
{
    var response = await _httpClient.GetAsync(url).ConfigureAwait(false);
    var content  = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
    return content;
}

// Application code (ASP.NET Core) — can omit, no sync context
public async Task<IActionResult> GetAsync(int id)
{
    var data = await _service.GetAsync(id);   // no ConfigureAwait needed
    return Ok(data);
}
```

## ❓ Follow-Up Questions
- **Q: What is a SynchronizationContext?** A: An abstraction that controls where async continuations resume (UI thread, request context, etc.).
- **Q: Does ASP.NET Core need ConfigureAwait(false)?** A: No — there's no sync context. But add it to reusable library code.
- **Q: How does it prevent deadlock?** A: The continuation doesn't wait for the (blocked) sync context thread to free up — it runs on the pool instead.

## ⚠️ Common Mistakes
❌ Using .Result or .Wait() in a sync context + awaiting without ConfigureAwait(false) in library code.
✅ Always async all the way in application code. In library code, use ConfigureAwait(false) so callers can mix sync/async safely.

## 🎯 Cheat Sheet
- **Use:** library code to avoid sync context capture
- **Effect:** continuation on thread pool, not original context
- **ASP.NET Core:** no sync context — not required but harmless
- **Keywords:** SynchronizationContext, deadlock prevention, library code, thread pool

## 🏢 Industry Experience Answer
"All our shared NuGet packages use ConfigureAwait(false) on every await — it's a rule enforced by a Roslyn analyzer. Without it, any WinForms or WPF consumer who calls our library synchronously (.Result) deadlocks. In our ASP.NET Core services it's not needed, but consistency wins for shared code."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is ConfigureAwait(false) and when should you use it?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q17 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A `CancellationToken` lets you **signal cancellation** from a caller to an async operation in a cooperative, structured way. The caller creates a `CancellationTokenSource`, passes its `Token` to the operation, and can call `Cancel()`. The operation periodically checks `ct.IsCancellationRequested` or calls `ct.ThrowIfCancellationRequested()` to stop gracefully.

## 📖 Detailed Explanation
**CancellationTokenSource (CTS):** creates and controls the token. Caller owns it.
**CancellationToken:** read-only struct passed to operations; they observe it.
**ThrowIfCancellationRequested():** throws OperationCanceledException if cancelled — propagates up naturally.
**Register:** attach a callback to fire on cancellation (useful for cleanup).
**Linked tokens:** CancellationTokenSource.CreateLinkedTokenSource(ct1, ct2) — cancelled when either source cancels.
**ASP.NET Core:** every request has a CancellationToken on HttpContext.RequestAborted — pass it to all DB/HTTP calls.

## 💻 Code Example
```csharp
// Caller
using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(5));  // auto-cancel in 5s
try
{
    var result = await ProcessAsync(cts.Token);
}
catch (OperationCanceledException)
{
    Console.WriteLine("Operation was cancelled");
}

// Callee
async Task<string> ProcessAsync(CancellationToken ct)
{
    for (int i = 0; i < 100; i++)
    {
        ct.ThrowIfCancellationRequested();   // cooperative check
        await Task.Delay(100, ct);            // also checks token
    }
    return "done";
}
```

## ❓ Follow-Up Questions
- **Q: Who creates CancellationTokenSource?** A: The caller — the operation only reads the token.
- **Q: What exception does cancellation throw?** A: OperationCanceledException.
- **Q: How do you set a timeout?** A: new CancellationTokenSource(TimeSpan.FromSeconds(N)) or cts.CancelAfter().

## ⚠️ Common Mistakes
❌ Ignoring the CancellationToken on DB/HTTP calls.
✅ Always pass the token down — if the user disconnects or the request is aborted, resources are freed immediately instead of running to completion.

## 🎯 Cheat Sheet
- **CancellationTokenSource:** owner, calls Cancel()
- **CancellationToken:** observed by operations
- **ThrowIfCancellationRequested:** cooperative cancellation check
- **Keywords:** cooperative cancellation, OperationCanceledException, timeout, linked tokens

## 🏢 Industry Experience Answer
"We pass HttpContext.RequestAborted to every DB query and HTTP call in our controllers. When a user closes the browser mid-request, the DB query is cancelled within milliseconds — no wasted resources. After adding this discipline across the codebase we saw a 30% reduction in DB load during high churn periods."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is a CancellationToken and how do you use it?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q18 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
`Task` is a **reference type** (heap allocation per task). `ValueTask` is a **value type** (struct) that avoids heap allocation when the result is already available synchronously — common for caching, hot paths. Use `ValueTask` when a method **frequently completes synchronously**; use `Task` everywhere else (simpler, well-understood).

## 📖 Detailed Explanation
**Task:** always heap-allocated, always a state machine when async. The go-to default; well-supported by all libraries and tools.
**ValueTask:** a struct that holds either a result (sync path — zero allocation) or a Task (async path). Introduced to eliminate Task allocation overhead on methods that often return cached/synchronous results.
**When ValueTask wins:** memory-critical hot paths, methods that return from cache 90%+ of the time (e.g., TryGetValue on an in-memory cache).
**Restrictions:** ValueTask must be awaited at most once; don't store or await twice — undefined behavior.

## 💻 Code Example
```csharp
// Task — default for most cases
public async Task<User> GetUserAsync(int id)
{
    return await _db.Users.FindAsync(id);
}

// ValueTask — hot path with memory cache (often sync)
private readonly Dictionary<int, User> _cache = new();

public ValueTask<User> GetUserCachedAsync(int id)
{
    if (_cache.TryGetValue(id, out var cached))
        return ValueTask.FromResult(cached);   // zero allocation — sync path

    return new ValueTask<User>(LoadAndCacheAsync(id));   // async path
}

private async Task<User> LoadAndCacheAsync(int id)
{
    var user = await _db.Users.FindAsync(id);
    _cache[id] = user;
    return user;
}
```

## ❓ Follow-Up Questions
- **Q: Can you await ValueTask multiple times?** A: No — undefined behavior; await it once or call .AsTask() to convert.
- **Q: Should you always use ValueTask?** A: No — only when profiling shows Task allocation is a bottleneck.
- **Q: IValueTaskSource?** A: Advanced — allows pooling the async state machine itself.

## ⚠️ Common Mistakes
❌ Using ValueTask everywhere "for performance."
✅ ValueTask adds complexity and restrictions. Profile first; use Task by default. Switch to ValueTask only for proven hot-path allocation issues.

## 🎯 Cheat Sheet
- **Task:** reference type, always allocates, default choice
- **ValueTask:** struct, zero alloc on sync path, one await only
- **Use ValueTask:** frequent sync returns (cache hits), hot paths
- **Keywords:** allocation, struct, hot path, IValueTaskSource

## 🏢 Industry Experience Answer
"We switched several high-frequency cache-read methods from Task to ValueTask after profiling showed Task allocations dominating GC collections. On methods called millions of times per second, eliminating the allocation made a measurable throughput difference. But we only made the change where profiling justified it — premature optimization otherwise."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between Task and ValueTask?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q19 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
`SemaphoreSlim` is a lightweight, async-compatible counting semaphore that limits the number of concurrent threads or tasks accessing a resource. Unlike `lock`, it can be used with `async/await` via `WaitAsync()`. Use it to cap concurrent DB connections, HTTP calls, or any resource with a fixed concurrency limit.

## 📖 Detailed Explanation
**What it is:** A semaphore with an initial count and optional max count. `WaitAsync()` decrements the count (blocks/waits if 0); `Release()` increments it.
**Why not lock:** lock is not async-friendly and allows only one. SemaphoreSlim allows N concurrent holders and is awaitable.
**Thread pool friendly:** `WaitAsync()` returns a Task — the thread is released while waiting, unlike a blocking semaphore Wait().
**Common uses:** rate limiting outbound HTTP calls, capping concurrent DB queries, limiting parallel file reads.

## 💻 Code Example
```csharp
// Allow at most 3 concurrent API calls
private readonly SemaphoreSlim _throttle = new SemaphoreSlim(3, 3);

public async Task<string> FetchSafeAsync(string url)
{
    await _throttle.WaitAsync();
    try
    {
        return await _httpClient.GetStringAsync(url);
    }
    finally
    {
        _throttle.Release();   // always release — even on exception
    }
}

// Process 100 URLs max 3 at a time
var tasks = urls.Select(url => FetchSafeAsync(url));
var results = await Task.WhenAll(tasks);
```

## ❓ Follow-Up Questions
- **Q: SemaphoreSlim vs Semaphore?** A: SemaphoreSlim is lighter, in-process only, async-capable. Semaphore is cross-process (OS-level).
- **Q: Why always Release() in finally?** A: Any exception must release the semaphore or it's never available again — deadlock.
- **Q: SemaphoreSlim vs lock?** A: lock is sync-only, binary (1). SemaphoreSlim is async-friendly and N-count.

## ⚠️ Common Mistakes
❌ Not releasing in a finally block.
✅ If the code between Wait and Release throws, you must still release. Always use try/finally.

## 🎯 Cheat Sheet
- **SemaphoreSlim(initial, max):** counting semaphore, async-ready
- **WaitAsync():** async decrement — thread freed while waiting
- **Release():** increment — always in finally
- **Use:** throttle concurrent I/O, cap DB connections, rate limiting

## 🏢 Industry Experience Answer
"We use SemaphoreSlim to throttle outbound calls to third-party APIs that have rate limits. Without it, 500 parallel requests would hammer the external API and get us 429s. With a semaphore of size 10, we fan out safely and max throughput. It's the most practical concurrency tool in day-to-day async code."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is SemaphoreSlim and how does it help control concurrency?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q20 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Expression trees represent code as a **data structure (AST — abstract syntax tree)** that can be inspected, transformed, and executed at runtime — rather than compiled and executed immediately. They're created when a lambda is assigned to `Expression<Func<T>>`. EF Core uses them to translate LINQ queries to SQL; they're also used in dynamic code generation and rule engines.

## 📖 Detailed Explanation
**How it works:** `Expression<Func<User, bool>> predicate = u => u.Age > 18` — instead of generating IL, the compiler creates an object tree: BinaryExpression(MemberExpression, ConstantExpression). This tree can be inspected, serialized, and visited.
**Compiled:** `expression.Compile()` turns the expression tree into a delegate — now it executes.
**EF Core use:** IQueryable<T>.Where(expression) sends the expression tree to the EF Core provider, which translates it to SQL. If you use Func<T,bool> (a compiled delegate), EF loads all rows then filters in memory.

## 💻 Code Example
```csharp
// Expression tree (translates to SQL in EF Core)
Expression<Func<User, bool>> sqlFilter = u => u.Age > 18;
var users = await _db.Users.Where(sqlFilter).ToListAsync();  // WHERE Age > 18

// Compiled delegate (filters in memory — loads all rows first)
Func<User, bool> memFilter = u => u.Age > 18;
var users2 = await _db.Users.ToListAsync();   // all rows
var filtered = users2.Where(memFilter).ToList();  // filtered in C#

// Inspect the tree
var body = (BinaryExpression)sqlFilter.Body;
Console.WriteLine(body.NodeType);   // GreaterThan
```

## ❓ Follow-Up Questions
- **Q: Expression<Func<T>> vs Func<T>?** A: Expression = inspectable AST; Func = compiled delegate. EF Core needs Expression for SQL translation.
- **Q: How do you execute an expression tree?** A: Call .Compile() to get a delegate, then invoke it.
- **Q: Where else are expression trees used?** A: AutoMapper, dynamic LINQ, rule engines, mock frameworks.

## ⚠️ Common Mistakes
❌ Using Func<T,bool> in EF Core Where — loads all rows, filters in memory.
✅ Use Expression<Func<T,bool>> — EF translates to SQL and filters in the database.

## 🎯 Cheat Sheet
- **Definition:** code as data (AST), inspectable and transformable
- **Created when:** lambda assigned to Expression<Func<T>>
- **EF Core:** translates expression trees to SQL
- **Keywords:** AST, IQueryable, Compile, expression visitor, SQL translation

## 🏢 Industry Experience Answer
"Expression trees power our dynamic reporting — users build filter criteria at runtime, we compose expression trees programmatically, and EF translates them directly to WHERE clauses. The alternative (loading all data and filtering in memory) would be catastrophic at scale. It's advanced but extremely powerful."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are expression trees and when are they used?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q21 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Reflection is the ability to **inspect and manipulate types, members, and assemblies at runtime** — discovering types, getting/setting properties, invoking methods, and creating instances without compile-time knowledge. It's powerful but slow (bypasses JIT optimisations, no type safety). Avoid it in hot paths; prefer generics, interfaces, or source generators instead.

## 📖 Detailed Explanation
**What it provides:** Type.GetType(), typeof(T).GetProperties(), PropertyInfo.GetValue()/SetValue(), MethodInfo.Invoke(), Activator.CreateInstance().
**Use cases:** ORMs (mapping columns to properties), dependency injection containers, serializers (JSON, XML), plugin architectures, test frameworks.
**Performance cost:** much slower than direct calls; bypasses inlining and type-check optimisations; attribute reads involve heap allocations.
**Alternatives:** generics (compile-time), source generators (Roslyn, compile-time reflection), cached delegates (compile once via reflection, invoke fast).

## 💻 Code Example
```csharp
// Inspect a type
Type type = typeof(User);
foreach (var prop in type.GetProperties())
    Console.WriteLine(prop.Name + ": " + prop.PropertyType.Name);

// Set a property by name (e.g., mapper)
var user = new User();
var prop = type.GetProperty("Name");
prop.SetValue(user, "Sidhant");
Console.WriteLine(user.Name);   // Sidhant

// Create instance dynamically
var instance = Activator.CreateInstance(type);
```

## ❓ Follow-Up Questions
- **Q: Is reflection thread-safe?** A: Type/member metadata is read-only and thread-safe; SetValue/Invoke on instances is not inherently thread-safe.
- **Q: How do you speed up reflection?** A: Cache the PropertyInfo/MethodInfo; compile to a delegate using Expression.Lambda and invoke that.
- **Q: Source generators vs reflection?** A: Source generators run at compile time (zero runtime cost, typed); reflection runs at runtime (flexible but slow).

## ⚠️ Common Mistakes
❌ Using reflection in a per-request hot path.
✅ Cache reflected members (PropertyInfo, MethodInfo) at startup; or better, use source generators or compiled expression delegates to eliminate reflection at runtime.

## 🎯 Cheat Sheet
- **API:** Type, PropertyInfo, MethodInfo, Activator, Assembly
- **Use:** DI containers, ORMs, serializers, plugin systems
- **Avoid:** hot paths, performance-critical code
- **Alternative:** generics, source generators, cached expression delegates

## 🏢 Industry Experience Answer
"We use reflection once at startup to build mapping dictionaries for our custom serializer, then cache them. At request time it's zero reflection — just dictionary lookups and pre-compiled delegates. The first version did reflect per-request and was 50x slower. Cache and compile early; never reflect in the hot path."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is reflection and when should you avoid it?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q22 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Attributes are **declarative metadata tags** applied to types, members, or parameters using `[AttributeName]` syntax. They're read at runtime via reflection or compile-time via source generators. Built-in examples: `[Obsolete]`, `[Required]`, `[HttpGet]`, `[Authorize]`. Create custom attributes by inheriting from `System.Attribute`.

## 📖 Detailed Explanation
**What they are:** metadata associated with a code element, not executable code themselves.
**How they're read:** `MemberInfo.GetCustomAttributes<T>()` — usually done once at startup and cached.
**AttributeUsage:** `[AttributeUsage(AttributeTargets.Method, AllowMultiple = false)]` controls where and how many times an attribute can be applied.
**Common patterns:** validation (DataAnnotations), routing (ASP.NET Core), authorization, serialization hints, DI registration.

## 💻 Code Example
```csharp
// Custom attribute
[AttributeUsage(AttributeTargets.Method, AllowMultiple = false)]
public class AuditAttribute : Attribute
{
    public string Action { get; }
    public AuditAttribute(string action) => Action = action;
}

// Usage
public class OrderService
{
    [Audit("PlaceOrder")]
    public void PlaceOrder(Order order) { /* ... */ }
}

// Reading via reflection
var method = typeof(OrderService).GetMethod("PlaceOrder");
var audit = method.GetCustomAttribute<AuditAttribute>();
if (audit != null)
    Console.WriteLine("Auditing action: " + audit.Action);
```

## ❓ Follow-Up Questions
- **Q: Are attributes executed at compile time?** A: No — the metadata is stored in the assembly; read at runtime (or by Roslyn source generators at compile time).
- **Q: AttributeTargets?** A: Enum specifying where the attribute can be applied: Class, Method, Property, Parameter, Assembly, etc.
- **Q: AllowMultiple?** A: Whether the same attribute can be applied multiple times to the same element.

## ⚠️ Common Mistakes
❌ Reading attributes via reflection in hot paths without caching.
✅ Read and cache attribute metadata once at startup. Attribute reads involve reflection and allocations.

## 🎯 Cheat Sheet
- **Definition:** declarative metadata, read via reflection or source generators
- **Create:** class MyAttr : Attribute + [AttributeUsage]
- **Apply:** [MyAttr] on class/method/property/parameter
- **Keywords:** AttributeUsage, AttributeTargets, GetCustomAttribute, AllowMultiple

## 🏢 Industry Experience Answer
"Attributes drive our entire permission system — [RequiresPermission('orders.write')] on controller actions. At startup, middleware reflects once over all endpoints, caches the permission requirements, and at request time it's a dictionary lookup. Zero reflection in the hot path, clean declarative API for developers."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are attributes and how do you create custom attributes?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q23 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
`Lazy<T>` defers the creation of an expensive object until it's **first accessed**, not when the containing class is constructed. It's thread-safe by default (LazyThreadSafetyMode.ExecutionAndPublication) and ensures the factory runs only once. Use it for expensive initializations that may never be needed.

## 📖 Detailed Explanation
**What it does:** wraps a factory delegate; .Value triggers initialization on first access.
**Thread safety modes:**
- `ExecutionAndPublication` (default): thread-safe, factory runs once even with concurrent first accesses.
- `PublicationOnly`: may run factory multiple times; first to publish wins.
- `None`: no synchronization — use only for single-threaded scenarios.
**Use cases:** expensive service initialization, computed properties, singleton-like resources initialized on demand.

## 💻 Code Example
```csharp
// Lazy initialization — connection only made when needed
private readonly Lazy<SqlConnection> _lazyConn;

public DataService(string connectionString)
{
    _lazyConn = new Lazy<SqlConnection>(() =>
    {
        Console.WriteLine("Connecting...");
        return new SqlConnection(connectionString);
    });
}

public SqlConnection Connection => _lazyConn.Value;  // connects on first access

// Check without triggering initialization
if (_lazyConn.IsValueCreated)
    Console.WriteLine("Already connected");
```

## ❓ Follow-Up Questions
- **Q: Is Lazy<T> thread-safe?** A: By default yes (ExecutionAndPublication).
- **Q: How do you check if initialized without triggering it?** A: .IsValueCreated property.
- **Q: Does Lazy<T> itself allocate?** A: Yes — Lazy<T> is a class. For ultra-hot paths consider a volatile field with double-checked locking.

## ⚠️ Common Mistakes
❌ Using Lazy<T> for cheap objects.
✅ The Lazy<T> wrapper itself has overhead. Only use it when the wrapped initialization is genuinely expensive or frequently skipped.

## 🎯 Cheat Sheet
- **Lazy<T>:** deferred initialization on .Value access
- **Thread-safe:** ExecutionAndPublication by default
- **IsValueCreated:** check without triggering
- **Keywords:** lazy initialization, deferred, thread-safe, factory delegate

## 🏢 Industry Experience Answer
"We use Lazy<T> for module-level expensive resources — e.g., loading a large configuration lookup table. The app boots faster because it's not loading things that might never be needed in the current request path. The thread-safety default is exactly right for most scenarios."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is the Lazy<T> class and when do you use lazy initialization?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q24 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
All four synchronize access to shared resources, but differ in scope and capabilities: **lock** (Monitor.Enter/Exit shorthand) is simplest — in-process, one thread at a time. **Monitor** has the same scope but adds TryEnter + Pulse/Wait. **Mutex** is cross-process (OS-level). **Semaphore** allows N concurrent threads (cross-process). In modern async code, prefer **SemaphoreSlim** over all of these.

## 📖 Detailed Explanation
| Type | Scope | Count | Async | Overhead |
|---|---|---|---|---|
| lock / Monitor | In-process | 1 | No | Lowest |
| Mutex | Cross-process | 1 | No | High (OS) |
| Semaphore | Cross-process | N | No | High (OS) |
| SemaphoreSlim | In-process | N | Yes | Low |

**lock:** compiled to Monitor.Enter/Exit with try/finally. Releases on exception. Re-entrant.
**Monitor.TryEnter:** attempts to acquire with a timeout, returns bool — no blocking.
**Monitor.Pulse/Wait:** condition variable pattern inside Monitor — advanced producer/consumer.
**Mutex:** named mutex works across processes (e.g., single-instance app enforcement).

## 💻 Code Example
```csharp
// lock (most common)
private readonly object _gate = new object();
void UpdateCounter() { lock (_gate) { _counter++; } }

// Monitor with timeout
bool acquired = Monitor.TryEnter(_gate, TimeSpan.FromMilliseconds(100));
if (acquired) try { /* work */ } finally { Monitor.Exit(_gate); }

// Mutex — cross-process single instance
using var mutex = new Mutex(initiallyOwned: false, "MyApp_SingleInstance");
if (!mutex.WaitOne(0)) { Console.WriteLine("Already running"); return; }
```

## ❓ Follow-Up Questions
- **Q: Is lock re-entrant?** A: Yes — the same thread can re-acquire a lock it already holds.
- **Q: When use Mutex over lock?** A: When you need cross-process synchronization (single-instance app, shared named resource).
- **Q: Best for async?** A: SemaphoreSlim.WaitAsync() — it's async-friendly unlike lock.

## ⚠️ Common Mistakes
❌ Using lock with async inside the lock body.
✅ lock prevents the thread from yielding — await inside lock can deadlock or hold the lock across an I/O wait. Use SemaphoreSlim for async mutual exclusion.

## 🎯 Cheat Sheet
- **lock:** simplest, in-process, binary, sync only
- **Monitor:** same as lock + TryEnter + Pulse/Wait
- **Mutex:** cross-process, binary, expensive
- **Semaphore:** cross-process, N-count
- **SemaphoreSlim:** in-process, N-count, async-ready

## 🏢 Industry Experience Answer
"In practice, 90% of synchronization in our code is lock for simple counter/cache updates or SemaphoreSlim for async-aware throttling. Mutex appears only in our installer and single-instance launcher. Semaphore (OS-level) is almost never needed in server code — if you need cross-process coordination, a Redis lock or a DB advisory lock is more robust anyway."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between lock, Monitor, Mutex, and Semaphore?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q25 ────────────────────────────────────────────────────────
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
`Span<T>` is a **stack-only struct** that provides a slice/view over any contiguous memory (array, stack, unmanaged) without copying. `Memory<T>` is the **heap-compatible** equivalent that can be stored in fields and used with async. Together they enable zero-copy parsing, slicing, and processing — critical for high-performance code.

## 📖 Detailed Explanation
**Span<T>:** ref struct (stack-only), cannot be a class field or captured in lambdas, cannot cross await. Extremely fast — no heap allocation, just a pointer+length.
**Memory<T>:** a regular struct (heap-compatible), can be stored in fields, works across async. Slightly more overhead than Span. Memory<T>.Span gives you a Span to work with.
**ReadOnlySpan<T>:** read-only view, enabling parsing of string/byte data without allocation.
**string.AsSpan():** wraps a string as ReadOnlySpan<char> — parse without substring allocations.
**stackalloc:** allocate directly on the stack and wrap in Span — zero heap allocation.

## 💻 Code Example
```csharp
// Parse CSV line without allocating substrings
void ParseCsv(ReadOnlySpan<char> line)
{
    while (!line.IsEmpty)
    {
        int comma = line.IndexOf(',');
        var field = comma >= 0 ? line[..comma] : line;
        ProcessField(field);        // no string allocation
        line = comma >= 0 ? line[(comma + 1)..] : ReadOnlySpan<char>.Empty;
    }
}

// Stack allocation — zero heap
Span<int> buffer = stackalloc int[128];
for (int i = 0; i < buffer.Length; i++) buffer[i] = i;

// Memory<T> for async scenarios
async Task ProcessAsync(Memory<byte> data)
{
    await _stream.WriteAsync(data);  // can use Memory across await
}
```

## ❓ Follow-Up Questions
- **Q: Why can't Span<T> cross an await?** A: It's a ref struct (stack-only) — it can't be stored in the async state machine (which is heap-allocated).
- **Q: When use Memory<T> vs Span<T>?** A: Span for sync, stack-bound processing; Memory for fields, async, heap-stored buffers.
- **Q: What is ArrayPool<T>?** A: Rents a pooled array from the runtime — combine with Memory<T> to process large data without constant allocation.

## ⚠️ Common Mistakes
❌ Using Span<T> across an await boundary.
✅ Convert to Memory<T> or extract the operation before/after the await — Span can't survive the async state machine.

## 🎯 Cheat Sheet
- **Span<T>:** stack-only, zero-copy slice, sync only, no heap
- **Memory<T>:** heap-compatible, async-safe, wraps array/memory
- **ReadOnlySpan<char>:** parse strings without allocation
- **Keywords:** zero-copy, ref struct, stackalloc, ArrayPool, high-performance

## 🏢 Industry Experience Answer
"Span and Memory transformed our binary protocol parser. Previously it allocated hundreds of byte[] per message for slicing. With ReadOnlySpan we slice in-place — zero allocation per field, GC pressure dropped 80%. For async paths we use Memory<byte> with ArrayPool-rented buffers. The learning curve is real but the performance gain is worth it for I/O-heavy code."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are Span<T> and Memory<T> and why are they important for performance?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- ════════════════════════════════════════════════════════════
-- End of Batch 2 — Section 2 COMPLETE (Advanced C# Q1–Q25)
-- Next: devready_batch03_aspnet_core.sql (Section 3, Q1–Q22)
-- ════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════
-- DevReady Seed — Batch 3
-- .NET › 3️⃣ ASP.NET Core › Q1–Q22
-- Dollar-quote safe (zero $ inside content). Idempotent upsert.
-- ════════════════════════════════════════════════════════════

-- Q1
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
.NET Core (now just ".NET") is Microsoft's **cross-platform, open-source, high-performance** successor to the Windows-only .NET Framework. .NET 8 (LTS, released Nov 2023) is the current long-term-support version — it runs on Windows, Linux, and macOS, supports containerisation natively, and delivers significant performance improvements over its predecessor.

## 📖 Detailed Explanation
**What it is:** A unified, modular runtime replacing .NET Framework, Mono, and Xamarin under one SDK.
**Key milestones:** .NET Core 1.0 (2016) → .NET 5 (unified, dropped "Core") → .NET 6 LTS → .NET 7 → .NET 8 LTS.
**Architecture:** CoreCLR (runtime), CoreFX (BCL), Roslyn (compiler), and SDK tooling — all open-source on GitHub.
**Performance:** .NET 8 consistently tops TechEmpower benchmarks; significant improvements in GC, JIT (tiered compilation, PGO), and built-in AOT compilation.

## 💻 Code Example
```csharp
// Minimal .NET 8 Web API — entire app in Program.cs
var builder = WebApplication.CreateBuilder(args);
builder.Services.AddControllers();
var app = builder.Build();
app.MapControllers();
app.Run();
// Build: dotnet build | Run: dotnet run | Docker: dotnet publish -c Release
```

## ❓ Follow-Up Questions
- **Q: .NET 8 vs .NET Framework — can they run side by side?** A: Yes — .NET (Core) is side-by-side; Framework is machine-wide.
- **Q: What is AOT in .NET 8?** A: Native AOT compiles to a self-contained native binary — no JIT at runtime, faster startup.
- **Q: Is .NET Framework dead?** A: Not removed, but in maintenance mode — no new features; migrate to .NET 8+.

## ⚠️ Common Mistakes
❌ Saying ".NET Core" for the current platform.
✅ From .NET 5+ it's simply ".NET". .NET Core refers to versions 1.0–3.1 specifically.

## 🎯 Cheat Sheet
- **Current LTS:** .NET 8
- **Cross-platform:** Windows, Linux, macOS, containers
- **Keywords:** CoreCLR, tiered JIT, PGO, AOT, open-source, side-by-side

## 🏢 Industry Experience Answer
"We migrated our monolith from .NET Framework 4.8 to .NET 8 last year. The biggest wins were Linux containers (halved infrastructure cost), a 40% throughput increase from the improved JIT and GC, and the unified SDK toolchain making CI/CD much simpler. The migration was gradual — first to .NET 6 LTS, then .NET 8."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is .NET Core / .NET 8?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q2
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
.NET Core / .NET 8 advantages over .NET Framework: **cross-platform** (Linux/macOS), **better performance**, **side-by-side versioning**, **open-source**, **container-first**, **modular** (no monolithic GAC), and **actively developed**. .NET Framework is Windows-only, tied to the OS, and in maintenance mode.

## 📖 Detailed Explanation
| Aspect | .NET Core / .NET 8 | .NET Framework |
|---|---|---|
| Platform | Windows, Linux, macOS | Windows only |
| Performance | Significantly faster | Slower baseline |
| Deployment | Self-contained or shared | Requires installed framework |
| Versioning | Side-by-side per app | Machine-wide, one version |
| Open source | Yes (GitHub) | Partial |
| Development | Active (annual releases) | Maintenance only |
| Container | Native Docker support | Limited |
| NuGet | Fully modular | Large monolithic BCL |

## 💻 Code Example
```csharp
// .NET 8 self-contained publish — no runtime required on target
// dotnet publish -c Release -r linux-x64 --self-contained true

// Docker multi-stage build (smaller images than Framework)
// FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
// FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
```

## ❓ Follow-Up Questions
- **Q: Can you run .NET 8 on a Raspberry Pi?** A: Yes — linux-arm64 is a supported runtime identifier.
- **Q: Is SignalR available in .NET Core?** A: Yes — completely rewritten and improved in ASP.NET Core.
- **Q: What about WCF?** A: WCF server is Framework-only; CoreWCF is a community port for .NET.

## ⚠️ Common Mistakes
❌ Trying to use .NET Framework-specific libraries (System.Web, WebForms) in .NET Core.
✅ They don't exist in .NET Core. Migrate to ASP.NET Core equivalents or use compatibility shims where available.

## 🎯 Cheat Sheet
- **Cross-platform, open-source, fast, modular, side-by-side, container-native**
- **Framework:** Windows-only, GAC, maintenance mode
- **Keywords:** self-contained, linux-x64, Docker, TechEmpower benchmarks

## 🏢 Industry Experience Answer
"The biggest practical advantage in my experience is Linux containers — we cut cloud compute cost significantly by moving from Windows Server VMs to Linux Docker images. The performance gains from the improved JIT and GC are real and measurable. Side-by-side versioning also means we can upgrade one service at a time without affecting others."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Advantages of .NET Core over .NET Framework?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q3
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
The `Startup` class (ASP.NET Core 2.x–5.x) was the conventional entry point for configuring **services** (`ConfigureServices`) and the **middleware pipeline** (`Configure`). In .NET 6+ it was merged into `Program.cs` using the minimal hosting model with `WebApplication.CreateBuilder()` — the Startup class is no longer required but still supported.

## 📖 Detailed Explanation
**ConfigureServices(IServiceCollection services):** registers dependencies with the DI container.
**Configure(IApplicationBuilder app, IWebHostEnvironment env):** builds the middleware pipeline — order matters here.
**Why it was separated:** clean separation of DI registration from pipeline configuration.
**Now (.NET 6+):** both jobs are done inline in Program.cs using `builder.Services.*` and `app.Use*()`.

## 💻 Code Example
```csharp
// Legacy Startup class pattern (.NET 5 and earlier)
public class Startup
{
    public void ConfigureServices(IServiceCollection services)
    {
        services.AddControllers();
        services.AddScoped<IOrderService, OrderService>();
    }

    public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
    {
        if (env.IsDevelopment()) app.UseDeveloperExceptionPage();
        app.UseRouting();
        app.UseAuthentication();
        app.UseAuthorization();
        app.UseEndpoints(endpoints => endpoints.MapControllers());
    }
}

// Modern equivalent in Program.cs (.NET 6+)
var builder = WebApplication.CreateBuilder(args);
builder.Services.AddControllers();
builder.Services.AddScoped<IOrderService, OrderService>();
var app = builder.Build();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
app.Run();
```

## ❓ Follow-Up Questions
- **Q: Is Startup class still valid in .NET 8?** A: Yes — you can still use it via builder.Host.ConfigureWebHostDefaults, but the minimal model is preferred.
- **Q: What replaces ConfigureServices?** A: builder.Services in Program.cs.
- **Q: What replaces Configure?** A: app.Use*() and app.Map*() calls after builder.Build().

## ⚠️ Common Mistakes
❌ Registering middleware in ConfigureServices or DI in Configure.
✅ ConfigureServices = DI only; Configure = middleware pipeline only. (In .NET 6+, use builder.Services and app.Use* respectively.)

## 🎯 Cheat Sheet
- **ConfigureServices:** DI registration
- **Configure:** middleware pipeline (order matters)
- **.NET 6+:** merged into Program.cs, minimal hosting model
- **Keywords:** IServiceCollection, IApplicationBuilder, middleware, DI

## 🏢 Industry Experience Answer
"We've moved all new services to the minimal hosting model — Program.cs is more readable for small-to-medium services and integrates better with source generators and minimal APIs. For large legacy projects with complex startup logic, we keep Startup classes organised by feature using extension methods on IServiceCollection."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is the Startup class in ASP.NET Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q4
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
`Program.cs` is the **entry point** of an ASP.NET Core application — it's where you create the host, register services with DI, configure the middleware pipeline, and start the application. In .NET 6+ it uses top-level statements and the minimal hosting model, eliminating boilerplate `Main()` and `Startup` class ceremony.

## 📖 Detailed Explanation
**Host creation:** `WebApplication.CreateBuilder(args)` sets up configuration, logging, DI, and the web server (Kestrel).
**Service registration:** `builder.Services.*` — adds controllers, EF Core, authentication, custom services.
**Build:** `builder.Build()` creates the configured app.
**Middleware pipeline:** `app.Use*()` calls define what happens to each request, in order.
**Run:** `app.Run()` starts listening for HTTP requests.

## 💻 Code Example
```csharp
// Complete Program.cs for a production API
var builder = WebApplication.CreateBuilder(args);

// 1. Services
builder.Services.AddControllers();
builder.Services.AddDbContext<AppDbContext>(o =>
    o.UseNpgsql(builder.Configuration.GetConnectionString("Default")));
builder.Services.AddScoped<IOrderService, OrderService>();
builder.Services.AddAuthentication().AddJwtBearer();
builder.Services.AddAuthorization();

// 2. Build
var app = builder.Build();

// 3. Middleware pipeline (ORDER MATTERS)
app.UseExceptionHandler("/error");
app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

// 4. Run
app.Run();
```

## ❓ Follow-Up Questions
- **Q: What did Program.cs look like before .NET 6?** A: It contained a `Main()` method calling `CreateHostBuilder(args).Build().Run()` and referenced a Startup class.
- **Q: What is WebApplication.CreateBuilder?** A: Creates a preconfigured builder with Kestrel, configuration providers, logging, and DI already wired up.
- **Q: Can you have multiple Program.cs files?** A: No — one entry point per executable, but you can split startup logic into extension methods.

## ⚠️ Common Mistakes
❌ Registering middleware before Build() or services after Build().
✅ Services go on builder.Services BEFORE Build(); middleware goes on app AFTER Build().

## 🎯 Cheat Sheet
- **Flow:** CreateBuilder → Services → Build → Middleware → Run
- **builder.Services:** DI registration
- **app.Use*():** middleware pipeline
- **Keywords:** WebApplication, CreateBuilder, host, Kestrel, minimal hosting

## 🏢 Industry Experience Answer
"The minimal hosting model in Program.cs made our microservices dramatically cleaner — a simple CRUD API fits in 50 lines without ceremony. For larger services we use extension methods to group related registrations: AddPersistence(), AddDomainServices(), AddInfrastructure() — Program.cs stays readable while logic is organized by concern."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is the Program.cs file used for?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q5
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Dependency Injection (DI) is a design pattern where a class **receives its dependencies from the outside** (via constructor, property, or method) rather than creating them itself. ASP.NET Core has a built-in DI container — you register types once, and the framework creates and injects instances automatically. DI enables loose coupling, testability, and lifetime management.

## 📖 Detailed Explanation
**Without DI:** a class uses `new DependencyClass()` — it's tightly coupled, can't be swapped or mocked.
**With DI:** the class declares what it needs (interface) in its constructor; the container provides it. The class only knows the contract, not the concrete type.
**ASP.NET Core DI:** register in builder.Services, inject via constructor. The framework resolves the full dependency graph automatically.
**Key concepts:** registration (what to inject), resolution (how to get it), lifetime (how long it lives).

## 💻 Code Example
```csharp
// 1. Define the contract
public interface IEmailService { Task SendAsync(string to, string body); }

// 2. Implement it
public class SmtpEmailService : IEmailService
{
    public async Task SendAsync(string to, string body) { /* SMTP logic */ }
}

// 3. Register in Program.cs
builder.Services.AddScoped<IEmailService, SmtpEmailService>();

// 4. Inject wherever needed
public class OrderController : ControllerBase
{
    private readonly IEmailService _email;
    public OrderController(IEmailService email) => _email = email;  // injected

    [HttpPost]
    public async Task<IActionResult> PlaceOrder(OrderDto dto)
    {
        await _email.SendAsync(dto.CustomerEmail, "Order placed!");
        return Ok();
    }
}
```

## ❓ Follow-Up Questions
- **Q: What are the DI lifetime options?** A: Transient (new every time), Scoped (once per HTTP request), Singleton (once per app lifetime).
- **Q: How does constructor injection work?** A: The framework reads the constructor's parameter types, resolves each from the container, and passes them in.
- **Q: What is the Service Locator anti-pattern?** A: Manually calling IServiceProvider.GetService() inside business logic — couples your code to the container. Prefer constructor injection.

## ⚠️ Common Mistakes
❌ Using `new` to create dependencies inside classes.
✅ Register them and inject via the constructor — loose coupling, easy testing, proper lifetime management.

## 🎯 Cheat Sheet
- **DI:** dependencies provided externally, not created internally
- **Register:** builder.Services.AddScoped/Transient/Singleton
- **Inject:** constructor parameter matching registered interface
- **Keywords:** IoC, inversion of control, loose coupling, mockability, IServiceCollection

## 🏢 Industry Experience Answer
"DI is the backbone of our entire architecture. Every service, repository, validator, and handler is registered in the container and injected at the constructor. In unit tests we inject mocks of the dependencies — because of DI our entire codebase is 100% unit-testable without a DB or network. It also lets us swap implementations (e.g., SMTP to SendGrid) with one line in Program.cs."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Dependency Injection (DI)?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q6
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
ASP.NET Core DI has three lifetimes: **Transient** — new instance every injection; **Scoped** — one instance per HTTP request (shared within that request); **Singleton** — one instance for the entire app lifetime. Choosing the wrong lifetime causes bugs ranging from stale data to memory leaks.

## 📖 Detailed Explanation
**Transient:** safest — fresh instance each time. Good for stateless, lightweight services.
**Scoped:** same instance within one HTTP request. Perfect for DbContext, Unit of Work — you want one context per request so change tracking is consistent.
**Singleton:** one instance forever — must be thread-safe. Good for caching, configuration wrappers, HttpClientFactory internals.
**Captive dependency:** a singleton depends on a scoped service — the scoped service lives as long as the singleton (forever), breaking the scoped guarantee. ASP.NET Core detects this in development mode and throws.

## 💻 Code Example
```csharp
builder.Services.AddTransient<IEmailService, EmailService>();      // new each time
builder.Services.AddScoped<IOrderRepository, OrderRepository>();   // per request
builder.Services.AddSingleton<ICache, MemoryCache>();              // app lifetime

// DbContext is always Scoped — one per request
builder.Services.AddDbContext<AppDbContext>(o =>
    o.UseNpgsql(connStr));  // AddDbContext registers as Scoped by default

// DANGER: captive dependency — don't do this
builder.Services.AddSingleton<IBadService, BadServiceThatNeedsDbContext>();
// If BadService takes IOrderRepository (Scoped), it captures and holds it forever
```

## ❓ Follow-Up Questions
- **Q: What lifetime for DbContext?** A: Scoped — one per request, disposed at request end.
- **Q: Can a Scoped service depend on a Singleton?** A: Yes — longer lives can depend on shorter is fine the other way (Singleton depends on Transient/Scoped is the problem).
- **Q: What happens with a captive dependency?** A: Runtime InvalidOperationException in development (scope validation enabled by default).

## ⚠️ Common Mistakes
❌ Registering DbContext as Singleton.
✅ DbContext is not thread-safe and holds a DB connection. It must be Scoped (per request) — one context per request, disposed cleanly at the end.

## 🎯 Cheat Sheet
- **Transient:** new every injection — stateless services
- **Scoped:** once per request — DbContext, Unit of Work, repositories
- **Singleton:** once per app — caches, HttpClientFactory, config
- **Keywords:** captive dependency, scope validation, thread-safe, IServiceScope

## 🏢 Industry Experience Answer
"The lifetime selection is one of the first things I check in code reviews. A DbContext registered as Singleton has caused real production bugs — concurrent requests sharing change tracking, stale entities, connection pool exhaustion. The rule is easy: DbContext = Scoped, repositories = Scoped, stateless helpers = Transient, caches = Singleton."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are the service lifetimes — Singleton, Scoped, Transient?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q7
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Middleware are components that form the **request processing pipeline** in ASP.NET Core — each component can inspect, modify, short-circuit, or pass the request to the next component. They're chained in order: request flows inward through each middleware, response flows back outward. Order matters critically.

## 📖 Detailed Explanation
**What it is:** A pipeline of RequestDelegate components; each has access to HttpContext and a reference to the next middleware.
**Short-circuit:** a middleware can respond and not call next() — e.g., authentication failing returns 401 and stops the pipeline.
**Built-in examples:** UseExceptionHandler, UseRouting, UseAuthentication, UseAuthorization, UseStaticFiles, UseResponseCaching.
**Custom middleware:** implement `InvokeAsync(HttpContext context, RequestDelegate next)` or use `app.Use()` inline.
**Order rule:** UseRouting before UseAuthentication before UseAuthorization before MapControllers.

## 💻 Code Example
```csharp
// Custom request-timing middleware
public class TimingMiddleware
{
    private readonly RequestDelegate _next;
    public TimingMiddleware(RequestDelegate next) => _next = next;

    public async Task InvokeAsync(HttpContext ctx)
    {
        var sw = Stopwatch.StartNew();
        await _next(ctx);                // call next middleware
        sw.Stop();
        ctx.Response.Headers["X-Response-Time"] = sw.ElapsedMilliseconds + "ms";
    }
}

// Register in Program.cs (ORDER MATTERS)
app.UseExceptionHandler("/error");  // outermost — catches all
app.UseHttpsRedirection();
app.UseRouting();
app.UseAuthentication();            // must be before Authorization
app.UseAuthorization();
app.UseMiddleware<TimingMiddleware>();
app.MapControllers();
```

## ❓ Follow-Up Questions
- **Q: What is the difference between app.Use() and app.Run()?** A: Use() calls next; Run() is terminal — it never calls next, ending the pipeline.
- **Q: What is app.Map()?** A: Branches the pipeline based on a path prefix.
- **Q: Why does middleware order matter?** A: Authentication must run before Authorization; routing must run before endpoint execution; exception handling must be outermost to catch everything.

## ⚠️ Common Mistakes
❌ Placing UseAuthentication after UseAuthorization.
✅ Authentication must identify the user BEFORE Authorization can check their permissions. Wrong order = all requests treated as unauthenticated.

## 🎯 Cheat Sheet
- **Pipeline:** inward on request, outward on response
- **Short-circuit:** return response without calling next()
- **Order:** ExceptionHandler → HTTPS → Routing → Auth → Authorization → Endpoints
- **Keywords:** RequestDelegate, HttpContext, pipeline, Use/Run/Map

## 🏢 Industry Experience Answer
"Middleware order has bitten us in production. We once placed correlation-ID middleware after routing, missing it on some requests. Now our middleware order is documented, reviewed, and tested with integration tests that verify headers and status codes for each stage. Treat the pipeline as a first-class architectural concern, not an afterthought."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Middleware?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q8
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Routing in ASP.NET Core matches incoming HTTP requests to endpoint handlers (controller actions or minimal API handlers) based on the URL pattern and HTTP method. ASP.NET Core uses **endpoint routing** (since 3.0) — routes are registered centrally and resolved in one place, enabling middleware to know the matched endpoint before executing it.

## 📖 Detailed Explanation
**Conventional routing:** `app.MapControllerRoute(name, pattern)` — maps URL patterns to controller/action by convention.
**Attribute routing:** `[Route("api/orders/{id}")]` on the controller/action — explicit, preferred for APIs.
**Endpoint routing:** UseRouting selects the endpoint; UseAuthorization/UseAuthentication run knowing the selected endpoint; MapControllers executes it.
**Route parameters:** `{id}`, `{id:int}`, `{id:int:min(1)}` — with optional constraints and defaults.
**Route priority:** more specific routes win; attribute routes take precedence over conventional.

## 💻 Code Example
```csharp
// Attribute routing (recommended for APIs)
[ApiController]
[Route("api/[controller]")]
public class OrdersController : ControllerBase
{
    [HttpGet]                           // GET api/orders
    public IActionResult GetAll() => Ok();

    [HttpGet("{id:int}")]               // GET api/orders/42
    public IActionResult GetById(int id) => Ok();

    [HttpPost]                          // POST api/orders
    public IActionResult Create(OrderDto dto) => CreatedAtAction(nameof(GetById), new { id = 1 }, dto);

    [HttpPut("{id:int}")]               // PUT api/orders/42
    public IActionResult Update(int id, OrderDto dto) => NoContent();

    [HttpDelete("{id:int}")]            // DELETE api/orders/42
    public IActionResult Delete(int id) => NoContent();
}
```

## ❓ Follow-Up Questions
- **Q: Attribute routing vs conventional routing?** A: Attribute is explicit and preferred for APIs; conventional is common for MVC/Razor Pages.
- **Q: What are route constraints?** A: {id:int}, {slug:alpha}, {date:datetime} — restrict what values match the segment.
- **Q: What is LinkGenerator?** A: A service to generate URLs for named routes/endpoints without hardcoding strings.

## ⚠️ Common Mistakes
❌ Mixing attribute and conventional routing without understanding precedence.
✅ For APIs, use attribute routing exclusively — it's explicit, refactor-safe, and self-documenting.

## 🎯 Cheat Sheet
- **Endpoint routing:** UseRouting → (auth middleware) → MapControllers
- **Attribute:** [Route], [HttpGet("{id:int}")]
- **Constraints:** {id:int}, {name:minlength(3)}, {id:guid}
- **Keywords:** endpoint routing, route template, constraint, LinkGenerator

## 🏢 Industry Experience Answer
"We use attribute routing for all APIs — it's explicit, survives renaming, and collocates the route with the action. Route constraints like {id:int} act as free input validation for path parameters. We also use [Route] on the controller with [controller] token so the route updates automatically if we rename the controller."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Routing in ASP.NET Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q9
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Model binding is the process by which ASP.NET Core **automatically maps incoming HTTP request data** (route values, query string, form fields, request body, headers) to action method parameters and model properties. It handles type conversion, nested objects, and collections — you don't manually parse `Request.Body` or `Request.Query`.

## 📖 Detailed Explanation
**Sources (in order):** Form values, Route data, Query string. Body is separate via [FromBody].
**Binding attributes:** [FromRoute], [FromQuery], [FromBody], [FromForm], [FromHeader], [FromServices].
**[ApiController]:** automatically applies [FromBody] for complex types in POST/PUT — no attribute needed.
**Model validation:** after binding, data annotations (Required, Range, MaxLength) are checked. ModelState.IsValid reflects the result.
**Custom binders:** implement IModelBinder for non-standard binding logic.

## 💻 Code Example
```csharp
[ApiController]
[Route("api/orders")]
public class OrdersController : ControllerBase
{
    // Route + query binding
    [HttpGet("{id:int}")]
    public IActionResult Get(
        [FromRoute] int id,               // from URL segment
        [FromQuery] string currency = "INR",  // from ?currency=USD
        [FromHeader(Name = "X-Tenant")] string tenant = "default")
    {
        return Ok(new { id, currency, tenant });
    }

    // Body binding (automatic with [ApiController])
    [HttpPost]
    public IActionResult Create([FromBody] CreateOrderDto dto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);
        return CreatedAtAction(nameof(Get), new { id = 1 }, dto);
    }
}

public class CreateOrderDto
{
    [Required] public string CustomerId { get; set; }
    [Range(1, 10000)] public decimal Amount { get; set; }
}
```

## ❓ Follow-Up Questions
- **Q: What happens if binding fails?** A: With [ApiController], a 400 Bad Request is returned automatically. Without it, the parameter is null/default.
- **Q: Can you bind from multiple sources in one parameter?** A: No — one attribute per parameter.
- **Q: How does [ApiController] help model binding?** A: Auto-applies [FromBody] for complex types; auto-returns 400 on ModelState invalid.

## ⚠️ Common Mistakes
❌ Forgetting [FromBody] on a complex POST parameter without [ApiController].
✅ The parameter won't bind — its properties will all be null/default. Add [ApiController] or explicit [FromBody].

## 🎯 Cheat Sheet
- **Sources:** FromRoute, FromQuery, FromBody, FromForm, FromHeader, FromServices
- **[ApiController]:** auto-FromBody + auto-400 on invalid ModelState
- **Validation:** DataAnnotations, ModelState.IsValid
- **Keywords:** model binding, model validation, DataAnnotations, binding source

## 🏢 Industry Experience Answer
"Model binding is one of those things you take for granted until it breaks. The key lesson: with [ApiController] the framework handles 80% of validation automatically. We add FluentValidation on top for complex business rules. The worst bug I've seen: a DateTime parameter bound from query string in a non-invariant culture — switched to ISO 8601 strings via [FromQuery] + custom binder."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Model Binding?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q10
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Filters in ASP.NET Core execute code **at specific stages of the action pipeline** — before/after model binding, before/after action execution, after result execution. They're the right place for cross-cutting concerns: authentication, logging, caching, exception handling, and validation that apply to multiple actions.

## 📖 Detailed Explanation
**Filter types and order:**
1. **Authorization filters** — first, short-circuit if unauthorized.
2. **Resource filters** — before model binding; caching at this stage.
3. **Action filters** — before/after the action method.
4. **Exception filters** — handle unhandled exceptions from actions.
5. **Result filters** — before/after the action result is executed.

**Scope:** Global (all actions), Controller (all actions in a controller), Action (one action).
**Implement:** IActionFilter / IAsyncActionFilter, IExceptionFilter, IAuthorizationFilter, etc.
**Attribute-based:** add as attributes — `[ServiceFilter(typeof(MyFilter))]` for DI-registered filters.

## 💻 Code Example
```csharp
// Action filter — logs request/response timing
public class TimingActionFilter : IAsyncActionFilter
{
    private readonly ILogger<TimingActionFilter> _logger;
    public TimingActionFilter(ILogger<TimingActionFilter> logger) => _logger = logger;

    public async Task OnActionExecutionAsync(ActionExecutingContext ctx, ActionExecutionDelegate next)
    {
        var sw = Stopwatch.StartNew();
        var executed = await next();   // execute the action
        sw.Stop();
        _logger.LogInformation("Action {Action} took {Ms}ms",
            ctx.ActionDescriptor.DisplayName, sw.ElapsedMilliseconds);
    }
}

// Register globally
builder.Services.AddScoped<TimingActionFilter>();
builder.Services.AddControllers(o =>
    o.Filters.Add<TimingActionFilter>());

// Or per controller
[ServiceFilter(typeof(TimingActionFilter))]
public class OrdersController : ControllerBase { }
```

## ❓ Follow-Up Questions
- **Q: Filter vs middleware — when to use which?** A: Middleware runs for all requests (including static files); filters run only within the MVC pipeline and have access to controller/action context.
- **Q: What is a global exception filter?** A: Implements IExceptionFilter; catches unhandled exceptions from all actions and returns a consistent error response.
- **Q: Can filters be async?** A: Yes — implement IAsyncActionFilter / IAsyncExceptionFilter etc.

## ⚠️ Common Mistakes
❌ Using middleware for logic that needs action/controller context (action name, route data).
✅ Use a filter — it has ActionExecutingContext with controller name, action name, arguments, route data.

## 🎯 Cheat Sheet
- **Types:** Authorization → Resource → Action → Exception → Result
- **Scope:** Global / Controller / Action
- **Register:** AddControllers(o => o.Filters.Add...) or [ServiceFilter]
- **Keywords:** IActionFilter, IExceptionFilter, cross-cutting concern, pipeline

## 🏢 Industry Experience Answer
"We use action filters extensively — audit logging, request validation, and response envelope wrapping all live in filters. The key advantage over middleware is context: a filter knows the controller name, action name, and arguments, which middleware doesn't. Exception filters give us one consistent JSON error format across all API controllers."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are Filters in ASP.NET Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q11
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
ASP.NET Core has a **layered configuration system** that aggregates settings from multiple providers (JSON files, environment variables, command-line args, secrets, Azure Key Vault) into a unified `IConfiguration` dictionary. Later providers override earlier ones, making environment-specific config easy without code changes.

## 📖 Detailed Explanation
**Default provider order (lowest to highest priority):**
1. appsettings.json
2. appsettings.{Environment}.json
3. User Secrets (development)
4. Environment variables
5. Command-line arguments

**IConfiguration:** key-value dictionary with colon-delimited keys (e.g., "ConnectionStrings:Default").
**IOptions<T>:** strongly-typed, validated config section bound to a class.
**Configuration reload:** AddJsonFile("...", reloadOnChange: true) — live update without restart.

## 💻 Code Example
```csharp
// appsettings.json
// { "Email": { "SmtpHost": "smtp.example.com", "Port": 587 } }

// Strongly-typed config class
public class EmailOptions
{
    public string SmtpHost { get; set; }
    public int Port { get; set; }
}

// Register and bind
builder.Services.Configure<EmailOptions>(
    builder.Configuration.GetSection("Email"));

// Inject and use
public class EmailService
{
    private readonly EmailOptions _opts;
    public EmailService(IOptions<EmailOptions> opts) => _opts = opts.Value;

    public void Send() => Console.WriteLine("SMTP: " + _opts.SmtpHost + ":" + _opts.Port);
}
```

## ❓ Follow-Up Questions
- **Q: How do environment variables override appsettings?** A: Env vars are loaded after JSON — same key wins. Use double-underscore (__) for hierarchy: Email__SmtpHost.
- **Q: IOptions vs IOptionsSnapshot vs IOptionsMonitor?** A: IOptions = singleton snapshot; IOptionsSnapshot = per-request reloaded; IOptionsMonitor = live-reload with change notification.
- **Q: How do you store secrets in development?** A: dotnet user-secrets set Key Value — stored outside the project, not in source control.

## ⚠️ Common Mistakes
❌ Hardcoding connection strings or secrets in appsettings.json checked into source control.
✅ Use User Secrets in development; environment variables or Azure Key Vault in production. Never commit secrets.

## 🎯 Cheat Sheet
- **Providers:** JSON, env vars, cmd-line, secrets, Key Vault
- **Priority:** later providers override earlier
- **IConfiguration:** key-value, : delimited hierarchy
- **Keywords:** IOptions, IOptionsSnapshot, user secrets, env var override

## 🏢 Industry Experience Answer
"Configuration layering is powerful in practice. Base settings in appsettings.json, environment-specific in appsettings.Production.json, secrets via environment variables injected by the orchestrator (Kubernetes secrets), and service-specific live config via Azure App Configuration. No code changes between environments — just config."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is configuration in ASP.NET Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q12
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
`appsettings.json` is the **default JSON configuration file** loaded at startup with shared base settings. Environment-specific files (`appsettings.Development.json`, `appsettings.Production.json`) override it for each environment. **Environment variables** override all JSON files and are the standard way to inject secrets and deployment-specific config in containers and cloud environments.

## 📖 Detailed Explanation
**appsettings.json:** base config — safe defaults, non-secret settings. Committed to source control.
**appsettings.{env}.json:** loaded when ASPNETCORE_ENVIRONMENT matches. Production.json overrides base.
**Environment variables:** highest priority (after command-line). Use double-underscore for hierarchy: `ConnectionStrings__Default` maps to ConnectionStrings:Default. Injected by Docker/Kubernetes/App Service.
**ASPNETCORE_ENVIRONMENT:** controls which appsettings file loads and enables/disables developer exception pages, etc. Common values: Development, Staging, Production.

## 💻 Code Example
```csharp
// appsettings.json (committed to git)
// { "Logging": { "LogLevel": { "Default": "Information" } }, "AllowedHosts": "*" }

// appsettings.Production.json (committed, no secrets)
// { "Logging": { "LogLevel": { "Default": "Warning" } } }

// Read in code
var connStr = builder.Configuration.GetConnectionString("Default");
var logLevel = builder.Configuration["Logging:LogLevel:Default"];

// Environment variable override (set in deployment)
// ConnectionStrings__Default=Host=prod-db;Database=myapp
// ASPNETCORE_ENVIRONMENT=Production
```

## ❓ Follow-Up Questions
- **Q: Where should secrets go?** A: Never in appsettings.json in source control. Use User Secrets (dev), env vars (prod), or Key Vault.
- **Q: How do you read the current environment?** A: IWebHostEnvironment.EnvironmentName or env.IsProduction() / env.IsDevelopment().
- **Q: What is the hierarchy for env var keys?** A: Double-underscore __ replaces the colon : separator for nested keys.

## ⚠️ Common Mistakes
❌ Putting database passwords or API keys in appsettings.json in the git repo.
✅ Leaked secrets in git history are a critical security incident. Use .gitignore for appsettings.Development.json with secrets, User Secrets for local dev, and env vars/Key Vault for production.

## 🎯 Cheat Sheet
- **appsettings.json:** base, committed
- **appsettings.{env}.json:** env-specific override, committed
- **Env vars:** deployment secrets, highest priority, __ for hierarchy
- **Keywords:** ASPNETCORE_ENVIRONMENT, User Secrets, double-underscore, gitignore

## 🏢 Industry Experience Answer
"Our config strategy: appsettings.json holds defaults and structure (keys present, values safe), Production.json overrides log levels and feature flags, and all secrets (connection strings, API keys) are injected via Kubernetes secrets as environment variables. This means the Docker image is identical across environments — only the env vars differ."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are appsettings.json and environment variables?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q13
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
`IHostedService` is an interface with `StartAsync`/`StopAsync` for background work tied to the host lifetime. `BackgroundService` is an abstract base class implementing `IHostedService` that simplifies long-running background work via the `ExecuteAsync(CancellationToken)` template method — it's the standard choice for background workers.

## 📖 Detailed Explanation
**IHostedService:** must implement StartAsync and StopAsync. Good for tasks that initialise resources at startup and stop them at shutdown.
**BackgroundService:** inherits IHostedService; you only implement ExecuteAsync. The base class handles the start/stop plumbing. ExecuteAsync runs for the lifetime of the service — use a loop with CancellationToken.
**Registration:** AddHostedService<T>() — runs alongside the web server.
**Resilience:** unhandled exceptions in ExecuteAsync stop the worker; use try/catch + retry logic for robustness.

## 💻 Code Example
```csharp
// BackgroundService for polling a queue
public class OrderProcessingWorker : BackgroundService
{
    private readonly ILogger<OrderProcessingWorker> _logger;
    private readonly IServiceProvider _services;  // use scope for Scoped deps

    public OrderProcessingWorker(ILogger<OrderProcessingWorker> logger, IServiceProvider sp)
        => (_logger, _services) = (logger, sp);

    protected override async Task ExecuteAsync(CancellationToken ct)
    {
        while (!ct.IsCancellationRequested)
        {
            using var scope = _services.CreateScope();
            var queue = scope.ServiceProvider.GetRequiredService<IOrderQueue>();

            var order = await queue.DequeueAsync(ct);
            if (order != null)
                await ProcessOrderAsync(order, ct);

            await Task.Delay(TimeSpan.FromSeconds(5), ct);
        }
    }
}

// Register
builder.Services.AddHostedService<OrderProcessingWorker>();
```

## ❓ Follow-Up Questions
- **Q: Can a BackgroundService use Scoped services?** A: Not directly (it's Singleton-lifetime). Create a scope with IServiceProvider.CreateScope() for each unit of work.
- **Q: What happens if ExecuteAsync throws?** A: The hosted service stops. In .NET 8 you can configure the host to stop the app or restart the service.
- **Q: IHostedService vs Worker Service template?** A: Worker Service is a project template for console/background apps; it uses BackgroundService internally.

## ⚠️ Common Mistakes
❌ Injecting a Scoped service (e.g., DbContext) directly into a BackgroundService constructor.
✅ BackgroundService is Singleton — Scoped services injected directly become captive. Create a scope per work unit using IServiceProvider.CreateScope().

## 🎯 Cheat Sheet
- **IHostedService:** StartAsync + StopAsync — full control
- **BackgroundService:** abstract base, only implement ExecuteAsync
- **Register:** AddHostedService<T>()
- **Scoped deps:** use IServiceProvider.CreateScope() per work unit
- **Keywords:** background worker, hosted service, CancellationToken, IServiceScope

## 🏢 Industry Experience Answer
"We use BackgroundService for all our background jobs — queue consumers, scheduled tasks, cache warmers. The key patterns: CancellationToken checked in every loop iteration, IServiceProvider.CreateScope() for each DB operation, and structured logging of each job's start/end/failure. We also wrap ExecuteAsync in a try/catch with exponential backoff so a transient error doesn't stop the whole worker."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between IHostedService and BackgroundService?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q14
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
ASP.NET Core has a built-in, provider-based logging system via `ILogger<T>`. You inject ILogger<T> and call log methods (LogInformation, LogWarning, LogError). Providers (console, debug, EventSource, Serilog, NLog) write the output. Structured logging with message templates and scopes makes logs queryable in tools like Seq, Kibana, or Azure Monitor.

## 📖 Detailed Explanation
**ILogger<T>:** generic interface injected by DI; T is the category (usually the class).
**Log levels:** Trace, Debug, Information, Warning, Error, Critical — filtered by provider and category.
**Structured logging:** `_logger.LogInformation("Order {OrderId} placed by {CustomerId}", orderId, customerId)` — parameters become queryable fields, not just string concatenation.
**Scopes:** `using (_logger.BeginScope("RequestId:{ReqId}", reqId))` — adds context to all log entries within the scope.
**Third-party:** Serilog and NLog are the most popular; they add sinks (file, Elasticsearch, Seq) and enrichers.

## 💻 Code Example
```csharp
public class OrderService
{
    private readonly ILogger<OrderService> _logger;
    public OrderService(ILogger<OrderService> logger) => _logger = logger;

    public async Task PlaceOrderAsync(Order order)
    {
        _logger.LogInformation("Placing order {OrderId} for customer {CustomerId}",
            order.Id, order.CustomerId);
        try
        {
            await SaveOrderAsync(order);
            _logger.LogInformation("Order {OrderId} saved successfully", order.Id);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to place order {OrderId}", order.Id);
            throw;
        }
    }
}
```

## ❓ Follow-Up Questions
- **Q: How do you configure log levels?** A: appsettings.json Logging:LogLevel section — per category, per provider.
- **Q: ILogger vs ILoggerFactory vs ILoggerProvider?** A: ILogger is what you inject; ILoggerFactory creates loggers; ILoggerProvider writes to a specific sink.
- **Q: What is Serilog and why use it?** A: Third-party logger with rich sinks (files, Seq, Elasticsearch), enrichers (thread, machine name), and better structured log support.

## ⚠️ Common Mistakes
❌ Using string concatenation in log messages: LogInformation("Order " + id + " placed").
✅ Use message templates: LogInformation("Order {OrderId} placed", id) — preserves structured properties for querying.

## 🎯 Cheat Sheet
- **Inject:** ILogger<T> via constructor
- **Levels:** Trace < Debug < Information < Warning < Error < Critical
- **Structured:** use {Property} placeholders, not string concat
- **Keywords:** ILogger, structured logging, log level, scope, Serilog, sink

## 🏢 Industry Experience Answer
"We use Serilog with structured logging pushed to Seq in development and Elasticsearch in production. The game-changer is structured properties — searching logs for 'OrderId = 12345' across thousands of entries is instant. Without structured logging you're grep-ing through text. We also add correlation IDs via middleware scope so every log entry in a request is linkable."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is logging in ASP.NET Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q15
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Minimal APIs (.NET 6+) let you define HTTP endpoints **directly in Program.cs** with `app.MapGet/Post/Put/Delete()` — no controllers, no attributes, minimal ceremony. They're ideal for microservices, AWS Lambda functions, and simple APIs. They have full access to DI, middleware, filters, and OpenAPI.

## 📖 Detailed Explanation
**Motivation:** remove controller/action overhead for small APIs; improve performance (fewer abstractions); enable a more functional style.
**Route handlers:** can be lambdas, local functions, or method group references. Parameters are automatically bound from route, query, body, services, or HttpContext.
**Groups:** `app.MapGroup("/api/orders")` — prefix and share middleware for related endpoints.
**Filters:** `app.MapGet(...)..AddEndpointFilter<T>()` — replaces action filters.
**Performance:** marginally faster than controllers due to fewer abstraction layers; same async/await support.

## 💻 Code Example
```csharp
var builder = WebApplication.CreateBuilder(args);
builder.Services.AddScoped<IOrderService, OrderService>();
var app = builder.Build();

// Simple endpoint
app.MapGet("/api/orders/{id:int}", async (int id, IOrderService svc) =>
{
    var order = await svc.GetAsync(id);
    return order is null ? Results.NotFound() : Results.Ok(order);
});

// Group with shared prefix
var orders = app.MapGroup("/api/orders").RequireAuthorization();
orders.MapGet("/", async (IOrderService svc) => Results.Ok(await svc.GetAllAsync()));
orders.MapPost("/", async (CreateOrderDto dto, IOrderService svc) =>
{
    var created = await svc.CreateAsync(dto);
    return Results.Created("/api/orders/" + created.Id, created);
});

app.Run();
```

## ❓ Follow-Up Questions
- **Q: Minimal APIs vs Controllers — which is better?** A: Minimal for small/simple; controllers for complex apps with many endpoints, filters, versioning, and team conventions.
- **Q: Do minimal APIs support OpenAPI/Swagger?** A: Yes — builder.Services.AddEndpointsApiExplorer() + AddSwaggerGen().
- **Q: Can they use model validation?** A: Not automatically — use FluentValidation or manual validation with Results.ValidationProblem().

## ⚠️ Common Mistakes
❌ Putting all 50 endpoints inline in Program.cs without organization.
✅ Use MapGroup, extension methods (app.MapOrderEndpoints()), or separate endpoint files to keep Program.cs readable.

## 🎯 Cheat Sheet
- **MapGet/Post/Put/Delete:** define endpoints inline
- **Parameters:** auto-bound from route, query, body, DI, HttpContext
- **MapGroup:** prefix + shared middleware for related endpoints
- **Keywords:** minimal API, Results, MapGroup, endpoint filter, .NET 6

## 🏢 Industry Experience Answer
"We use minimal APIs for our lighter microservices and Azure Functions. For services with 5-10 endpoints, the reduction in boilerplate is significant — no controller classes, no action attributes. For our larger services with 50+ endpoints, versioning, and complex filters, we stick to controllers — they're more organised at scale."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are minimal APIs in .NET 6+?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q16
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
`HttpClientFactory` manages the lifecycle of `HttpClient` instances — pooling `HttpMessageHandler` connections to avoid socket exhaustion, while providing fresh `HttpClient` instances per use to avoid stale DNS. Never use `new HttpClient()` in long-running apps; always use `IHttpClientFactory` or typed clients registered in DI.

## 📖 Detailed Explanation
**Problem 1 — socket exhaustion:** `new HttpClient()` and `Dispose()` per request doesn't close the underlying TCP socket immediately — TIME_WAIT state exhausts sockets under load.
**Problem 2 — DNS staleness:** a singleton HttpClient caches DNS — won't pick up DNS changes (e.g., failover).
**HttpClientFactory solution:** pools the underlying HttpMessageHandler (reuses TCP connections); creates a fresh HttpClient per request (no DNS staleness). Best of both worlds.
**Registration types:**
- **Basic:** `services.AddHttpClient()` — use IHttpClientFactory.CreateClient()
- **Named:** `AddHttpClient("PaymentApi", c => c.BaseAddress = ...)` — create by name
- **Typed:** `AddHttpClient<PaymentServiceClient>()` — injected directly

## 💻 Code Example
```csharp
// Typed client (preferred)
public class PaymentClient
{
    private readonly HttpClient _client;
    public PaymentClient(HttpClient client) => _client = client;

    public async Task<bool> ChargeAsync(decimal amount)
    {
        var response = await _client.PostAsJsonAsync("/charge", new { amount });
        return response.IsSuccessStatusCode;
    }
}

// Register in Program.cs
builder.Services.AddHttpClient<PaymentClient>(c =>
{
    c.BaseAddress = new Uri("https://api.payments.com");
    c.DefaultRequestHeaders.Add("X-Api-Key", "secret");
});

// Inject and use
public class OrderService
{
    private readonly PaymentClient _payment;
    public OrderService(PaymentClient payment) => _payment = payment;
}
```

## ❓ Follow-Up Questions
- **Q: Why not a singleton HttpClient?** A: Solves socket exhaustion but causes DNS staleness — won't pick up DNS changes after startup.
- **Q: What is Polly integration with HttpClientFactory?** A: AddHttpClient(...).AddTransientHttpErrorPolicy(p => p.RetryAsync(3)) — retry, circuit breaker, timeout policies.
- **Q: What is HttpMessageHandler?** A: The pipeline component that sends HTTP requests; the factory pools and recycles these while clients are short-lived.

## ⚠️ Common Mistakes
❌ `new HttpClient()` in a class constructor or inside a method body.
✅ Register a typed client with AddHttpClient<T>() and inject it. The factory manages the handler lifetime.

## 🎯 Cheat Sheet
- **Problem:** socket exhaustion (new+dispose) vs DNS staleness (singleton)
- **Factory:** pools handlers, fresh clients — solves both
- **Types:** Basic, Named, Typed (prefer typed for DI)
- **Keywords:** HttpMessageHandler, socket exhaustion, DNS staleness, Polly, IHttpClientFactory

## 🏢 Industry Experience Answer
"We hit socket exhaustion on a high-traffic service using new HttpClient() per call — ran out of sockets under load and got connection refused errors. Switching to typed clients via HttpClientFactory + Polly retry policies fixed it. Now every external HTTP dependency is a typed client with retry, circuit breaker, and timeout — configured centrally."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is HttpClientFactory and why use it instead of new HttpClient()?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q17
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
The `IOptions<T>` pattern provides **strongly-typed, DI-friendly access to configuration sections**. You bind a section to a POCO class, register it with `Configure<T>`, and inject `IOptions<T>` to access settings as a typed object — no magic strings, refactor-safe, and supports validation via DataAnnotations.

## 📖 Detailed Explanation
**Three variants:**
- **IOptions<T>:** registered as Singleton; reads config once at startup. Does not reflect changes.
- **IOptionsSnapshot<T>:** Scoped; re-reads config per request — supports reloadOnChange.
- **IOptionsMonitor<T>:** Singleton with change notification; use OnChange() to react to live config changes.
**Validation:** add `ValidateDataAnnotations()` and `ValidateOnStart()` to catch config errors at startup rather than at runtime.

## 💻 Code Example
```csharp
// Config class with validation
public class SmtpOptions
{
    [Required] public string Host { get; set; }
    [Range(1, 65535)] public int Port { get; set; }
    [Required] public string FromAddress { get; set; }
}

// Register with validation
builder.Services.AddOptions<SmtpOptions>()
    .BindConfiguration("Smtp")
    .ValidateDataAnnotations()
    .ValidateOnStart();          // fail fast at startup

// Inject and use
public class EmailService
{
    private readonly SmtpOptions _opts;
    public EmailService(IOptions<SmtpOptions> opts) => _opts = opts.Value;

    public void Send(string to, string body)
        => Console.WriteLine("Sending via " + _opts.Host + ":" + _opts.Port);
}

// appsettings.json:
// { "Smtp": { "Host": "smtp.example.com", "Port": 587, "FromAddress": "noreply@example.com" } }
```

## ❓ Follow-Up Questions
- **Q: IOptions vs IOptionsSnapshot?** A: IOptions = singleton (reads once); IOptionsSnapshot = per-request reload.
- **Q: How do you validate config at startup?** A: .ValidateDataAnnotations().ValidateOnStart() — throws on startup if config is invalid.
- **Q: Can you have multiple option classes?** A: Yes — one per config section, each bound separately.

## ⚠️ Common Mistakes
❌ Injecting IConfiguration directly into services and reading keys with magic strings.
✅ Use IOptions<T> — typed, refactor-safe, validated. Magic strings are a maintenance burden and fail silently.

## 🎯 Cheat Sheet
- **IOptions<T>:** singleton, read once at startup
- **IOptionsSnapshot<T>:** scoped, per-request reload
- **IOptionsMonitor<T>:** singleton + live change notification
- **ValidateOnStart:** fail fast on bad config
- **Keywords:** strongly-typed config, BindConfiguration, ValidateDataAnnotations

## 🏢 Industry Experience Answer
"IOptions<T> with ValidateOnStart is one of my favourite patterns. We validate all config sections at startup — the app refuses to start if SMTP host is missing or a port is out of range. This turns runtime config bugs into immediate startup failures, which are caught in deployment, not in production at 3am."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is the IOptions<T> pattern and how does it work?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q18
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Health checks expose an endpoint (`/health`) that reports the **liveness and readiness** of your application and its dependencies (DB, cache, external APIs). Kubernetes, load balancers, and monitoring systems use this endpoint to decide whether to route traffic or restart the pod. ASP.NET Core has a built-in health check framework via `AddHealthChecks()`.

## 📖 Detailed Explanation
**Liveness:** is the app alive (not crashed/deadlocked)? → restart if unhealthy.
**Readiness:** is the app ready to serve traffic (DB connected, warmup done)? → remove from load balancer if not ready.
**Response:** Healthy / Degraded / Unhealthy.
**Built-in checks:** EF Core DB ping, SQL Server, Redis, RabbitMQ (via NuGet packages).
**Custom checks:** implement `IHealthCheck` with `CheckHealthAsync`.

## 💻 Code Example
```csharp
// Register
builder.Services.AddHealthChecks()
    .AddDbContextCheck<AppDbContext>("database")          // EF Core check
    .AddUrlGroup(new Uri("https://api.payment.com/ping"), "payment-api")
    .AddCheck<CustomBusinessRuleCheck>("business-rules");

// Map endpoints
app.MapHealthChecks("/health/live", new HealthCheckOptions
{
    Predicate = _ => false   // liveness: always healthy if app is running
});
app.MapHealthChecks("/health/ready", new HealthCheckOptions
{
    Predicate = check => check.Tags.Contains("ready")    // readiness: only DB etc.
});

// Custom check
public class CustomBusinessRuleCheck : IHealthCheck
{
    public Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext ctx, CancellationToken ct)
    {
        var isHealthy = /* check something */ true;
        return Task.FromResult(isHealthy
            ? HealthCheckResult.Healthy("All good")
            : HealthCheckResult.Unhealthy("Rule violation detected"));
    }
}
```

## ❓ Follow-Up Questions
- **Q: Liveness vs readiness?** A: Liveness = app alive (restart on fail); Readiness = app can serve traffic (remove from LB on fail).
- **Q: What format is the health check response?** A: JSON with status and component details (from HealthCheckOptions.ResponseWriter).
- **Q: What NuGet packages add built-in checks?** A: AspNetCore.HealthChecks.SqlServer, .NpgSql, .Redis, .RabbitMq, .Elasticsearch.

## ⚠️ Common Mistakes
❌ Using a single /health endpoint for both liveness and readiness.
✅ Separate them — a slow DB making readiness fail shouldn't trigger a pod restart (liveness action). Two endpoints, two different Kubernetes probe targets.

## 🎯 Cheat Sheet
- **Liveness:** is the app alive? Restart if fails.
- **Readiness:** can it serve traffic? Remove from LB if fails.
- **Register:** AddHealthChecks() + specific check packages
- **Keywords:** IHealthCheck, Healthy/Degraded/Unhealthy, Kubernetes probes, /health

## 🏢 Industry Experience Answer
"Health checks saved us from serving errors after a database failover. Readiness probes pulled the pod from rotation until the new DB connection was established, so no traffic hit the pod during the reconnect window. We have separate /health/live (always 200 if app is up) and /health/ready (checks DB + Redis + downstream APIs) configured in our Kubernetes deployment manifests."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are health checks in ASP.NET Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q19
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**Response caching** adds HTTP cache headers (`Cache-Control`, `Vary`) so clients and CDN/proxies cache the response. **Output caching** (.NET 7+) is server-side — ASP.NET Core stores the response in memory/distributed cache and serves it without executing the action again. Output caching is more powerful: works regardless of client headers and supports tags and invalidation.

## 📖 Detailed Explanation
**Response caching:** sends `Cache-Control: public, max-age=60`. Relies on client/CDN honouring headers. Server still processes every request from clients that bypass cache.
**Output caching (.NET 7+):** server stores the output; requests that match cached keys get the stored response immediately — zero action execution. Supports Redis for distributed caching, tag-based invalidation.
**When to use:** response caching for CDN/client-level caching (static/semi-static content); output caching for server-side CPU savings (expensive DB queries, aggregations).

## 💻 Code Example
```csharp
// Response caching
builder.Services.AddResponseCaching();
app.UseResponseCaching();

[HttpGet("products")]
[ResponseCache(Duration = 60, VaryByQueryKeys = new[] { "category" })]
public async Task<IActionResult> GetProducts(string category) => Ok(await _svc.GetAsync(category));

// Output caching (.NET 7+)
builder.Services.AddOutputCache(o =>
{
    o.AddPolicy("Products", p => p.Cache().Expire(TimeSpan.FromMinutes(5)).Tag("products"));
});
app.UseOutputCache();

[HttpGet("products")]
[OutputCache(PolicyName = "Products")]
public async Task<IActionResult> GetProducts() => Ok(await _svc.GetAsync());

// Invalidate by tag (e.g., after update)
await cache.EvictByTagAsync("products", ct);
```

## ❓ Follow-Up Questions
- **Q: Which is newer and more powerful?** A: Output caching (.NET 7+) — server-side, tag invalidation, distributed cache support.
- **Q: Does output caching bypass action filters?** A: Yes — on a cache hit, the action and its filters don't run.
- **Q: What varies the cache key?** A: By default, URL path + query string; configurable with VaryBy* methods.

## ⚠️ Common Mistakes
❌ Caching responses that vary by user/auth token without VaryByHeader("Authorization").
✅ Cached responses can leak data between users. Always vary by auth headers or use output cache policies that exclude authenticated responses.

## 🎯 Cheat Sheet
- **Response caching:** HTTP headers, client/CDN-side
- **Output caching:** server-side, action skipped on hit, tag invalidation
- **Keywords:** Cache-Control, Vary, EvictByTag, IOutputCacheStore, .NET 7

## 🏢 Industry Experience Answer
"We use output caching for our product catalogue — expensive JOIN queries that rarely change. Tag invalidation is the key feature: when a product is updated, we call EvictByTag('products') and the next request rebuilds the cache. Response caching we use only for public CDN-friendly endpoints where client-side caching is intentional."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is output caching vs response caching?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q20
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Rate limiting (.NET 7+) restricts the number of requests a client can make in a time window, protecting APIs from abuse and overload. ASP.NET Core's built-in `AddRateLimiter` supports four algorithms: **Fixed Window**, **Sliding Window**, **Token Bucket**, and **Concurrency Limiter** — applied globally or per endpoint.

## 📖 Detailed Explanation
**Fixed window:** N requests per time window (e.g., 100/minute). Simple; can have burst at window boundary.
**Sliding window:** smoother — distributes N requests across N segments of the window.
**Token bucket:** refills tokens at a rate; allows short bursts up to the bucket size. Most natural for APIs.
**Concurrency limiter:** max N concurrent requests at a time (not rate, but parallelism).
**Partitioned limiters:** different limits per user, IP, or API key via GetLimiter(context) factory.

## 💻 Code Example
```csharp
builder.Services.AddRateLimiter(o =>
{
    // Global fixed window: 100 req/min
    o.GlobalLimiter = PartitionedRateLimiter.Create<HttpContext, string>(ctx =>
        RateLimitPartition.GetFixedWindowLimiter(
            partitionKey: ctx.User?.Identity?.Name ?? ctx.Connection.RemoteIpAddress?.ToString() ?? "anon",
            factory: _ => new FixedWindowRateLimiterOptions
            {
                PermitLimit = 100,
                Window = TimeSpan.FromMinutes(1),
                QueueProcessingOrder = QueueProcessingOrder.OldestFirst,
                QueueLimit = 5
            }));

    o.RejectionStatusCode = 429;   // Too Many Requests
});

app.UseRateLimiter();

// Per-endpoint policy
[EnableRateLimiting("upload")]
public IActionResult UploadFile(IFormFile file) => Ok();
```

## ❓ Follow-Up Questions
- **Q: Which algorithm for API throttling?** A: Token bucket — allows short bursts while enforcing a long-term rate.
- **Q: What status code on rejection?** A: 429 Too Many Requests, optionally with Retry-After header.
- **Q: Can you limit by user/IP?** A: Yes — use PartitionedRateLimiter.Create with a partition key based on user identity or IP.

## ⚠️ Common Mistakes
❌ Implementing rate limiting only at the application level for distributed services.
✅ In multi-instance deployments, in-memory rate limiters count per instance. Use a distributed rate limiter backed by Redis for consistent limits across all instances.

## 🎯 Cheat Sheet
- **Algorithms:** Fixed Window, Sliding Window, Token Bucket, Concurrency
- **Partitioned:** limit per user/IP/key
- **Status:** 429 Too Many Requests
- **Keywords:** AddRateLimiter, PermitLimit, Window, RejectionStatusCode, distributed

## 🏢 Industry Experience Answer
"We added rate limiting after a partner accidentally hammered our API with a bug in their integration — 10,000 requests/second, took down our DB. Now every public endpoint has token bucket limiting per API key. For the actual distributed enforcement we back it with Redis so all pods share the same counters. The 429 response includes a Retry-After header so well-behaved clients back off gracefully."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is rate limiting in ASP.NET Core 7+?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q21
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Action results are objects returned from controller actions that determine **what HTTP response is sent** — status code, headers, and body. ASP.NET Core provides factory methods (`Ok()`, `NotFound()`, `BadRequest()`, `Created()`, etc.) via `ControllerBase` that return typed `IActionResult` implementations for clean, semantic responses.

## 📖 Detailed Explanation
**Common action results:**
- `Ok(value)` → 200 with serialized body
- `Created(uri, value)` → 201 with Location header
- `CreatedAtAction(actionName, routeValues, value)` → 201 with generated Location
- `NoContent()` → 204
- `BadRequest(modelState/object)` → 400
- `Unauthorized()` → 401
- `Forbid()` → 403
- `NotFound()` → 404
- `Conflict(object)` → 409
- `UnprocessableEntity(errors)` → 422
- `StatusCode(code, value)` → custom code
- `File(bytes, contentType)` → file download

## 💻 Code Example
```csharp
[ApiController]
[Route("api/orders")]
public class OrdersController : ControllerBase
{
    [HttpGet("{id:int}")]
    public async Task<ActionResult<OrderDto>> GetById(int id)
    {
        var order = await _svc.GetAsync(id);
        if (order is null) return NotFound();                // 404
        return Ok(order);                                    // 200
    }

    [HttpPost]
    public async Task<ActionResult<OrderDto>> Create(CreateOrderDto dto)
    {
        var order = await _svc.CreateAsync(dto);
        return CreatedAtAction(nameof(GetById), new { id = order.Id }, order);  // 201
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var deleted = await _svc.DeleteAsync(id);
        return deleted ? NoContent() : NotFound();           // 204 or 404
    }
}
```

## ❓ Follow-Up Questions
- **Q: IActionResult vs ActionResult<T>?** A: ActionResult<T> is generic — carries type info for OpenAPI and allows returning either T or an IActionResult.
- **Q: What is ProblemDetails?** A: RFC 7807-compliant error response format. [ApiController] returns ProblemDetails automatically for 400/404/etc.
- **Q: How do you return a file?** A: File(bytes, contentType, fileName) or PhysicalFile/VirtualFile for disk files.

## ⚠️ Common Mistakes
❌ Returning 200 OK for created resources.
✅ Return 201 Created with a Location header pointing to the new resource — it's the correct REST semantic.

## 🎯 Cheat Sheet
- **200:** Ok(value) — success with body
- **201:** Created/CreatedAtAction — resource created
- **204:** NoContent() — success, no body
- **400:** BadRequest() — client error
- **404:** NotFound() — resource missing
- **Keywords:** IActionResult, ActionResult<T>, ProblemDetails, REST semantics

## 🏢 Industry Experience Answer
"Using the right action result matters for API consumers. A frontend that sees 200 on a create assumes update semantics; 201 tells it a new resource was created with a URL in Location. We use CreatedAtAction everywhere for creates — it generates the correct Location header automatically from the route, no string formatting needed."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are action results and what types does ASP.NET Core provide?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q22
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
`AddScoped` creates one instance per HTTP request; `AddTransient` creates a new instance every time it's requested from the container; `AddSingleton` creates one instance for the entire application lifetime. This is the same as the lifetimes question reframed as DI registration methods — choosing the wrong one causes bugs from stale data to memory leaks.

## 📖 Detailed Explanation
**AddTransient:** new instance each injection. Good for lightweight, stateless services. Slightly more allocation overhead. Safe to depend on anything.
**AddScoped:** one instance per DI scope (= one per HTTP request in web apps). All injections within the same request get the same instance — perfect for DbContext, repositories, Unit of Work.
**AddSingleton:** one instance forever. Must be thread-safe since all requests share it. Good for caches, configuration wrappers, HttpClientFactory internals, expensive-to-create resources.
**Captive dependency:** Singleton → Scoped causes the Scoped service to live forever. ASP.NET Core's scope validation (enabled in dev) throws InvalidOperationException.

## 💻 Code Example
```csharp
builder.Services.AddTransient<IEmailValidator, EmailValidator>();    // new every call
builder.Services.AddScoped<IOrderRepository, OrderRepository>();     // per request
builder.Services.AddScoped<AppDbContext>();                          // per request (default)
builder.Services.AddSingleton<ICache, InMemoryCache>();              // app lifetime
builder.Services.AddSingleton<IConfiguration>(builder.Configuration); // app lifetime

// Verify the scope with a quick test
builder.Services.AddScoped<Guid>(sp => Guid.NewGuid());  // same Guid within one request

// Captive dependency — DO NOT DO
builder.Services.AddSingleton<BadSvc>(sp =>
    new BadSvc(sp.GetRequiredService<IOrderRepository>())); // captures Scoped forever!
```

## ❓ Follow-Up Questions
- **Q: What is scope validation?** A: In Development, ASP.NET Core throws if a Singleton resolves a Scoped or Transient dependency — catches captive dependency bugs at startup.
- **Q: Can you resolve services manually?** A: Yes — IServiceProvider.GetService<T>() or GetRequiredService<T>(). Prefer constructor injection.
- **Q: How do background services use Scoped services?** A: Create a manual scope: IServiceProvider.CreateScope().ServiceProvider.GetRequiredService<T>().

## ⚠️ Common Mistakes
❌ AddSingleton<IMyService, MyService>() when MyService uses DbContext.
✅ DbContext is Scoped — a Singleton capturing it holds the same context forever (thread-unsafe, stale). Register MyService as Scoped instead.

## 🎯 Cheat Sheet
- **Transient:** new every injection — stateless, lightweight
- **Scoped:** one per request — DbContext, repositories
- **Singleton:** one forever — caches, config, thread-safe only
- **Keywords:** captive dependency, scope validation, IServiceScope, lifetime mismatch

## 🏢 Industry Experience Answer
"Lifetime mismatch is one of the most common DI bugs I see. The tell-tale sign: a singleton service that gives stale or incorrect data after the first request, or a DbContext that shares state across concurrent requests. The fix is always the same: make the service Scoped, or if it must be Singleton, inject IServiceProvider and create a scope per operation."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between AddScoped, AddTransient, and AddSingleton?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- End of Batch 3 — ASP.NET Core COMPLETE (Q1–Q22)
-- Next: devready_batch04_ef_core.sql (Section 4, Q1–Q18)

-- ════════════════════════════════════════════════════════════
-- DevReady Seed — Batch 4
-- .NET › 4️⃣ Entity Framework Core › Q1–Q18
-- Dollar-quote safe (zero $ inside content). Idempotent upsert.
-- ════════════════════════════════════════════════════════════

-- Q1
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Entity Framework Core (EF Core) is Microsoft's **open-source ORM (Object-Relational Mapper)** for .NET. It lets you work with a relational database using .NET objects — no raw SQL required for most operations. It supports Code-First, Database-First, and raw SQL, runs on multiple providers (SQL Server, PostgreSQL, SQLite, MySQL), and integrates natively with ASP.NET Core DI.

## 📖 Detailed Explanation
**What it does:** maps C# entity classes to database tables, translates LINQ queries to SQL, tracks changes, and manages migrations.
**Key components:** DbContext (unit of work + session), DbSet<T> (repository abstraction per entity), migrations (schema versioning), change tracker (detects what changed).
**Providers:** Microsoft.EntityFrameworkCore.SqlServer, Npgsql.EntityFrameworkCore.PostgreSQL, EF Core SQLite, Pomelo.MySQL, etc.
**EF Core vs EF6:** EF Core is the modern, cross-platform rewrite — faster, more features (compiled queries, raw SQL mapping, temporal tables), but some EF6 features were removed (lazy loading by default, some query patterns).

## 💻 Code Example
```csharp
// Entity
public class Order
{
    public int Id { get; set; }
    public string CustomerId { get; set; }
    public decimal Total { get; set; }
    public List<OrderItem> Items { get; set; } = new();
}

// DbContext
public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }
    public DbSet<Order> Orders { get; set; }
}

// Registration
builder.Services.AddDbContext<AppDbContext>(o =>
    o.UseNpgsql(builder.Configuration.GetConnectionString("Default")));

// Usage
var orders = await _ctx.Orders
    .Where(o => o.Total > 100m)
    .Include(o => o.Items)
    .ToListAsync();
```

## ❓ Follow-Up Questions
- **Q: EF Core vs Dapper?** A: EF Core: full ORM, migrations, change tracking — productive for CRUD. Dapper: micro-ORM, raw SQL mapped to objects — faster for complex queries.
- **Q: What is the N+1 problem in EF Core?** A: Loading a collection without Include causes one SQL query per item. Fix: use Include/ThenInclude or split queries.
- **Q: Is EF Core production-ready?** A: Absolutely — used in large-scale production systems. Version 8 adds significant performance improvements.

## ⚠️ Common Mistakes
❌ Loading all columns with Select(*) when you only need a few.
✅ Project to DTOs with Select(o => new OrderDto { ... }) — reduces data transfer and memory use.

## 🎯 Cheat Sheet
- **ORM:** C# classes → DB tables, LINQ → SQL
- **Key parts:** DbContext, DbSet, migrations, change tracker
- **Providers:** SQL Server, PostgreSQL, SQLite, MySQL
- **Keywords:** ORM, LINQ-to-SQL, migrations, change tracking, DbContext

## 🏢 Industry Experience Answer
"EF Core handles about 80% of our data access through clean LINQ queries. For complex reporting with multiple joins and aggregations, we drop to raw SQL or Dapper. The migration system is a huge productivity win — schema changes are code-reviewed, versioned in git, and applied safely in CI/CD pipelines."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Entity Framework Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q2
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Code-First means you **define your database schema via C# entity classes and DbContext** — EF Core generates the SQL schema from your code. You use migrations to apply schema changes incrementally. Code-First is the default and recommended approach for new projects — schema is version-controlled in C#, not in the database.

## 📖 Detailed Explanation
**Workflow:** write entity classes → configure via Fluent API or DataAnnotations → run `dotnet ef migrations add MigrationName` → `dotnet ef database update`.
**Fluent API:** `modelBuilder.Entity<Order>().HasKey(o => o.Id)` — fine-grained configuration in `OnModelCreating`.
**DataAnnotations:** `[Required]`, `[MaxLength(200)]`, `[Column("order_total")]` — declarative, simpler but less powerful.
**Benefits:** schema is code — reviewed, tested, versioned in git, applied automatically in CI/CD.

## 💻 Code Example
```csharp
// Entity with annotations
public class Product
{
    public int Id { get; set; }
    [Required, MaxLength(200)] public string Name { get; set; }
    [Column(TypeName = "decimal(18,2)")] public decimal Price { get; set; }
}

// Fluent API configuration (preferred for complex scenarios)
protected override void OnModelCreating(ModelBuilder mb)
{
    mb.Entity<Order>(e =>
    {
        e.ToTable("orders");
        e.HasKey(o => o.Id);
        e.Property(o => o.Total).HasPrecision(18, 2).IsRequired();
        e.HasMany(o => o.Items).WithOne(i => i.Order).HasForeignKey(i => i.OrderId);
        e.HasIndex(o => o.CustomerId);
    });
}

// Add migration and apply
// dotnet ef migrations add AddOrderTable
// dotnet ef database update
```

## ❓ Follow-Up Questions
- **Q: Annotations vs Fluent API?** A: Fluent API is more powerful and doesn't pollute domain entities with infrastructure attributes. Preferred for clean architecture.
- **Q: What does `dotnet ef migrations add` do?** A: Generates a C# migration class with Up() and Down() methods for the schema change.
- **Q: How do you apply migrations in production?** A: Either `dotnet ef database update` in CI or `context.Database.MigrateAsync()` at app startup.

## ⚠️ Common Mistakes
❌ Calling Database.EnsureCreated() instead of using migrations.
✅ EnsureCreated creates the schema once but doesn't track migrations — you can't evolve the schema. Use migrations from day one.

## 🎯 Cheat Sheet
- **Code-First:** C# → DB schema via migrations
- **Annotations:** [Required], [MaxLength], [Column] — simple
- **Fluent API:** OnModelCreating — powerful, clean
- **Commands:** dotnet ef migrations add, dotnet ef database update

## 🏢 Industry Experience Answer
"We use Code-First with Fluent API configured in separate IEntityTypeConfiguration<T> classes — one per entity. This keeps OnModelCreating clean and the DB config colocated with the entity. Migrations are generated on feature branches, reviewed as code, and applied automatically in our deployment pipeline before the app starts."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Code-First approach?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q3
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Database-First means you **start with an existing database and scaffold entity classes from it** using `dotnet ef dbcontext scaffold`. EF Core generates the DbContext and entity classes from the live schema. Useful for legacy databases you don't own — but regenerating overwrites customizations, so partial classes or separate files are needed.

## 📖 Detailed Explanation
**Workflow:** existing DB → run scaffold command → generated entity/DbContext C# classes → work with generated code.
**Scaffold command:** `dotnet ef dbcontext scaffold "ConnectionString" Microsoft.EntityFrameworkCore.SqlServer -o Models --no-onconfiguring`
**When to use:** integrating with a legacy database schema you don't control; database is the source of truth.
**Limitations:** regenerating replaces custom code. Workaround: use partial classes to add logic without touching generated files.
**Code-First vs DB-First:** Code-First = C# drives schema; Database-First = DB drives C# classes. Prefer Code-First for new projects.

## 💻 Code Example
```csharp
// Run scaffold (generates models from existing DB)
// dotnet ef dbcontext scaffold "Host=localhost;Database=legacy" Npgsql.EntityFrameworkCore.PostgreSQL
//   -o Models --no-onconfiguring --force

// Generated entity (do not edit — will be overwritten)
public partial class Order    // partial allows extension
{
    public int Id { get; set; }
    public string CustomerId { get; set; }
}

// Your additions in a separate file (safe from regen)
public partial class Order
{
    public string DisplayName => "Order #" + Id + " - " + CustomerId;
}
```

## ❓ Follow-Up Questions
- **Q: Does scaffold generate migrations?** A: No — scaffolding creates classes from the DB; migrations are for Code-First.
- **Q: How do you handle schema changes with Database-First?** A: Re-run scaffold with --force; customizations in partial classes survive.
- **Q: Can you mix Code-First and Database-First?** A: You can scaffold then switch to Code-First migrations, but it requires careful baseline setup.

## ⚠️ Common Mistakes
❌ Editing scaffolded files directly.
✅ Any edits in scaffolded files are lost on re-scaffold. Use partial classes for customizations.

## 🎯 Cheat Sheet
- **Command:** dotnet ef dbcontext scaffold
- **Use case:** existing/legacy database, DB is source of truth
- **Problem:** regen overwrites custom code
- **Solution:** partial classes for safe customization
- **Keywords:** scaffold, reverse engineering, legacy DB, partial class

## 🏢 Industry Experience Answer
"Database-First is our approach for the one legacy system we integrate with — a 15-year-old schema we don't own. We scaffold once, put all customizations in partial classes, and re-scaffold when the schema changes. For all new services we use Code-First — it's much cleaner and schema is part of the code review."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Database-First approach?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q4
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Migrations are **versioned, incremental schema change scripts** generated by EF Core when your model changes. Each migration has an `Up()` (apply) and `Down()` (rollback) method. They're C# files committed to source control, reviewed like code, and applied to the database via `dotnet ef database update` or programmatically at startup.

## 📖 Detailed Explanation
**Workflow:** change entity → add migration → review generated SQL → apply.
**`dotnet ef migrations add <Name>`:** compares current model against the last migration snapshot, generates a diff as a C# migration class.
**`dotnet ef database update`:** applies all pending migrations in order.
**Snapshot:** `ModelSnapshot.cs` — EF's record of the model state; don't delete it.
**Production strategies:**
- Apply via `context.Database.MigrateAsync()` at startup (simple, works for most cases).
- Generate SQL scripts (`dotnet ef migrations script`) and apply via DBA/CI pipeline.

## 💻 Code Example
```csharp
// 1. Change your entity
public class Order
{
    public int Id { get; set; }
    public string CustomerId { get; set; }
    public DateTime CreatedAt { get; set; }  // added new column
}

// 2. Generate migration
// dotnet ef migrations add AddCreatedAtToOrder

// Generated migration class:
public partial class AddCreatedAtToOrder : Migration
{
    protected override void Up(MigrationBuilder mb)
    {
        mb.AddColumn<DateTime>("CreatedAt", "Orders", nullable: false, defaultValue: DateTime.UtcNow);
    }
    protected override void Down(MigrationBuilder mb)
    {
        mb.DropColumn("CreatedAt", "Orders");
    }
}

// 3. Apply at startup (common approach)
using var scope = app.Services.CreateScope();
await scope.ServiceProvider.GetRequiredService<AppDbContext>().Database.MigrateAsync();
```

## ❓ Follow-Up Questions
- **Q: What happens if you delete a migration that's been applied?** A: The DB is ahead of EF's model — dangerous. Always roll back first (update to previous migration), then delete.
- **Q: How do you generate a SQL script for production?** A: dotnet ef migrations script --idempotent -o migration.sql — idempotent applies only pending migrations.
- **Q: What is the migrations history table?** A: __EFMigrationsHistory — EF records which migrations have been applied.

## ⚠️ Common Mistakes
❌ Editing the generated migration file heavily after creation.
✅ Light edits (adding a seed, adjusting a column default) are fine. Heavy changes indicate the model configuration is wrong — fix the entity/Fluent API and regenerate.

## 🎯 Cheat Sheet
- **Add:** dotnet ef migrations add Name
- **Apply:** dotnet ef database update / Database.MigrateAsync()
- **Script:** dotnet ef migrations script --idempotent
- **Keywords:** Up/Down, ModelSnapshot, __EFMigrationsHistory, idempotent

## 🏢 Industry Experience Answer
"Migrations are code — every schema change goes through a pull request and gets reviewed. We never run migrations manually; our CI/CD pipeline generates an idempotent SQL script, a DBA reviews it for large tables, and it runs automatically before deployment. MigrateAsync() at startup is our fallback for smaller services where that's appropriate."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are migrations?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q5
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
`DbContext` is the central class in EF Core — it represents a **session with the database** and acts as both a **Unit of Work** (tracks all changes in one transaction) and a **Repository factory** (provides DbSet<T> for each entity). You interact with the database through DbContext: query, add, update, delete, and save changes.

## 📖 Detailed Explanation
**What it manages:** a DB connection, change tracker (all pending changes), cached entities, and transactions.
**Lifetime:** should be Scoped (per HTTP request) — never Singleton (not thread-safe) or Transient (multiple change-tracking sessions in one request).
**Key methods:** SaveChanges() / SaveChangesAsync() — flushes all tracked changes in a transaction.
**Configuration:** override OnModelCreating to configure entities; DbContextOptions injected via constructor for DI.
**Pooling:** AddDbContextPool<T> reuses DbContext instances for performance — good for high-throughput APIs.

## 💻 Code Example
```csharp
public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<Order> Orders { get; set; }
    public DbSet<Customer> Customers { get; set; }

    protected override void OnModelCreating(ModelBuilder mb)
    {
        mb.ApplyConfigurationsFromAssembly(typeof(AppDbContext).Assembly);
    }

    // Audit: auto-set CreatedAt/UpdatedAt
    public override async Task<int> SaveChangesAsync(CancellationToken ct = default)
    {
        foreach (var entry in ChangeTracker.Entries<AuditableEntity>())
        {
            if (entry.State == EntityState.Added)
                entry.Entity.CreatedAt = DateTime.UtcNow;
            if (entry.State is EntityState.Added or EntityState.Modified)
                entry.Entity.UpdatedAt = DateTime.UtcNow;
        }
        return await base.SaveChangesAsync(ct);
    }
}
```

## ❓ Follow-Up Questions
- **Q: Should DbContext be Singleton?** A: Never — it's not thread-safe and holds a DB connection. Scoped = one per request.
- **Q: What is DbContextPool?** A: AddDbContextPool reuses configured contexts (connection string, options) — reduces allocation for high-throughput.
- **Q: Unit of Work pattern and DbContext?** A: DbContext IS the Unit of Work — all changes tracked and committed together in SaveChanges.

## ⚠️ Common Mistakes
❌ Creating multiple DbContext instances per request or sharing one across requests.
✅ One Scoped DbContext per request — all repositories within that request share the same context and change tracker.

## 🎯 Cheat Sheet
- **DbContext:** session + Unit of Work + Repository factory
- **Lifetime:** Scoped (never Singleton, never Transient)
- **SaveChanges:** flushes all tracked changes in one transaction
- **Keywords:** change tracker, Unit of Work, DbContextPool, OnModelCreating

## 🏢 Industry Experience Answer
"We inject DbContext into all repositories within a request, sharing the same Unit of Work. When the service layer calls SaveChangesAsync(), all repositories' changes commit atomically. Overriding SaveChangesAsync for audit timestamps is a pattern we use on every project — it's a clean way to add cross-cutting concerns without polluting domain logic."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is DbContext?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q6
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
`DbSet<T>` is a property on DbContext representing a **table in the database** as a queryable, manipulable collection. It provides LINQ querying, and Add/Update/Remove methods that register changes with the change tracker. It implements both `IQueryable<T>` (for composable queries → SQL) and `IEnumerable<T>` (for in-memory operations).

## 📖 Detailed Explanation
**Querying:** DbSet is IQueryable — LINQ methods (Where, Select, Include) build up an expression tree and translate to SQL on ToList/ToListAsync.
**Adding:** `_ctx.Orders.Add(order)` — marks the entity as Added in the change tracker; INSERT runs on SaveChanges.
**Finding:** `FindAsync(id)` — checks the change tracker first (identity map), then queries DB.
**Attaching:** `_ctx.Orders.Attach(order)` — tracks an existing entity without querying (useful for updates when you have the entity from outside the context).

## 💻 Code Example
```csharp
public class OrderRepository
{
    private readonly AppDbContext _ctx;
    public OrderRepository(AppDbContext ctx) => _ctx = ctx;

    // Query — translates to SQL
    public Task<List<Order>> GetActiveAsync() =>
        _ctx.Orders
            .Where(o => o.Status == OrderStatus.Active)
            .Include(o => o.Items)
            .OrderByDescending(o => o.CreatedAt)
            .ToListAsync();

    // Add
    public void Add(Order order) => _ctx.Orders.Add(order);

    // Update (tracked entity)
    public Task<Order?> GetByIdAsync(int id) => _ctx.Orders.FindAsync(id).AsTask();

    // Remove
    public void Delete(Order order) => _ctx.Orders.Remove(order);
}
```

## ❓ Follow-Up Questions
- **Q: DbSet vs raw SQL?** A: DbSet for LINQ-expressible queries; raw SQL (FromSqlRaw, ExecuteSqlRaw) for complex queries EF can't generate.
- **Q: IQueryable vs IEnumerable on DbSet?** A: IQueryable composes SQL; IEnumerable pulls all data to memory first. Always stay IQueryable until ToListAsync.
- **Q: What is FindAsync?** A: Looks up by primary key; checks the identity cache first — avoids redundant DB calls within the same context scope.

## ⚠️ Common Mistakes
❌ Calling .ToList() mid-query then chaining more LINQ on the result.
✅ ToList() materialises to memory; subsequent LINQ runs in C#, not SQL. Keep the query IQueryable until the final materialization.

## 🎯 Cheat Sheet
- **DbSet<T>:** table as IQueryable + change-tracker gateway
- **Add/Remove:** register in change tracker; SQL on SaveChanges
- **FindAsync:** primary key lookup, cache-first
- **Keywords:** IQueryable, LINQ-to-SQL, change tracker, identity map

## 🏢 Industry Experience Answer
"Understanding that DbSet is IQueryable is fundamental. Every .Where(), .Select(), .Include() just builds the expression tree — nothing hits the DB. Only ToListAsync/FirstOrDefaultAsync/CountAsync etc. execute the SQL. A common review comment is 'you called ToList() too early' — the rest of the LINQ then runs in C# on potentially thousands of rows."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is DbSet?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q7
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
EF Core has three strategies for loading related entities: **Eager loading** (Include — loads related data in the same SQL query via JOIN), **Lazy loading** (loads related data on property access — N+1 risk), and **Explicit loading** (Entry().Collection().LoadAsync() — you choose when to load). Eager loading with Include is the default recommendation.

## 📖 Detailed Explanation
**Eager loading (Include/ThenInclude):** adds JOINs to the main query. Everything comes back in one SQL round trip (or a split query). Predictable and efficient for known relationships.
**Lazy loading:** EF generates proxy classes; navigation properties load automatically when accessed. Requires Proxies package and virtual navigation properties. Danger: N+1 — each access triggers a new SQL query.
**Explicit loading:** _ctx.Entry(order).Collection(o => o.Items).LoadAsync() — load on demand, under your control. Good for conditional loading.
**Split queries:** AsSplitQuery() — loads the main entity and each Include in separate SQL queries; avoids Cartesian explosion with multiple collection includes.

## 💻 Code Example
```csharp
// Eager loading — one SQL with JOINs
var orders = await _ctx.Orders
    .Include(o => o.Customer)
    .Include(o => o.Items)
        .ThenInclude(i => i.Product)
    .Where(o => o.Total > 100m)
    .ToListAsync();

// Split query — avoids Cartesian explosion for multiple collections
var orders2 = await _ctx.Orders
    .Include(o => o.Items)
    .Include(o => o.Tags)
    .AsSplitQuery()
    .ToListAsync();

// Explicit loading — conditional
var order = await _ctx.Orders.FindAsync(id);
if (needItems)
    await _ctx.Entry(order).Collection(o => o.Items).LoadAsync();
```

## ❓ Follow-Up Questions
- **Q: What is Cartesian explosion?** A: Multiple collection includes in one query can multiply rows — e.g., 100 orders * 10 items * 5 tags = 5000 rows. Use AsSplitQuery.
- **Q: How to enable lazy loading?** A: Install Microsoft.EntityFrameworkCore.Proxies, call UseLazyLoadingProxies(), make navigation properties virtual.
- **Q: When is explicit loading useful?** A: When you conditionally need related data — avoid loading it always (eager) but also avoid N+1 (lazy).

## ⚠️ Common Mistakes
❌ Enabling lazy loading in a web API — each serialized navigation property triggers a DB round trip.
✅ Use eager loading with Include for APIs. Lazy loading can generate hundreds of queries per request without you realising.

## 🎯 Cheat Sheet
- **Eager:** Include/ThenInclude — JOIN in same query, predictable
- **Lazy:** auto-load on access — N+1 risk, requires proxies
- **Explicit:** Entry().Collection().LoadAsync() — on-demand
- **Split:** AsSplitQuery() — separate SQL per Include collection
- **Keywords:** N+1, Cartesian explosion, ThenInclude, AsSplitQuery

## 🏢 Industry Experience Answer
"We ban lazy loading from all APIs — it's a hidden N+1 waiting to happen, especially when a serializer walks the object graph. All loading is explicit via Include. For complex aggregates with multiple collections we use AsSplitQuery to avoid the Cartesian explosion. Explicit loading we use only in command handlers where we conditionally need extra data."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is lazy loading, eager loading, and explicit loading?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q8
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Change tracking is EF Core's mechanism to **track what changed** in entities retrieved from the database. When you load entities, EF takes a snapshot of their original values. On `SaveChanges`, it compares current values to the snapshot and generates INSERT/UPDATE/DELETE statements for only what changed — no manual "dirty" tracking needed.

## 📖 Detailed Explanation
**States:** Detached, Unchanged, Added, Modified, Deleted.
**How it works:** DbContext maintains an identity map of tracked entities. On SaveChanges, the change tracker detects state changes and emits the minimum SQL needed.
**AsNoTracking():** returns entities without tracking — lighter query, faster for read-only scenarios. No SaveChanges possible on these entities.
**Performance:** tracking adds per-entity overhead. For read-only queries (reports, API reads with no update), always use AsNoTracking().
**Manual state:** `_ctx.Entry(entity).State = EntityState.Modified` — marks entire entity as modified even if only one property changed.

## 💻 Code Example
```csharp
// Tracked — changes detected automatically
var order = await _ctx.Orders.FindAsync(id);   // Unchanged state
order.Status = OrderStatus.Shipped;             // Modified state detected
await _ctx.SaveChangesAsync();                  // UPDATE orders SET Status = 'Shipped' WHERE Id = @id

// Adding new entity
var newOrder = new Order { CustomerId = "C1", Total = 99m };
_ctx.Orders.Add(newOrder);   // Added state
await _ctx.SaveChangesAsync(); // INSERT

// Deleting
_ctx.Orders.Remove(order);   // Deleted state
await _ctx.SaveChangesAsync(); // DELETE

// Read-only — no tracking overhead
var orderDtos = await _ctx.Orders
    .AsNoTracking()
    .Select(o => new OrderDto { Id = o.Id, Total = o.Total })
    .ToListAsync();
```

## ❓ Follow-Up Questions
- **Q: What happens if you modify a detached entity and call SaveChanges?** A: Nothing — EF doesn't know about it. Attach it first or use _ctx.Update(entity).
- **Q: What is the identity map?** A: EF caches each tracked entity by primary key — multiple queries for the same Id return the same in-memory object.
- **Q: How do you update a detached entity?** A: _ctx.Update(entity) — marks all properties as Modified. Or attach + set specific property state.

## ⚠️ Common Mistakes
❌ Using tracked entities for large read-only queries (reports, lists).
✅ Always add .AsNoTracking() for read-only scenarios — it skips the snapshot and identity map overhead, noticeably faster for large result sets.

## 🎯 Cheat Sheet
- **States:** Detached, Unchanged, Added, Modified, Deleted
- **Tracking:** snapshot on load, diff on SaveChanges
- **AsNoTracking:** read-only, faster, no save
- **Keywords:** change tracker, identity map, EntityState, snapshot

## 🏢 Industry Experience Answer
"Change tracking is EF Core's killer feature — you load an entity, change a property, call SaveChanges, and EF figures out the minimum SQL. For read-heavy operations like our reporting endpoints, we always use AsNoTracking() — on queries returning hundreds of entities, skipping the snapshot and identity map reduces query time by 20-30%."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is change tracking in EF Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q9
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
EF Core handles transactions automatically — each `SaveChanges()` call wraps all pending changes in a **single implicit transaction**. For explicit multi-step transactions spanning multiple SaveChanges calls, use `context.Database.BeginTransactionAsync()`. EF also integrates with ambient transactions via `System.Transactions.TransactionScope`.

## 📖 Detailed Explanation
**Implicit (default):** all changes in one SaveChanges = one atomic transaction. All succeed or all roll back.
**Explicit transaction:** BeginTransactionAsync → multiple SaveChanges → CommitAsync. All changes across all SaveChanges calls are in one transaction.
**Savepoints (EF Core 5+):** nested transactions use savepoints — partial rollback without aborting the outer transaction.
**Distributed transactions:** TransactionScope with multiple contexts — works on SQL Server; limited support on other providers.

## 💻 Code Example
```csharp
// Implicit — one SaveChanges = one transaction
order.Status = OrderStatus.Shipped;
_ctx.Invoices.Add(invoice);
await _ctx.SaveChangesAsync();   // both changes in one atomic TX

// Explicit transaction — multiple SaveChanges in one TX
await using var tx = await _ctx.Database.BeginTransactionAsync();
try
{
    _ctx.Orders.Add(order);
    await _ctx.SaveChangesAsync();          // first save

    _ctx.Inventory.Update(inventory);
    await _ctx.SaveChangesAsync();          // second save

    await tx.CommitAsync();                 // commit both
}
catch
{
    await tx.RollbackAsync();
    throw;
}
```

## ❓ Follow-Up Questions
- **Q: Does EF Core auto-rollback on exception?** A: On exception from SaveChanges, the implicit transaction rolls back. For explicit transactions, call RollbackAsync in catch.
- **Q: Can two DbContexts share a transaction?** A: Yes — UseTransaction(transaction.GetDbTransaction()) on the second context.
- **Q: What is the Unit of Work pattern here?** A: DbContext IS the Unit of Work — accumulate changes across multiple repos, one SaveChanges commits all atomically.

## ⚠️ Common Mistakes
❌ Multiple SaveChanges calls without an explicit transaction when they must be atomic.
✅ If ordering + payment must both succeed or both fail, wrap in an explicit BeginTransactionAsync.

## 🎯 Cheat Sheet
- **Implicit:** one SaveChanges = one atomic TX (automatic)
- **Explicit:** BeginTransactionAsync → multiple SaveChanges → Commit/Rollback
- **Savepoints:** EF Core 5+, partial rollback in nested calls
- **Keywords:** atomicity, BeginTransactionAsync, Unit of Work, rollback

## 🏢 Industry Experience Answer
"Implicit transactions handle 90% of our use cases — one SaveChanges per command handler, everything in one TX. We use explicit transactions for the occasional multi-step operation: deduct inventory, create order, charge payment — all three in one transaction. If the payment fails, the inventory deduction and order creation roll back automatically."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'How do you handle transactions in EF Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q10
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Navigation properties are **C# properties on an entity that reference related entities** — they represent foreign key relationships in object form. A reference navigation (`public Customer Customer { get; set; }`) represents a many-to-one; a collection navigation (`public List<OrderItem> Items { get; set; }`) represents a one-to-many. EF Core uses them for Include (eager loading) and relationship configuration.

## 📖 Detailed Explanation
**Reference navigation:** points to one related entity (the "one" side of one-to-many, or either side of one-to-one).
**Collection navigation:** points to many related entities (the "many" side of one-to-many or many-to-many).
**Foreign key property:** typically alongside the navigation — `public int CustomerId { get; set; }` + `public Customer Customer { get; set; }`.
**Configuration:** EF infers relationships from naming conventions; Fluent API for explicit config.
**Many-to-many (EF Core 5+):** direct collection-to-collection without a join entity class — EF creates the join table automatically.

## 💻 Code Example
```csharp
public class Order
{
    public int Id { get; set; }

    // Foreign key
    public int CustomerId { get; set; }

    // Reference navigation (many Orders → one Customer)
    public Customer Customer { get; set; }

    // Collection navigation (one Order → many Items)
    public List<OrderItem> Items { get; set; } = new();

    // Many-to-many (EF Core 5+)
    public List<Tag> Tags { get; set; } = new();
}

// Fluent API relationship config
mb.Entity<Order>()
    .HasOne(o => o.Customer)
    .WithMany(c => c.Orders)
    .HasForeignKey(o => o.CustomerId)
    .OnDelete(DeleteBehavior.Restrict);
```

## ❓ Follow-Up Questions
- **Q: What is a foreign key shadow property?** A: EF-managed FK column with no corresponding C# property on the entity.
- **Q: Do navigation properties need to be virtual?** A: Only for lazy loading proxies. Without lazy loading, no need.
- **Q: What is cascade delete?** A: OnDelete(DeleteBehavior.Cascade) — deleting the principal automatically deletes dependents.

## ⚠️ Common Mistakes
❌ Not initializing collection navigations.
✅ Initialize collections: `public List<OrderItem> Items { get; set; } = new();`. An uninitialized collection causes NullReferenceException when you try to add items before loading.

## 🎯 Cheat Sheet
- **Reference nav:** one related entity, FK on this or other side
- **Collection nav:** many related entities, Initialize with new()
- **Many-to-many (EF5+):** direct collection, auto join table
- **Keywords:** Include, HasOne, WithMany, HasForeignKey, DeleteBehavior

## 🏢 Industry Experience Answer
"Navigation properties are the heart of the EF model, but you need discipline. We always initialize collections, explicitly configure FK relationships with OnDelete behavior (never rely on defaults for cascades), and use ThenInclude for deep graphs. Many-to-many without a join entity (EF Core 5+) is a big quality-of-life improvement for simpler relationships."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are navigation properties?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q11
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A shadow property is a **property that exists in the EF Core model and database table but has no corresponding C# property on the entity class**. It's managed entirely by EF Core — readable/writable via `ChangeTracker.Entries` and `EF.Property<T>(entity, "PropertyName")`. Use it for audit columns (CreatedAt, UpdatedAt) you don't want polluting your domain model.

## 📖 Detailed Explanation
**How it works:** defined in OnModelCreating via Fluent API; EF includes the column in migrations and queries, but the entity class has no property.
**Read/write:** via `EF.Property<T>(entity, name)` in queries or via the change tracker.
**Common uses:** CreatedAt, CreatedBy, RowVersion, IsDeleted — infrastructure concerns that don't belong in domain entities.
**Alternative:** owned types or interface-based audit properties if you want compile-time safety.

## 💻 Code Example
```csharp
// Fluent API — define shadow properties
protected override void OnModelCreating(ModelBuilder mb)
{
    foreach (var entity in mb.Model.GetEntityTypes())
    {
        mb.Entity(entity.Name).Property<DateTime>("CreatedAt");
        mb.Entity(entity.Name).Property<DateTime>("UpdatedAt");
    }
}

// Set in SaveChangesAsync override
public override async Task<int> SaveChangesAsync(CancellationToken ct = default)
{
    var now = DateTime.UtcNow;
    foreach (var entry in ChangeTracker.Entries())
    {
        if (entry.State == EntityState.Added)
            entry.Property("CreatedAt").CurrentValue = now;
        if (entry.State is EntityState.Added or EntityState.Modified)
            entry.Property("UpdatedAt").CurrentValue = now;
    }
    return await base.SaveChangesAsync(ct);
}

// Query using shadow property
var recent = await _ctx.Orders
    .OrderByDescending(o => EF.Property<DateTime>(o, "CreatedAt"))
    .Take(10)
    .ToListAsync();
```

## ❓ Follow-Up Questions
- **Q: How do you query on a shadow property?** A: EF.Property<T>(entity, "PropertyName") in LINQ — translated to SQL.
- **Q: Shadow property vs owned type?** A: Shadow = no C# property; owned type = nested C# object mapped to the same table.
- **Q: Are shadow properties included in migrations?** A: Yes — they appear as real columns in the database.

## ⚠️ Common Mistakes
❌ Putting every audit property as shadow properties — loses compile-time safety.
✅ Use shadow properties for pure infrastructure columns. For anything your domain logic needs, keep a real C# property.

## 🎯 Cheat Sheet
- **Shadow property:** DB column, no C# property, EF-managed
- **Define:** Fluent API in OnModelCreating
- **Access:** EF.Property<T>() in LINQ or entry.Property() in SaveChanges
- **Keywords:** audit, CreatedAt, EF.Property, shadow state

## 🏢 Industry Experience Answer
"Shadow properties for CreatedAt and UpdatedAt are in every project of ours. The domain entities stay clean — no infrastructure concerns like audit timestamps cluttering the model. We set them centrally in a SaveChangesAsync override. The downside: no IntelliSense for queries; we wrap EF.Property calls in typed extension methods."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is shadow property in EF Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q12
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**Tracked queries** (default) load entities and register them with the change tracker — changes are detected on SaveChanges. **`AsNoTracking()`** returns entities without registering them — significantly faster for read-only operations because EF skips snapshot creation and identity map management. Use AsNoTracking for any query where you won't save changes.

## 📖 Detailed Explanation
**Tracked:** EF takes a snapshot of each entity, maintains an identity map. Allows detecting and saving changes. Required if you'll call SaveChanges on these entities.
**AsNoTracking:** no snapshot, no identity map entry. Faster query, lower memory. Cannot update/delete these entities via SaveChanges directly.
**AsNoTrackingWithIdentityResolution:** no tracking but still deduplicates related entities (prevents multiple instances of the same entity). Useful for Includes that might return duplicates.
**When to use:** always add AsNoTracking() to read-only queries (GET endpoints, reports, list views).

## 💻 Code Example
```csharp
// Tracked — needed if you'll update
var order = await _ctx.Orders.FirstAsync(o => o.Id == id);
order.Status = OrderStatus.Shipped;
await _ctx.SaveChangesAsync();   // UPDATE generated

// AsNoTracking — read only, faster
var orderDtos = await _ctx.Orders
    .AsNoTracking()
    .Where(o => o.CustomerId == customerId)
    .Select(o => new OrderDto { Id = o.Id, Status = o.Status.ToString() })
    .ToListAsync();

// Global default for context (all queries read-only)
_ctx.ChangeTracker.QueryTrackingBehavior = QueryTrackingBehavior.NoTracking;

// Per-query: AsNoTrackingWithIdentityResolution (deduplicates)
var orders = await _ctx.Orders
    .AsNoTrackingWithIdentityResolution()
    .Include(o => o.Customer)
    .ToListAsync();
```

## ❓ Follow-Up Questions
- **Q: Can you update an AsNoTracking entity?** A: Not directly via change detection. Attach it with _ctx.Update(entity) to force all properties as Modified.
- **Q: How much faster is AsNoTracking?** A: 20-30% faster for most queries; more for large result sets where snapshot overhead dominates.
- **Q: What is AsNoTrackingWithIdentityResolution?** A: No tracking but same related entity referenced by multiple rows → same C# object instance.

## ⚠️ Common Mistakes
❌ Using tracked queries for all GET endpoints.
✅ GET endpoints never need tracking. Always use AsNoTracking() for reads — it's a free performance win.

## 🎯 Cheat Sheet
- **Tracked:** change detection enabled, snapshot, identity map
- **AsNoTracking:** read-only, no snapshot, faster
- **AsNoTrackingWithIdentityResolution:** no tracking + deduplication
- **Keywords:** QueryTrackingBehavior, snapshot, identity map, performance

## 🏢 Industry Experience Answer
"AsNoTracking is one of our standard code review checklist items — every GET endpoint query should have it. On a list endpoint returning 500 orders with their items, adding AsNoTracking cut response time by 25% because EF wasn't snapshotting 2500 entities. It's a no-brainer for any read path."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'AsNoTracking() vs tracked queries — when to use each?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q13
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Compiled queries pre-compile the LINQ expression to a delegate once and reuse it for subsequent executions — eliminating the LINQ-to-SQL translation overhead on every call. Use `EF.CompileAsyncQuery()` for hot-path queries called thousands of times per minute where translation overhead is measurable.

## 📖 Detailed Explanation
**Normal LINQ:** every call re-translates the expression tree to SQL (cached internally per app session, but still inspected). Small overhead per call.
**Compiled query:** translated ONCE to a SQL-generating delegate at startup. Subsequent calls skip translation — just bind parameters and execute.
**When it matters:** queries called very frequently (hot paths), where profiling shows query compilation time is significant.
**EF Core's internal caching:** EF already caches query plans — compiled queries offer marginal improvement in most cases. Profile before optimising.

## 💻 Code Example
```csharp
// Compiled async query — translate once
private static readonly Func<AppDbContext, int, Task<Order?>> GetOrderByIdCompiled =
    EF.CompileAsyncQuery((AppDbContext ctx, int id) =>
        ctx.Orders
            .Include(o => o.Items)
            .FirstOrDefault(o => o.Id == id));

// Usage — no translation overhead on repeated calls
public Task<Order?> GetByIdAsync(int id) => GetOrderByIdCompiled(_ctx, id);

// Comparable — normal LINQ (EF internally caches too, so difference is small)
public Task<Order?> GetByIdNormalAsync(int id) =>
    _ctx.Orders.Include(o => o.Items).FirstOrDefaultAsync(o => o.Id == id);
```

## ❓ Follow-Up Questions
- **Q: Does EF Core already cache queries?** A: Yes — it caches the compiled plan per query shape. Compiled queries bypass even that lookup.
- **Q: When should you use compiled queries?** A: Profile first. Only worth it for high-frequency hot paths (thousands/sec) where EF's internal cache lookup is measurable.
- **Q: Any limitations?** A: Parameters must be value types or string; complex closures don't work.

## ⚠️ Common Mistakes
❌ Adding compiled queries everywhere for "performance."
✅ Measure first. EF's internal query cache handles most cases. Compiled queries add code complexity — worth it only where profiling shows a real gain.

## 🎯 Cheat Sheet
- **Purpose:** skip LINQ-to-SQL translation on repeated calls
- **API:** EF.CompileAsyncQuery / EF.CompileQuery
- **Use:** hot-path, high-frequency queries
- **Keywords:** pre-compilation, query plan, expression tree, hot path

## 🏢 Industry Experience Answer
"We have three compiled queries in our entire codebase — the GetById, GetActiveByTenant, and GetByEmail lookups that run on every authenticated request. Profiling showed EF's internal cache lookup was adding 0.2ms per call; at 5000 req/sec that's 1 second of pure overhead per second. Compiled queries eliminated it. Everywhere else, EF's caching is sufficient."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are compiled queries in EF Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q14
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Optimistic concurrency assumes conflicts are rare and doesn't lock rows on read. Instead, it detects conflicts at save time by including a **row version / timestamp** in the UPDATE WHERE clause. If another user changed the row first, the WHERE clause matches zero rows, EF throws `DbUpdateConcurrencyException`, and you handle the conflict.

## 📖 Detailed Explanation
**How it works:** mark a property as a concurrency token — EF includes it in UPDATE/DELETE WHERE clauses. If zero rows affected → conflict → DbUpdateConcurrencyException.
**RowVersion:** a database-managed byte[] incremented on every update (SQL Server: rowversion; PostgreSQL: xmin). Mark with [Timestamp] or IsRowVersion().
**Concurrency token:** any property — EF checks it in the WHERE clause. Useful for specific fields (e.g., version number).
**Handling conflicts:** catch DbUpdateConcurrencyException, reload the entity, merge or re-throw to the user.

## 💻 Code Example
```csharp
// Entity with row version
public class Product
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
    [Timestamp] public byte[] RowVersion { get; set; }  // auto-managed concurrency token
}

// Fluent API alternative
mb.Entity<Product>()
    .Property(p => p.RowVersion)
    .IsRowVersion();

// Handle concurrency conflict
try
{
    product.Price = 99.99m;
    await _ctx.SaveChangesAsync();
}
catch (DbUpdateConcurrencyException ex)
{
    var entry = ex.Entries.Single();
    var dbValues = await entry.GetDatabaseValuesAsync();
    // Option 1: client wins — overwrite DB
    // Option 2: DB wins — reload and show user
    entry.OriginalValues.SetValues(dbValues);
    // Retry save, or return 409 Conflict to the client
}
```

## ❓ Follow-Up Questions
- **Q: Optimistic vs pessimistic concurrency?** A: Optimistic: no lock, check at save; pessimistic: lock row on read (SELECT FOR UPDATE). Optimistic is better for web APIs.
- **Q: What exception is thrown?** A: DbUpdateConcurrencyException — contains the conflicting entities.
- **Q: How does EF include the token in SQL?** A: WHERE Id = @id AND RowVersion = @originalVersion — zero rows affected = conflict.

## ⚠️ Common Mistakes
❌ Not handling DbUpdateConcurrencyException — the request silently succeeds or fails incorrectly.
✅ Always catch DbUpdateConcurrencyException on entities with concurrency tokens. Return 409 Conflict to the client with information to resolve.

## 🎯 Cheat Sheet
- **Token:** [Timestamp] byte[] or any [ConcurrencyCheck] property
- **Detection:** zero rows updated → DbUpdateConcurrencyException
- **Handle:** reload DB values, merge or reject, retry or return 409
- **Keywords:** [Timestamp], rowversion, DbUpdateConcurrencyException, xmin (PostgreSQL)

## 🏢 Industry Experience Answer
"We use rowversion on every entity users can edit concurrently. The UI sends the rowversion back with the update request; EF checks it in the WHERE clause. If a conflict occurs we return 409 with the current DB state so the client can show 'someone else changed this, here's the latest' — much better UX than silently overwriting."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'How do you handle optimistic concurrency in EF Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q15
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Value converters tell EF Core how to **convert a C# type to a database column type** (and back) during reads and writes. Use them to store enums as strings, value objects as JSON or strings, encrypt sensitive fields, or map any custom type that has no direct database equivalent.

## 📖 Detailed Explanation
**What it does:** defines two lambdas — one to convert C# → DB (model to store) and one for DB → C# (store to model).
**Built-in converters:** enum to string, bool to int, DateTimeOffset to long, etc.
**Custom converters:** any bidirectional transformation. Registered via Fluent API in OnModelCreating.
**JSON columns (EF Core 7+):** OwnsOne/OwnsMany with ToJson() — stores complex objects as a JSON column.

## 💻 Code Example
```csharp
// 1. Store enum as string
mb.Entity<Order>()
    .Property(o => o.Status)
    .HasConversion<string>();  // stored as "Active", "Shipped" etc.

// 2. Custom value object converter
public class MoneyConverter : ValueConverter<Money, decimal>
{
    public MoneyConverter() : base(
        money => money.Amount,
        amount => new Money(amount)) { }
}

mb.Entity<Order>()
    .Property(o => o.Total)
    .HasConversion(new MoneyConverter());

// 3. JSON column (EF Core 7+)
public class Order
{
    public int Id { get; set; }
    public ShippingAddress Address { get; set; }   // stored as JSON
}
mb.Entity<Order>().OwnsOne(o => o.Address, a => a.ToJson());
```

## ❓ Follow-Up Questions
- **Q: Can you query on a converted property?** A: Depends on the conversion — simple conversions (enum to string) are translated to SQL; complex ones may require client-side evaluation.
- **Q: JSON column vs owned entity?** A: Owned entity without ToJson = separate table; ToJson = JSON column in same row. JSON column is great for variable-structure data.
- **Q: Any performance considerations?** A: Complex converters that can't be SQL-translated force client-side evaluation (all rows loaded then filtered).

## ⚠️ Common Mistakes
❌ Storing enums as ints — DB becomes unreadable without the code.
✅ Store enums as strings — readable in the DB, no magic numbers, and new enum values are safe without integer collisions.

## 🎯 Cheat Sheet
- **Definition:** bidirectional type mapping for DB storage
- **Common use:** enum to string, value objects, encryption, JSON
- **API:** HasConversion<T> or HasConversion(new MyConverter())
- **Keywords:** ValueConverter, enum to string, JSON column, ToJson, OwnsOne

## 🏢 Industry Experience Answer
"Storing enums as strings via HasConversion<string>() is a team standard — the database is readable and a new enum value doesn't collide with an existing integer. For value objects like Money and Address, custom ValueConverters keep the domain model clean while mapping cleanly to DB columns. JSON columns (EF7+) replaced several owned entity tables for us."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are value converters in EF Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q16
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Soft delete marks a record as deleted (e.g., `IsDeleted = true`) **without physically removing it from the database**. The record is preserved for auditing and recovery. In EF Core, implement it via a global query filter (`modelBuilder.Entity<T>().HasQueryFilter(e => !e.IsDeleted)`) that automatically excludes soft-deleted rows from all queries.

## 📖 Detailed Explanation
**Why soft delete:** audit trail, recovery from accidental deletion, referential integrity (foreign keys still valid).
**Global query filter:** applied to every query on that entity — transparent to the caller, no need to add `Where(!IsDeleted)` everywhere.
**Hard delete override:** `IgnoreQueryFilters()` bypasses the filter when you genuinely need to see deleted records.
**Interceptors:** override SaveChanges to intercept Remove() and convert it to a soft delete automatically.

## 💻 Code Example
```csharp
// Entity with soft delete
public interface ISoftDeletable { bool IsDeleted { get; set; } DateTime? DeletedAt { get; set; } }

public class Order : ISoftDeletable
{
    public int Id { get; set; }
    public bool IsDeleted { get; set; }
    public DateTime? DeletedAt { get; set; }
}

// Global query filter — auto-applies to all queries
mb.Entity<Order>().HasQueryFilter(o => !o.IsDeleted);

// Override Remove to do soft delete
public override async Task<int> SaveChangesAsync(CancellationToken ct = default)
{
    foreach (var entry in ChangeTracker.Entries<ISoftDeletable>()
        .Where(e => e.State == EntityState.Deleted))
    {
        entry.State = EntityState.Modified;
        entry.Entity.IsDeleted = true;
        entry.Entity.DeletedAt = DateTime.UtcNow;
    }
    return await base.SaveChangesAsync(ct);
}

// See deleted records when needed
var allOrders = await _ctx.Orders.IgnoreQueryFilters().ToListAsync();
```

## ❓ Follow-Up Questions
- **Q: Does the global query filter apply to Include?** A: Yes — filtered entities are excluded from navigation collection loads too.
- **Q: Does it affect performance?** A: Adds a WHERE IsDeleted = false to every query — index on IsDeleted recommended.
- **Q: How do you restore a soft-deleted entity?** A: IgnoreQueryFilters() to find it, then set IsDeleted = false, SaveChanges.

## ⚠️ Common Mistakes
❌ Adding IsDeleted filter manually to every query.
✅ Use HasQueryFilter — it applies globally and transparently, preventing missed filters.

## 🎯 Cheat Sheet
- **Concept:** mark deleted, don't remove; preserve for audit/recovery
- **Implementation:** IsDeleted column + HasQueryFilter
- **Override:** IgnoreQueryFilters() to see deleted
- **Keywords:** HasQueryFilter, ISoftDeletable, IgnoreQueryFilters, audit

## 🏢 Industry Experience Answer
"Soft delete is in our base entity on every aggregate. The global query filter means developers don't have to think about it — no one accidentally shows deleted customers. The interceptor converting Remove() to a soft delete was the cleanest pattern; callers call Remove() as normal and the infrastructure handles it. We index IsDeleted for performance on large tables."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'How would you implement a soft delete in EF Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q17
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
The N+1 problem occurs when you load N entities and then for each one trigger an additional query to load a related entity — resulting in N+1 total queries instead of 1. In EF Core, fix it with **`Include()`** (eager loading in one JOIN), **`AsSplitQuery()`** (multiple targeted queries), or by projecting to a DTO with Select that includes what you need.

## 📖 Detailed Explanation
**How it happens:** load orders (1 query), then in a loop access order.Customer (N queries). With lazy loading this is silent — each navigation property access fires a query.
**Fix 1 — Include:** `.Include(o => o.Customer)` — JOIN in the main query, one round trip.
**Fix 2 — Select projection:** select only the fields you need from both entities in one query — no navigation property access needed.
**Fix 3 — AsSplitQuery:** for multiple collection Includes, EF fires one query per Include but in one round trip — avoids Cartesian explosion.
**Detection:** log EF queries (`optionsBuilder.LogTo(Console.WriteLine)`) and look for repeated similar queries.

## 💻 Code Example
```csharp
// N+1 PROBLEM — DO NOT DO THIS
var orders = await _ctx.Orders.ToListAsync();      // 1 query
foreach (var o in orders)
    Console.WriteLine(o.Customer.Name);             // N queries (lazy loading)

// FIX 1: Include (eager loading)
var orders = await _ctx.Orders
    .Include(o => o.Customer)
    .ToListAsync();                                 // 1 query with JOIN

// FIX 2: Projection (only what you need)
var summaries = await _ctx.Orders
    .Select(o => new { o.Id, CustomerName = o.Customer.Name, o.Total })
    .ToListAsync();                                 // 1 query, minimal columns

// FIX 3: AsSplitQuery (multiple collections)
var orders = await _ctx.Orders
    .Include(o => o.Items)
    .Include(o => o.Tags)
    .AsSplitQuery()
    .ToListAsync();                                 // 3 queries, no Cartesian explosion
```

## ❓ Follow-Up Questions
- **Q: How do you detect N+1?** A: Enable query logging or use MiniProfiler/Application Insights — look for many identical queries per request.
- **Q: Does AsSplitQuery eliminate N+1?** A: For multiple collection Includes yes — it runs one query per Include, not one per row.
- **Q: Should you always use Include?** A: Only include what you need — unnecessary Includes bring extra data over the wire.

## ⚠️ Common Mistakes
❌ Enabling lazy loading in a web API.
✅ Lazy loading is the silent cause of N+1. Disable it; use explicit Include or projection. Every navigation property access must be intentional.

## 🎯 Cheat Sheet
- **N+1:** 1 list query + N row-level queries for related data
- **Fix:** Include (JOIN), projection (Select), AsSplitQuery
- **Detect:** EF query logging, MiniProfiler
- **Keywords:** Include, AsSplitQuery, lazy loading, Cartesian explosion

## 🏢 Industry Experience Answer
"N+1 is the most common EF Core performance bug I find in code reviews. The tell-tale sign: a page loads fine locally but is slow in production with real data volume. Enabling EF query logging immediately shows 50 queries where there should be 1. The fix is always Include or projection — and banning lazy loading from the codebase entirely."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is the N+1 query problem and how do you fix it in EF Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q18
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
`SaveChanges()` is the **synchronous** version — it blocks the calling thread while the database operation completes. `SaveChangesAsync()` is the **asynchronous** version — it releases the thread during the I/O wait, allowing the thread pool to handle other requests. In ASP.NET Core, always use `SaveChangesAsync()` — sync blocking under concurrent load exhausts thread pool threads.

## 📖 Detailed Explanation
**Functional difference:** Both flush all tracked changes in a single transaction, return the number of rows affected, and throw on errors. The only difference is threading: sync blocks, async doesn't.
**Async rule:** in any I/O context in an ASP.NET Core application, use the async version — every blocked thread is one fewer request your server can handle.
**CancellationToken:** SaveChangesAsync accepts a CancellationToken — pass the request's token so DB operations cancel cleanly on client disconnect.
**SaveChanges use cases:** console apps with no SynchronizationContext concerns, test utilities, migration scripts.

## 💻 Code Example
```csharp
// In ASP.NET Core — ALWAYS use async
[HttpPost]
public async Task<IActionResult> CreateOrder(CreateOrderDto dto, CancellationToken ct)
{
    var order = new Order { CustomerId = dto.CustomerId, Total = dto.Total };
    _ctx.Orders.Add(order);
    await _ctx.SaveChangesAsync(ct);   // async + cancellable
    return CreatedAtAction(nameof(GetOrder), new { id = order.Id }, order);
}

// Sync is acceptable in non-async contexts
// Console app, test setup, DbContext seed
public static void SeedDatabase(AppDbContext ctx)
{
    ctx.Orders.Add(new Order { CustomerId = "SEED", Total = 0 });
    ctx.SaveChanges();   // OK in sync context
}
```

## ❓ Follow-Up Questions
- **Q: What does SaveChanges return?** A: The number of state entries written to the database.
- **Q: Does SaveChangesAsync wrap in a transaction?** A: Yes — all changes are in one implicit transaction by default.
- **Q: What if SaveChanges throws?** A: The transaction is rolled back; the DbContext is in an unknown state — consider disposing and creating a new context.

## ⚠️ Common Mistakes
❌ Using SaveChanges() inside an async action method.
✅ Mixing sync DB calls inside async methods defeats the purpose of async — the thread blocks waiting for DB even though it could have been released. Always match the async pattern end-to-end.

## 🎯 Cheat Sheet
- **SaveChanges:** synchronous, blocks thread
- **SaveChangesAsync:** async, releases thread during I/O, accepts CancellationToken
- **Rule:** always async in ASP.NET Core
- **Keywords:** async I/O, thread pool, CancellationToken, implicit transaction

## 🏢 Industry Experience Answer
"SaveChanges vs SaveChangesAsync is the same discussion as any sync vs async DB call. We enforce SaveChangesAsync everywhere in web APIs via a Roslyn analyzer that flags SaveChanges() in async methods. The CancellationToken is also mandatory — we pass ct through from the controller all the way to SaveChangesAsync so client disconnects cancel in-flight DB operations."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between SaveChanges() and SaveChangesAsync()?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- End of Batch 4 — EF Core COMPLETE (Q1–Q18)
-- Next: devready_batch05_auth_security.sql (Section 5, Q1–Q15)

-- ════════════════════════════════════════════════════════════
-- DevReady Seed — Batch 5
-- .NET › 5️⃣ Auth & Security › Q1–Q15
-- Dollar-quote safe (zero $ inside content). Idempotent upsert.
-- ════════════════════════════════════════════════════════════

-- Q1
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
JWT (JSON Web Token) is a compact, URL-safe token format for securely transmitting claims between parties. It consists of three Base64-encoded parts: **Header** (algorithm + type), **Payload** (claims), and **Signature** (verifies integrity). The server signs the token; clients include it in the Authorization header on subsequent requests — no session state needed on the server.

## 📖 Detailed Explanation
**Structure:** `header.payload.signature` — all Base64url encoded, separated by dots.
**Header:** `{ "alg": "HS256", "typ": "JWT" }` — algorithm and token type.
**Payload (claims):** registered (iss, sub, exp, iat, aud), public, and private claims. Not encrypted by default — never store sensitive data in payload.
**Signature:** HMAC-SHA256(base64(header) + "." + base64(payload), secret) — verifies the token wasn't tampered with.
**Stateless:** the server validates the signature on every request — no DB lookup needed. The trade-off: a valid token cannot be invalidated before expiry without a blocklist.

## 💻 Code Example
```csharp
// JWT structure (decoded)
// Header:  { "alg": "HS256", "typ": "JWT" }
// Payload: { "sub": "user123", "name": "Sidhant", "role": "Admin", "exp": 1700000000 }
// Signature: HMACSHA256(base64(header) + "." + base64(payload), secret)

// Validate JWT in ASP.NET Core
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = "https://myapp.com",
            ValidateAudience = true,
            ValidAudience = "myapp-api",
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes("your-256-bit-secret-key-here")),
            ValidateLifetime = true,
            ClockSkew = TimeSpan.Zero
        };
    });
```

## ❓ Follow-Up Questions
- **Q: Is JWT payload encrypted?** A: Not by default — it's Base64-encoded (readable). Use JWE (JSON Web Encryption) to encrypt, or keep sensitive data out of the payload.
- **Q: How do you invalidate a JWT before expiry?** A: JWTs are stateless — you need a blocklist (Redis/DB) or use short expiry + refresh tokens.
- **Q: What does `exp` claim mean?** A: Expiration time (Unix timestamp) — the token is invalid after this time.

## ⚠️ Common Mistakes
❌ Storing sensitive user data (passwords, PII) in the JWT payload.
✅ The payload is only Base64-encoded, not encrypted — anyone with the token can decode and read it. Store only non-sensitive identifiers (userId, role, email).

## 🎯 Cheat Sheet
- **Parts:** Header.Payload.Signature (Base64url encoded)
- **Claims:** sub, iss, aud, exp, iat, nbf + custom
- **Signature:** prevents tampering — not encryption
- **Keywords:** stateless, claims, Bearer token, HMAC, RSA, JWE

## 🏢 Industry Experience Answer
"JWTs are our auth mechanism for all APIs — issued on login with a 15-minute expiry, paired with a long-lived refresh token stored in an HttpOnly cookie. The short expiry limits the blast radius if a token is stolen; the refresh flow is transparent to the user. We never put PII in the payload — just userId, roles, and tenantId."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is JWT (JSON Web Token)?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q2
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
JWT authentication in ASP.NET Core: the client logs in and receives a JWT. On every subsequent request, the client sends `Authorization: Bearer <token>` in the header. The `JwtBearer` middleware validates the token's signature, issuer, audience, and expiry — if valid, it populates `HttpContext.User` with the claims. No server session is needed.

## 📖 Detailed Explanation
**Flow:**
1. Client POST /auth/login with credentials.
2. Server validates credentials, creates JWT with claims (userId, roles), signs it.
3. Server returns the JWT in the response body.
4. Client stores the JWT (memory or secure storage).
5. Client sends `Authorization: Bearer <jwt>` on every API call.
6. JwtBearer middleware validates signature, expiry, issuer, audience.
7. On success, ClaimsPrincipal is set in HttpContext.User.
8. [Authorize] attribute checks the principal.

**Token generation:** use `System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler`.

## 💻 Code Example
```csharp
// 1. Generate JWT on login
public string GenerateToken(User user)
{
    var claims = new[]
    {
        new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
        new Claim(ClaimTypes.Email, user.Email),
        new Claim(ClaimTypes.Role, user.Role)
    };
    var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]));
    var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
    var token = new JwtSecurityToken(
        issuer: _config["Jwt:Issuer"],
        audience: _config["Jwt:Audience"],
        claims: claims,
        expires: DateTime.UtcNow.AddMinutes(15),
        signingCredentials: creds);
    return new JwtSecurityTokenHandler().WriteToken(token);
}

// 2. Validate in Program.cs (see Q1 for full options)
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(/* options */);

// 3. Protect endpoints
[Authorize]
[HttpGet("profile")]
public IActionResult GetProfile() => Ok(User.FindFirst(ClaimTypes.Email)?.Value);
```

## ❓ Follow-Up Questions
- **Q: Where should the JWT be stored on the client?** A: Memory (most secure for SPAs — lost on refresh) or HttpOnly cookie (XSS-safe, CSRF risk). Avoid localStorage — vulnerable to XSS.
- **Q: What is ClockSkew?** A: A tolerance window for time differences between servers. Set to TimeSpan.Zero for strict validation.
- **Q: How is the user identity set?** A: JwtBearer middleware creates a ClaimsPrincipal from the JWT claims and sets HttpContext.User.

## ⚠️ Common Mistakes
❌ Storing JWT in localStorage.
✅ localStorage is accessible to JavaScript — XSS attacks steal it. Use HttpOnly, Secure, SameSite=Strict cookies for refresh tokens; keep access tokens in memory.

## 🎯 Cheat Sheet
- **Flow:** login → JWT → Authorization: Bearer → validate → ClaimsPrincipal
- **Storage:** memory (SPA), HttpOnly cookie (web)
- **Validate:** signature, exp, iss, aud, nbf
- **Keywords:** JwtBearerDefaults, JwtSecurityTokenHandler, ClaimsPrincipal, ClockSkew

## 🏢 Industry Experience Answer
"Our auth flow: login returns a 15-min access JWT in the response body (stored in JS memory) and a 7-day refresh token in an HttpOnly, Secure, SameSite=Strict cookie. The short access token limits breach impact; the HttpOnly cookie protects the refresh token from XSS. Middleware validates the JWT on every request without any DB lookup — pure stateless validation."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'How does JWT authentication work in ASP.NET Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q3
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**Authentication** answers "who are you?" — it verifies identity (login, JWT validation, API key). **Authorization** answers "what can you do?" — it determines what an authenticated identity is allowed to access. Authentication must happen before authorization. In ASP.NET Core: `UseAuthentication()` → `UseAuthorization()`.

## 📖 Detailed Explanation
**Authentication:** validates credentials and establishes identity (HttpContext.User). Schemes: JWT Bearer, Cookies, API Key, OAuth, Windows.
**Authorization:** checks whether the established identity has permission for the requested resource. Policies, roles, claims, resource-based checks.
**Key difference:** you can be authenticated (known user) but not authorized (no permission). A guest in a hotel is authenticated (checked in) but not authorized to enter other rooms.
**ASP.NET Core:** [Authorize] = requires authentication. [Authorize(Roles = "Admin")] = requires auth + role. [Authorize(Policy = "MinAge")] = requires auth + policy.

## 💻 Code Example
```csharp
// Middleware order: Authentication BEFORE Authorization
app.UseAuthentication();   // who are you?
app.UseAuthorization();    // what can you do?

// Authentication only (any logged-in user)
[Authorize]
public IActionResult Dashboard() => Ok();

// Authorization: specific role
[Authorize(Roles = "Admin,Manager")]
public IActionResult AdminPanel() => Ok();

// Authorization: policy
[Authorize(Policy = "PremiumSubscriber")]
public IActionResult PremiumContent() => Ok();

// Allow anonymous (bypass auth completely)
[AllowAnonymous]
public IActionResult PublicPage() => Ok();
```

## ❓ Follow-Up Questions
- **Q: Can you be authorized without being authenticated?** A: No — you must first establish identity, then check permissions.
- **Q: What is multi-factor authentication (MFA)?** A: A second factor (OTP, hardware key) in addition to password — strengthens authentication.
- **Q: What HTTP status for each failure?** A: 401 Unauthorized = not authenticated; 403 Forbidden = authenticated but not authorized.

## ⚠️ Common Mistakes
❌ Placing UseAuthorization before UseAuthentication in the pipeline.
✅ Authentication must run first to establish the identity that Authorization then checks. Wrong order = all users appear anonymous to the authorization check.

## 🎯 Cheat Sheet
- **Authentication:** "who are you?" — verifies identity, 401 on failure
- **Authorization:** "what can you do?" — checks permissions, 403 on failure
- **Order:** UseAuthentication → UseAuthorization → endpoints
- **Keywords:** ClaimsPrincipal, [Authorize], 401 vs 403, identity, permission

## 🏢 Industry Experience Answer
"The clearest way I explain it: authentication is showing your passport at the border (proving who you are), authorization is having the right visa (proving you're allowed to enter). In our API, JWT authentication identifies every request, then endpoint authorization checks roles and policies. We return 401 for missing/invalid tokens and 403 for valid tokens with insufficient permissions — correct HTTP semantics matter for client error handling."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is authorization vs authentication?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q4
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Role-based authorization (RBAC) restricts access based on **roles assigned to a user** (Admin, Manager, User, Editor). In ASP.NET Core, roles are stored as claims in the JWT/cookie. The `[Authorize(Roles = "Admin")]` attribute or `RequireRole()` in policy checks if the current user's ClaimsPrincipal contains the required role claim.

## 📖 Detailed Explanation
**How it works:** during authentication, user's roles are added as claims. The authorization middleware checks for the required role claim.
**JWT roles:** added as claims when generating the token: `new Claim(ClaimTypes.Role, "Admin")`.
**Cookie auth:** roles stored in the authentication ticket cookie.
**Multiple roles:** `[Authorize(Roles = "Admin,Manager")]` — user needs ANY of the listed roles (OR logic).
**All roles:** use multiple attributes for AND logic: `[Authorize(Roles = "Admin")] [Authorize(Roles = "SuperUser")]`.

## 💻 Code Example
```csharp
// Add role claim when generating JWT
var claims = new[]
{
    new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
    new Claim(ClaimTypes.Role, "Admin"),    // single role
    new Claim(ClaimTypes.Role, "Editor"),   // multiple roles = multiple claims
};

// Role-based authorization on endpoints
[Authorize(Roles = "Admin")]
[HttpDelete("users/{id}")]
public async Task<IActionResult> DeleteUser(int id) => Ok();

[Authorize(Roles = "Admin,Manager")]   // Admin OR Manager
[HttpGet("reports")]
public IActionResult GetReports() => Ok();

// Check in code
if (User.IsInRole("Admin"))
    return Ok("Admin view");
```

## ❓ Follow-Up Questions
- **Q: RBAC vs ABAC (Attribute-Based)?** A: RBAC uses named roles; ABAC uses attributes/context (user.Department, resource.Owner). ABAC is more granular but complex.
- **Q: What if a user has multiple roles?** A: Add multiple Role claims to the JWT — IsInRole checks for any matching claim.
- **Q: Role in JWT vs database?** A: JWT roles: stateless but stale until token refresh. DB roles: always fresh but require a DB call per request.

## ⚠️ Common Mistakes
❌ Hardcoding role strings everywhere without constants.
✅ Define role names as constants (static class Roles { public const string Admin = "Admin"; }) — typos in role strings cause silent authorization failures.

## 🎯 Cheat Sheet
- **[Authorize(Roles="X")]:** user must have role X
- **OR:** list roles comma-separated in one attribute
- **AND:** stack multiple [Authorize] attributes
- **Check in code:** User.IsInRole("Admin")
- **Keywords:** RBAC, ClaimTypes.Role, role claim, JWT roles

## 🏢 Industry Experience Answer
"RBAC works well for coarse-grained access control — Admin, Manager, User. For our multi-tenant SaaS we combine it with claim-based authorization: roles define what type of user, claims define the tenant scope. One gotcha: role changes don't take effect until the JWT expires and a new one is issued, so we keep access token expiry short (15 minutes)."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is role-based authorization?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q5
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Policy-based authorization is a flexible, expressive authorization model where you define **named policies** that can check multiple requirements — claims, roles, custom logic, or resource ownership. Use it when role-based authorization isn't expressive enough. Register policies in AddAuthorization(); apply with `[Authorize(Policy = "PolicyName")]`.

## 📖 Detailed Explanation
**Why policies:** roles are coarse (Admin/User). Policies let you express "user must be over 18 AND from India" or "user must own the resource." They're composable, testable, and centrally defined.
**Components:**
- **Policy:** named set of requirements registered in AddAuthorization.
- **Requirement:** IAuthorizationRequirement (data/marker).
- **Handler:** IAuthorizationHandler<TRequirement> — logic that evaluates the requirement.
**Resource-based authorization:** pass the resource to IAuthorizationService.AuthorizeAsync for per-resource checks.

## 💻 Code Example
```csharp
// Custom requirement
public class MinimumAgeRequirement : IAuthorizationRequirement
{
    public int MinAge { get; }
    public MinimumAgeRequirement(int minAge) => MinAge = minAge;
}

// Handler
public class MinimumAgeHandler : AuthorizationHandler<MinimumAgeRequirement>
{
    protected override Task HandleRequirementAsync(
        AuthorizationHandlerContext ctx, MinimumAgeRequirement req)
    {
        var dob = ctx.User.FindFirst("DateOfBirth")?.Value;
        if (dob is not null && DateTime.TryParse(dob, out var birth))
        {
            var age = DateTime.Today.Year - birth.Year;
            if (age >= req.MinAge) ctx.Succeed(req);
        }
        return Task.CompletedTask;
    }
}

// Register
builder.Services.AddSingleton<IAuthorizationHandler, MinimumAgeHandler>();
builder.Services.AddAuthorization(o =>
{
    o.AddPolicy("Over18", p => p.Requirements.Add(new MinimumAgeRequirement(18)));
    o.AddPolicy("PremiumUser", p => p.RequireRole("Premium").RequireClaim("Subscription", "Active"));
});

// Apply
[Authorize(Policy = "Over18")]
public IActionResult AdultContent() => Ok();
```

## ❓ Follow-Up Questions
- **Q: Policy vs role — when to use which?** A: Roles for broad user types; policies for composite or context-dependent checks.
- **Q: What is resource-based authorization?** A: Inject IAuthorizationService, call AuthorizeAsync(user, resource, policy) to check ownership of a specific object.
- **Q: Can a policy have multiple requirements?** A: Yes — ALL requirements must succeed for the policy to pass (AND logic by default).

## ⚠️ Common Mistakes
❌ Putting authorization logic directly inside controllers.
✅ Extract to named policies with handlers — reusable, testable, centrally managed. Controllers stay clean.

## 🎯 Cheat Sheet
- **Policy:** named set of requirements, AddAuthorization
- **Requirement:** IAuthorizationRequirement (data)
- **Handler:** IAuthorizationHandler — logic that calls ctx.Succeed/Fail
- **Keywords:** IAuthorizationService, resource-based, IAuthorizationRequirement

## 🏢 Industry Experience Answer
"Policy-based authorization unlocked fine-grained control we couldn't express with roles. Our 'CanEditDocument' policy checks: user is authenticated, has the Editor role, AND owns or is assigned to the document. The handler receives the document as a resource. This pattern cleanly separates authorization logic from business logic and lets us unit-test authorization independently."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is policy-based authorization?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q6
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Custom authentication middleware lets you implement non-standard auth schemes — API keys, HMAC signatures, custom tokens — by inspecting the request and setting `HttpContext.User` manually. For ASP.NET Core, prefer implementing `IAuthenticationHandler` (the proper extension point) over raw middleware for integration with the auth framework, policy checks, and challenge/forbid flows.

## 📖 Detailed Explanation
**When to use:** API key authentication, HMAC request signing, legacy token formats, custom header schemes.
**Proper way — AuthenticationHandler<T>:** implement AuthenticateAsync, ChallengeAsync, ForbidAsync. Register with AddScheme<T>.
**Simple way — middleware:** call next only if auth passes; set HttpContext.User directly. Simpler but doesn't integrate with [Authorize] challenge flow.
**Order:** custom auth middleware/scheme must be registered before UseAuthorization.

## 💻 Code Example
```csharp
// API Key Authentication Handler (proper extension point)
public class ApiKeyAuthHandler : AuthenticationHandler<AuthenticationSchemeOptions>
{
    private readonly IApiKeyValidator _validator;
    public ApiKeyAuthHandler(IOptionsMonitor<AuthenticationSchemeOptions> opts,
        ILoggerFactory logger, UrlEncoder encoder, IApiKeyValidator validator)
        : base(opts, logger, encoder) => _validator = validator;

    protected override async Task<AuthenticateResult> AuthenticateAsync()
    {
        if (!Request.Headers.TryGetValue("X-Api-Key", out var key))
            return AuthenticateResult.NoResult();

        var client = await _validator.ValidateAsync(key!);
        if (client is null)
            return AuthenticateResult.Fail("Invalid API key");

        var claims = new[] { new Claim(ClaimTypes.Name, client.Name), new Claim("ClientId", client.Id) };
        var identity = new ClaimsIdentity(claims, Scheme.Name);
        var principal = new ClaimsPrincipal(identity);
        return AuthenticateResult.Success(new AuthenticationTicket(principal, Scheme.Name));
    }
    protected override Task HandleChallengeAsync(AuthenticationProperties props)
    {
        Response.StatusCode = 401;
        return Task.CompletedTask;
    }
}

// Register
builder.Services.AddAuthentication("ApiKey")
    .AddScheme<AuthenticationSchemeOptions, ApiKeyAuthHandler>("ApiKey", null);
```

## ❓ Follow-Up Questions
- **Q: Can you have multiple auth schemes?** A: Yes — AddAuthentication with multiple AddScheme/AddJwtBearer/AddCookie calls. Use [Authorize(AuthenticationSchemes = "ApiKey")] to specify.
- **Q: AuthenticationHandler vs middleware?** A: AuthenticationHandler integrates with [Authorize], challenge/forbid, policy — use it. Middleware is simpler but bypasses the framework.
- **Q: What is AuthenticateResult.NoResult vs Fail?** A: NoResult = "I don't handle this request" (try next scheme); Fail = "I handle it but it failed" (return 401).

## ⚠️ Common Mistakes
❌ Setting HttpContext.User in raw middleware and bypassing the auth framework.
✅ Implement IAuthenticationHandler — it integrates correctly with [Authorize], policy-based auth, and the challenge/forbid flow.

## 🎯 Cheat Sheet
- **Implement:** AuthenticationHandler<TOptions>
- **Methods:** AuthenticateAsync, ChallengeAsync, ForbidAsync
- **Register:** AddScheme<TOptions, THandler>
- **Keywords:** AuthenticateResult, ClaimsPrincipal, auth scheme, API key

## 🏢 Industry Experience Answer
"We built an API key auth handler for our partner integrations — keys are stored hashed in the DB, validated on every request, and rate-limited per key. The AuthenticationHandler approach means [Authorize(AuthenticationSchemes = 'ApiKey')] just works, and the challenge flow returns the correct 401 with a WWW-Authenticate header. Partners get clear error responses instead of mysterious failures."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'How do you implement custom authentication middleware?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q7
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
CORS (Cross-Origin Resource Sharing) is a browser security mechanism that **restricts which origins can make HTTP requests to your API**. Browsers block cross-origin requests by default (same-origin policy). CORS headers on the server tell the browser which origins, methods, and headers are allowed. In ASP.NET Core, configure it with `AddCors` and `UseCors`.

## 📖 Detailed Explanation
**Same-origin policy:** browser blocks requests from origin A to API on origin B (different domain/port/protocol).
**CORS headers:** the server adds `Access-Control-Allow-Origin` (and others) to tell the browser to allow the cross-origin request.
**Preflight:** for non-simple requests (POST with JSON, custom headers), the browser first sends an OPTIONS preflight. The server must respond correctly for the actual request to proceed.
**Types of policy:** allow specific origins (production), allow any (development only), with/without credentials.

## 💻 Code Example
```csharp
// Register CORS policies
builder.Services.AddCors(o =>
{
    o.AddPolicy("FrontendPolicy", p => p
        .WithOrigins("https://myapp.com", "https://app.myapp.com")
        .WithMethods("GET", "POST", "PUT", "DELETE")
        .WithHeaders("Content-Type", "Authorization")
        .AllowCredentials());    // needed for cookies/auth headers

    o.AddPolicy("DevelopmentPolicy", p => p
        .AllowAnyOrigin()        // NEVER in production
        .AllowAnyMethod()
        .AllowAnyHeader());
});

// Apply (MUST be after UseRouting, before UseAuthorization)
app.UseCors("FrontendPolicy");

// Or per-endpoint
[EnableCors("FrontendPolicy")]
[HttpGet("data")]
public IActionResult GetData() => Ok();
```

## ❓ Follow-Up Questions
- **Q: Is CORS a server-side or browser-side mechanism?** A: The restriction is browser-side; the permission (CORS headers) is server-side. Server-to-server calls don't have CORS restrictions.
- **Q: What is a preflight request?** A: OPTIONS request the browser sends to check if the actual request is permitted. Must return 200 with correct headers.
- **Q: AllowAnyOrigin + AllowCredentials — why can't they be combined?** A: The CORS spec forbids it — credentials + wildcard origin is a security hole. You must specify exact origins when allowing credentials.

## ⚠️ Common Mistakes
❌ Using AllowAnyOrigin() in production.
✅ Whitelist specific origins. AllowAnyOrigin with credentials is also rejected by the CORS spec — the framework throws if you try.

## 🎯 Cheat Sheet
- **CORS:** browser mechanism to allow cross-origin requests
- **Headers:** Access-Control-Allow-Origin, -Methods, -Headers
- **Preflight:** OPTIONS request for non-simple requests
- **Keywords:** same-origin policy, UseCors, WithOrigins, AllowCredentials, preflight

## 🏢 Industry Experience Answer
"CORS misconfiguration is one of the most common API issues I debug. The rules: whitelist exactly the origins needed (no wildcards in production), always handle preflight OPTIONS correctly, and never combine AllowAnyOrigin with AllowCredentials. We configure CORS once centrally with named policies and apply the right policy per service — no duplication."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is CORS?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q8
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
CSRF (Cross-Site Request Forgery) tricks an authenticated user's browser into sending an unwanted request to your site. Prevention: use **anti-forgery tokens** (a per-session secret included in forms, validated server-side) or the **SameSite cookie attribute** (blocks cross-site cookie sending). REST APIs using Bearer tokens in the Authorization header are naturally CSRF-immune — CSRF only applies to cookie-based auth.

## 📖 Detailed Explanation
**The attack:** user is logged into bank.com. Evil.com's page triggers a POST to bank.com — the browser automatically sends the auth cookie. The bank processes it as a legitimate request.
**Why JWTs are safe:** CSRF exploits automatic cookie sending. JWTs in Authorization headers must be explicitly included by JavaScript — a cross-origin request on evil.com cannot read localStorage or add the Authorization header (blocked by CORS).
**Anti-forgery token:** ASP.NET Core generates a hidden token tied to the session. Form POST includes it; server validates it. An attacker's site can't read it due to same-origin policy.
**SameSite cookie:** `SameSite=Strict` prevents cookies from being sent on cross-origin requests entirely.

## 💻 Code Example
```csharp
// For Razor Pages / MVC with cookie auth — auto-validated
builder.Services.AddAntiforgery(o =>
{
    o.Cookie.Name = "__Host-XSRF";
    o.Cookie.SameSite = SameSiteMode.Strict;
    o.Cookie.SecurePolicy = CookieSecurePolicy.Always;
    o.HeaderName = "X-XSRF-TOKEN";   // SPA reads from cookie, sends in header
});

// For APIs using Bearer JWT — no anti-forgery needed
// JWT in Authorization header cannot be sent by attacker's cross-origin script
// (CORS + same-origin policy blocks it)

// SameSite cookie (most modern browsers default to Lax)
builder.Services.ConfigureApplicationCookie(o =>
{
    o.Cookie.SameSite = SameSiteMode.Strict;
    o.Cookie.SecurePolicy = CookieSecurePolicy.Always;
    o.Cookie.HttpOnly = true;
});
```

## ❓ Follow-Up Questions
- **Q: Why are APIs using Bearer tokens not vulnerable to CSRF?** A: The browser doesn't automatically send Authorization headers — unlike cookies. The attacker can't set that header from a cross-origin page.
- **Q: What is the Double Submit Cookie pattern?** A: A CSRF token in both a cookie and a request header/form; server validates they match. Works without server-side state.
- **Q: SameSite=Lax vs Strict?** A: Lax allows GET cross-site navigation; Strict blocks all cross-site sends including top-level navigations. Strict is safest.

## ⚠️ Common Mistakes
❌ Adding CSRF protection to an API that uses Bearer JWT tokens.
✅ Unnecessary — JWT in Authorization header can't be sent by cross-origin scripts. Anti-forgery is for cookie-authenticated MVC/Razor Pages.

## 🎯 Cheat Sheet
- **CSRF:** browser auto-sends cookies → attacker triggers actions
- **Prevention:** anti-forgery token, SameSite cookie, CORS
- **APIs with JWT:** immune to CSRF (Authorization header not auto-sent)
- **Keywords:** anti-forgery, SameSite, HttpOnly, Double Submit Cookie

## 🏢 Industry Experience Answer
"Once we switched from cookie auth to Bearer JWT for our SPA API, CSRF became a non-issue. For our Razor Pages admin portal that uses cookie auth, we keep anti-forgery tokens with SameSite=Strict cookies. The clearest way I explain it: CSRF is a cookie problem. If your auth isn't in a cookie, CSRF doesn't apply."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is CSRF protection?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q9
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**OAuth 2.0** is an authorization framework that lets a third party act on a user's behalf without sharing credentials (e.g., "Login with Google"). **OpenID Connect (OIDC)** is an identity layer on top of OAuth 2.0 — it adds authentication: the server returns an ID Token (JWT) with the user's identity claims. OAuth = authorization; OIDC = authentication + authorization.

## 📖 Detailed Explanation
**OAuth 2.0:** defines flows for obtaining access tokens. No concept of user identity — just access to resources. Flows: Authorization Code, Client Credentials, Implicit (deprecated), Device.
**OpenID Connect:** adds: ID Token (JWT with sub, name, email, iss), UserInfo endpoint, standardized discovery, and standard claims.
**Authorization Code + PKCE:** the most secure flow for web apps and SPAs. PKCE (Proof Key for Code Exchange) prevents auth code interception.
**Client Credentials:** machine-to-machine (no user) — service gets a token to call another service.

## 💻 Code Example
```csharp
// ASP.NET Core: add Google OIDC login
builder.Services.AddAuthentication(o =>
{
    o.DefaultScheme = CookieAuthenticationDefaults.AuthenticationScheme;
    o.DefaultChallengeScheme = OpenIdConnectDefaults.AuthenticationScheme;
})
.AddCookie()
.AddOpenIdConnect("Google", o =>
{
    o.Authority = "https://accounts.google.com";
    o.ClientId = builder.Configuration["Google:ClientId"];
    o.ClientSecret = builder.Configuration["Google:ClientSecret"];
    o.ResponseType = "code";   // Authorization Code flow
    o.Scope.Add("openid");
    o.Scope.Add("email");
    o.Scope.Add("profile");
    o.CallbackPath = "/signin-google";
});
```

## ❓ Follow-Up Questions
- **Q: OAuth 2.0 vs OAuth 1.0?** A: OAuth 2.0 is simpler (no cryptographic signing per request), HTTPS-dependent. The current standard.
- **Q: What is PKCE?** A: Proof Key for Code Exchange — prevents authorization code interception by including a code_verifier/code_challenge pair. Required for SPAs and mobile.
- **Q: What is the difference between access token and ID token?** A: Access token = authorization to access resources; ID token (OIDC) = user identity info.

## ⚠️ Common Mistakes
❌ Using OAuth 2.0 for authentication (checking if a user exists).
✅ OAuth 2.0 alone is not authentication — use OIDC for identity. Checking that a Google access token is valid doesn't prove who the user is; the OIDC ID Token does.

## 🎯 Cheat Sheet
- **OAuth 2.0:** authorization framework, access tokens, delegate access
- **OIDC:** OAuth + authentication, ID token, user identity
- **Flows:** Auth Code+PKCE (users), Client Credentials (services)
- **Keywords:** access token, ID token, authorization_code, PKCE, scope

## 🏢 Industry Experience Answer
"We use Auth0 as our OIDC provider — it handles OAuth flows, MFA, and social logins. Our ASP.NET Core APIs validate JWTs (access tokens) issued by Auth0; the SPA handles the OIDC login flow. For service-to-service calls we use Client Credentials flow — no user involved, just a service identity token. Understanding the difference between OAuth (authorization) and OIDC (authentication) was essential for designing this correctly."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is OAuth 2.0 and OpenID Connect? How do they differ?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q10
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Refresh tokens are **long-lived credentials** used to obtain new short-lived access tokens (JWTs) without re-authentication. They're stored securely (HttpOnly cookie, encrypted DB) and exchanged at a /refresh endpoint. Implement them securely with rotation (invalidate old token on use), revocation, and family tracking to detect refresh token theft.

## 📖 Detailed Explanation
**Flow:** login → access token (15 min) + refresh token (7 days) → access token expires → call /refresh with refresh token → new access token (and optionally new refresh token).
**Storage:** refresh token stored HttpOnly, Secure, SameSite=Strict cookie (XSS-safe) OR in DB hashed.
**Rotation:** on every refresh, invalidate the old token and issue a new one. If the old token is used again, it indicates theft — invalidate the entire family.
**Revocation:** logout invalidates the refresh token in the DB.

## 💻 Code Example
```csharp
// Refresh token entity
public class RefreshToken
{
    public Guid Id { get; set; }
    public string UserId { get; set; }
    public string TokenHash { get; set; }    // store hashed
    public DateTime ExpiresAt { get; set; }
    public bool IsRevoked { get; set; }
    public Guid FamilyId { get; set; }       // for theft detection
}

// Refresh endpoint
[HttpPost("refresh")]
public async Task<IActionResult> Refresh([FromBody] RefreshRequest req)
{
    var stored = await _db.RefreshTokens
        .FirstOrDefaultAsync(t => t.TokenHash == Hash(req.RefreshToken) && !t.IsRevoked);

    if (stored is null || stored.ExpiresAt < DateTime.UtcNow)
        return Unauthorized("Invalid or expired refresh token");

    // Rotate: revoke old, issue new
    stored.IsRevoked = true;
    var newRefresh = new RefreshToken { UserId = stored.UserId, FamilyId = stored.FamilyId,
        TokenHash = Hash(NewToken()), ExpiresAt = DateTime.UtcNow.AddDays(7) };
    _db.RefreshTokens.Add(newRefresh);
    await _db.SaveChangesAsync();

    return Ok(new { AccessToken = GenerateJwt(stored.UserId), RefreshToken = newRefresh.Id });
}
```

## ❓ Follow-Up Questions
- **Q: What is refresh token rotation?** A: Issue a new refresh token on every use and invalidate the old one — limits the window of a stolen token.
- **Q: What is a refresh token family?** A: All tokens from a single login session share a FamilyId — reuse of an already-rotated token invalidates the whole family (theft detection).
- **Q: Where to store refresh tokens?** A: HttpOnly, Secure cookie (preferred for web) or DB + return in response body (mobile). Never localStorage.

## ⚠️ Common Mistakes
❌ Storing refresh tokens in localStorage.
✅ XSS can steal localStorage. HttpOnly cookie is invisible to JavaScript. For mobile apps, use secure storage (Keychain/Keystore).

## 🎯 Cheat Sheet
- **Purpose:** get new access tokens without re-login
- **Store:** HttpOnly cookie or DB (hashed)
- **Rotation:** new refresh token on every use, invalidate old
- **Family:** detect reuse of revoked token → revoke family
- **Keywords:** token rotation, revocation, HttpOnly, family tracking

## 🏢 Industry Experience Answer
"Our refresh token implementation: 15-min access JWTs returned in response body, 7-day refresh tokens in HttpOnly cookies with rotation. Every refresh issues a new token and revokes the old. Family tracking catches stolen tokens — if a previously-rotated token is presented, we revoke the whole family and force re-login. This has caught credential theft attempts in production."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are refresh tokens and how do you implement them securely?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q11
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Claims are **key-value pairs** in a `ClaimsPrincipal` that describe attributes of an authenticated user (name, email, role, tenantId, subscription level). In ASP.NET Core, the JWT payload claims are mapped to `ClaimsPrincipal.Claims` after authentication — middleware and policies read them for authorization decisions without querying the database.

## 📖 Detailed Explanation
**Claim:** `new Claim(type, value)` — type is a URI or constant (ClaimTypes.Email), value is a string.
**ClaimsPrincipal:** represents the user; contains one or more ClaimsIdentity objects (one per auth scheme).
**ClaimsIdentity:** a set of claims for one identity; has an AuthenticationType.
**Accessing claims:** `User.FindFirst(ClaimTypes.Email)?.Value`, `User.Claims.Where(c => c.Type == "tenantId")`.
**Custom claims:** any string type — "tenantId", "subscriptionLevel", "departmentCode".

## 💻 Code Example
```csharp
// Adding claims in JWT generation
var claims = new List<Claim>
{
    new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
    new Claim(ClaimTypes.Email, user.Email),
    new Claim(ClaimTypes.Role, user.Role),
    new Claim("tenantId", user.TenantId.ToString()),
    new Claim("subscriptionLevel", user.SubscriptionLevel),
};

// Accessing claims in a controller
[HttpGet("me")]
[Authorize]
public IActionResult GetCurrentUser()
{
    var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
    var email = User.FindFirstValue(ClaimTypes.Email);
    var tenantId = User.FindFirstValue("tenantId");
    return Ok(new { userId, email, tenantId });
}

// Claim in a policy requirement
protected override Task HandleRequirementAsync(AuthorizationHandlerContext ctx, MyRequirement req)
{
    var level = ctx.User.FindFirstValue("subscriptionLevel");
    if (level == "Premium") ctx.Succeed(req);
    return Task.CompletedTask;
}
```

## ❓ Follow-Up Questions
- **Q: ClaimTypes vs custom string types?** A: ClaimTypes are standardized URIs (ClaimTypes.Email = "...email-address"). Custom strings are fine for domain-specific claims.
- **Q: How many claims should a JWT have?** A: As few as necessary. JWTs are sent on every request — large payloads increase bandwidth. Include identifiers, not full user profiles.
- **Q: Can claims expire?** A: Claims themselves don't expire; the JWT containing them does. Put the exp claim on the token.

## ⚠️ Common Mistakes
❌ Putting large amounts of user data in JWT claims.
✅ Include only identifiers (userId, roles, tenantId). Fetch detailed profile from the user service when needed.

## 🎯 Cheat Sheet
- **Claim:** key-value attribute of the user identity
- **ClaimsPrincipal:** container for all claims
- **Access:** User.FindFirst(type), User.FindFirstValue(type), User.IsInRole()
- **Keywords:** ClaimTypes, ClaimsIdentity, FindFirstValue, custom claim

## 🏢 Industry Experience Answer
"Claims are how we pass context through the auth boundary without extra DB calls. Our JWTs carry userId, tenantId, role, and subscription tier — everything a request needs for authorization. Multi-tenancy data isolation is enforced with a tenantId claim: every repository filters by the tenantId from the current user's claims, never trusting a client-supplied value."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are claims and claim-based identity in ASP.NET Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q12
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Store sensitive configuration (connection strings, API keys, JWT secrets) using **.NET User Secrets** in development (stored outside the project, never in git) and **environment variables** or **Azure Key Vault** in production. Never commit secrets to source control — they're compromised the moment they appear in git history.

## 📖 Detailed Explanation
**User Secrets (development):** `dotnet user-secrets set "Jwt:Key" "my-secret"` — stored in `~/.microsoft/usersecrets/{userSecretsId}/secrets.json` on your machine, outside the repo. Loaded automatically in Development by WebApplication.CreateBuilder.
**Environment variables (production):** set in the deployment environment (Kubernetes secrets, App Service settings, docker-compose env). Use double-underscore for hierarchy: `Jwt__Key`.
**Azure Key Vault:** call AddAzureKeyVault() — secrets fetched at startup (or live). Uses managed identity — no credentials stored anywhere.
**Secret scanning:** GitHub and Azure DevOps have built-in secret scanning that alerts on committed secrets.

## 💻 Code Example
```csharp
// 1. Enable User Secrets in your project
// dotnet user-secrets init
// dotnet user-secrets set "ConnectionStrings:Default" "Host=localhost;..."
// dotnet user-secrets set "Jwt:Key" "super-secret-key-32-chars"

// 2. Access in code — same as appsettings
var connStr = builder.Configuration.GetConnectionString("Default");
var jwtKey = builder.Configuration["Jwt:Key"];

// 3. Azure Key Vault in production
builder.Configuration.AddAzureKeyVault(
    new Uri("https://myvault.vault.azure.net/"),
    new DefaultAzureCredential());   // uses managed identity — no credentials!

// 4. Environment variable (Kubernetes/App Service)
// env var: ConnectionStrings__Default = "Host=prod-db;..."
// auto-mapped to: config["ConnectionStrings:Default"]
```

## ❓ Follow-Up Questions
- **Q: Where does User Secrets store files?** A: `%APPDATA%/Microsoft/UserSecrets/{id}/secrets.json` (Windows) or `~/.microsoft/usersecrets/{id}/secrets.json` (Linux/Mac).
- **Q: What is managed identity in Azure?** A: A service identity that Azure manages — your app authenticates to Key Vault without any stored credentials.
- **Q: What if a secret is accidentally committed?** A: Rotate it immediately — assume it's compromised. Remove from git history with git-filter-repo. Audit access logs.

## ⚠️ Common Mistakes
❌ Storing secrets in appsettings.json committed to git.
✅ Even a private repo isn't safe enough — git history is persistent and access control can fail. Use User Secrets locally, env vars or Key Vault in production.

## 🎯 Cheat Sheet
- **Dev:** User Secrets — stored outside repo, `dotnet user-secrets set`
- **Prod:** environment variables or Azure Key Vault
- **Never:** secrets in appsettings.json in git
- **Keywords:** UserSecrets, Key Vault, managed identity, DefaultAzureCredential, rotation

## 🏢 Industry Experience Answer
"Secret management is the first security practice I enforce on new projects. User Secrets in development, Azure Key Vault with managed identity in production — zero credentials stored anywhere. We also have a GitHub secret scanning rule that blocks PRs containing API keys or connection strings. The discipline must be in the tooling, not just policy."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'How do you store sensitive configuration data using .NET Secrets?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q13
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**HTTPS enforcement** redirects all HTTP requests to HTTPS. **HSTS (HTTP Strict Transport Security)** tells browsers to only ever connect via HTTPS for a specified period — even if the user types http://. In ASP.NET Core: `UseHttpsRedirection()` for redirects and `UseHsts()` for the HSTS header. Always enable both in production.

## 📖 Detailed Explanation
**UseHttpsRedirection:** redirects HTTP (80) to HTTPS (443) with a 301/307 redirect. Handles misconfigured clients; doesn't protect the first request.
**HSTS header:** `Strict-Transport-Security: max-age=31536000; includeSubDomains; preload`. Browser remembers: never send this domain over HTTP. Protects against downgrade attacks and SSL stripping.
**Preload:** submit your domain to browsers' built-in HSTS preload list — even the first-ever visit is HTTPS. Irreversible without long waiting periods — only for stable domains.
**Development:** HSTS is disabled in development by default (would break HTTP debugging).

## 💻 Code Example
```csharp
// Program.cs
var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    // HSTS — only in production
    app.UseHsts();
}

// Redirect HTTP to HTTPS
app.UseHttpsRedirection();

// Configure HSTS options
builder.Services.AddHsts(o =>
{
    o.MaxAge = TimeSpan.FromDays(365);     // 1 year
    o.IncludeSubDomains = true;
    o.Preload = true;                       // submittable to preload list
});

// ASP.NET Core Kestrel — enforce HTTPS in production
builder.WebHost.ConfigureKestrel(o =>
{
    o.ListenAnyIP(80);    // HTTP — will redirect
    o.ListenAnyIP(443, l => l.UseHttps());  // HTTPS
});
```

## ❓ Follow-Up Questions
- **Q: What is an SSL stripping attack?** A: Attacker intercepts the initial HTTP request before the redirect, serving a fake HTTP site. HSTS prevents this by caching the HTTPS requirement in the browser.
- **Q: Should HSTS be on during development?** A: No — UseHsts is intentionally excluded from Development by the default template. It would break HTTP localhost.
- **Q: What is HSTS preloading?** A: Submitting your domain to browsers' hardcoded HSTS list — zero HTTP even on first visit. Permanent commitment.

## ⚠️ Common Mistakes
❌ Enabling HSTS before your TLS certificate is fully set up.
✅ HSTS is irreversible for max-age duration — enabling it with a broken cert locks users out. Test TLS thoroughly before enabling HSTS with a long max-age.

## 🎯 Cheat Sheet
- **UseHttpsRedirection:** HTTP → HTTPS redirect (301/307)
- **UseHsts:** Strict-Transport-Security header, browser caches HTTPS requirement
- **Preload:** browser hard-codes HTTPS for domain — permanent commitment
- **Keywords:** SSL stripping, HSTS, max-age, includeSubDomains, TLS

## 🏢 Industry Experience Answer
"HTTPS is non-negotiable for any production API. We enable UseHttpsRedirection and UseHsts with a 1-year max-age. Our domains are on the HSTS preload list. The TLS certificate is managed by Let's Encrypt with auto-renewal via cert-manager in Kubernetes — zero manual certificate management. The HSTS + preload combination means there's no path for HTTP traffic to our services."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is HTTPS enforcement and HSTS in ASP.NET Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q14
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
SQL injection is an attack where malicious SQL is injected into an input that gets concatenated into a query — allowing attackers to read, modify, or delete data. **EF Core fully protects against SQL injection** by using parameterized queries for all LINQ-generated SQL. The only risk is raw SQL methods if you concatenate user input — use parameters there too.

## 📖 Detailed Explanation
**How it works:** `SELECT * FROM Users WHERE Name = '" + input + "'"`. Input `' OR '1'='1` returns all rows. Input `'; DROP TABLE Users;--` destroys data.
**EF Core protection:** all LINQ queries generate parameterized SQL — values are passed as SQL parameters, never concatenated. The DB treats them as data, not SQL.
**Risk area — raw SQL:** `FromSqlRaw("SELECT * FROM Users WHERE Name = '" + name + "'")` is vulnerable. Use `FromSqlRaw("SELECT * FROM Users WHERE Name = {0}", name)` or `FromSqlInterpolated`.

## 💻 Code Example
```csharp
// SAFE: EF Core LINQ — always parameterized
var user = await _ctx.Users.FirstOrDefaultAsync(u => u.Name == userInput);
// Generates: SELECT * FROM Users WHERE Name = @p0
// @p0 = userInput — data, never SQL

// SAFE: raw SQL with parameters
var users = await _ctx.Users
    .FromSqlRaw("SELECT * FROM Users WHERE Name = {0}", userInput)
    .ToListAsync();

// SAFE: interpolated (EF wraps params automatically)
var users2 = await _ctx.Users
    .FromSqlInterpolated($"SELECT * FROM Users WHERE Name = {userInput}")
    .ToListAsync();

// VULNERABLE: string concatenation in raw SQL — NEVER DO
var users3 = await _ctx.Users
    .FromSqlRaw("SELECT * FROM Users WHERE Name = '" + userInput + "'")
    .ToListAsync();   // SQL INJECTION RISK
```

## ❓ Follow-Up Questions
- **Q: Is EF Core immune to SQL injection?** A: For LINQ queries, yes. For raw SQL with string concatenation, no — always use parameters.
- **Q: What is FromSqlInterpolated?** A: A safe version of raw SQL that takes a FormattableString — EF extracts interpolated values as parameters.
- **Q: Other defenses?** A: Least-privilege DB accounts, input validation, stored procedures with parameters, WAF.

## ⚠️ Common Mistakes
❌ Using FromSqlRaw with string concatenation for user input.
✅ Always use {0} placeholders or FromSqlInterpolated. Or better, avoid raw SQL for user-input-driven queries — use LINQ.

## 🎯 Cheat Sheet
- **LINQ queries:** always safe — EF parameterizes automatically
- **Raw SQL:** use {0} / FromSqlInterpolated — never concatenate
- **Attack:** user input becomes executable SQL
- **Keywords:** parameterized query, FromSqlInterpolated, OWASP Top 10, least privilege

## 🏢 Industry Experience Answer
"EF Core with LINQ gives us SQL injection protection for free — parameterization is built in. The risk we audit for is FromSqlRaw with any string that has a user-input component. We have a Roslyn analyzer that flags string concatenation inside raw SQL methods. Two layers of defense: never concatenate user input, and our DB accounts have only SELECT/INSERT/UPDATE/DELETE — no DROP or schema access."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is SQL injection and how does EF Core protect against it?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q15
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**Symmetric encryption** uses the **same secret key** for signing and verifying (HMAC-SHA256 — fast, simple, server-only). **Asymmetric encryption** uses a **private key to sign** and a **public key to verify** (RS256, ES256 — allows anyone with the public key to verify without exposing the signing key). Use symmetric for single-service JWTs; asymmetric for multi-service or external consumers.

## 📖 Detailed Explanation
**Symmetric (HS256):** `HMACSHA256(header.payload, secret)`. Only parties with the secret can sign or verify. Simple, fast, no key distribution for verification. Risk: every service that needs to verify must have the secret — if one is compromised, all are.
**Asymmetric (RS256/ES256):** private key signs (kept secret on auth server), public key verifies (safely distributed). Other services verify tokens without ever having the signing key. JWKS (JSON Web Key Set) endpoint exposes the public key automatically.
**ES256 vs RS256:** both asymmetric. ES256 (ECDSA) produces smaller signatures and is faster than RS256 (RSA). Prefer ES256 for new systems.

## 💻 Code Example
```csharp
// Symmetric (HS256) — single service, same key to sign and verify
var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("your-32-char-secret-here!!!!!!!!"));
var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

// Asymmetric (RS256) — auth server signs, APIs verify via public key
// Generate key pair:  openssl genrsa -out private.pem 2048
//                     openssl rsa -in private.pem -pubout -out public.pem

// Auth server (signs with private key)
var rsa = RSA.Create();
rsa.ImportFromPem(File.ReadAllText("private.pem"));
var rsaKey = new RsaSecurityKey(rsa);
var rsaCreds = new SigningCredentials(rsaKey, SecurityAlgorithms.RsaSha256);

// API server (verifies with public key only)
options.TokenValidationParameters = new TokenValidationParameters
{
    IssuerSigningKeyResolver = (token, secToken, kid, params) =>
    {
        // Fetch from JWKS endpoint: https://auth.myapp.com/.well-known/jwks.json
        var publicKeys = FetchPublicKeys();
        return publicKeys;
    }
};
```

## ❓ Follow-Up Questions
- **Q: Why is asymmetric better for microservices?** A: Each microservice only needs the public key to verify tokens — the private signing key stays only on the auth server. A compromised microservice can't forge tokens.
- **Q: What is a JWKS endpoint?** A: A well-known URL (/.well-known/jwks.json) that exposes the public keys — consuming services auto-discover them.
- **Q: ES256 vs RS256?** A: Both asymmetric. ES256 (ECDSA P-256) is smaller, faster, and the modern recommendation. RS256 is more widely supported.

## ⚠️ Common Mistakes
❌ Using HS256 with the same secret across multiple microservices.
✅ If any service is compromised, it can forge JWTs for all others. Use RS256/ES256 — only the auth server has the private key; all others get the public key.

## 🎯 Cheat Sheet
- **HS256:** symmetric, same key sign+verify, single service or trusted boundary
- **RS256:** asymmetric, private signs / public verifies, multi-service
- **ES256:** asymmetric, ECDSA, smaller+faster than RSA, preferred
- **JWKS:** auto-distribute public keys via well-known endpoint
- **Keywords:** signing key, verification, public key, private key, JWKS

## 🏢 Industry Experience Answer
"We use RS256 for our JWT signing — the auth service has the private key, all API services fetch the public key from the JWKS endpoint on startup and cache it. This means a compromised API service can read tokens but can't forge new ones. We're migrating to ES256 for the performance and smaller token size benefits."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Symmetric vs asymmetric encryption for JWT signing?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- End of Batch 5 — Auth & Security COMPLETE (Q1–Q15)

-- ════════════════════════════════════════════════════════════
-- DevReady Seed — Batch 6
-- .NET › 6️⃣ Web API Concepts › Q1–Q17
-- Dollar-quote safe (zero $ inside content). Idempotent upsert.
-- ════════════════════════════════════════════════════════════

-- Q1
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A Web API is an application that exposes functionality over HTTP using standard protocols — clients send HTTP requests and receive structured responses (JSON, XML). It's the backbone of modern distributed systems: SPAs talk to APIs, mobile apps talk to APIs, microservices talk to each other via APIs. ASP.NET Core provides a first-class Web API framework via controllers and minimal APIs.

## 📖 Detailed Explanation
**What it is:** an application accessible via HTTP/HTTPS that accepts requests and returns responses — typically JSON.
**Why it matters:** decoupling — the backend serves data; any client (React SPA, mobile app, third-party service) can consume it independently.
**Types:** REST (most common), GraphQL, gRPC, SOAP (legacy). REST is the dominant style for public and internal APIs.
**Core components:** endpoints (URL + method), request/response models, authentication, error handling, versioning, documentation.

## 💻 Code Example
```csharp
// Minimal Web API in ASP.NET Core
var builder = WebApplication.CreateBuilder(args);
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();
app.UseSwagger();
app.UseSwaggerUI();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
app.Run();

// A controller
[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll() => Ok(new[] { "Laptop", "Phone" });

    [HttpGet("{id:int}")]
    public IActionResult GetById(int id) => Ok(new { Id = id, Name = "Laptop" });
}
```

## ❓ Follow-Up Questions
- **Q: REST vs SOAP vs GraphQL?** A: REST = resource-based HTTP; SOAP = XML contract-based (enterprise/legacy); GraphQL = query language, client specifies shape.
- **Q: What makes it a "Web" API vs a desktop API?** A: HTTP transport — accessible over the network via URLs.
- **Q: What is [ApiController]?** A: Enables auto-400 on model validation, [FromBody] inference, ProblemDetails responses — essential for APIs.

## ⚠️ Common Mistakes
❌ Building an API without authentication or rate limiting.
✅ Every API needs auth (who can call it), authorization (what can they do), rate limiting (how often), and proper error responses — security is not optional.

## 🎯 Cheat Sheet
- **Definition:** HTTP-accessible application, JSON responses
- **[ApiController]:** auto-validation, ProblemDetails, binding inference
- **Styles:** REST (most common), GraphQL, gRPC, SOAP
- **Keywords:** endpoint, request/response, JSON, HTTP methods, status codes

## 🏢 Industry Experience Answer
"Every product I've built in the last five years is API-first. The backend exposes a versioned REST API; multiple frontends (web SPA, mobile app, partner integrations) consume it independently. The API is the product contract — breaking it breaks everything. That's why versioning, documentation, and backward compatibility are non-negotiable from day one."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is a Web API?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q2
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
HTTP methods define the **intended operation** on a resource: **GET** (read), **POST** (create), **PUT** (full replace), **PATCH** (partial update), **DELETE** (delete). Choosing the right method makes your API predictable, enables caching (GET), and communicates idempotency semantics clearly to clients and infrastructure.

## 📖 Detailed Explanation
- **GET:** retrieve a resource or collection. Safe + idempotent. Cacheable. No request body. 200 on success.
- **POST:** create a new resource. Not idempotent (calling twice creates two). 201 Created with Location header.
- **PUT:** full replacement — client sends the complete updated resource. Idempotent. 200 or 204.
- **PATCH:** partial update — only send changed fields. Not inherently idempotent (depends on implementation). 200 or 204.
- **DELETE:** remove a resource. Idempotent (deleting an already-deleted resource = same end state). 204 on success.
- **HEAD:** like GET but no body — useful to check if a resource exists or get its metadata.
- **OPTIONS:** used by CORS preflight to discover allowed methods.

## 💻 Code Example
```csharp
[ApiController]
[Route("api/orders")]
public class OrdersController : ControllerBase
{
    [HttpGet]                           // GET api/orders
    public Task<IActionResult> GetAll() => Task.FromResult<IActionResult>(Ok());

    [HttpGet("{id:int}")]               // GET api/orders/1
    public Task<IActionResult> GetById(int id) => Task.FromResult<IActionResult>(Ok());

    [HttpPost]                          // POST api/orders — create
    public Task<IActionResult> Create(CreateOrderDto dto) =>
        Task.FromResult<IActionResult>(CreatedAtAction(nameof(GetById), new { id = 1 }, dto));

    [HttpPut("{id:int}")]               // PUT api/orders/1 — full replace
    public Task<IActionResult> Replace(int id, OrderDto dto) =>
        Task.FromResult<IActionResult>(NoContent());

    [HttpPatch("{id:int}")]             // PATCH api/orders/1 — partial update
    public Task<IActionResult> Update(int id, JsonPatchDocument<OrderDto> patch) =>
        Task.FromResult<IActionResult>(NoContent());

    [HttpDelete("{id:int}")]            // DELETE api/orders/1
    public Task<IActionResult> Delete(int id) =>
        Task.FromResult<IActionResult>(NoContent());
}
```

## ❓ Follow-Up Questions
- **Q: PUT vs PATCH?** A: PUT replaces the entire resource; PATCH updates only specified fields. Use PATCH for partial updates to avoid accidentally nulling fields.
- **Q: Which methods are safe?** A: GET, HEAD, OPTIONS — they don't modify state.
- **Q: Which are idempotent?** A: GET, PUT, DELETE, HEAD, OPTIONS. POST is not (creates new each time); PATCH may not be.

## ⚠️ Common Mistakes
❌ Using GET with a body for complex search queries.
✅ GET bodies are technically allowed but widely unsupported. Use POST for complex searches (POST /search) or encode criteria in query parameters.

## 🎯 Cheat Sheet
- **GET:** read, safe, idempotent, cacheable → 200
- **POST:** create, not idempotent → 201 + Location
- **PUT:** full replace, idempotent → 200/204
- **PATCH:** partial update → 200/204
- **DELETE:** remove, idempotent → 204
- **Keywords:** safe, idempotent, cacheable, HTTP verb semantics

## 🏢 Industry Experience Answer
"Method semantics matter for infrastructure. GET responses are cached by CDNs and browsers — a miscategorized POST won't be. DELETE idempotency means retry logic on network failure is safe. PUT vs PATCH confusion causes data loss bugs — a client sending partial PUT data nulls out fields they didn't include. I standardize on PATCH for partial updates in all our APIs."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are HTTP methods (GET, POST, PUT, DELETE, PATCH)?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q3
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
HTTP status codes are 3-digit numeric responses that tell the client **what happened**: 2xx = success, 3xx = redirect, 4xx = client error, 5xx = server error. Using correct status codes is essential for REST API correctness — clients, load balancers, and monitoring systems all use them to make decisions.

## 📖 Detailed Explanation
**2xx — Success:**
- 200 OK — standard success with body
- 201 Created — resource created, Location header points to new resource
- 204 No Content — success, no body (DELETE, PUT with no return)
- 202 Accepted — async operation started, not yet complete

**3xx — Redirection:**
- 301 Moved Permanently — URL changed forever
- 302/307 — temporary redirect
- 304 Not Modified — cached response is still valid (ETag/If-None-Match)

**4xx — Client Error:**
- 400 Bad Request — invalid input, validation failure
- 401 Unauthorized — not authenticated
- 403 Forbidden — authenticated but not authorized
- 404 Not Found — resource doesn't exist
- 405 Method Not Allowed
- 409 Conflict — state conflict (duplicate, optimistic concurrency)
- 422 Unprocessable Entity — syntactically valid but semantically wrong
- 429 Too Many Requests — rate limit exceeded

**5xx — Server Error:**
- 500 Internal Server Error — unhandled exception
- 502 Bad Gateway — upstream service failed
- 503 Service Unavailable — overloaded/maintenance
- 504 Gateway Timeout — upstream timed out

## 💻 Code Example
```csharp
[HttpPost]
public async Task<IActionResult> CreateOrder(CreateOrderDto dto)
{
    if (!ModelState.IsValid) return BadRequest(ModelState);         // 400
    if (!await _auth.CanCreateAsync(User)) return Forbid();        // 403
    if (await _repo.ExistsAsync(dto.ExternalId)) return Conflict(); // 409

    var order = await _service.CreateAsync(dto);
    return CreatedAtAction(nameof(GetById), new { id = order.Id }, order); // 201
}
```

## ❓ Follow-Up Questions
- **Q: 401 vs 403?** A: 401 = not authenticated (no identity); 403 = authenticated but not permitted.
- **Q: 400 vs 422?** A: 400 = structurally bad request; 422 = valid structure but business rule violation.
- **Q: When to return 404 vs 403?** A: 403 reveals the resource exists. Use 404 for security-sensitive resources to avoid information disclosure.

## ⚠️ Common Mistakes
❌ Returning 200 OK with an error body (error in the response JSON).
✅ Use the appropriate 4xx/5xx code — clients, monitoring, and load balancers act on status codes, not response body content.

## 🎯 Cheat Sheet
- **2xx:** success (200, 201, 204, 202)
- **3xx:** redirect (301, 304)
- **4xx:** client error (400, 401, 403, 404, 409, 422, 429)
- **5xx:** server error (500, 502, 503, 504)
- **Keywords:** semantic correctness, monitoring, retry logic, RFC 7231

## 🏢 Industry Experience Answer
"Correct status codes are a force multiplier. Our alerting fires on 5xx spikes automatically. Load balancers retry on 503. CDNs cache 304s. Clients retry 429s with backoff. If everything returns 200, all that infrastructure intelligence breaks. I enforce status code correctness in code reviews — it's as important as the business logic."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are HTTP status codes and what do they indicate?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q4
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
REST (Representational State Transfer) is an architectural **style** for distributed hypermedia systems, not a protocol. It defines six constraints: client-server, stateless, cacheable, uniform interface, layered system, and code on demand (optional). A "RESTful" API uses HTTP semantically — resources identified by URLs, methods define operations, status codes signal outcomes.

## 📖 Detailed Explanation
**Six REST constraints:**
1. **Client-Server:** UI and data are separated — independent evolution.
2. **Stateless:** each request contains all information needed; no server-side session.
3. **Cacheable:** responses declare cacheability; reduces load.
4. **Uniform Interface:** resource-based URLs, standard methods, self-descriptive messages.
5. **Layered System:** client can't tell if connected directly to server or through a proxy/CDN.
6. **Code on Demand (optional):** server sends executable code (JavaScript).

**Resource-based design:** nouns in URLs (`/orders/{id}`), not verbs (`/getOrder`). Operations expressed via HTTP methods.

## 💻 Code Example
```csharp
// RESTful resource design
// GET  /api/orders          — list all
// GET  /api/orders/{id}     — get one
// POST /api/orders          — create
// PUT  /api/orders/{id}     — full replace
// PATCH /api/orders/{id}    — partial update
// DELETE /api/orders/{id}   — delete

// Sub-resources
// GET /api/orders/{id}/items        — get items of an order
// POST /api/orders/{id}/items       — add item to order
// DELETE /api/orders/{ordId}/items/{itemId}

// NOT RESTful (verb in URL — avoid)
// POST /api/getOrder
// POST /api/cancelOrder/{id}    -- better: PATCH /api/orders/{id} { status: "Cancelled" }
```

## ❓ Follow-Up Questions
- **Q: Is REST a standard?** A: No — it's an architectural style defined by Roy Fielding's 2000 dissertation. Most "REST APIs" are actually REST-ish (pragmatic REST).
- **Q: REST vs RPC?** A: REST is resource-centric (nouns); RPC is action-centric (verbs). gRPC and JSON-RPC are RPC styles.
- **Q: What is HATEOAS?** A: Hypermedia as the Engine of Application State — responses include links to related actions. Rarely implemented fully in practice.

## ⚠️ Common Mistakes
❌ Putting verbs in URLs: /api/activateUser, /api/sendEmail.
✅ Use nouns + HTTP methods: PATCH /api/users/{id} with { status: "Active" }; POST /api/emails.

## 🎯 Cheat Sheet
- **REST:** architectural style, 6 constraints, resource-based
- **Resources:** nouns in URLs, methods express operations
- **Stateless:** each request self-contained, no server session
- **Keywords:** idempotent, cacheable, uniform interface, HTTP semantics

## 🏢 Industry Experience Answer
"True REST with all 6 constraints (especially HATEOAS) is rarely implemented in practice — most APIs are pragmatic REST. What I focus on: resource-based URLs with proper HTTP methods, correct status codes, stateless design (JWT not session), and versioning. The REST style provides a shared vocabulary that makes APIs predictable for consumers."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is REST architecture?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q5
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
An operation is **idempotent** if making the same request multiple times produces the **same result as making it once** — the server state is identical after N calls as after 1. Idempotent HTTP methods: GET, PUT, DELETE, HEAD, OPTIONS. POST and PATCH are generally NOT idempotent. Idempotency enables safe retries in distributed systems.

## 📖 Detailed Explanation
**Why it matters:** networks are unreliable. Clients retry failed requests. If the operation is idempotent, retrying is safe — no duplicate data, no unintended side effects.
**GET:** reading the same resource N times returns the same result, changes nothing.
**PUT:** replacing a resource with the same data N times = same state.
**DELETE:** deleting a resource that's already deleted = still deleted (204 or 404 — same end state).
**POST:** typically creates a new resource each time — NOT idempotent.
**Idempotency keys:** for non-idempotent operations (POST), clients send a unique key (`Idempotency-Key: uuid`). The server deduplicates and returns the same response for repeated requests with the same key.

## 💻 Code Example
```csharp
// Idempotent: PUT replaces — same result on repeat
[HttpPut("{id:int}")]
public async Task<IActionResult> Replace(int id, UpdateOrderDto dto)
{
    await _service.ReplaceAsync(id, dto);
    return NoContent();   // calling twice = same state
}

// NOT idempotent without key: POST creates new each time
[HttpPost]
public async Task<IActionResult> Create(CreateOrderDto dto,
    [FromHeader(Name = "Idempotency-Key")] string? idempotencyKey)
{
    // Deduplication using key
    if (idempotencyKey != null)
    {
        var existing = await _idempotencyStore.GetAsync(idempotencyKey);
        if (existing != null) return existing;   // return cached response
    }

    var order = await _service.CreateAsync(dto);
    var result = CreatedAtAction(nameof(GetById), new { id = order.Id }, order);

    if (idempotencyKey != null)
        await _idempotencyStore.StoreAsync(idempotencyKey, result, TimeSpan.FromHours(24));

    return result;
}
```

## ❓ Follow-Up Questions
- **Q: Is DELETE idempotent?** A: Yes — deleting an already-deleted resource returns the same end state (no resource). Whether it returns 204 or 404 on the second call is a design choice.
- **Q: What is an idempotency key?** A: A client-generated UUID sent in a header; the server uses it to deduplicate repeated POST requests.
- **Q: Is PATCH idempotent?** A: Not inherently — depends on the operation. "Set status to Active" is idempotent; "increment counter by 1" is not.

## ⚠️ Common Mistakes
❌ Assuming all safe methods are idempotent.
✅ Safety (no side effects) and idempotency are different properties. POST is unsafe and not idempotent. GET is safe AND idempotent. DELETE is idempotent but not safe (it has a side effect — deletion).

## 🎯 Cheat Sheet
- **Idempotent:** same result regardless of how many times called
- **GET, PUT, DELETE, HEAD:** idempotent
- **POST:** not idempotent (unless idempotency key used)
- **Idempotency key:** deduplication header for POST operations
- **Keywords:** safe retry, distributed systems, Idempotency-Key

## 🏢 Industry Experience Answer
"Idempotency is critical in our payment service. A payment POST must not create duplicate charges if the client retries on timeout. We implemented Stripe's idempotency key pattern — clients generate a UUID for each payment attempt, we deduplicate in Redis for 24 hours. Without this, network timeouts caused duplicate charges in early versions."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is idempotent in REST APIs?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q6
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**Request models (DTOs — Data Transfer Objects)** define the shape of incoming request data; **response models** define what the API returns. They decouple the API contract from the domain/database model — you control exactly what's accepted and returned, hide internal structure, and can evolve each independently.

## 📖 Detailed Explanation
**Why separate from domain models:** exposing domain entities directly leaks internal structure, creates security risks (over-posting), and couples the API contract to the DB schema.
**Request DTOs:** validate input shape; use DataAnnotations or FluentValidation. Prevent mass assignment by accepting only specific fields.
**Response DTOs:** return only the data the client needs; flatten/shape data appropriately.
**Mapping:** use AutoMapper, Mapster, or manual mapping. Never return DbContext-tracked entities directly from API — they risk serialization loops and context disposal issues.

## 💻 Code Example
```csharp
// Request DTO — what we accept
public class CreateOrderRequest
{
    [Required] public string CustomerId { get; set; }
    [Required, MinLength(1)] public List<OrderItemRequest> Items { get; set; }
    [MaxLength(500)] public string? Notes { get; set; }
    // NO internal fields: Id, CreatedAt, Status — prevent over-posting
}

// Response DTO — what we return
public class OrderResponse
{
    public int Id { get; set; }
    public string CustomerId { get; set; }
    public string CustomerName { get; set; }   // flattened from Customer navigation
    public decimal Total { get; set; }
    public string Status { get; set; }          // enum as string
    public DateTime CreatedAt { get; set; }
    public List<OrderItemResponse> Items { get; set; }
    // NO internal fields: RowVersion, IsDeleted, DbId etc.
}

// Controller
[HttpPost]
public async Task<ActionResult<OrderResponse>> Create(CreateOrderRequest req)
{
    var order = await _service.CreateAsync(req);
    return CreatedAtAction(nameof(GetById), new { id = order.Id }, order);
}
```

## ❓ Follow-Up Questions
- **Q: What is over-posting?** A: Sending fields the API shouldn't accept (e.g., setting IsAdmin = true). DTOs prevent it by only accepting declared properties.
- **Q: AutoMapper vs manual mapping?** A: AutoMapper is convenient; manual is explicit and less magical. Prefer manual or Mapster for complex mappings.
- **Q: Should request/response DTOs be the same class?** A: Rarely — request and response often have different fields. Separate them.

## ⚠️ Common Mistakes
❌ Returning EF Core entity objects directly from API actions.
✅ Entities may have circular navigation properties (serialization loop), tracked state, and internal fields. Always map to response DTOs.

## 🎯 Cheat Sheet
- **Request DTO:** input shape, validated, prevents over-posting
- **Response DTO:** output shape, hides internals, flattened
- **Never:** return tracked entities directly from controllers
- **Keywords:** DTO, over-posting, AutoMapper, contract decoupling

## 🏢 Industry Experience Answer
"DTOs are a hard rule in our API design. Early on a developer returned a User entity directly — it included PasswordHash and all navigation properties, caused JSON serialization loops, and leaked internal fields to the client. Now every endpoint has an explicit response DTO. The added mapping code is worth the safety and flexibility."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are request and response models (DTOs)?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q7
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Model validation ensures incoming request data meets declared rules before your business logic runs. In ASP.NET Core with [ApiController], DataAnnotations ([Required], [Range], [MaxLength]) are checked automatically and a 400 Bad Request with ProblemDetails is returned if validation fails — no manual ModelState.IsValid check needed.

## 📖 Detailed Explanation
**DataAnnotations:** attributes on DTO properties. [Required], [Range(1, 100)], [MaxLength(200)], [EmailAddress], [RegularExpression], [Compare].
**[ApiController] behavior:** runs validation automatically before the action executes; returns 400 ProblemDetails on failure.
**Without [ApiController]:** must check ModelState.IsValid manually.
**FluentValidation:** richer, testable, code-based validation — supports complex rules, async validation, cross-property rules. Integrates with ASP.NET Core via AddFluentValidation().
**Custom attributes:** implement ValidationAttribute for reusable custom rules.

## 💻 Code Example
```csharp
// DTO with DataAnnotations
public class CreateProductRequest
{
    [Required] [MaxLength(200)] public string Name { get; set; }
    [Range(0.01, 1_000_000)] public decimal Price { get; set; }
    [Required] public string CategoryId { get; set; }
    [Url] public string? ImageUrl { get; set; }
}

// With [ApiController] — validation is automatic
[HttpPost]
public async Task<IActionResult> Create(CreateProductRequest req)
{
    // Reaches here only if validation passes
    var product = await _service.CreateAsync(req);
    return CreatedAtAction(nameof(GetById), new { id = product.Id }, product);
}

// FluentValidation (richer rules)
public class CreateProductValidator : AbstractValidator<CreateProductRequest>
{
    public CreateProductValidator()
    {
        RuleFor(x => x.Name).NotEmpty().MaximumLength(200);
        RuleFor(x => x.Price).GreaterThan(0);
        RuleFor(x => x.CategoryId).NotEmpty().MustAsync(CategoryExistsAsync)
            .WithMessage("Category does not exist");
    }
}
```

## ❓ Follow-Up Questions
- **Q: What is ModelState?** A: A dictionary of validation errors for the current request; populated by model binding and validation; checked by [ApiController] automatically.
- **Q: DataAnnotations vs FluentValidation?** A: DataAnnotations for simple rules; FluentValidation for complex, async, testable, cross-property rules.
- **Q: Can you disable automatic validation?** A: builder.Services.AddControllers(o => o.SuppressModelStateInvalidFilter = true) — then check manually.

## ⚠️ Common Mistakes
❌ Doing validation only in the service layer after returning from the controller.
✅ Validate at the entry point (controller/DTO) for a fast-fail 400 before any business logic or DB calls.

## 🎯 Cheat Sheet
- **DataAnnotations:** [Required], [Range], [MaxLength], [EmailAddress]
- **[ApiController]:** auto-validates + returns 400 on failure
- **FluentValidation:** code-based, testable, async rules
- **Keywords:** ModelState, ProblemDetails, fast-fail, 400, AbstractValidator

## 🏢 Industry Experience Answer
"We use FluentValidation for all complex validation — it's testable (we unit-test validators), async (can check DB uniqueness), and keeps business rules out of attributes. DataAnnotations handle the simple structural rules. The combination gives us a clean, fast-fail validation layer before any expensive service logic runs."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is model validation?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q8
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
API versioning allows you to **introduce breaking changes without breaking existing clients** by maintaining multiple API versions simultaneously. Common strategies: **URL path** (`/api/v1/orders`), **query string** (`?version=1.0`), **header** (`X-Api-Version: 1.0`), or **media type** (`Accept: application/json; version=1.0`). In ASP.NET Core, use the `Asp.Versioning.Http` NuGet package.

## 📖 Detailed Explanation
**When to version:** breaking changes — removing fields, changing types, renaming endpoints, changing behavior.
**URL versioning:** simplest and most visible (`/api/v2/orders`). Easy to test in browser, works with all clients. Most common choice.
**Header versioning:** cleaner URLs but harder to test/document. Requires clients to set a header.
**Query string:** easy but pollutes the URL. Used by some legacy APIs.
**Deprecation:** version old APIs with deprecation headers; give clients time to migrate before removing.

## 💻 Code Example
```csharp
// Install: Asp.Versioning.Mvc, Asp.Versioning.Http
builder.Services.AddApiVersioning(o =>
{
    o.DefaultApiVersion = new ApiVersion(1, 0);
    o.AssumeDefaultVersionWhenUnspecified = true;
    o.ReportApiVersions = true;   // adds Api-Supported-Versions header to responses
}).AddMvc();

// V1 Controller
[ApiController]
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/orders")]
public class OrdersV1Controller : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll() => Ok(new { version = "1.0", data = "..." });
}

// V2 Controller (breaking change)
[ApiController]
[ApiVersion("2.0")]
[Route("api/v{version:apiVersion}/orders")]
public class OrdersV2Controller : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll() => Ok(new { version = "2.0", data = "...", newField = "..." });
}
```

## ❓ Follow-Up Questions
- **Q: Which versioning strategy is most common?** A: URL path versioning — most explicit and easiest for clients to use and tools to document.
- **Q: When should you increment the version?** A: Only for breaking changes. Non-breaking additions (new optional fields, new endpoints) don't need version bumps.
- **Q: What is a breaking change?** A: Removing or renaming a field, changing a type, removing an endpoint, changing behavior that clients depend on.

## ⚠️ Common Mistakes
❌ Versioning every release regardless of breaking changes.
✅ Version only on breaking changes. Over-versioning fragments the API surface and creates maintenance burden.

## 🎯 Cheat Sheet
- **Strategies:** URL path (most common), header, query string, media type
- **Breaking change:** requires new version; addition = no version needed
- **Deprecation:** header warning, sunset date, time to migrate
- **Keywords:** Asp.Versioning, ApiVersion, backward compatibility, non-breaking

## 🏢 Industry Experience Answer
"We use URL path versioning exclusively — /api/v1/, /api/v2/. It's explicit, bookmark-able, and Swagger handles it beautifully. We define 'breaking change' strictly in our API guidelines and only version on those. When deprecating, we add a Deprecation header with a sunset date and give clients 6 months before removal. Clear deprecation policy prevents the chaos of clients suddenly breaking."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is versioning in Web API?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q9
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**OpenAPI** (formerly Swagger) is a specification for describing REST APIs in a machine-readable format (JSON/YAML). **Swagger UI** is the interactive documentation UI generated from that spec. In ASP.NET Core, add Swashbuckle or NSwag to auto-generate the OpenAPI spec from your controllers — no manual documentation needed. Clients can generate SDK code from the spec.

## 📖 Detailed Explanation
**OpenAPI spec:** describes every endpoint — URL, method, parameters, request/response schemas, auth requirements. Machine-readable → tools can generate client SDKs, mock servers, test suites.
**Swashbuckle:** most popular ASP.NET Core library. Reflects your controllers and generates the OpenAPI JSON at /swagger/v1/swagger.json.
**Swagger UI:** served at /swagger — interactive HTML UI where you can execute API calls directly.
**XML comments:** `<summary>` tags on actions are picked up by Swashbuckle → better documentation.
**NSwag:** alternative to Swashbuckle; also generates TypeScript/C# clients.

## 💻 Code Example
```csharp
// Install: Swashbuckle.AspNetCore
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(o =>
{
    o.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "DevReady API",
        Version = "v1",
        Description = "Interview prep platform API"
    });

    // JWT auth in Swagger UI
    o.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Type = SecuritySchemeType.Http,
        Scheme = "bearer",
        BearerFormat = "JWT"
    });
    o.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        { new OpenApiSecurityScheme { Reference = new OpenApiReference
            { Type = ReferenceType.SecurityScheme, Id = "Bearer" } }, new string[] { } }
    });

    // Include XML comments
    var xmlFile = Assembly.GetExecutingAssembly().GetName().Name + ".xml";
    o.IncludeXmlComments(Path.Combine(AppContext.BaseDirectory, xmlFile));
});

app.UseSwagger();
app.UseSwaggerUI(o => o.SwaggerEndpoint("/swagger/v1/swagger.json", "DevReady API v1"));
```

## ❓ Follow-Up Questions
- **Q: Should Swagger be enabled in production?** A: For public APIs yes; for internal APIs consider restricting with auth or disable entirely.
- **Q: OpenAPI vs Swagger?** A: Swagger was the original name; OpenAPI is the current specification name (Swagger donated it to the Linux Foundation). Tools (Swagger UI) kept the Swagger name.
- **Q: What is NSwag?** A: Alternative to Swashbuckle; additionally generates type-safe TypeScript and C# clients from the spec.

## ⚠️ Common Mistakes
❌ Returning ActionResult without ActionResult<T> — Swagger can't infer the response schema.
✅ Use ActionResult<T> or ProducesResponseType attributes so Swashbuckle can document response schemas.

## 🎯 Cheat Sheet
- **OpenAPI:** machine-readable API description spec
- **Swashbuckle:** generates OpenAPI JSON from ASP.NET Core
- **Swagger UI:** interactive HTML documentation at /swagger
- **Keywords:** OpenAPI spec, Swashbuckle, NSwag, API-first, client generation

## 🏢 Industry Experience Answer
"OpenAPI documentation is non-negotiable for any API with external consumers. We configure Swashbuckle to include XML comments and security definitions, then use NSwag to generate TypeScript clients for our React frontend — the client stays in sync with the API automatically. When the API changes, regenerate the client — no manual type maintenance."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Swagger / OpenAPI?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q10
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Content negotiation is the process by which the client and server **agree on the format** of the response. The client declares what it accepts via the `Accept` header (`Accept: application/json`); the server returns the matching format or 406 Not Acceptable. ASP.NET Core supports JSON by default; add XML with AddXmlSerializerFormatters().

## 📖 Detailed Explanation
**How it works:** client sends `Accept: application/xml`. ASP.NET Core checks registered output formatters — if XML formatter is registered, it serializes the response as XML; if not, returns 406.
**Input formatters:** for request body — Content-Type header tells the server how the request is formatted. `Content-Type: application/json` → JSON deserializer.
**Default ASP.NET Core:** JSON input/output formatter only. Add XML, MessagePack, etc. via extensions.
**ProducesResponseType / Produces:** document what formats an endpoint produces; also affects content negotiation.

## 💻 Code Example
```csharp
// Add XML support (in addition to JSON)
builder.Services.AddControllers(o =>
{
    o.RespectBrowserAcceptHeader = true;     // don't ignore browser Accept: text/html
    o.ReturnHttpNotAcceptable = true;         // return 406 if no matching formatter
})
.AddXmlSerializerFormatters();

// Document what an endpoint produces
[HttpGet("{id:int}")]
[Produces("application/json", "application/xml")]
[ProducesResponseType(typeof(OrderDto), StatusCodes.Status200OK)]
[ProducesResponseType(StatusCodes.Status404NotFound)]
public async Task<ActionResult<OrderDto>> GetById(int id)
{
    // Response format determined by Accept header at runtime
    var order = await _service.GetAsync(id);
    return order is null ? NotFound() : Ok(order);
}

// Client requests XML:
// GET /api/orders/1
// Accept: application/xml
// → ASP.NET Core serializes OrderDto as XML
```

## ❓ Follow-Up Questions
- **Q: What happens if no formatter matches?** A: Returns 406 Not Acceptable (if ReturnHttpNotAcceptable = true; otherwise defaults to JSON).
- **Q: What are input formatters?** A: Deserialize the request body based on Content-Type (JSON, XML, form data, multipart).
- **Q: When is XML still used?** A: Enterprise integrations, SOAP legacy systems, some regulatory APIs that mandate XML.

## ⚠️ Common Mistakes
❌ Not setting ReturnHttpNotAcceptable = true.
✅ By default ASP.NET Core ignores unsupported Accept headers and returns JSON. Enable ReturnHttpNotAcceptable to correctly return 406 when the client requests an unsupported format.

## 🎯 Cheat Sheet
- **Accept header:** client declares desired response format
- **Content-Type:** client declares request body format
- **406:** no matching output formatter
- **Keywords:** output formatter, input formatter, Accept, Content-Type, ReturnHttpNotAcceptable

## 🏢 Industry Experience Answer
"Most of our APIs are JSON-only — content negotiation is a non-issue. The one exception is our B2B integration endpoint used by a government system that requires XML. We added AddXmlSerializerFormatters() for that endpoint only and decorated it with [Produces('application/xml')] to make the expectation explicit in documentation."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is content negotiation in Web API?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q11
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Problem Details (RFC 7807) is a **standardized JSON error format** for HTTP APIs. Instead of ad-hoc error shapes, every API returns a consistent error response with `type`, `title`, `status`, `detail`, and optional `instance`. ASP.NET Core with [ApiController] returns ProblemDetails automatically for 400/404/etc., and you can extend it for custom errors.

## 📖 Detailed Explanation
**RFC 7807 fields:**
- `type` (URI): links to documentation for this error type
- `title`: short human-readable summary (don't change based on instance)
- `status`: HTTP status code
- `detail`: human-readable, instance-specific explanation
- `instance` (URI): identifies this specific occurrence of the problem

**Why it matters:** consistent error format means clients have one parser for all errors across all endpoints.
**ASP.NET Core:** [ApiController] already returns ProblemDetails for built-in errors. AddProblemDetails() (NET 7+) and exception handlers extend it.

## 💻 Code Example
```csharp
// Standard ProblemDetails response shape
// HTTP 400 Bad Request
// {
//   "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
//   "title": "One or more validation errors occurred.",
//   "status": 400,
//   "errors": { "Price": ["'Price' must be greater than 0."] }
// }

// Custom ProblemDetails for business errors
public static class ProblemDetailsExtensions
{
    public static IActionResult BusinessError(this ControllerBase ctrl,
        string title, string detail, int status = 422)
    {
        return ctrl.Problem(
            title: title,
            detail: detail,
            statusCode: status,
            type: "https://api.myapp.com/errors/" + title.ToLower().Replace(" ", "-"));
    }
}

// Usage
[HttpPost("orders")]
public async Task<IActionResult> Create(CreateOrderDto dto)
{
    if (!await _service.CustomerExistsAsync(dto.CustomerId))
        return this.BusinessError("Customer Not Found",
            "Customer " + dto.CustomerId + " does not exist", 422);

    var order = await _service.CreateAsync(dto);
    return CreatedAtAction(nameof(GetById), new { id = order.Id }, order);
}
```

## ❓ Follow-Up Questions
- **Q: Why not just return a custom error DTO?** A: ProblemDetails is a standard — clients know how to parse it, API gateways understand it, logging tools parse it.
- **Q: What is ValidationProblemDetails?** A: A subclass of ProblemDetails with an `errors` dictionary for field-level validation errors. Used automatically by [ApiController].
- **Q: How do you add custom fields to ProblemDetails?** A: Use the Extensions dictionary: `problem.Extensions["traceId"] = traceId`.

## ⚠️ Common Mistakes
❌ Returning 200 OK with `{ "success": false, "error": "..." }`.
✅ Use proper 4xx/5xx status codes with ProblemDetails. Clients can't rely on status codes if you always return 200.

## 🎯 Cheat Sheet
- **RFC 7807:** type, title, status, detail, instance
- **ASP.NET Core:** [ApiController] returns ProblemDetails automatically
- **Extensions:** add custom fields via Extensions dictionary
- **Keywords:** standardized error, ValidationProblemDetails, consistent contract

## 🏢 Industry Experience Answer
"ProblemDetails is our standard across all APIs. We extend the base ProblemDetails with correlationId and errorCode fields — the correlationId ties the error to a specific log entry for fast debugging. Clients parse one error shape regardless of which microservice returns it. We document our custom error types at stable URIs that explain each error and resolution steps."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is the Problem Details format (RFC 7807)?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q12
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Global exception handling catches unhandled exceptions from any action and returns a consistent error response rather than a raw 500 or leaked stack trace. In ASP.NET Core, use `UseExceptionHandler` middleware with a custom handler or exception filter, and `AddProblemDetails()` (NET 7+) for automatic ProblemDetails error responses.

## 📖 Detailed Explanation
**Why needed:** unhandled exceptions must never reach the client as stack traces (security risk). Every API needs a consistent error shape.
**UseExceptionHandler:** catches unhandled exceptions in the middleware pipeline. Re-execute a specified endpoint or handler.
**Exception filter:** IExceptionFilter / IAsyncExceptionFilter — catches exceptions from MVC actions specifically.
**IExceptionHandler (NET 8):** the modern, clean approach — implement IExceptionHandler, register multiple, each handles specific exception types.
**Structured error response:** map exception types to status codes and ProblemDetails.

## 💻 Code Example
```csharp
// Modern approach: IExceptionHandler (.NET 8)
public class GlobalExceptionHandler : IExceptionHandler
{
    private readonly ILogger<GlobalExceptionHandler> _logger;
    public GlobalExceptionHandler(ILogger<GlobalExceptionHandler> logger) => _logger = logger;

    public async ValueTask<bool> TryHandleAsync(
        HttpContext ctx, Exception ex, CancellationToken ct)
    {
        var (status, title) = ex switch
        {
            NotFoundException => (StatusCodes.Status404NotFound, "Not Found"),
            ValidationException => (StatusCodes.Status422UnprocessableEntity, "Validation Error"),
            UnauthorizedAccessException => (StatusCodes.Status403Forbidden, "Forbidden"),
            _ => (StatusCodes.Status500InternalServerError, "Internal Server Error")
        };

        _logger.LogError(ex, "Unhandled exception: {Title}", title);

        var problem = new ProblemDetails
        {
            Status = status, Title = title,
            Detail = ex.Message,
            Extensions = { ["traceId"] = ctx.TraceIdentifier }
        };
        ctx.Response.StatusCode = status;
        await ctx.Response.WriteAsJsonAsync(problem, ct);
        return true;   // handled
    }
}

// Register
builder.Services.AddExceptionHandler<GlobalExceptionHandler>();
builder.Services.AddProblemDetails();
app.UseExceptionHandler();
```

## ❓ Follow-Up Questions
- **Q: Where to place exception handling in the pipeline?** A: Outermost middleware — must be before all other middleware to catch all exceptions.
- **Q: Should you log exceptions in the handler?** A: Yes — with structured logging, including the traceId so the log entry matches the error response.
- **Q: What is the difference between exception handler and exception filter?** A: Middleware handler catches everything (including non-MVC exceptions); exception filter only catches exceptions from MVC action execution.

## ⚠️ Common Mistakes
❌ Catching all exceptions and returning 200 OK.
✅ Return the appropriate 4xx/5xx status code. Swallowing exceptions as 200 makes monitoring impossible.

## 🎯 Cheat Sheet
- **UseExceptionHandler:** outermost middleware, catches all pipeline exceptions
- **IExceptionHandler (.NET 8):** clean, DI-friendly, chainable
- **Map:** exception type → status code + ProblemDetails
- **Keywords:** global exception handling, traceId, structured error, IExceptionHandler

## 🏢 Industry Experience Answer
"We have a single GlobalExceptionHandler that maps domain exceptions (NotFoundException, ConflictException, ValidationException) to correct HTTP codes and ProblemDetails with a correlationId. Unhandled exceptions log at Error level with full stack trace tied to the correlationId. Support can find any production error by correlationId in seconds. Before this, every developer handled errors differently — inconsistent shapes, leaked stack traces, random status codes."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'How do you implement global exception handling in ASP.NET Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q13
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
API throttling (rate limiting) controls the **number of requests a client can make in a time window** to protect your API from abuse and overload. ASP.NET Core 7+ has built-in rate limiting via `AddRateLimiter`. For distributed deployments, back the limiter with Redis so limits are enforced across all instances.

## 📖 Detailed Explanation
**Algorithms:** Fixed Window (simple, window boundary burst), Sliding Window (smoother), Token Bucket (allows bursts, best for APIs), Concurrency (parallel request cap).
**Partitioning:** limit per user, per IP, per API key — use PartitionedRateLimiter with a key extractor.
**Response:** return 429 Too Many Requests with `Retry-After` header.
**Distributed:** in-memory limiters are per-instance. Use RedisRateLimiter (from Microsoft.AspNetCore.RateLimiting + Redis client) for cross-instance enforcement.

## 💻 Code Example
```csharp
// Built-in rate limiting (ASP.NET Core 7+)
builder.Services.AddRateLimiter(options =>
{
    // Token bucket per user: 60 tokens, refills 1/sec
    options.GlobalLimiter = PartitionedRateLimiter.Create<HttpContext, string>(ctx =>
    {
        var userId = ctx.User?.FindFirst("sub")?.Value ?? ctx.Connection.RemoteIpAddress?.ToString() ?? "anonymous";
        return RateLimitPartition.GetTokenBucketLimiter(userId,
            _ => new TokenBucketRateLimiterOptions
            {
                TokenLimit = 60,
                TokensPerPeriod = 10,
                ReplenishmentPeriod = TimeSpan.FromSeconds(1),
                QueueProcessingOrder = QueueProcessingOrder.OldestFirst,
                QueueLimit = 5
            });
    });

    options.RejectionStatusCode = 429;
    options.OnRejected = async (ctx, ct) =>
    {
        ctx.HttpContext.Response.Headers.RetryAfter = "60";
        await ctx.HttpContext.Response.WriteAsJsonAsync(
            new ProblemDetails { Status = 429, Title = "Too Many Requests", Detail = "Rate limit exceeded. Retry after 60 seconds." }, ct);
    };
});

app.UseRateLimiter();
```

## ❓ Follow-Up Questions
- **Q: In-memory vs distributed rate limiting?** A: In-memory is per-instance (inconsistent in multi-pod deployments). Redis-backed is consistent across all instances.
- **Q: Throttling vs rate limiting?** A: Often used interchangeably. Throttling can also mean slowing down (queuing) rather than rejecting.
- **Q: What is the Retry-After header?** A: Tells the client when it can retry — should always accompany a 429 response.

## ⚠️ Common Mistakes
❌ Only implementing rate limiting at the application level for services behind a load balancer.
✅ Per-instance limits are unfair and inconsistent. Use a Redis-backed distributed limiter or implement at the API gateway/load balancer level.

## 🎯 Cheat Sheet
- **Algorithms:** Fixed Window, Sliding Window, Token Bucket, Concurrency
- **Partition:** per user/IP/API key
- **Response:** 429 + Retry-After header
- **Distributed:** Redis for cross-instance enforcement
- **Keywords:** AddRateLimiter, PartitionedRateLimiter, 429, Retry-After

## 🏢 Industry Experience Answer
"Rate limiting saved us from a partner integration bug that hammered our API with 10,000 req/sec. We now have two layers: API gateway rate limiting (per-API-key, fast, before app layer) and application-level rate limiting (per-endpoint granularity). The Retry-After header is mandatory — well-behaved clients back off gracefully. Poorly-behaved clients get blocked by the gateway's IP blocklist."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is API throttling and how do you implement it?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q14
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
HATEOAS (Hypermedia as the Engine of Application State) is a REST constraint where **API responses include links to related actions** — the client navigates the API by following links rather than hardcoding URLs. It's one of the highest REST maturity levels (Richardson Maturity Model Level 3) but is **rarely implemented in practice** due to complexity versus benefit.

## 📖 Detailed Explanation
**What it is:** responses include `_links` objects pointing to available next actions. The client becomes driven by the server's links, not hardcoded routes.
**Richardson Maturity Model:**
- Level 0: one endpoint, XML/JSON
- Level 1: resources (multiple URLs)
- Level 2: HTTP verbs (GET, POST, etc.) ← most real-world APIs
- Level 3: HATEOAS ← true REST

**Why rarely implemented:** significant complexity; client must handle dynamic links; frontend teams often prefer known endpoints; OpenAPI docs serve similar discoverability purposes.
**When useful:** very dynamic APIs where available actions change per resource state (banking: transfer only available if balance positive).

## 💻 Code Example
```csharp
// HATEOAS response shape
// GET /api/orders/42
// {
//   "id": 42,
//   "status": "Pending",
//   "_links": {
//     "self":   { "href": "/api/orders/42", "method": "GET" },
//     "cancel": { "href": "/api/orders/42/cancel", "method": "POST" },
//     "pay":    { "href": "/api/payments", "method": "POST" }
//   }
// }

public class OrderWithLinks
{
    public int Id { get; set; }
    public string Status { get; set; }
    public Dictionary<string, Link> Links { get; set; } = new();
}
public record Link(string Href, string Method);

[HttpGet("{id:int}")]
public async Task<IActionResult> GetById(int id)
{
    var order = await _service.GetAsync(id);
    var response = new OrderWithLinks { Id = order.Id, Status = order.Status };

    response.Links["self"] = new Link("/api/orders/" + id, "GET");
    if (order.Status == "Pending")
        response.Links["cancel"] = new Link("/api/orders/" + id + "/cancel", "POST");

    return Ok(response);
}
```

## ❓ Follow-Up Questions
- **Q: Is HATEOAS required for a RESTful API?** A: Per Roy Fielding's definition, yes — Level 3 is true REST. In practice, most "REST" APIs skip it and are Level 2.
- **Q: What is the Richardson Maturity Model?** A: A four-level scale (0-3) measuring how RESTful an API is. Level 2 (HTTP verbs) is the practical standard.
- **Q: What replaces HATEOAS in practice?** A: OpenAPI/Swagger documentation provides discoverability; versioned stable contracts replace dynamic link navigation.

## ⚠️ Common Mistakes
❌ Implementing HATEOAS for its own sake on a simple CRUD API.
✅ The complexity rarely justifies the benefit for standard CRUD. Focus on correct HTTP verbs, status codes, and OpenAPI docs (Level 2 REST) instead.

## 🎯 Cheat Sheet
- **HATEOAS:** responses include links to next actions
- **Richardson Level 3:** true REST, rarely implemented in practice
- **Practical standard:** Level 2 (resources + HTTP methods)
- **Keywords:** hypermedia, _links, Richardson Maturity Model, discoverability

## 🏢 Industry Experience Answer
"In four years of API design, I've implemented HATEOAS once — for a financial API where available operations (transfer, lock, close) genuinely depend on account state and we wanted the server to be the single source of truth for what's allowed. For all other APIs, OpenAPI documentation serves discoverability better with far less implementation cost. Level 2 REST is the pragmatic standard."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is HATEOAS and is it required for a RESTful API?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q15
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**REST** is resource-based HTTP (multiple endpoints, client decides what to fetch). **GraphQL** is a query language where **clients specify exactly what data they need** in a single request to a single endpoint. GraphQL eliminates over-fetching and under-fetching but adds schema, resolver, and N+1 complexity. Use REST for simple/standard APIs; GraphQL for complex, client-driven data requirements.

## 📖 Detailed Explanation
**REST characteristics:** multiple endpoints, server-defined response shape, multiple requests for related data, HTTP caching native.
**GraphQL characteristics:** single /graphql endpoint, client-defined query, strongly-typed schema, single request resolves all related data.
**Over-fetching (REST):** endpoint returns 50 fields; client needs 5. GraphQL returns exactly what the client asks.
**Under-fetching (REST):** need data from /users/{id} AND /orders/{userId} — two round trips. GraphQL: one query for both.
**GraphQL N+1:** resolvers per field can cause N+1 DB queries. Mitigate with DataLoader.

## 💻 Code Example
```csharp
// REST: client makes multiple calls, gets all fields
// GET /api/users/1          → { id, name, email, address, ... }  (all fields)
// GET /api/orders?userId=1  → [ { id, total, status, ... } ]     (second request)

// GraphQL: one call, exactly the fields needed
// POST /graphql
// { query: "{ user(id: 1) { name orders { id total } } }" }
// → { user: { name: "Sidhant", orders: [{ id: 1, total: 99 }] } }

// Hot Chocolate (C# GraphQL server)
[QueryType]
public class Query
{
    [UseProjection, UseFiltering, UseSorting]
    public IQueryable<User> GetUsers([Service] AppDbContext ctx) => ctx.Users;
}
```

## ❓ Follow-Up Questions
- **Q: When to choose GraphQL over REST?** A: Multiple client types (mobile vs web) with different data needs; complex nested data; frontend-driven development.
- **Q: What is DataLoader in GraphQL?** A: Batches N+1 resolver calls into a single DB query — essential for production GraphQL.
- **Q: Does GraphQL replace REST?** A: No — both coexist. Many companies use REST for external public APIs (well-understood, cacheable) and GraphQL for internal frontend APIs.

## ⚠️ Common Mistakes
❌ Choosing GraphQL for a simple CRUD API.
✅ GraphQL adds schema complexity, resolver testing overhead, and N+1 risk. For standard CRUD with predictable data needs, REST is simpler and better cached.

## 🎯 Cheat Sheet
- **REST:** multiple endpoints, server-defined shape, HTTP caching
- **GraphQL:** single endpoint, client-defined query, schema-typed
- **REST problems:** over/under-fetching (GraphQL solves)
- **GraphQL problems:** N+1 resolvers, caching complexity, schema overhead
- **Keywords:** schema, resolver, DataLoader, N+1, over-fetching, Hot Chocolate

## 🏢 Industry Experience Answer
"We use REST for our public partner API and GraphQL for our internal SPA backend. The SPA has wildly different data needs on different pages — GraphQL lets each page fetch exactly what it needs without me building 20 custom REST endpoints. DataLoader is essential — without it, the resolver N+1 problem killed our DB. For public APIs, REST with OpenAPI docs is cleaner and more cacheable."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between REST and GraphQL?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q16
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**gRPC** is a high-performance, contract-first RPC framework using **Protocol Buffers** (binary serialization) and **HTTP/2** (multiplexing, bidirectional streaming). It's 5-10x faster than REST+JSON for service-to-service communication. Choose gRPC for **internal microservice communication** where performance and strong typing matter; stick with REST for public APIs or browser clients.

## 📖 Detailed Explanation
**Protocol Buffers:** binary format — much smaller and faster to serialize/deserialize than JSON. Strongly-typed schema defined in .proto files; code generated for client and server.
**HTTP/2:** multiplexing (multiple requests on one connection), bidirectional streaming, header compression — lower latency than HTTP/1.1.
**Four gRPC patterns:** Unary (request-response), Server Streaming, Client Streaming, Bidirectional Streaming.
**When gRPC wins:** internal service-to-service calls, polyglot environments (the .proto contract auto-generates clients in Go, Python, Java, etc.), real-time streaming, low-latency requirements.
**When to avoid:** public APIs (browsers need grpc-web), human-readable debugging needed, simple CRUD with no perf concerns.

## 💻 Code Example
```csharp
// orders.proto
// syntax = "proto3";
// service OrderService {
//   rpc GetOrder (GetOrderRequest) returns (OrderResponse);
//   rpc StreamOrders (OrderFilter) returns (stream OrderResponse);
// }

// Server implementation (ASP.NET Core)
public class OrderGrpcService : OrderService.OrderServiceBase
{
    private readonly IOrderRepository _repo;
    public OrderGrpcService(IOrderRepository repo) => _repo = repo;

    public override async Task<OrderResponse> GetOrder(GetOrderRequest req, ServerCallContext ctx)
    {
        var order = await _repo.GetAsync(req.Id);
        if (order is null) throw new RpcException(new Status(StatusCode.NotFound, "Order not found"));
        return new OrderResponse { Id = order.Id, Total = (double)order.Total, Status = order.Status };
    }
}

// Register
builder.Services.AddGrpc();
app.MapGrpcService<OrderGrpcService>();

// Client (auto-generated from .proto)
var channel = GrpcChannel.ForAddress("https://order-service");
var client = new OrderService.OrderServiceClient(channel);
var order = await client.GetOrderAsync(new GetOrderRequest { Id = 42 });
```

## ❓ Follow-Up Questions
- **Q: gRPC vs REST — performance?** A: gRPC is typically 5-10x faster for serialization; HTTP/2 reduces connection overhead. Measurable in high-throughput internal services.
- **Q: Can browsers use gRPC?** A: Not natively — need grpc-web (a proxy/transcoder). For browser clients, REST+JSON is simpler.
- **Q: What is grpc-json transcoding?** A: ASP.NET Core feature that exposes gRPC services as REST+JSON endpoints simultaneously — single codebase, both protocols.

## ⚠️ Common Mistakes
❌ Using gRPC for public-facing APIs that browser clients must consume.
✅ Browsers don't support HTTP/2 trailers needed by gRPC. Use REST for public/browser APIs; gRPC for internal service-to-service calls.

## 🎯 Cheat Sheet
- **Protocol Buffers:** binary, strongly-typed, smaller than JSON
- **HTTP/2:** multiplexing, streaming, header compression
- **Patterns:** Unary, Server Streaming, Client Streaming, Bidirectional
- **Use:** internal microservices, polyglot, real-time streaming
- **Keywords:** .proto, code generation, HTTP/2, grpc-web, latency

## 🏢 Industry Experience Answer
"We use gRPC for all internal microservice communication — the auto-generated clients from .proto files mean a service contract change instantly shows up as a compile error in dependent services. The 7x throughput improvement over REST+JSON made a measurable difference in our high-traffic notification service. For the public API consumed by our web frontend, we keep REST — gRPC browser support is still too complicated for the marginal gain."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is gRPC and when would you choose it over REST?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q17
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Implement pagination with `page`/`pageSize` or cursor-based parameters; filtering with typed query parameters; sorting with a `sortBy`/`sortOrder` pair. Return pagination metadata (totalCount, currentPage, pageSize, hasNextPage) in the response body or Link header. Always set a max page size and default sort to prevent abuse.

## 📖 Detailed Explanation
**Pagination strategies:**
- **Offset/page-based:** `?page=2&pageSize=20` — simple, supports random access. Problem: records can shift between pages if data changes (skip-N is expensive on large datasets).
- **Cursor-based:** `?cursor=eyJpZCI6MjB9` — stable, performant for large tables. Can't jump to arbitrary pages.

**Filtering:** typed query params (`?status=Active&minTotal=100`). Validate and sanitize — never string-interpolate into SQL.

**Sorting:** `?sortBy=createdAt&sortOrder=desc`. Whitelist allowed sort columns to prevent injection; index commonly sorted columns.

## 💻 Code Example
```csharp
// Request
public class OrderQueryParams
{
    [Range(1, int.MaxValue)] public int Page { get; set; } = 1;
    [Range(1, 100)] public int PageSize { get; set; } = 20;   // max 100
    public string? Status { get; set; }
    public string SortBy { get; set; } = "createdAt";
    public string SortOrder { get; set; } = "desc";
}

// Response with pagination metadata
public class PagedResult<T>
{
    public IEnumerable<T> Data { get; set; }
    public int TotalCount { get; set; }
    public int Page { get; set; }
    public int PageSize { get; set; }
    public bool HasNextPage => Page * PageSize < TotalCount;
}

// Implementation
[HttpGet]
public async Task<ActionResult<PagedResult<OrderDto>>> GetAll([FromQuery] OrderQueryParams q)
{
    var allowedSortColumns = new HashSet<string> { "createdAt", "total", "status" };
    if (!allowedSortColumns.Contains(q.SortBy)) q.SortBy = "createdAt";

    var query = _ctx.Orders.AsNoTracking();

    if (!string.IsNullOrWhiteSpace(q.Status))
        query = query.Where(o => o.Status == q.Status);

    var total = await query.CountAsync();

    var data = await query
        .OrderByDynamic(q.SortBy, q.SortOrder)
        .Skip((q.Page - 1) * q.PageSize)
        .Take(q.PageSize)
        .Select(o => new OrderDto { Id = o.Id, Total = o.Total, Status = o.Status })
        .ToListAsync();

    return Ok(new PagedResult<OrderDto>
    {
        Data = data, TotalCount = total, Page = q.Page, PageSize = q.PageSize
    });
}
```

## ❓ Follow-Up Questions
- **Q: Offset vs cursor pagination — when to use each?** A: Offset for small-to-medium datasets where random page access is needed; cursor for large, real-time datasets where consistency matters.
- **Q: How do you prevent expensive queries?** A: Max page size (100), required filters for large tables, proper DB indexes on filterable/sortable columns.
- **Q: Where to return pagination metadata?** A: Response body (most common, easy to use) or custom response headers (X-Total-Count, Link). Body is simpler for clients.

## ⚠️ Common Mistakes
❌ Not setting a maximum page size.
✅ Without a max, a client requesting pageSize=100000 loads your entire table into memory. Enforce a hard cap (100-200) server-side.

## 🎯 Cheat Sheet
- **Offset:** page + pageSize, simple, skip-N problem on large data
- **Cursor:** opaque cursor, stable, performant, no random access
- **Filtering:** typed params, whitelist, no SQL concatenation
- **Sorting:** whitelist columns, index them, default sort
- **Keywords:** skip/take, cursor, HasNextPage, TotalCount, max page size

## 🏢 Industry Experience Answer
"Pagination is a non-negotiable for any list endpoint. We enforce 100 max pageSize server-side regardless of what clients request. For our high-traffic activity feed we use cursor-based pagination — offset-based was causing expensive OFFSET 10000 queries. We always index the sortBy columns; a table scan on an unsorted column with 10 million rows is a production incident waiting to happen."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'How do you implement pagination, filtering, and sorting in a REST API?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- End of Batch 6 — Web API Concepts COMPLETE (Q1–Q17)
-- Next: devready_batch07_architecture_design.sql (Section 7, Q1–Q16)

-- ════════════════════════════════════════════════════════════
-- DevReady Seed — Batch 7
-- .NET › 7️⃣ Architecture & Design › Q1–Q16
-- Dollar-quote safe (zero $ inside content). Idempotent upsert.
-- ════════════════════════════════════════════════════════════

-- Q1
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
The Dependency Inversion Principle (DIP — the D in SOLID) states: **high-level modules should not depend on low-level modules; both should depend on abstractions** (interfaces). Abstractions should not depend on details — details should depend on abstractions. In practice: your business logic depends on interfaces, not concrete implementations. DI containers wire up the concrete types at runtime.

## 📖 Detailed Explanation
**Problem without DIP:** `OrderService` creates `new SqlOrderRepository()` internally — tightly coupled, untestable, hard to swap.
**With DIP:** `OrderService` depends on `IOrderRepository`. At startup, the DI container injects `SqlOrderRepository`. You can inject a mock for testing, swap to `MongoOrderRepository` with zero code changes in `OrderService`.
**Relationship to DI:** Dependency Injection is the mechanism that implements DIP — the container inverts who creates dependencies.
**Clean Architecture connection:** DIP is why inner layers (Domain, Application) don't reference outer layers (Infrastructure, UI) — they depend on interfaces defined in the inner layers.

## 💻 Code Example
```csharp
// VIOLATION: high-level depends on low-level concrete
public class OrderService
{
    private readonly SqlOrderRepository _repo = new SqlOrderRepository(); // tightly coupled
}

// DIP APPLIED: both depend on abstraction
public interface IOrderRepository
{
    Task<Order?> GetByIdAsync(int id);
    Task AddAsync(Order order);
}

public class SqlOrderRepository : IOrderRepository { /* concrete */ }
public class InMemoryOrderRepository : IOrderRepository { /* for tests */ }

public class OrderService                      // high-level module
{
    private readonly IOrderRepository _repo;  // depends on abstraction
    public OrderService(IOrderRepository repo) => _repo = repo;
}

// DI Container inverts the dependency
builder.Services.AddScoped<IOrderRepository, SqlOrderRepository>();
```

## ❓ Follow-Up Questions
- **Q: DIP vs DI — what's the difference?** A: DIP is the design principle ("depend on abstractions"); DI is the pattern/technique that achieves it.
- **Q: Why is DIP the most important SOLID principle?** A: It makes all others achievable — loose coupling, testability, and swappability all flow from it.
- **Q: How does DIP enable unit testing?** A: Tests inject mock implementations of the interfaces — no real DB, no network, instant tests.

## ⚠️ Common Mistakes
❌ Depending on concrete classes in constructors even when using DI.
✅ Always depend on interfaces, not `new ConcreteClass()`. Even with a DI container, if you call `new` in your service you've violated DIP.

## 🎯 Cheat Sheet
- **DIP:** high-level and low-level both depend on interfaces
- **Key benefit:** loose coupling, testability, swappability
- **Achieved by:** Dependency Injection (constructor injection)
- **Keywords:** inversion of control, abstraction, interface, DI container

## 🏢 Industry Experience Answer
"DIP is the foundation of our entire architecture. Every service depends on interfaces — IOrderRepository, IEmailService, IPaymentProvider. In tests we inject fakes; in production the container injects the real implementations. When we migrated from SQL Server to PostgreSQL, zero business logic changed — we swapped one IOrderRepository implementation. That's the payoff of DIP done right."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Dependency Inversion Principle?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q2
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
SOLID is five design principles for writing maintainable, scalable OOP code: **S**ingle Responsibility, **O**pen/Closed, **L**iskov Substitution, **I**nterface Segregation, **D**ependency Inversion. Together they eliminate tight coupling, reduce side effects of change, and make systems testable and extensible without requiring rewrites.

## 📖 Detailed Explanation
**S — Single Responsibility Principle (SRP):** a class has one reason to change. Don't mix data access, business logic, and formatting in one class. Example: OrderService handles order business logic; OrderRepository handles DB access; OrderEmailFormatter handles formatting.

**O — Open/Closed Principle (OCP):** open for extension, closed for modification. Add new behavior via new classes/methods, don't edit existing ones. Example: new payment providers implement IPaymentProvider — checkout code never changes.

**L — Liskov Substitution Principle (LSP):** subclasses must be usable wherever the base type is expected without breaking behavior. A Square extending Rectangle that overrides Width/Height setters violates LSP because callers expecting Rectangle behavior get unexpected results.

**I — Interface Segregation Principle (ISP):** don't force clients to implement methods they don't use. Split fat interfaces into focused ones. `IReadRepository<T>` and `IWriteRepository<T>` instead of one interface with 10 methods.

**D — Dependency Inversion Principle (DIP):** depend on abstractions (interfaces), not concretions. High-level and low-level modules both depend on interfaces.

## 💻 Code Example
```csharp
// SRP: one class, one job
public class OrderValidator { public bool Validate(Order o) => o.Total > 0; }
public class OrderRepository { public Task SaveAsync(Order o) => Task.CompletedTask; }
public class OrderService { /* orchestrates — uses both above */ }

// OCP: extend without modifying
public interface IDiscountStrategy { decimal Apply(decimal price); }
public class SeasonalDiscount : IDiscountStrategy { public decimal Apply(decimal p) => p * 0.9m; }
public class LoyaltyDiscount : IDiscountStrategy { public decimal Apply(decimal p) => p * 0.85m; }

// ISP: split fat interface
public interface IOrderReader { Task<Order?> GetByIdAsync(int id); }
public interface IOrderWriter { Task AddAsync(Order o); }
public class OrderRepository : IOrderReader, IOrderWriter { /* implements both */ }

// LSP: subclass behaves correctly
public class Bird { public virtual void Move() { } }
public class Eagle : Bird { public override void Move() { /* flies */ } }
// Penguin CAN'T fly — don't force it to override Fly(); redesign the hierarchy
```

## ❓ Follow-Up Questions
- **Q: Which SOLID principle is most important?** A: DIP — it enables all others. SRP + DIP together solve most design problems.
- **Q: Real-world LSP violation?** A: Square : Rectangle overriding Width setting Height too — Area() returns unexpected results. Fix: don't inherit; use composition.
- **Q: ISP vs SRP?** A: SRP = one reason to change per class. ISP = clients don't depend on methods they don't use. Both fight fat classes/interfaces.

## ⚠️ Common Mistakes
❌ God classes with 20 methods and 500 lines violating SRP.
✅ If your service has more than 5-7 public methods, it probably has more than one responsibility. Split it.

## 🎯 Cheat Sheet
- **S:** one reason to change — focused classes
- **O:** extend (new class), don't modify (existing class)
- **L:** subclass is a true substitute for base
- **I:** small focused interfaces, no forced unused methods
- **D:** depend on interfaces, not concretions

## 🏢 Industry Experience Answer
"SOLID isn't a rigid checklist — it's a set of smells to watch for. The most actionable: SRP (if it's hard to name the class, it's doing too much), OCP (if adding a feature means editing 5 existing files, redesign), DIP (if the class creates its own dependencies, refactor to constructor injection). In code reviews I catch SRP and DIP violations most frequently."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are SOLID principles?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q3
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
The Repository pattern **abstracts data access behind an interface** — business logic talks to `IOrderRepository`, not to EF Core or SQL directly. It decouples the domain from persistence, enables testability (mock the interface), and centralises query logic in one place. In EF Core projects it's often implemented as a thin wrapper, but the interface isolation value remains.

## 📖 Detailed Explanation
**What it does:** encapsulates all data access code (queries, adds, updates, deletes) for an entity behind an interface.
**Benefits:** swappable persistence (EF → Dapper → MongoDB), testable (mock the interface), single place for query logic.
**Generic vs specific:** Generic repository `IRepository<T>` is reusable but coarse. Specific repositories `IOrderRepository` are expressive but more code. Blend: generic for CRUD + specific for domain-specific queries.
**Controversy:** EF Core's DbSet is already a repository and DbContext is a Unit of Work — adding a repo on top adds abstraction without value for simple projects. Add it when you need testability or persistence-swappability.

## 💻 Code Example
```csharp
// Interface — what business logic sees
public interface IOrderRepository
{
    Task<Order?> GetByIdAsync(int id, CancellationToken ct = default);
    Task<List<Order>> GetByCustomerAsync(string customerId, CancellationToken ct = default);
    Task<List<Order>> GetPendingAsync(CancellationToken ct = default);
    void Add(Order order);
    void Remove(Order order);
}

// EF Core implementation
public class EfOrderRepository : IOrderRepository
{
    private readonly AppDbContext _ctx;
    public EfOrderRepository(AppDbContext ctx) => _ctx = ctx;

    public Task<Order?> GetByIdAsync(int id, CancellationToken ct = default) =>
        _ctx.Orders.Include(o => o.Items).FirstOrDefaultAsync(o => o.Id == id, ct);

    public Task<List<Order>> GetByCustomerAsync(string cId, CancellationToken ct = default) =>
        _ctx.Orders.Where(o => o.CustomerId == cId).AsNoTracking().ToListAsync(ct);

    public Task<List<Order>> GetPendingAsync(CancellationToken ct = default) =>
        _ctx.Orders.Where(o => o.Status == OrderStatus.Pending).ToListAsync(ct);

    public void Add(Order o) => _ctx.Orders.Add(o);
    public void Remove(Order o) => _ctx.Orders.Remove(o);
}
```

## ❓ Follow-Up Questions
- **Q: Is Repository pattern necessary with EF Core?** A: Not mandatory — DbSet is a repository. Add it when you need to isolate tests from EF Core or may swap persistence.
- **Q: Generic vs specific repository?** A: Generic for simple CRUD; specific for meaningful domain queries. Mixing is common.
- **Q: Where does querying live in Repository?** A: Named methods for meaningful queries. Avoid leaking IQueryable<T> from the repo — it couples callers to EF semantics.

## ⚠️ Common Mistakes
❌ Leaking IQueryable<T> from the repository interface.
✅ If callers can chain Where/Include on the IQueryable, they're coupled to EF Core — mock implementations don't easily support this. Return List<T> from the interface.

## 🎯 Cheat Sheet
- **Purpose:** abstract data access, decouple domain from persistence
- **Interface:** domain-meaningful methods (GetPending, GetByCustomer)
- **Benefits:** testability, swappability, centralised query logic
- **Keywords:** persistence ignorance, IOrderRepository, mock, Unit of Work

## 🏢 Industry Experience Answer
"We use specific repositories with meaningful method names — GetPendingOrders, GetOrdersByCustomer — rather than a generic repo. The interface is the contract between the application layer and infrastructure; tests mock it. When we migrated a module from EF Core to Dapper for performance, only the repository implementation changed. Zero changes to the service layer."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Repository Pattern?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q4
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
The Unit of Work pattern **groups multiple repository operations into a single transaction** — they all succeed or all fail together. It maintains a list of objects affected by a business transaction and coordinates writing out changes. In EF Core, `DbContext` IS the Unit of Work — `SaveChanges()` commits everything tracked across all repositories in one atomic transaction.

## 📖 Detailed Explanation
**Problem it solves:** you call OrderRepository.Add(order) and InventoryRepository.Deduct(item) — they must commit together atomically. Without UoW they could partially succeed.
**How EF Core implements it:** all repositories share one DbContext instance (per request). Each repo calls Add/Remove (marks state). `SaveChangesAsync()` on the context commits everything in one DB transaction.
**Explicit UoW interface:** sometimes exposed as `IUnitOfWork` with a `CommitAsync()` method — the service calls it once at the end. The implementation calls `DbContext.SaveChangesAsync()`.

## 💻 Code Example
```csharp
// IUnitOfWork interface
public interface IUnitOfWork
{
    IOrderRepository Orders { get; }
    IInventoryRepository Inventory { get; }
    Task<int> CommitAsync(CancellationToken ct = default);
}

// EF Core implementation — DbContext IS the UoW
public class UnitOfWork : IUnitOfWork
{
    private readonly AppDbContext _ctx;
    public UnitOfWork(AppDbContext ctx) => _ctx = ctx;

    public IOrderRepository Orders => new EfOrderRepository(_ctx);
    public IInventoryRepository Inventory => new EfInventoryRepository(_ctx);

    // One SaveChanges commits changes from ALL repositories
    public Task<int> CommitAsync(CancellationToken ct = default) =>
        _ctx.SaveChangesAsync(ct);
}

// Service — single commit for atomic operation
public class PlaceOrderService
{
    private readonly IUnitOfWork _uow;
    public PlaceOrderService(IUnitOfWork uow) => _uow = uow;

    public async Task PlaceOrderAsync(CreateOrderDto dto, CancellationToken ct)
    {
        var order = Order.Create(dto);
        _uow.Orders.Add(order);
        await _uow.Inventory.DeductAsync(dto.Items, ct);
        await _uow.CommitAsync(ct);   // ONE transaction — all or nothing
    }
}
```

## ❓ Follow-Up Questions
- **Q: Do you need to wrap DbContext to get UoW?** A: No — DbContext already is UoW. The explicit IUnitOfWork wrapper adds testability and makes the pattern visible.
- **Q: UoW and Repository together?** A: UoW coordinates multiple repositories in one transaction. They're designed to work together.
- **Q: What if CommitAsync fails?** A: EF Core rolls back the transaction — all tracked changes are discarded.

## ⚠️ Common Mistakes
❌ Calling SaveChangesAsync() inside each repository method.
✅ Repositories should only register changes (Add/Remove/Update). Only the Unit of Work/service calls SaveChangesAsync at the end — preserving atomicity.

## 🎯 Cheat Sheet
- **Purpose:** group repo operations into one atomic transaction
- **EF Core:** DbContext IS the Unit of Work
- **Pattern:** repos mark changes; UoW commits them all at once
- **Keywords:** atomicity, CommitAsync, SaveChangesAsync, shared DbContext

## 🏢 Industry Experience Answer
"We expose IUnitOfWork as a seam between application and infrastructure. Services depend on IUnitOfWork (not DbContext directly), so tests can mock it. The key discipline: repositories never call SaveChanges — they just Add/Remove entities. The service calls CommitAsync once at the end of a command handler. This makes every command handler implicitly transactional."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Unit of Work pattern?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q5
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
The Service Layer (application services) sits between the **presentation layer** (controllers, UI) and the **domain/data layer** (repositories, entities). It orchestrates use cases — coordinates domain logic, repositories, and external services — without containing business rules itself. Controllers call services; services call repositories and domain objects. This keeps controllers thin and business logic testable.

## 📖 Detailed Explanation
**Why a service layer:** controllers should only handle HTTP concerns (binding, responses, auth). Repositories handle persistence. Business logic and use-case coordination go in services.
**What services do:** validate input, call domain methods, coordinate repositories, raise events, call external services, commit transactions.
**What services DON'T do:** contain complex domain invariants (those belong in domain entities/aggregates) or data access logic (belongs in repositories).
**Application service vs Domain service:** application service = use-case orchestration; domain service = domain logic that doesn't naturally fit one entity.

## 💻 Code Example
```csharp
// Service interface
public interface IOrderService
{
    Task<OrderDto> PlaceOrderAsync(PlaceOrderCommand cmd, CancellationToken ct);
    Task CancelOrderAsync(int orderId, CancellationToken ct);
}

// Service implementation — orchestration, no domain rules here
public class OrderService : IOrderService
{
    private readonly IOrderRepository _orders;
    private readonly IInventoryService _inventory;
    private readonly IEmailService _email;
    private readonly IUnitOfWork _uow;

    public async Task<OrderDto> PlaceOrderAsync(PlaceOrderCommand cmd, CancellationToken ct)
    {
        // 1. Create domain object (domain logic is IN the entity)
        var order = Order.Create(cmd.CustomerId, cmd.Items);

        // 2. Coordinate with other services
        await _inventory.ReserveAsync(cmd.Items, ct);

        // 3. Persist
        _orders.Add(order);
        await _uow.CommitAsync(ct);

        // 4. Side effects
        await _email.SendOrderConfirmationAsync(order, ct);

        // 5. Return DTO
        return order.ToDto();
    }
}

// Controller — thin, HTTP concerns only
[HttpPost]
public async Task<IActionResult> PlaceOrder(PlaceOrderRequest req, CancellationToken ct)
{
    var result = await _orderService.PlaceOrderAsync(req.ToCommand(), ct);
    return CreatedAtAction(nameof(GetById), new { id = result.Id }, result);
}
```

## ❓ Follow-Up Questions
- **Q: Service layer vs domain layer?** A: Service layer = use-case orchestration (how to do the operation); domain layer = business rules (what is allowed/valid).
- **Q: Can controllers access repositories directly?** A: Technically yes, but it skips the service layer and puts orchestration in the controller — harder to test and reuse.
- **Q: CQRS and service layer?** A: In CQRS, command/query handlers replace the service layer as the orchestration point. Both serve the same purpose.

## ⚠️ Common Mistakes
❌ Fat service layer with 500 lines of business logic (anemic domain).
✅ Business rules belong in domain entities. Services orchestrate; entities enforce invariants.

## 🎯 Cheat Sheet
- **Service layer:** orchestrates use cases, coordinates domain + repos + external services
- **Controllers:** HTTP only — call services, return results
- **Domain:** business rules and invariants
- **Keywords:** use-case, orchestration, thin controller, application service

## 🏢 Industry Experience Answer
"Our service layer is the heart of the application — each service method maps 1:1 to a use case (PlaceOrder, CancelOrder, RefundOrder). Controllers are dumb: bind request → call service → map result to response. Tests hit the service layer directly without HTTP overhead. When we add a gRPC endpoint, it calls the same services as the REST controllers — zero duplication."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Service Layer and why use it?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q6
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**Layered architecture** organizes code into horizontal layers (Presentation → Business → Data), where each layer depends on the one below — the business layer depends on the data layer (database-centric). **Clean Architecture** (Onion/Hexagonal) inverts this: the **domain is the center**, all other layers depend inward — infrastructure depends on domain interfaces, not vice versa. Clean Architecture enforces DIP at the architectural level.

## 📖 Detailed Explanation
**Layered architecture:**
- UI → Business Logic → Data Access → Database
- Business logic knows about data access (imports EF Core, SQL)
- Domain entities often have EF attributes mixed in
- Changing the database affects the business layer

**Clean Architecture (Onion/Hexagonal):**
- Core: Domain (entities, value objects, domain services) — zero dependencies
- Application: use cases, interfaces (IRepository) — depends on Domain only
- Infrastructure: EF Core, DB, email — depends on Application interfaces
- Presentation: controllers, API — depends on Application

**Dependency rule:** dependencies always point inward. Domain knows nothing about infrastructure.

## 💻 Code Example
```csharp
// PROJECT STRUCTURE — Clean Architecture
// Domain/            ← no external dependencies
//   Entities/Order.cs
//   Interfaces/IOrderRepository.cs  (defined HERE, not in Infrastructure)
//   ValueObjects/Money.cs
//
// Application/       ← depends on Domain only
//   UseCases/PlaceOrderCommand.cs
//   Services/OrderService.cs
//
// Infrastructure/    ← depends on Application interfaces
//   Persistence/EfOrderRepository.cs  (implements Domain.IOrderRepository)
//   Email/SmtpEmailService.cs
//
// API/               ← depends on Application
//   Controllers/OrdersController.cs

// In Domain — interface defined (not in Infrastructure!)
namespace Domain.Interfaces;
public interface IOrderRepository
{
    Task<Order?> GetByIdAsync(int id, CancellationToken ct = default);
}

// In Infrastructure — implementation (depends inward on Domain interface)
namespace Infrastructure.Persistence;
public class EfOrderRepository : Domain.Interfaces.IOrderRepository
{
    private readonly AppDbContext _ctx;
    public Task<Order?> GetByIdAsync(int id, CancellationToken ct = default) =>
        _ctx.Orders.FindAsync(new object[] { id }, ct).AsTask();
}
```

## ❓ Follow-Up Questions
- **Q: Onion vs Hexagonal vs Clean Architecture?** A: All are variants of the same concept — domain at center, infrastructure at edges. Clean Architecture (Robert Martin) is the most documented.
- **Q: What is the Dependency Rule?** A: Source code dependencies can only point inward. Nothing in an inner circle can know about an outer circle.
- **Q: Is Clean Architecture always worth it?** A: For complex, long-lived domains — yes. For a simple CRUD microservice — the overhead may not be justified. Match architecture to complexity.

## ⚠️ Common Mistakes
❌ Putting EF Core or infrastructure concerns in the Domain project.
✅ Domain must have zero external dependencies. If Domain references EntityFrameworkCore, Clean Architecture is violated — infrastructure has leaked into the domain.

## 🎯 Cheat Sheet
- **Layered:** UI→BL→Data→DB, business depends on data layer
- **Clean:** domain at center, all layers depend inward
- **Dependency Rule:** outer layers depend on inner — never reverse
- **Keywords:** Onion, Hexagonal, Dependency Rule, persistence ignorance

## 🏢 Industry Experience Answer
"We use Clean Architecture for all production services. The key win: the Domain project compiles with zero NuGet packages — pure C# business logic. Tests for domain rules run in milliseconds. When we replaced our caching library, only the Infrastructure project changed. The Application layer (use cases) changed only when business requirements changed — not when we changed EF Core versions. That's the payoff."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between layered and clean architecture?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q7
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
The middleware pipeline is a **chain of components that each process an HTTP request and optionally pass it to the next component**. It's ASP.NET Core's primary architectural extension point — cross-cutting concerns (logging, auth, exception handling, caching, compression, CORS) are implemented as middleware, keeping controllers focused on business logic.

## 📖 Detailed Explanation
**Architecture angle:** middleware implements the Chain of Responsibility pattern at the HTTP pipeline level. Each component can inspect/mutate the request, call next(), then inspect/mutate the response on the way back.
**Order is architecture:** UseExceptionHandler must be first (outermost), UseRouting before UseAuthorization, UseAuthentication before UseAuthorization. Wrong order = silent security bugs.
**Custom middleware as extension points:** new cross-cutting concerns (tenancy, correlation ID, feature flags) are added as middleware without touching business code.
**Short-circuit:** middleware can respond without calling next() — auth failures, cache hits, health checks — reducing load on downstream components.

## 💻 Code Example
```csharp
// Middleware as architectural layers — order defines priority
app.UseExceptionHandler("/error");      // outermost — catches everything
app.UseHttpsRedirection();
app.UseStaticFiles();                   // serves files before auth
app.UseRouting();
app.UseCors("Policy");
app.UseAuthentication();                // who are you?
app.UseAuthorization();                 // what can you do?
app.UseResponseCaching();
app.MapControllers();                   // innermost — business logic

// Custom: correlation ID middleware (cross-cutting concern)
public class CorrelationIdMiddleware
{
    private readonly RequestDelegate _next;
    public CorrelationIdMiddleware(RequestDelegate next) => _next = next;

    public async Task InvokeAsync(HttpContext ctx)
    {
        var id = ctx.Request.Headers["X-Correlation-ID"].FirstOrDefault()
                 ?? Guid.NewGuid().ToString();
        ctx.Items["CorrelationId"] = id;
        ctx.Response.Headers["X-Correlation-ID"] = id;
        await _next(ctx);
    }
}
```

## ❓ Follow-Up Questions
- **Q: Middleware vs filter — which is more architectural?** A: Middleware operates at the HTTP pipeline level (all requests); filters operate within the MVC pipeline (controller actions only). Middleware is the wider architectural hook.
- **Q: How do you add cross-cutting concerns without touching controllers?** A: Middleware for HTTP-level concerns; action filters for MVC-level concerns. Both are additive — controllers stay clean.
- **Q: What is the Chain of Responsibility pattern?** A: Each handler decides to handle the request or pass it to the next handler — exactly what middleware implements.

## ⚠️ Common Mistakes
❌ Putting cross-cutting concerns (logging, error handling, auth) inside controller actions.
✅ Cross-cutting concerns belong in middleware or filters — they apply once, uniformly, without polluting business code.

## 🎯 Cheat Sheet
- **Pattern:** Chain of Responsibility for HTTP requests
- **Order:** defines priority — ExceptionHandler outermost, endpoints innermost
- **Short-circuit:** respond without calling next() for cache hits, auth failures
- **Keywords:** RequestDelegate, HttpContext, pipeline, cross-cutting concerns

## 🏢 Industry Experience Answer
"Middleware is where we put everything that applies to all requests without exception — correlation IDs, request timing, structured logging context, tenant identification. The pipeline order is documented and tested. Adding a new cross-cutting concern means one new middleware class registered in the correct position — zero changes to controllers or services."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is middleware pipeline?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q8
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Caching stores the result of an expensive operation so subsequent requests can be served without repeating it. Key strategies: **Cache-Aside** (check cache → miss → load from DB → populate cache), **Write-Through** (write to cache and DB together), **Write-Behind** (write cache immediately, DB asynchronously). In .NET: IMemoryCache (in-process), IDistributedCache (Redis — cross-instance).

## 📖 Detailed Explanation
**Why cache:** DB queries, complex computations, external API calls are expensive. Serving from memory is microseconds vs milliseconds.
**Cache-Aside (Lazy Loading):** most common pattern. Check cache first; on miss, load from source and populate. Simple, flexible, resilient (cache can be empty without breaking the app).
**Write-Through:** write to cache and DB simultaneously on every update. Cache is always fresh. More complex, every write touches both.
**Write-Behind (Write-Back):** writes go to cache first; DB is updated asynchronously. Fast writes; risk of data loss on cache failure.
**Cache invalidation:** the hardest problem. Strategies: TTL (time-to-live), event-based (evict on update), tag-based (evict all with tag).
**Distributed cache:** multiple app instances need a shared cache — Redis is the standard (.NET IDistributedCache, StackExchange.Redis).

## 💻 Code Example
```csharp
// Cache-aside pattern with IMemoryCache
public class ProductService
{
    private readonly IMemoryCache _cache;
    private readonly IProductRepository _repo;
    private static readonly TimeSpan CacheDuration = TimeSpan.FromMinutes(15);

    public async Task<ProductDto?> GetAsync(int id, CancellationToken ct)
    {
        var cacheKey = "product_" + id;
        if (_cache.TryGetValue(cacheKey, out ProductDto? cached))
            return cached;                          // cache hit

        var product = await _repo.GetByIdAsync(id, ct);  // cache miss — load from DB
        if (product is null) return null;

        _cache.Set(cacheKey, product.ToDto(), new MemoryCacheEntryOptions
        {
            AbsoluteExpirationRelativeToNow = CacheDuration,
            SlidingExpiration = TimeSpan.FromMinutes(5)
        });
        return product.ToDto();
    }

    public async Task InvalidateAsync(int id)
    {
        _cache.Remove("product_" + id);             // invalidate on update
        await _repo.SaveChangesAsync();
    }
}

// Distributed cache (Redis) for multi-instance deployments
builder.Services.AddStackExchangeRedisCache(o => o.Configuration = "localhost:6379");
```

## ❓ Follow-Up Questions
- **Q: IMemoryCache vs IDistributedCache?** A: IMemoryCache = in-process (single server). IDistributedCache = Redis/SQL Server (shared across all instances). Always use distributed in production multi-pod environments.
- **Q: What is cache stampede?** A: Many requests miss cache simultaneously (e.g., after TTL expiry) and all hit the DB at once. Fix: lock/semaphore on the cache miss path.
- **Q: TTL vs event-based invalidation?** A: TTL is simple but serves stale data for TTL duration. Event-based is immediate but adds complexity.

## ⚠️ Common Mistakes
❌ Caching per-user or sensitive data in a shared cache without key isolation.
✅ Always include the userId in cache keys for user-specific data. Never cache sensitive info unencrypted in Redis.

## 🎯 Cheat Sheet
- **Cache-Aside:** check → miss → load → populate (most common)
- **Write-Through:** write cache + DB together
- **Write-Behind:** write cache, async DB
- **IMemoryCache:** in-process; IDistributedCache: Redis (multi-instance)
- **Keywords:** TTL, cache invalidation, stampede, eviction, Redis

## 🏢 Industry Experience Answer
"Cache-aside with Redis is our standard. Product catalogue, user profiles, config lookups — all cached with appropriate TTLs. The hardest part isn't caching; it's invalidation. We tag cache entries (e.g., 'product:42') and evict by tag on updates. We also protect against stampede with a SemaphoreSlim on the cache miss path for high-traffic keys."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is caching?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q9
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Configuration providers are the pluggable sources in .NET's layered configuration system. They load key-value pairs from different sources — JSON files, environment variables, command-line arguments, Azure Key Vault, AWS Parameter Store, custom databases — and merge them with later providers overriding earlier ones. The unified `IConfiguration` interface hides which provider a value came from.

## 📖 Detailed Explanation
**Built-in providers (added by CreateBuilder in order):**
1. ChainedConfigurationProvider (existing IConfiguration)
2. appsettings.json
3. appsettings.{Environment}.json
4. User Secrets (Development only)
5. Environment variables
6. Command-line arguments

**Custom providers:** implement IConfigurationSource + IConfigurationProvider. Examples: DB-backed live config, Consul, etcd, HashiCorp Vault.
**Reload-on-change:** JSON providers support reloadOnChange:true — config updates without restart.
**Priority:** last-registered wins. Command-line overrides env vars overrides appsettings.

## 💻 Code Example
```csharp
// Default providers added automatically by CreateBuilder
var builder = WebApplication.CreateBuilder(args);

// Add additional providers
builder.Configuration
    .AddJsonFile("custom.json", optional: true, reloadOnChange: true)
    .AddEnvironmentVariables("MYAPP_")           // only vars prefixed MYAPP_
    .AddCommandLine(args)
    .AddAzureKeyVault(new Uri("https://vault.azure.net"), new DefaultAzureCredential())
    .AddUserSecrets<Program>(optional: true);     // Development only

// Read — IConfiguration abstracts the source
var connStr = builder.Configuration.GetConnectionString("Default");
var jwtKey = builder.Configuration["Jwt:Key"];    // : for hierarchy

// Custom provider (DB-backed)
builder.Configuration.AddDatabaseConfiguration(
    builder.Configuration.GetConnectionString("Config")!);
```

## ❓ Follow-Up Questions
- **Q: How do you scope env vars to your app?** A: Use a prefix: `AddEnvironmentVariables("MYAPP_")` — only MYAPP_ prefixed vars are loaded, avoiding conflicts.
- **Q: Can config reload at runtime?** A: JSON files with reloadOnChange; use IOptionsMonitor<T> to get live-reloaded strongly-typed config.
- **Q: Where is the hierarchy separator for env vars?** A: Double underscore __ replaces : in env var names (MYAPP__DB__Host maps to DB:Host).

## ⚠️ Common Mistakes
❌ Hardcoding environment-specific values in code or committed appsettings.
✅ All environment-specific values (URLs, feature flags, limits) go in the appropriate provider. Code is environment-agnostic.

## 🎯 Cheat Sheet
- **Providers:** JSON, env vars, cmd-line, User Secrets, Key Vault, custom
- **Priority:** later provider wins; cmd-line overrides all
- **Hierarchy:** : in config key maps to __ in env var names
- **Keywords:** IConfigurationSource, IConfigurationProvider, reloadOnChange, IOptionsMonitor

## 🏢 Industry Experience Answer
"The layered configuration system is one of the best .NET features. We use it to build a clear config hierarchy: shared defaults in appsettings.json, environment overrides in env vars injected by Kubernetes, and secrets from Azure Key Vault via managed identity. One codebase, zero config changes between environments — the container is identical; only the mounted secrets and env vars differ."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are configuration providers in .NET Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q10
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**Configuration** is the runtime key-value system built from multiple providers. **appsettings.json** is a JSON file (one provider) containing base non-secret settings committed to source control. **secrets.json** (User Secrets) is a development-only JSON file stored outside the project directory — never committed — for local secrets. In production, secrets come from environment variables or Azure Key Vault.

## 📖 Detailed Explanation
**Configuration (IConfiguration):** the unified runtime view merging all providers. Code reads `config["Key"]` without caring which file it came from.
**appsettings.json:** base, safe, committed. Contains structure + safe defaults (log levels, feature flags, public URLs). No secrets.
**appsettings.{Environment}.json:** environment-specific overrides — production log levels, staging feature flags. Committed but no secrets.
**secrets.json (User Secrets):** only loaded in Development. Stored in `~/.microsoft/usersecrets/{id}/secrets.json` — outside the repo. `dotnet user-secrets set "Key" "Value"`.
**Production secrets:** environment variables (set by orchestrator) or Azure Key Vault (fetched at startup). Never in files committed to source control.

## 💻 Code Example
```csharp
// appsettings.json (committed, no secrets)
// { "Logging": { "LogLevel": { "Default": "Information" } },
//   "AllowedHosts": "*",
//   "ConnectionStrings": { "Default": "placeholder" } }

// appsettings.Development.json (committed, dev overrides)
// { "Logging": { "LogLevel": { "Default": "Debug" } } }

// secrets.json via dotnet user-secrets (NOT committed)
// dotnet user-secrets init
// dotnet user-secrets set "ConnectionStrings:Default" "Host=localhost;Database=devdb"
// dotnet user-secrets set "Jwt:Key" "dev-secret-key-must-be-32-chars"

// In code — same IConfiguration API regardless of source
var connStr = config.GetConnectionString("Default");   // from secrets in dev, env var in prod
var jwtKey = config["Jwt:Key"];                       // from secrets in dev, Key Vault in prod

// Production: env var CONNECTIONSTRINGS__DEFAULT overrides appsettings
// kubectl create secret generic app-secrets
//   --from-literal=ConnectionStrings__Default="Host=prod-db;..."
```

## ❓ Follow-Up Questions
- **Q: What is the User Secrets ID?** A: A GUID in the .csproj file (`<UserSecretsId>`) that links the project to its secrets.json location.
- **Q: Can secrets.json be committed accidentally?** A: Not if stored in ~/.microsoft/usersecrets/ (outside the repo). The .csproj UserSecretsId attribute stores the link, not the secrets.
- **Q: How do you share secrets between team members?** A: Don't — each developer sets their own via dotnet user-secrets. Team secrets are stored in a secrets manager (1Password, Azure Key Vault, Bitwarden) and pulled manually.

## ⚠️ Common Mistakes
❌ Putting database passwords in appsettings.Development.json committed to git.
✅ Even dev secrets belong in user-secrets, not committed files. Use appsettings.Development.json only for non-secret overrides.

## 🎯 Cheat Sheet
- **appsettings.json:** base, committed, no secrets
- **appsettings.{Env}.json:** env overrides, committed, no secrets
- **secrets.json:** dev secrets, NOT committed, per-developer
- **Production:** env vars or Key Vault — never in files
- **Keywords:** User Secrets, dotnet user-secrets, committed vs non-committed

## 🏢 Industry Experience Answer
"The discipline we enforce: appsettings.json has the shape (keys present, values are safe placeholders), secrets.json fills in the actual values in dev, and env vars fill them in production. New developer onboarding: clone repo, run dotnet user-secrets set for each secret (documented in the README), run the app. Zero secrets in git, ever."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between configuration, appsettings, and secrets.json?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q11
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
CQRS (Command Query Responsibility Segregation) separates **write operations (Commands)** from **read operations (Queries)** into distinct models and handlers. Commands mutate state and return nothing (or a minimal result); Queries read state and never mutate. This separation enables independent optimization, scaling, and evolution of read and write sides.

## 📖 Detailed Explanation
**Why:** a single model trying to serve both complex writes (business rules, validation, transactions) and complex reads (joins, projections, aggregations) becomes bloated. CQRS splits them.
**Simple CQRS (same DB):** different C# classes for commands and queries; still one database. The most common and pragmatic implementation.
**Full CQRS + Event Sourcing:** separate read and write stores (write = event log, read = materialized projection views). Enables independent scaling.
**MediatR:** the standard .NET library for CQRS — IRequest<T> for commands/queries, IRequestHandler<TReq,TResult> for handlers.

## 💻 Code Example
```csharp
// Command — mutates state
public record PlaceOrderCommand(string CustomerId, List<OrderItemDto> Items)
    : IRequest<int>;

public class PlaceOrderHandler : IRequestHandler<PlaceOrderCommand, int>
{
    private readonly IOrderRepository _orders;
    private readonly IUnitOfWork _uow;

    public async Task<int> Handle(PlaceOrderCommand cmd, CancellationToken ct)
    {
        var order = Order.Create(cmd.CustomerId, cmd.Items);
        _orders.Add(order);
        await _uow.CommitAsync(ct);
        return order.Id;
    }
}

// Query — reads, never mutates
public record GetOrderByIdQuery(int Id) : IRequest<OrderDto?>;

public class GetOrderByIdHandler : IRequestHandler<GetOrderByIdQuery, OrderDto?>
{
    private readonly AppDbContext _ctx;   // direct DB access — no repo needed for reads

    public async Task<OrderDto?> Handle(GetOrderByIdQuery q, CancellationToken ct) =>
        await _ctx.Orders.AsNoTracking()
            .Where(o => o.Id == q.Id)
            .Select(o => new OrderDto { Id = o.Id, Status = o.Status.ToString(), Total = o.Total })
            .FirstOrDefaultAsync(ct);
}

// Controller
[HttpPost] public async Task<IActionResult> Create(PlaceOrderRequest req) =>
    Ok(await _mediator.Send(new PlaceOrderCommand(req.CustomerId, req.Items)));

[HttpGet("{id:int}")] public async Task<IActionResult> Get(int id) =>
    await _mediator.Send(new GetOrderByIdQuery(id)) is { } dto ? Ok(dto) : NotFound();
```

## ❓ Follow-Up Questions
- **Q: CQRS requires separate databases?** A: No — simple CQRS with one DB is the common starting point. Separate read/write stores are an optimization for extreme scale.
- **Q: What is the difference between CQRS and Event Sourcing?** A: They're complementary but independent. CQRS = separate command/query models; Event Sourcing = store events as the source of truth. Often combined but each stands alone.
- **Q: When NOT to use CQRS?** A: Simple CRUD with no complex domain logic — the extra structure adds overhead without benefit.

## ⚠️ Common Mistakes
❌ Having command handlers perform complex reads and return large DTOs.
✅ Commands return minimal results (id, status). Put read logic in queries. Mixing them defeats the separation.

## 🎯 Cheat Sheet
- **Command:** mutates state, no return (or minimal)
- **Query:** reads state, never mutates
- **IRequest / IRequestHandler:** MediatR contracts
- **Keywords:** separation of concerns, MediatR, read model, write model

## 🏢 Industry Experience Answer
"CQRS with MediatR is our standard architecture. Commands contain business rules; queries are optimised reads — sometimes bypassing the domain model entirely with raw EF projections or Dapper for complex reports. The split made our read side dramatically faster: queries don't go through Change Tracking or business rule validation. We added a read replica and pointed queries there — zero changes to command handlers."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is CQRS?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q12
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Event Sourcing stores all state changes as an **immutable sequence of events** rather than current state. Instead of `UPDATE orders SET status='Shipped'`, you append `OrderShipped { orderId, timestamp, shippedBy }`. Current state is derived by replaying events. CRUD stores current state only; Event Sourcing gives you the full history, auditability, and the ability to rebuild any past state.

## 📖 Detailed Explanation
**How it works:** events are the source of truth. An aggregate's state is computed by replaying its events from the event store (EventStoreDB, CosmosDB, Postgres as event log).
**Benefits:** complete audit trail, temporal queries ("what was the order status at 3pm?"), event replay for projections, decoupled consumers via event streams.
**Drawbacks:** complexity, eventual consistency of projections, schema evolution of historical events, querying current state requires projections.
**Projections:** read models built from events — a background process replays events to build optimized read tables. CQRS + Event Sourcing = write side = events, read side = projections.
**CRUD vs Event Sourcing:** CRUD = final answer only; Event Sourcing = the full story.

## 💻 Code Example
```csharp
// Events — immutable facts that happened
public record OrderPlaced(Guid OrderId, string CustomerId, decimal Total, DateTime PlacedAt);
public record OrderShipped(Guid OrderId, string TrackingNumber, DateTime ShippedAt);
public record OrderCancelled(Guid OrderId, string Reason, DateTime CancelledAt);

// Aggregate rebuilds state from events
public class Order
{
    public Guid Id { get; private set; }
    public string Status { get; private set; }
    public decimal Total { get; private set; }

    // Apply events to rebuild state
    public void Apply(OrderPlaced e) { Id = e.OrderId; Status = "Pending"; Total = e.Total; }
    public void Apply(OrderShipped e) { Status = "Shipped"; }
    public void Apply(OrderCancelled e) { Status = "Cancelled"; }

    // Load from event history
    public static Order LoadFromHistory(IEnumerable<object> events)
    {
        var order = new Order();
        foreach (var evt in events)
        {
            if (evt is OrderPlaced p) order.Apply(p);
            else if (evt is OrderShipped s) order.Apply(s);
            else if (evt is OrderCancelled c) order.Apply(c);
        }
        return order;
    }
}

// Projection: read model built from events
public class OrderSummaryProjection
{
    public void On(OrderPlaced e) => /* upsert to read DB */;
    public void On(OrderShipped e) => /* update status in read DB */;
}
```

## ❓ Follow-Up Questions
- **Q: What is a snapshot in Event Sourcing?** A: A periodically saved aggregate state so replay starts from the snapshot, not event 1 — avoids replaying thousands of events.
- **Q: What database is used for the event store?** A: EventStoreDB (purpose-built), MariaDB/PostgreSQL with an events table, Azure Cosmos DB, AWS DynamoDB.
- **Q: Event Sourcing vs Audit Log?** A: An audit log is a side effect of CRUD (log when changes happen). Event Sourcing makes events the primary source of truth — state is derived from them.

## ⚠️ Common Mistakes
❌ Using Event Sourcing for every domain.
✅ Event Sourcing adds significant complexity. Use it where audit trails, temporal queries, or event-driven integrations are core requirements. Simple CRUD domains don't need it.

## 🎯 Cheat Sheet
- **CRUD:** stores current state — the final answer
- **Event Sourcing:** stores events — the full story; state is derived
- **Events:** immutable facts; append-only event store
- **Projections:** read models built from event streams
- **Keywords:** EventStore, replay, snapshot, projection, temporal query

## 🏢 Industry Experience Answer
"We use Event Sourcing for the financial transactions domain — every payment, refund, and adjustment is an immutable event. Regulatory compliance requires the complete history; event sourcing gives it naturally. Projections build the current balance and statement views. For our product catalogue (simple CRUD), Event Sourcing would be pure overhead. Right tool for the right domain."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Event Sourcing and how does it differ from CRUD?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q13
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Domain-Driven Design (DDD) is an approach to software design where the **domain model** (business concepts, rules, language) drives the architecture. Core building blocks: **Entities** (identity-based), **Value Objects** (equality by value), **Aggregates** (consistency boundaries), **Domain Services** (logic spanning entities), **Repositories** (persistence abstraction), **Domain Events** (significant occurrences), **Bounded Contexts** (explicit boundaries).

## 📖 Detailed Explanation
**Ubiquitous Language:** shared vocabulary between developers and domain experts used consistently in code, conversations, and documentation.
**Entity:** has a unique identity that persists over time (Order, Customer — identified by Id).
**Value Object:** defined by its attributes, no identity, immutable (Money{100, "USD"}, Address — two identical ones are equal).
**Aggregate:** cluster of entities/value objects treated as one unit for data changes. The Aggregate Root is the gateway — all changes go through it. Invariants are enforced within the aggregate boundary.
**Bounded Context:** explicit boundary where a model applies — "Order" means different things in Shipping vs Billing; each context has its own model.
**Domain Event:** significant business event that happened ("OrderPlaced", "PaymentProcessed") — published after aggregate state change.

## 💻 Code Example
```csharp
// Value Object — equality by value, immutable
public record Money(decimal Amount, string Currency)
{
    public Money Add(Money other)
    {
        if (Currency != other.Currency) throw new InvalidOperationException("Currency mismatch");
        return new Money(Amount + other.Amount, Currency);
    }
}

// Entity — identity-based
public class OrderItem
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public int ProductId { get; private set; }
    public int Quantity { get; private set; }
    public Money Price { get; private set; }
}

// Aggregate Root — enforces invariants, gateway for all changes
public class Order
{
    public Guid Id { get; private set; }
    private List<OrderItem> _items = new();
    public IReadOnlyList<OrderItem> Items => _items.AsReadOnly();
    public string Status { get; private set; } = "Draft";

    private readonly List<IDomainEvent> _events = new();
    public IReadOnlyList<IDomainEvent> DomainEvents => _events.AsReadOnly();

    public void AddItem(int productId, int quantity, Money price)
    {
        if (Status != "Draft") throw new DomainException("Cannot add items to a non-draft order");
        _items.Add(new OrderItem(productId, quantity, price));
    }

    public void Place()
    {
        if (!_items.Any()) throw new DomainException("Order must have items");
        Status = "Placed";
        _events.Add(new OrderPlacedEvent(Id));  // domain event
    }
}
```

## ❓ Follow-Up Questions
- **Q: Strategic vs tactical DDD?** A: Strategic = bounded contexts, context mapping, ubiquitous language. Tactical = aggregates, entities, value objects, repositories.
- **Q: When to use DDD?** A: Complex business domains with rich rules and invariants. Simple CRUD doesn't justify the overhead.
- **Q: What is an anti-corruption layer?** A: A translation layer between bounded contexts with incompatible models — prevents one context's model from polluting another.

## ⚠️ Common Mistakes
❌ Anemic domain model — entities are just data containers, all logic in service layer.
✅ Business rules (invariants) belong IN the aggregate. The aggregate enforces them; the service orchestrates.

## 🎯 Cheat Sheet
- **Entity:** identity (Id), mutable, persisted
- **Value Object:** value equality, immutable, no Id
- **Aggregate Root:** consistency boundary, invariant guardian
- **Bounded Context:** explicit model boundary
- **Keywords:** ubiquitous language, invariant, domain event, anti-corruption layer

## 🏢 Industry Experience Answer
"DDD transformed how our team talks about the system. Ubiquitous language first — if developers say 'user' and the business says 'subscriber', the code says 'Subscriber'. Aggregates enforce business invariants: you can't call order.Ship() directly; it checks order.IsReadyToShip() first. We define Bounded Contexts in microservices — each service has its own Order concept without the other services' baggage leaking in."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Domain-Driven Design (DDD) and its core building blocks?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q14
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
MediatR is a .NET library implementing the **Mediator pattern** — it decouples senders from receivers by routing requests through a central mediator. Callers send an `IRequest<T>` object; MediatR finds and calls the registered `IRequestHandler<TRequest,TResult>`. Used in .NET for CQRS, pipeline behaviors (cross-cutting concerns), and decoupling controllers from services.

## 📖 Detailed Explanation
**Mediator pattern:** objects communicate via a central coordinator — they don't reference each other directly. Reduces coupling between many-to-many dependencies.
**MediatR components:**
- `IRequest<T>`: marker interface for a request (command or query)
- `IRequestHandler<TReq,TRes>`: handles the request
- `IMediator.Send()`: dispatches the request to its handler
- `IPipelineBehavior<TReq,TRes>`: cross-cutting behavior (like middleware) that wraps all handlers

**Pipeline behaviors:** validation, logging, transactions, caching — applied to all handlers automatically.

## 💻 Code Example
```csharp
// Install: MediatR, MediatR.Extensions.Microsoft.DependencyInjection
builder.Services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(typeof(Program).Assembly));

// Command + Handler
public record CreateOrderCommand(string CustomerId, decimal Total) : IRequest<int>;

public class CreateOrderHandler : IRequestHandler<CreateOrderCommand, int>
{
    private readonly IOrderRepository _repo;
    private readonly IUnitOfWork _uow;
    public CreateOrderHandler(IOrderRepository repo, IUnitOfWork uow)
        => (_repo, _uow) = (repo, uow);

    public async Task<int> Handle(CreateOrderCommand cmd, CancellationToken ct)
    {
        var order = new Order { CustomerId = cmd.CustomerId, Total = cmd.Total };
        _repo.Add(order);
        await _uow.CommitAsync(ct);
        return order.Id;
    }
}

// Pipeline behavior — runs for every command/query
public class ValidationBehavior<TReq, TRes> : IPipelineBehavior<TReq, TRes>
    where TReq : IRequest<TRes>
{
    private readonly IEnumerable<IValidator<TReq>> _validators;
    public ValidationBehavior(IEnumerable<IValidator<TReq>> validators) => _validators = validators;

    public async Task<TRes> Handle(TReq req, RequestHandlerDelegate<TRes> next, CancellationToken ct)
    {
        var failures = _validators.SelectMany(v => v.Validate(req).Errors).ToList();
        if (failures.Any()) throw new ValidationException(failures);
        return await next();   // call the actual handler
    }
}

// Controller — thin, sends to MediatR
[HttpPost]
public async Task<IActionResult> Create(CreateOrderRequest req, CancellationToken ct) =>
    Ok(await _mediator.Send(new CreateOrderCommand(req.CustomerId, req.Total), ct));
```

## ❓ Follow-Up Questions
- **Q: MediatR vs direct service injection?** A: Both work. MediatR adds indirection (no direct coupling) + pipeline behaviors. Direct injection is simpler for small apps.
- **Q: What are pipeline behaviors good for?** A: Validation, logging, timing, caching, transaction wrapping — applied once, globally, to all handlers.
- **Q: MediatR notifications?** A: INotification + INotificationHandler — one-to-many pub/sub within the process. Useful for domain events.

## ⚠️ Common Mistakes
❌ Using MediatR as a service locator — mediating everything including simple utility calls.
✅ Use MediatR for commands and queries (use cases). Don't mediator simple helper calls that belong in injected services.

## 🎯 Cheat Sheet
- **IRequest<T>:** command or query object
- **IRequestHandler:** handler for the request
- **IPipelineBehavior:** cross-cutting wrapper (validation, logging, transactions)
- **INotification:** domain event for one-to-many dispatch
- **Keywords:** Mediator pattern, CQRS, pipeline, decoupling

## 🏢 Industry Experience Answer
"MediatR + pipeline behaviors replaced our service layer boilerplate. Validation, transaction wrapping, and structured logging all go in behaviors — registered once, applied to every handler automatically. Adding a new feature means: create a command/query record, create a handler class, done. No service registration, no new interfaces. The controller just calls mediator.Send and doesn't care who handles it."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is MediatR and why is it used in .NET applications?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q15
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
The Specification pattern **encapsulates a query/business rule as a reusable, composable object** (`ISpecification<T>`). Instead of scattered query logic across repositories, you define named specifications (`ActiveOrdersSpec`, `OverdueInvoicesSpec`) and compose them with AND/OR. The repository accepts a specification and translates it to IQueryable — clean, reusable, testable.

## 📖 Detailed Explanation
**Problem:** query logic duplicated across repositories and services, hard to test, hard to name/reuse.
**Solution:** specification = named, composable predicate + Include logic + sorting.
**Benefits:** business-meaningful names (`PremiumCustomerSpec`), composable (`new ActiveSpec().And(new PremiumSpec())`), testable (unit-test the spec, not the DB), single responsibility for each rule.
**Popular libraries:** Ardalis.Specification — production-ready specification base classes for .NET + EF Core.

## 💻 Code Example
```csharp
// Base specification interface
public interface ISpecification<T>
{
    Expression<Func<T, bool>> Criteria { get; }
    List<Expression<Func<T, object>>> Includes { get; }
    Expression<Func<T, object>>? OrderBy { get; }
}

// Named specification — readable, reusable
public class ActiveOrdersForCustomerSpec : Specification<Order>
{
    public ActiveOrdersForCustomerSpec(string customerId)
    {
        AddCriteria(o => o.CustomerId == customerId && o.Status != "Cancelled");
        AddInclude(o => o.Items);
        AddOrderByDescending(o => o.CreatedAt);
    }
}

// Repository accepts specification
public interface IOrderRepository
{
    Task<List<Order>> GetAsync(ISpecification<Order> spec, CancellationToken ct = default);
}

public class EfOrderRepository : IOrderRepository
{
    private readonly AppDbContext _ctx;
    public async Task<List<Order>> GetAsync(ISpecification<Order> spec, CancellationToken ct)
    {
        var query = _ctx.Orders.Where(spec.Criteria);
        foreach (var include in spec.Includes) query = query.Include(include);
        if (spec.OrderBy != null) query = query.OrderByDescending(spec.OrderBy);
        return await query.AsNoTracking().ToListAsync(ct);
    }
}

// Usage — business-meaningful, composable
var orders = await _repo.GetAsync(new ActiveOrdersForCustomerSpec(customerId), ct);
```

## ❓ Follow-Up Questions
- **Q: Specification vs repository method?** A: Repository methods proliferate (`GetActiveByCustomer`, `GetPendingAbove100`, etc.). Specifications compose — `ActiveSpec.And(AboveAmountSpec(100))`.
- **Q: Can specifications be unit-tested without a DB?** A: Yes — `spec.Criteria.Compile()(order)` evaluates the predicate on an in-memory object.
- **Q: Ardalis.Specification?** A: A popular .NET library with a ready base Specification class, EF Core evaluator, and Include support.

## ⚠️ Common Mistakes
❌ Creating one specification per micro-variation (effectively recreating repository methods with extra steps).
✅ Specifications shine when composed — `new PremiumSpec().And(new ActiveSpec())`. If you never compose, a named repository method may be simpler.

## 🎯 Cheat Sheet
- **Purpose:** encapsulate reusable, composable query/business rules
- **Composition:** And/Or operators combine specifications
- **Repository:** accepts ISpecification<T>, applies via EF IQueryable
- **Keywords:** Ardalis.Specification, Expression<Func<T,bool>>, composable, reusable predicate

## 🏢 Industry Experience Answer
"Specification pattern cleaned up our complex query mess. We had thirty `GetOrdersByX` methods in the repository. Now we have fifteen Specification classes that compose into hundreds of query combinations. Tests on specifications are pure expression-tree unit tests — no EF, no DB, instant. Ardalis.Specification handles the EF integration boilerplate."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is the Specification pattern?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q16
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
An **anemic domain model** has entities as pure data containers (getters/setters only) with all business logic in services — violating OOP encapsulation. A **rich domain model** puts business logic AND data together inside entities — methods enforce invariants and express domain meaning. Rich models are the OOP ideal and the DDD recommendation; anemic models are easier to build but harder to reason about at scale.

## 📖 Detailed Explanation
**Anemic model:** `Order` has public setters. `OrderService.Ship(order)` sets fields directly. The entity is passive. Business rules are scattered across services, hard to find, easy to bypass.
**Rich model:** `Order.Ship()` is a method on the entity that validates preconditions, sets status, and raises a domain event. The entity protects its own invariants. Business logic has one obvious home.
**Why anemic is common:** easier with ORMs (public setters for change tracking), simpler to scaffold, CRUD mindset from DB-first development.
**Why rich models win:** invariants can't be bypassed (private setters), logic is colocated with data (easier to find), expressive domain language in code, easier to test domain logic without infrastructure.

## 💻 Code Example
```csharp
// ANEMIC MODEL — data bag, logic elsewhere
public class AnOrder
{
    public int Id { get; set; }
    public string Status { get; set; }    // public setter — anyone can set anything
    public List<OrderItem> Items { get; set; } = new();
}
// Service does all the work — scattered, can bypass rules
public class AnOrderService
{
    public void Ship(AnOrder o, string tracking) { o.Status = "Shipped"; /* no validation! */ }
}

// RICH DOMAIN MODEL — logic lives WITH data
public class Order
{
    public int Id { get; private set; }
    public string Status { get; private set; } = "Draft";
    private List<OrderItem> _items = new();
    public IReadOnlyList<OrderItem> Items => _items.AsReadOnly();

    public void AddItem(int productId, int qty, decimal price)
    {
        if (Status != "Draft") throw new DomainException("Cannot modify a placed order");
        _items.Add(new OrderItem(productId, qty, price));
    }

    public void Place()
    {
        if (!_items.Any()) throw new DomainException("Order must have at least one item");
        Status = "Placed";
    }

    public void Ship(string trackingNumber)
    {
        if (Status != "Placed") throw new DomainException("Only placed orders can be shipped");
        Status = "Shipped";
        TrackingNumber = trackingNumber;
    }
}
// No way to bypass the rules — all changes go through domain methods
```

## ❓ Follow-Up Questions
- **Q: Are anemic models always bad?** A: Not for simple CRUD. Anemic models become a problem when business rules grow — they get scattered and duplicated across services.
- **Q: How do you use private setters with EF Core?** A: EF Core supports private setters and private constructors with proper Fluent API configuration — no forced public setters.
- **Q: Anemic vs transaction script?** A: Transaction script = procedural code in services for each operation. Anemic domain = OOP structure without OOP behavior. Both are patterns, not inherently wrong.

## ⚠️ Common Mistakes
❌ Making all entity properties public with public setters.
✅ Make properties private-set (or init-only). Expose only domain methods that enforce invariants. EF Core works with private setters.

## 🎯 Cheat Sheet
- **Anemic:** data bag, public setters, logic in services — easy but fragile at scale
- **Rich:** logic + data together, private setters, methods enforce invariants
- **DDD stance:** rich domain model — entities are intelligent, not passive
- **Keywords:** domain invariant, private setter, encapsulation, DDD, transaction script

## 🏢 Industry Experience Answer
"We refactored from anemic to rich models last year. The sign we needed to: we had 12 places in the codebase where order.Status = 'Cancelled' was set directly, each with slightly different guard conditions. Now there's one Order.Cancel(reason) method that enforces all rules. Finding the rule = find the method. Changing the rule = change one place. That's the payoff."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between anemic and rich domain models?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- End of Batch 7 — Architecture & Design COMPLETE (Q1–Q16)

-- ════════════════════════════════════════════════════════════
-- DevReady Seed — Batch 8
-- .NET › 8️⃣ Performance & Scalability › Q1–Q15
-- Dollar-quote safe (zero $ inside content). Idempotent upsert.
-- ════════════════════════════════════════════════════════════

-- Q1
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Logging in .NET is implemented via the built-in `ILogger<T>` interface — inject it, call structured log methods (LogInformation, LogWarning, LogError). Providers write logs to console, files, Application Insights, Serilog, etc. From a performance perspective: use structured logging with message templates (not string concatenation), filter by log level to avoid unnecessary work, and use LoggerMessage.Define for high-frequency hot paths to eliminate allocation.

## 📖 Detailed Explanation
**Performance considerations:**
- **Log level filtering:** only the configured minimum level is evaluated. Debug/Trace in production = silent, zero cost if logger.IsEnabled(level) short-circuits.
- **Structured logging:** `_logger.LogInformation("Order {OrderId} placed", orderId)` — no string concatenation until the message is actually written. The parameters are captured lazily.
- **LoggerMessage.Define:** pre-compiled log actions — avoid lambda allocation on every call in hot paths.
- **Async logging:** Serilog async sink buffers log writes — logging never blocks the request thread.

## 💻 Code Example
```csharp
// Standard structured logging
public class OrderService
{
    private readonly ILogger<OrderService> _logger;
    public OrderService(ILogger<OrderService> logger) => _logger = logger;

    public async Task ProcessAsync(int orderId)
    {
        _logger.LogInformation("Processing order {OrderId}", orderId);   // structured
        try { /* ... */ }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to process order {OrderId}", orderId);
            throw;
        }
    }
}

// High-performance logging — zero allocation per call
public static partial class LogMessages
{
    [LoggerMessage(Level = LogLevel.Information, Message = "Order {OrderId} placed by {CustomerId}")]
    public static partial void OrderPlaced(ILogger logger, int orderId, string customerId);
}
// Usage (no allocation, no boxing, compiler-generated)
LogMessages.OrderPlaced(_logger, orderId, customerId);

// Serilog async sink (non-blocking)
Log.Logger = new LoggerConfiguration()
    .WriteTo.Async(a => a.File("logs/app.log", rollingInterval: RollingInterval.Day))
    .CreateLogger();
```

## ❓ Follow-Up Questions
- **Q: What is LoggerMessage.Define?** A: A source-generated or manually defined static log action that compiles the message template once — zero allocation per log call.
- **Q: How to avoid logging performance overhead?** A: Use if (_logger.IsEnabled(LogLevel.Debug)) guard for expensive interpolations; use source-generated log methods; use async sinks.
- **Q: When to use LogWarning vs LogError?** A: Warning = unexpected but recoverable; Error = failure that needs attention; Critical = system about to go down.

## ⚠️ Common Mistakes
❌ `_logger.LogDebug("Data: " + JsonSerializer.Serialize(bigObject))` in a hot path.
✅ String concatenation/serialization happens even if the log is filtered out. Use `_logger.LogDebug("Data: {Data}", bigObject)` — parameters are only evaluated if the level is enabled.

## 🎯 Cheat Sheet
- **Structured logging:** {Property} templates, not concatenation
- **LoggerMessage.Define / [LoggerMessage]:** source-generated, zero allocation
- **Async sink:** non-blocking log writes
- **Level filtering:** trace/debug filtered in production = near-zero cost
- **Keywords:** ILogger, Serilog, structured, hot path, allocation-free

## 🏢 Industry Experience Answer
"Logging performance cost us 8% throughput on our highest-traffic endpoint. Root cause: Debug logs serializing large request objects into strings — even though Debug was filtered. Switched to source-generated [LoggerMessage] attributes and moved to async Serilog sink. The endpoint recovered its throughput. Now logging is a first-class performance consideration, not an afterthought."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is logging and how do you implement it in .NET?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q2
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Exception handling middleware is the **outermost component in the ASP.NET Core pipeline** that catches unhandled exceptions from any middleware or controller, logs them, and returns a structured error response. It prevents stack traces from reaching clients (security), ensures consistent error format (ProblemDetails), and provides a single place for error logging with structured context.

## 📖 Detailed Explanation
**Why outermost:** must wrap the entire pipeline — if placed later, exceptions from earlier middleware are missed.
**UseExceptionHandler:** built-in; re-executes a specified error path. Simple and reliable.
**IExceptionHandler (.NET 8):** DI-injectable, chainable handlers per exception type — cleanest modern approach.
**Performance aspect:** exception handling is the unhappy path — performance here matters less than correctness. However: never use exceptions for control flow (e.g., checking if a record exists) — exception handling has non-trivial overhead.

## 💻 Code Example
```csharp
// Modern IExceptionHandler (.NET 8)
public class AppExceptionHandler : IExceptionHandler
{
    private readonly ILogger<AppExceptionHandler> _logger;
    public AppExceptionHandler(ILogger<AppExceptionHandler> logger) => _logger = logger;

    public async ValueTask<bool> TryHandleAsync(HttpContext ctx, Exception ex, CancellationToken ct)
    {
        var (status, title) = ex switch
        {
            NotFoundException nfe => (404, "Not Found"),
            ValidationException ve => (422, "Validation Error"),
            ConflictException ce   => (409, "Conflict"),
            _                      => (500, "Internal Server Error")
        };

        // Structured log with trace ID for correlation
        _logger.LogError(ex, "Request {Method} {Path} failed with {Status}",
            ctx.Request.Method, ctx.Request.Path, status);

        ctx.Response.StatusCode = status;
        await ctx.Response.WriteAsJsonAsync(new ProblemDetails
        {
            Status = status, Title = title,
            Detail = ex.Message,
            Extensions = { ["traceId"] = ctx.TraceIdentifier }
        }, ct);
        return true;
    }
}

// Register — must be outermost
builder.Services.AddExceptionHandler<AppExceptionHandler>();
builder.Services.AddProblemDetails();
app.UseExceptionHandler();   // before all other middleware
```

## ❓ Follow-Up Questions
- **Q: UseExceptionHandler vs exception filter?** A: Middleware catches all pipeline exceptions including non-MVC. Filter only catches exceptions from controller actions.
- **Q: Should you use exceptions for not-found checks?** A: No — throwing NotFoundException for every GetById miss has measurable overhead at high request rates. Check null and return early instead; reserve exceptions for truly exceptional conditions.
- **Q: How do you correlate a logged error with a specific request?** A: Include HttpContext.TraceIdentifier in both the log entry and the error response. Client reports the traceId; you search logs by it.

## ⚠️ Common Mistakes
❌ Using throw/catch for business flow control (e.g., if user not found, throw NotFoundException).
✅ Use nullable returns or Result<T> pattern for expected "not found" scenarios. Reserve exceptions for unexpected failures.

## 🎯 Cheat Sheet
- **Position:** outermost middleware — before all others
- **IExceptionHandler:** DI-injectable, chainable, type-mapped (.NET 8)
- **Response:** ProblemDetails with traceId for correlation
- **Performance:** exceptions = expensive; don't use for control flow
- **Keywords:** exception pipeline, ProblemDetails, traceId, IExceptionHandler

## 🏢 Industry Experience Answer
"Our exception handler maps domain exceptions to HTTP codes and logs with structured context including correlationId, userId, and request path. Every 5xx in our monitoring links to the exact log entry via traceId. The critical performance rule: domain exceptions (NotFoundException, ConflictException) should be rare — they're for truly unexpected conditions, not routine 'not found' checks that happen on every other request."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is exception handling middleware?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q3
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Scaling is the ability to **handle increasing load** by adding resources. Two dimensions: **vertical scaling** (bigger machine — more CPU/RAM) and **horizontal scaling** (more machines — distribute load). Modern cloud-native apps are designed for horizontal scaling — stateless services behind a load balancer, with shared state in external stores (Redis, DB).

## 📖 Detailed Explanation
**Why scaling matters:** a single server has limits. At some request volume, it can't keep up. Scaling extends that limit.
**Vertical (scale-up):** upgrade the server. Simple, no code changes. Limited by the biggest available machine. Single point of failure. Expensive per unit at the top end.
**Horizontal (scale-out):** add more identical instances behind a load balancer. Theoretically unlimited. Requires stateless app design. Cost-efficient (commodity hardware). Resilient (one instance fails, others serve traffic).
**Stateless prerequisite:** horizontal scaling requires that any instance can handle any request — no in-memory session, no local file state. Use Redis for sessions/cache, S3/blob for files.

## 💻 Code Example
```csharp
// Design for horizontal scaling — stateless service
// NO: in-memory state that's per-instance
// private static Dictionary<string, Session> _sessions = new();  // WRONG

// YES: external state store
public class SessionService
{
    private readonly IDistributedCache _cache;   // Redis — shared across all instances
    public async Task<string?> GetSessionAsync(string sessionId, CancellationToken ct)
    {
        var bytes = await _cache.GetAsync(sessionId, ct);
        return bytes is null ? null : Encoding.UTF8.GetString(bytes);
    }
}

// Kubernetes HPA — scale instances based on CPU
// kubectl autoscale deployment my-api --cpu-percent=70 --min=2 --max=10
// No code changes needed — app is stateless, any instance handles any request
```

## ❓ Follow-Up Questions
- **Q: When do you choose vertical over horizontal?** A: Vertical for stateful workloads (databases, legacy monoliths); horizontal for stateless services (APIs, workers).
- **Q: What is auto-scaling?** A: Automatically adding/removing instances based on metrics (CPU, request rate, queue depth). Kubernetes HPA, AWS Auto Scaling, Azure VMSS.
- **Q: What limits horizontal scaling?** A: Shared resources — the database becomes the bottleneck. DB scaling (read replicas, sharding, caching) is the next step.

## ⚠️ Common Mistakes
❌ Storing session/cart data in server memory — works on one instance, breaks when scaled to many.
✅ All shared state (sessions, cache, jobs) must be in an external store (Redis, DB). The app itself must be stateless.

## 🎯 Cheat Sheet
- **Vertical:** bigger machine, simple, limited, expensive at top
- **Horizontal:** more machines, theoretically unlimited, requires stateless
- **Stateless:** key prerequisite for horizontal — no per-instance state
- **Keywords:** load balancer, stateless, Redis, auto-scaling, single point of failure

## 🏢 Industry Experience Answer
"All our APIs are designed stateless from day one — makes horizontal scaling trivial. When traffic spikes, Kubernetes HPA adds pods automatically. The real bottleneck we hit was the database: 50 app instances hammering one DB. Solution: Redis cache for hot reads, read replica for analytics queries, connection pooling via PgBouncer. App scaling is easy; data layer scaling is the hard part."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is scaling?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q4
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**Vertical scaling** adds more resources to a single machine (bigger CPU, more RAM, faster storage). **Horizontal scaling** adds more machines/instances running the same application in parallel. Vertical has a hard ceiling; horizontal is theoretically unlimited. Modern cloud-native architecture targets horizontal scaling by designing stateless services.

## 📖 Detailed Explanation
| Aspect | Vertical (Scale-Up) | Horizontal (Scale-Out) |
|---|---|---|
| How | Bigger machine | More machines |
| Limit | Largest available VM | Theoretically unlimited |
| Code changes | None | Requires stateless design |
| Failure | Single point of failure | Resilient (N-1 still serves) |
| Cost | Expensive at top | Commodity hardware |
| Database | Natural fit | Needs external state |
| Downtime | Brief restart | Zero (rolling deploys) |

**Hybrid:** start vertical (simpler), then horizontal when needed. Databases often scale vertically longer — horizontal sharding is complex.

## 💻 Code Example
```csharp
// Ensuring stateless design for horizontal scaling
public class OrderController : ControllerBase
{
    // All dependencies injected — no static/in-memory state
    private readonly IOrderService _service;
    private readonly IDistributedCache _cache;

    // Any pod, any instance can handle any request
    [HttpGet("{id:int}")]
    public async Task<IActionResult> Get(int id, CancellationToken ct)
    {
        // Check distributed cache (shared across all instances)
        var cacheKey = "order_" + id;
        var cached = await _cache.GetStringAsync(cacheKey, ct);
        if (cached != null) return Ok(cached);

        var order = await _service.GetAsync(id, ct);
        await _cache.SetStringAsync(cacheKey, order.ToString(),
            new DistributedCacheEntryOptions
            { AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(5) }, ct);
        return Ok(order);
    }
}
// Scale to 20 pods with kubectl scale deployment my-api --replicas=20
```

## ❓ Follow-Up Questions
- **Q: Which databases scale vertically best?** A: Traditional relational (PostgreSQL, SQL Server) are optimised for vertical scaling. NoSQL (Cassandra, DynamoDB) are designed for horizontal.
- **Q: What is diagonal scaling?** A: Scale both — add more AND bigger instances. Common in auto-scaling groups.
- **Q: How does Kubernetes enable horizontal scaling?** A: Horizontal Pod Autoscaler (HPA) automatically adds/removes pods based on CPU, memory, or custom metrics.

## ⚠️ Common Mistakes
❌ Designing an app that caches data in local memory and expecting horizontal scaling to work.
✅ Any data shared between requests must be in an external store. Local memory caching is fine as a secondary layer, but the primary must be distributed.

## 🎯 Cheat Sheet
- **Vertical:** CPU/RAM up, one machine, ceiling exists
- **Horizontal:** instances up, load-balanced, stateless required
- **Prerequisites:** stateless app, external session/cache, shared storage
- **Keywords:** HPA, load balancer, stateless, read replica, auto-scaling

## 🏢 Industry Experience Answer
"We started vertical — one big VM was simpler. When we hit the ceiling (and the 6-figure annual cost), we went horizontal. The work was mostly state migration: moving in-memory cache to Redis, sessions to Redis, uploaded files to Azure Blob. Once stateless, we deploy on 5 small pods instead of one giant VM — cheaper, resilient, auto-scaling on traffic spikes."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is vertical scaling vs horizontal scaling?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q5
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A load balancer **distributes incoming requests across multiple server instances** to prevent any one instance from being overwhelmed, improve availability, and enable horizontal scaling. It routes traffic based on algorithms (round-robin, least connections, IP hash) and performs health checks to avoid routing to failed instances.

## 📖 Detailed Explanation
**Layer 4 (TCP/UDP):** balances at the transport layer — fast, no HTTP awareness. AWS NLB, Azure Load Balancer.
**Layer 7 (HTTP/HTTPS):** balances at the application layer — can route by URL path, host header, cookie; SSL termination; sticky sessions. AWS ALB, Azure Application Gateway, Nginx, Kubernetes Ingress.
**Algorithms:**
- **Round Robin:** requests cycle through instances equally.
- **Least Connections:** routes to the instance with fewest active connections.
- **IP Hash:** same client always goes to the same instance (useful for session affinity).
- **Weighted:** some instances get more traffic (A/B testing, canary deploys).
**Health checks:** load balancer polls /health/ready; failed instances removed from rotation until healthy.

## 💻 Code Example
```csharp
// App must be load-balancer-aware

// 1. Health check endpoint (load balancer polls this)
app.MapHealthChecks("/health/ready", new HealthCheckOptions
{
    Predicate = check => check.Tags.Contains("ready")
});

// 2. Forward headers from load balancer (for correct HTTPS/IP detection)
builder.Services.Configure<ForwardedHeadersOptions>(o =>
{
    o.ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto;
});
app.UseForwardedHeaders();

// 3. Correlation ID from load balancer passthrough
app.Use(async (ctx, next) =>
{
    var corrId = ctx.Request.Headers["X-Correlation-ID"].FirstOrDefault()
                 ?? Guid.NewGuid().ToString();
    ctx.Items["CorrelationId"] = corrId;
    await next();
});
```

## ❓ Follow-Up Questions
- **Q: What is sticky session / session affinity?** A: Load balancer always routes the same client to the same instance (via cookie or IP hash). Enables stateful apps but reduces load balancing effectiveness.
- **Q: What is SSL termination?** A: The load balancer decrypts HTTPS traffic and forwards plain HTTP to backends — offloads TLS overhead from app servers.
- **Q: What is UseForwardedHeaders for?** A: When behind a load balancer, the real client IP and HTTPS scheme are in X-Forwarded-For/Proto headers. Without UseForwardedHeaders, the app sees the LB's IP and thinks requests are HTTP.

## ⚠️ Common Mistakes
❌ Not configuring UseForwardedHeaders behind a reverse proxy.
✅ Without it, auth redirect URLs use HTTP instead of HTTPS, and IPs logged are the load balancer's, not the real client's.

## 🎯 Cheat Sheet
- **L4:** TCP/UDP balancing, fast, no HTTP awareness
- **L7:** HTTP-aware, URL routing, SSL termination, sticky sessions
- **Algorithms:** round-robin, least connections, IP hash, weighted
- **Health checks:** remove unhealthy instances from rotation
- **Keywords:** UseForwardedHeaders, sticky session, SSL termination, ingress

## 🏢 Industry Experience Answer
"Our Kubernetes Nginx ingress handles L7 load balancing with round-robin. Health checks remove pods from rotation within 10 seconds of failure. UseForwardedHeaders is mandatory — without it, our IP-based rate limiter was throttling the load balancer's IP, not the actual client. All instances are stateless so sticky sessions are unnecessary — any pod handles any request."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is load balancing?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q6
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Connection pooling reuses existing database connections rather than creating a new one per request — because creating a connection is expensive (TCP handshake, auth, session setup). The pool maintains a set of open connections and lends them to callers. EF Core (via ADO.NET) uses connection pooling automatically. Key settings: MinPoolSize, MaxPoolSize (default 100 for SQL Server/PostgreSQL).

## 📖 Detailed Explanation
**Why expensive:** opening a DB connection involves TCP socket creation, auth handshake, and server-side session allocation — can take 50-200ms.
**How pooling works:** on connection open, ADO.NET checks the pool; if an idle connection exists, it's returned immediately. On connection close (Dispose), it's returned to the pool, not actually closed.
**EF Core:** handled automatically — DbContext.Dispose returns the connection to the pool; no manual pooling needed.
**Key metrics:** pool exhaustion (all connections in use, new requests wait), pool fragmentation (different connection strings = different pools).
**PgBouncer / ProxySQL:** external connection poolers that sit between app and DB — especially useful when horizontal scaling creates too many app-side connections.

## 💻 Code Example
```csharp
// Connection string pool settings
// PostgreSQL: "Host=db;Database=app;MaxPoolSize=100;MinPoolSize=5;Connection Idle Lifetime=300"
// SQL Server: "Server=db;Database=app;Max Pool Size=100;Min Pool Size=5;Connection Timeout=30"

// EF Core uses pooling transparently
builder.Services.AddDbContext<AppDbContext>(o =>
    o.UseNpgsql("Host=db;MaxPoolSize=100;MinPoolSize=5"));

// DbContext Pooling (even faster — reuses DbContext instances too)
builder.Services.AddDbContextPool<AppDbContext>(o =>
    o.UseNpgsql("Host=db;MaxPoolSize=100"), poolSize: 128);

// Monitoring pool health
// Watch: DbPool metrics — available connections, pending requests
// Alert on: pool exhaustion (pending > 0 sustained), long connection acquisition times

// ANTI-PATTERN: multiple connection strings = multiple pools = pool fragmentation
// var conn1 = new("Host=db;Database=app;User=read");   // pool 1
// var conn2 = new("Host=db;Database=app;User=write");  // pool 2 -- fragmented!
```

## ❓ Follow-Up Questions
- **Q: What is connection pool exhaustion?** A: All MaxPoolSize connections are in use; new requests wait. Causes timeout exceptions under high load. Fix: increase MaxPoolSize, optimise slow queries that hold connections too long.
- **Q: What is AddDbContextPool?** A: EF Core context pooling — reuses DbContext instances (not just connections), reducing per-request allocation. Use for high-throughput APIs.
- **Q: What is PgBouncer?** A: A lightweight PostgreSQL connection pooler. Sits between app and DB; lets 1000 app connections share 50 DB connections. Essential for large Kubernetes deployments.

## ⚠️ Common Mistakes
❌ Not disposing DbContext (or HttpClient) — connections leak back to pool in bad state.
✅ Always use using/await using or let DI manage lifetime. EF Core Scoped lifetime auto-disposes at request end.

## 🎯 Cheat Sheet
- **Pool:** reuse connections, avoid expensive per-request creation
- **MaxPoolSize:** hard cap on simultaneous connections (default 100)
- **Exhaustion:** all connections busy → timeout → 503
- **AddDbContextPool:** also reuses DbContext instances
- **PgBouncer:** external pooler for massive scale
- **Keywords:** ADO.NET pool, MinPoolSize, MaxPoolSize, PgBouncer, exhaustion

## 🏢 Industry Experience Answer
"Connection pool exhaustion took down our API during a traffic spike. Root cause: slow queries holding connections for 5+ seconds while new requests piled up. Fix: optimised the slow queries, set Connection Timeout=15 for faster failure, and deployed PgBouncer to share 50 DB connections across 30 app pods. Pool exhaustion went from regular occurrence to never."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is connection pooling?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q7
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Async I/O allows the .NET thread pool thread to be **released during I/O waits** (DB queries, HTTP calls, file reads) so it can serve other requests. Without async, a thread blocks (wastes) while waiting for the response. With async/await, one thread pool of 100 threads can handle thousands of concurrent I/O-bound requests — the key scalability mechanism for ASP.NET Core.

## 📖 Detailed Explanation
**Thread pool model:** ASP.NET Core services each request on a thread pool thread. Threads are expensive (~1MB stack). Default pool: ~500 threads.
**Sync I/O bottleneck:** 100 threads × 500ms DB query = max 200 requests/second possible before thread exhaustion.
**Async I/O model:** thread is released during the 500ms wait. 100 threads × 1000 concurrent waits = thousands of requests in flight with 100 threads. Thread pool is never exhausted by I/O waits.
**Golden rule:** async all the way — mixing sync blocking (.Result, .Wait()) in async code deadlocks or negates the benefit.

## 💻 Code Example
```csharp
// SYNC — blocks thread for entire DB duration
[HttpGet("{id:int}")]
public IActionResult GetSync(int id)
{
    var order = _ctx.Orders.Find(id);    // thread blocked for 50ms
    return Ok(order);                    // same thread, wasted during wait
}

// ASYNC — releases thread during DB wait
[HttpGet("{id:int}")]
public async Task<IActionResult> GetAsync(int id, CancellationToken ct)
{
    var order = await _ctx.Orders.FindAsync(new object[] { id }, ct);  // thread released!
    return Ok(order);                    // resumes on any available thread
}

// Load test comparison on a 4-core server, 1000 concurrent requests:
// Sync: exhausts 200 threads, rest queue → avg response 2.5s
// Async: 100 threads serve 1000 concurrent requests → avg response 55ms

// Don't do this — negates async benefit, potential deadlock
public IActionResult BadMix()
{
    var order = GetOrderAsync(1).Result;   // BLOCKS the thread — defeats async!
    return Ok(order);
}
```

## ❓ Follow-Up Questions
- **Q: Async I/O vs parallel computation?** A: Async = free thread during I/O wait (one task, non-blocking). Parallel = multiple threads computing simultaneously (CPU-bound work).
- **Q: What causes thread pool starvation?** A: Sync blocking (.Wait(), .Result) in async code; long-running CPU work on pool threads; excessive Task.Run.
- **Q: How many threads does .NET create?** A: Pool starts with min threads (= CPU count), grows up to 500+ as needed. async I/O keeps the pool from growing unnecessarily.

## ⚠️ Common Mistakes
❌ Calling .Result or .Wait() on async methods in controller actions.
✅ This blocks the thread and can deadlock (in frameworks with SynchronizationContext). Always await — async all the way up the call stack.

## 🎯 Cheat Sheet
- **Async I/O:** release thread during wait, serve more concurrent requests
- **Thread pool:** shared across all requests; not exhausted by async I/O
- **Blocking:** .Result/.Wait() = thread wasted = defeats the purpose
- **Keywords:** ThreadPool, Task, await, scalability, thread exhaustion

## 🏢 Industry Experience Answer
"Async I/O is why a .NET 8 API on 4 CPUs can handle 10,000 concurrent requests while a sync version chokes at 200. Every DB call, HTTP call, and file read is async with the cancellation token passed through. We ran load tests comparing async vs sync for the same API — async was 50x more throughput on I/O-heavy endpoints. It's not an optimisation; it's the foundation."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is async I/O and why is it important for scalability?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q8
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A memory leak in .NET is when objects are **rooted in memory (referenced)** and cannot be collected by the GC, despite no longer being needed — causing memory to grow unbounded until the app crashes or degrades. Common causes: event handler subscriptions not unsubscribed, static collections accumulating entries, improper use of caches without eviction, not disposing IDisposable objects.

## 📖 Detailed Explanation
**Why .NET has leaks despite GC:** GC collects unreachable objects. If a reference (event subscription, static field, cache) keeps an object reachable, GC can't collect it — it's a leak.
**Common causes:**
1. **Event handlers:** Publisher holds reference to subscriber via event. If subscriber is short-lived but doesn't unsubscribe, it stays alive as long as the publisher.
2. **Static collections:** `static List<T>` accumulating entries without removal.
3. **Unbounded caches:** IMemoryCache with no size limit or expiry.
4. **Unclosed streams/connections:** DbContext, HttpClient, IDisposable not disposed.
5. **Captured closures:** lambdas capturing large objects.

## 💻 Code Example
```csharp
// LEAK: event handler not unsubscribed
public class OrderEventListener : IDisposable
{
    private readonly OrderService _service;
    public OrderEventListener(OrderService svc)
    {
        _service = svc;
        _service.OrderPlaced += OnOrderPlaced;    // svc holds ref to this — LEAK if not removed
    }

    private void OnOrderPlaced(object sender, EventArgs e) { /* handle */ }

    public void Dispose()
    {
        _service.OrderPlaced -= OnOrderPlaced;    // MUST unsubscribe
    }
}

// LEAK: unbounded static cache
public static class ProductCache
{
    private static readonly Dictionary<int, Product> _cache = new();  // grows forever!
    public static void Add(int id, Product p) => _cache[id] = p;     // never evicted
}

// FIX: bounded cache with eviction
builder.Services.AddMemoryCache(o => o.SizeLimit = 1000);
_cache.Set(key, value, new MemoryCacheEntryOptions { Size = 1, SlidingExpiration = TimeSpan.FromMinutes(10) });

// Detect leaks
// dotnet-counters monitor --process-id {pid} System.Runtime
// Watch: gc-heap-size growing over time
// Tools: dotMemory, PerfView, Visual Studio Diagnostic Tools
```

## ❓ Follow-Up Questions
- **Q: How do you detect a memory leak in .NET?** A: Monitor GC heap size over time (dotnet-counters, Application Insights metrics). Growing heap without corresponding load increase = leak. Profile with dotMemory or PerfView to find the retained objects.
- **Q: Weak references for caches?** A: WeakReference<T> lets GC collect the object when under memory pressure — useful for object caches where freshness on memory pressure is acceptable.
- **Q: IDisposable and memory leaks?** A: Not disposing IDisposable doesn't leak managed memory (GC handles that) but leaks unmanaged resources (file handles, socket, DB connection). Equally dangerous.

## ⚠️ Common Mistakes
❌ Subscribing to events on long-lived publishers from short-lived objects without unsubscribing.
✅ If an object subscribes to an event, it must unsubscribe in Dispose(). Use weak event patterns or explicit unsubscription.

## 🎯 Cheat Sheet
- **Memory leak:** object reachable but no longer needed — GC can't collect
- **Causes:** event subscriptions, static collections, unbounded caches, undisposed resources
- **Detect:** gc-heap-size metric, dotMemory, PerfView, heap snapshots
- **Fix:** unsubscribe events, eviction policies, using/IDisposable
- **Keywords:** GC root, event handler, WeakReference, IDisposable, dotnet-counters

## 🏢 Industry Experience Answer
"We diagnosed a slow memory leak in production: heap grew 50MB per hour, pod OOM-killed every 3 days. Root cause: a background worker subscribed to a domain event bus and never unsubscribed, accumulating subscriber references. dotMemory heap snapshot showed 50,000 worker instances alive. Fix: implement IDisposable, unsubscribe on Dispose. Post-fix: heap stable for weeks."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is memory leak and how to prevent it in .NET Core apps?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q9
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
.NET's garbage collector manages memory automatically using a **generational model** with three generations: **Gen 0** (new, short-lived objects — collected most frequently), **Gen 1** (objects that survived Gen 0 — medium), **Gen 2** (long-lived objects — collected rarely, most expensive). Objects promote from Gen 0 → Gen 1 → Gen 2 if they survive collection.

## 📖 Detailed Explanation
**Generational hypothesis:** most objects die young (temporaries, request-scoped objects). Gen 0 is small and collected cheaply; most garbage is found there.
**Gen 0 collection:** very fast (milliseconds), triggered frequently (when Gen 0 is full). Only Gen 0 is scanned.
**Gen 1 collection:** medium, scans Gen 0 + Gen 1. Survivours of Gen 0 are here.
**Gen 2 collection (Full GC):** expensive, scans the entire heap including Large Object Heap (LOH). Pauses the app (or concurrent in Server GC). Avoid promoting objects to Gen 2 unnecessarily.
**GC modes:** Workstation GC (low latency, pauses for full GC), Server GC (throughput-optimized, multiple GC threads, one per CPU — default in ASP.NET Core).

## 💻 Code Example
```csharp
// Understanding generation promotion

// Short-lived (ideal for Gen 0) — immediately eligible for collection
var dto = new OrderDto { Id = 1, Status = "Active" };   // created, used, then GC'd in Gen 0

// Long-lived (ends up in Gen 2) — don't make these too large
private static readonly IReadOnlyList<string> Countries = LoadCountries();  // Gen 2 forever

// Pattern to avoid unnecessary Gen 2 promotion
// BAD: keeping large objects alive longer than needed
List<OrderDto> _allOrders = await LoadAllAsync();  // request-scoped: Gen 0 → Gen 2 if large
// GOOD: stream and process rather than load all
await foreach (var order in _repo.StreamAsync(ct))
    await ProcessAsync(order, ct);   // one at a time, Gen 0 collection between iterations

// Inspect GC in code
Console.WriteLine("Gen 0: " + GC.CollectionCount(0));
Console.WriteLine("Gen 1: " + GC.CollectionCount(1));
Console.WriteLine("Gen 2: " + GC.CollectionCount(2));

// Monitor via dotnet-counters
// dotnet-counters monitor System.Runtime
// gc-collections-0, gc-collections-1, gc-collections-2
```

## ❓ Follow-Up Questions
- **Q: What is a Full GC?** A: Gen 2 collection scanning the entire managed heap including LOH. Most expensive; should be rare in healthy apps.
- **Q: Server GC vs Workstation GC?** A: Server GC uses one GC heap per CPU core with dedicated GC threads — higher throughput but more memory. ASP.NET Core uses Server GC by default.
- **Q: How do you reduce Gen 2 pressure?** A: Keep objects short-lived, avoid large object allocations (>85KB), use object pooling and Span/Memory to avoid allocations.

## ⚠️ Common Mistakes
❌ Loading all records into a List<T> when processing large datasets.
✅ Stream using IAsyncEnumerable — process one at a time so large collections don't promote to Gen 2.

## 🎯 Cheat Sheet
- **Gen 0:** new, cheap, frequent collection
- **Gen 1:** survived Gen 0, medium
- **Gen 2:** long-lived, Full GC, expensive — minimize promotions
- **Server GC:** one heap per CPU, high throughput — default for ASP.NET Core
- **Keywords:** generational GC, promotion, Full GC, LOH, collection count

## 🏢 Industry Experience Answer
"Gen 2 collection rate is a key health metric for us — if it spikes, something is promoting too many objects to long-lived memory. We've fixed two performance regressions by identifying code that loaded large collections into memory (promoting to Gen 2) instead of streaming. Switching to IAsyncEnumerable and batched processing brought Gen 2 collections from 10/minute to near zero."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'How does the .NET garbage collector work? Gen 0, Gen 1, Gen 2?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q10
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
The **Large Object Heap (LOH)** stores objects 85KB or larger. The LOH is part of Gen 2 — objects go there directly and are collected only during Full GC. Unlike the small object heap, the LOH is **not compacted by default** (moving large objects is expensive), leading to memory fragmentation. Fragmented LOH wastes memory and increases GC pressure.

## 📖 Detailed Explanation
**85KB threshold:** objects >= 85,000 bytes (arrays of ~21,250 `int`, ~10,625 `long`, etc.) go to the LOH.
**No compaction:** the GC marks LOH free space but doesn't move surviving objects together. Over time, the LOH can have many small gaps — fragmentation.
**Fragmentation consequences:** free space exists but is unusable for large allocations if it's fragmented. GC must do more Full GCs to find/create space.
**Mitigation:**
- `GCSettings.LargeObjectHeapCompactionMode = GCLargeObjectHeapCompactionMode.CompactOnce` — force one compaction.
- ArrayPool<T> — rent large arrays from a pool instead of allocating.
- Avoid frequent large object creation/disposal.

## 💻 Code Example
```csharp
// Objects that go to LOH:
var bigArray = new byte[86_000];      // > 85KB → LOH immediately
var bigString = new string('x', 50_000);  // strings > 85KB → LOH

// PROBLEM: frequent large array alloc/dealloc fragments LOH
for (int i = 0; i < 10_000; i++)
{
    var buffer = new byte[100_000];    // allocates on LOH each iteration
    Process(buffer);
    // buffer goes out of scope, LOH gets a 100KB hole → fragmentation
}

// FIX: ArrayPool — rent from pool, return after use, zero LOH allocation
var pool = ArrayPool<byte>.Shared;
for (int i = 0; i < 10_000; i++)
{
    var buffer = pool.Rent(100_000);   // reuses from pool — no LOH allocation
    try { Process(buffer); }
    finally { pool.Return(buffer); }
}

// Monitor LOH fragmentation
// PerfView: GC heap dumps show LOH fragmentation %
// dotnet-counters: loh-size, gc-loh-compaction
```

## ❓ Follow-Up Questions
- **Q: Can you force LOH compaction?** A: Yes — GCSettings.LargeObjectHeapCompactionMode = CompactOnce before GC.Collect() or in GC callback. Expensive, blocking.
- **Q: Is string interning related to LOH?** A: Only for strings >= 85KB. Most interned strings are in Gen 2 small object heap.
- **Q: Span<T> and LOH?** A: Span<T> can slice over an existing large array without creating new ones — avoids LOH allocations.

## ⚠️ Common Mistakes
❌ Allocating and discarding large byte arrays in a loop (e.g., per-request byte[] buffers for file reads).
✅ Use ArrayPool<byte>.Shared.Rent/Return — pool keeps the arrays alive; no LOH allocation per request.

## 🎯 Cheat Sheet
- **LOH threshold:** 85,000 bytes
- **LOH vs SOH:** LOH = Gen 2 only, no compaction by default
- **Fragmentation:** holes in LOH waste memory, increase GC frequency
- **Fix:** ArrayPool<T>, avoid frequent large alloc/dealloc
- **Keywords:** Large Object Heap, LOH fragmentation, ArrayPool, compaction, 85KB

## 🏢 Industry Experience Answer
"LOH fragmentation caused our file upload service to OOM after a few hours. Root cause: per-upload 200KB byte[] buffer — allocating and discarding thousands per hour. LOH became fragmented to the point where new allocations triggered Full GCs searching for contiguous space. Switching to ArrayPool<byte> eliminated the LOH allocation entirely and memory usage became perfectly flat."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is the Large Object Heap (LOH) and why can it cause fragmentation?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q11
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Object pooling reuses expensive-to-create objects instead of creating new ones per use. In .NET: **`ArrayPool<T>`** pools byte/char arrays (avoids LOH allocation), **`ObjectPool<T>`** (Microsoft.Extensions.ObjectPool) pools any object. Use pooling for large buffers, expensive-to-construct objects (e.g., regex engines, serializers), or any object created at high frequency in hot paths.

## 📖 Detailed Explanation
**Why pool:** object creation = memory allocation + GC pressure. For objects created thousands of times per second or objects that are expensive to initialize, pooling trades allocation overhead for a rent/return pattern.
**ArrayPool<T>.Shared:** globally shared pool for byte/char/int arrays. Rent minimum size needed; return immediately when done. Not zero-initialized on return — security: zero before use if processing untrusted data.
**ObjectPool<T>:** generic pool from Microsoft.Extensions.ObjectPool. Requires IPooledObjectPolicy<T> — defines Create() and Return(). Registered in DI.
**When NOT to pool:** objects that are cheap to create (strings, simple POCOs), or when holding them long-term. Pool thrashing (frequent rent/return) can be worse than allocation.

## 💻 Code Example
```csharp
// ArrayPool<T> — avoid LOH allocation for large buffers
public async Task ProcessFileAsync(Stream stream, CancellationToken ct)
{
    var pool = ArrayPool<byte>.Shared;
    var buffer = pool.Rent(65536);    // rent at least 65KB (may get more)
    try
    {
        var bytesRead = await stream.ReadAsync(buffer.AsMemory(0, 65536), ct);
        // Process buffer[0..bytesRead]
    }
    finally
    {
        pool.Return(buffer, clearArray: true);   // clearArray=true for security
    }
}

// ObjectPool<T> — pool expensive objects
public class RegexPool
{
    private readonly ObjectPool<Regex> _pool;
    public RegexPool(ObjectPoolProvider provider) =>
        _pool = provider.Create(new DefaultPooledObjectPolicy<Regex>());

    public bool IsMatch(string input)
    {
        var regex = _pool.Get();
        try { return regex.IsMatch(input); }
        finally { _pool.Return(regex); }
    }
}

// StringBuilder pooling (built-in in .NET 6+)
var sb = StringBuilderPool.Get();
try { sb.Append("Hello"); return sb.ToString(); }
finally { StringBuilderPool.Return(sb); }
```

## ❓ Follow-Up Questions
- **Q: Is ArrayPool.Shared thread-safe?** A: Yes — fully thread-safe, designed for concurrent use.
- **Q: Does Rent guarantee the requested size?** A: No — it returns >= requested size. Use buffer.AsMemory(0, requestedSize) to slice to exact size.
- **Q: When does ObjectPool use DefaultPooledObjectPolicy?** A: When your pooled object has a parameterless constructor and can be reset to a clean state for reuse.

## ⚠️ Common Mistakes
❌ Not returning rented arrays to the pool.
✅ Always return in a finally block. If not returned, the array is never reused and you've gained no benefit from pooling.

## 🎯 Cheat Sheet
- **ArrayPool<T>.Shared:** byte[] pooling, avoids LOH, thread-safe
- **ObjectPool<T>:** generic pooling for expensive-to-create objects
- **Rent/Return:** always return in finally to avoid pool leaks
- **Keywords:** ArrayPool, ObjectPool, LOH, GC pressure, hot path

## 🏢 Industry Experience Answer
"ArrayPool is used in every I/O handler in our system — file uploads, HTTP body parsing, response serialization. Before pooling, our binary processing service was generating 2GB of LOH allocations per hour. After ArrayPool everywhere, it dropped to near zero. The pattern is mechanical: rent, try-finally-return. Once it's habit, it's no extra cognitive load."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is object pooling and when is it useful (e.g., ArrayPool<T>)?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q12
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
BenchmarkDotNet is the **gold-standard .NET benchmarking library** — it runs code under controlled conditions (warm-up, multiple iterations, statistics) and produces accurate, reproducible performance measurements with hardware counters. Use it to compare implementations, measure allocation, and validate performance improvements with statistical significance.

## 📖 Detailed Explanation
**Why not Stopwatch:** manual timing is noisy — JIT warm-up, CPU frequency scaling, GC interruptions. BenchmarkDotNet controls all of these for accurate results.
**What it measures:** mean/median/StdDev execution time, memory allocation per operation, Gen 0/1/2 collection counts.
**Attributes:** [Benchmark] on methods, [GlobalSetup] for one-time setup, [IterationSetup] per iteration, [Params] for parameterized benchmarks.
**MemoryDiagnoser:** shows bytes allocated per operation — critical for allocation-reduction optimization.
**Running:** `dotnet run -c Release` in the benchmark project — must be Release mode; Debug benchmarks are meaningless.

## 💻 Code Example
```csharp
// Install: BenchmarkDotNet
// Create a SEPARATE console project for benchmarks

[MemoryDiagnoser]   // show allocation per operation
[SimpleJob(RuntimeMoniker.Net80)]
public class StringBenchmarks
{
    private const int N = 1000;

    [Benchmark(Baseline = true)]
    public string ConcatenationLoop()
    {
        string result = "";
        for (int i = 0; i < N; i++) result += i.ToString();
        return result;
    }

    [Benchmark]
    public string StringBuilderLoop()
    {
        var sb = new System.Text.StringBuilder();
        for (int i = 0; i < N; i++) sb.Append(i);
        return sb.ToString();
    }

    [Benchmark]
    public string StringJoin() =>
        string.Join("", Enumerable.Range(0, N).Select(i => i.ToString()));
}

// Program.cs
BenchmarkRunner.Run<StringBenchmarks>();

// Run: dotnet run -c Release
// Output shows: Mean, Allocated, Gen0, Ratio (vs Baseline)
```

## ❓ Follow-Up Questions
- **Q: Why must benchmarks run in Release mode?** A: Debug builds have no JIT optimisations — results are meaningless and misleading. Always -c Release.
- **Q: What is BenchmarkDotNet's warm-up phase?** A: Runs the method several times before measuring to allow JIT compilation and CPU branch prediction to stabilize.
- **Q: How many iterations does BenchmarkDotNet run?** A: Automatically adjusts — typically 15+ measured iterations per benchmark for statistical reliability.

## ⚠️ Common Mistakes
❌ Using Stopwatch in a Debug build to benchmark code.
✅ Stopwatch gives meaningless results without JIT warmup control. Use BenchmarkDotNet with Release mode for reliable measurements.

## 🎯 Cheat Sheet
- **[Benchmark]:** marks a method to benchmark
- **[MemoryDiagnoser]:** shows bytes allocated per operation
- **[Params]:** parameterized benchmarks (test N=100, N=1000)
- **Run:** dotnet run -c Release — never Debug
- **Keywords:** BenchmarkDotNet, JIT warmup, allocation, Gen0, statistical significance

## 🏢 Industry Experience Answer
"BenchmarkDotNet settled every 'which implementation is faster?' debate on our team. We benchmarked our JSON serialization options and confirmed System.Text.Json was 2.3x faster than Newtonsoft with 60% less allocation. The [MemoryDiagnoser] attribute is the most valuable — often the 'faster' method allocates 3x more, which the timing alone doesn't reveal. Data beats arguments."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'How do you benchmark .NET code using BenchmarkDotNet?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q13
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Response compression reduces the size of HTTP responses using GZIP or Brotli, reducing bandwidth and improving client-perceived performance. In ASP.NET Core, enable with `AddResponseCompression()` and `UseResponseCompression()`. Compress text content (JSON, HTML, CSS, JS) — not already-compressed binary (images, PDFs, video).

## 📖 Detailed Explanation
**How it works:** the client sends `Accept-Encoding: gzip, br` in request headers. The server compresses the response body and sets `Content-Encoding: gzip` (or br) in the response.
**Brotli vs GZIP:** Brotli typically achieves 15-25% better compression than GZIP, especially for text. Supported by all modern browsers. GZIP for broader compatibility.
**What to compress:** application/json, text/html, text/css, application/javascript, text/plain. Minimum size threshold (don't compress very small responses — overhead > benefit).
**HTTPS caveat:** CRIME/BREACH attacks exploit compression + HTTPS for sensitive data. Don't compress responses containing secrets with predictable content.
**CPU tradeoff:** compression uses CPU. For high-throughput APIs, a CDN or reverse proxy (Nginx) may handle compression more efficiently.

## 💻 Code Example
```csharp
// Register response compression
builder.Services.AddResponseCompression(o =>
{
    o.EnableForHttps = true;   // be aware of CRIME/BREACH for sensitive data
    o.Providers.Add<BrotliCompressionProvider>();
    o.Providers.Add<GzipCompressionProvider>();
    o.MimeTypes = ResponseCompressionDefaults.MimeTypes.Concat(
        new[] { "application/json", "application/problem+json" });
});

builder.Services.Configure<BrotliCompressionProviderOptions>(o =>
    o.Level = CompressionLevel.Fastest);   // balance speed vs ratio

builder.Services.Configure<GzipCompressionProviderOptions>(o =>
    o.Level = CompressionLevel.SmallestSize);

// Apply (BEFORE static files, routing)
app.UseResponseCompression();

// Verify: curl -H "Accept-Encoding: gzip" -v https://myapi/orders
// Response headers should include: Content-Encoding: gzip
```

## ❓ Follow-Up Questions
- **Q: Should you compress all response types?** A: No — images (JPEG, PNG), video, and already-compressed binaries waste CPU with minimal size reduction. Compress text/JSON only.
- **Q: App-level vs CDN/reverse proxy compression?** A: CDNs (Cloudflare) and Nginx handle compression at the edge — can cache compressed responses and serve directly. App-level compression is a fallback.
- **Q: CRIME/BREACH attack?** A: Exploits response compression to extract secrets from HTTPS responses by observing size changes with crafted requests. Mitigate by not compressing responses containing user-controllable secrets.

## ⚠️ Common Mistakes
❌ Enabling EnableForHttps without considering BREACH.
✅ For APIs returning authentication tokens or sensitive user data in predictable positions, disable compression or add per-response randomness. For typical JSON API responses, EnableForHttps is generally safe.

## 🎯 Cheat Sheet
- **Algorithms:** Brotli (better ratio), GZIP (wider support)
- **Compress:** JSON, HTML, CSS, JS text content
- **Skip:** images, binary, already-compressed content
- **Level:** Fastest for real-time, Optimal/SmallestSize for static
- **Keywords:** Accept-Encoding, Content-Encoding, BREACH, AddResponseCompression

## 🏢 Industry Experience Answer
"Enabling Brotli compression on our API reduced JSON response sizes by 70% on average. For mobile clients on limited bandwidth, this translated to 2-3x faster load times. We offloaded compression to Nginx for cached responses, keeping the app-level compression only for dynamic responses. The one gotcha: we initially compressed an endpoint returning auth tokens — disabled compression there after reviewing BREACH risk."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is response compression in ASP.NET Core?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q14
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Profiling identifies where a .NET application spends its CPU time and memory. Key tools: **dotnet-counters** (live metrics), **dotnet-trace** (CPU + events), **PerfView** (deep CPU + GC analysis), **dotMemory** (JetBrains, memory profiling), **Application Insights** (production APM), and **Visual Studio Diagnostic Tools** (integrated IDE profiler). Profile in Release mode; measure before optimising.

## 📖 Detailed Explanation
**When to profile:** performance regression, high CPU/memory in production, slow endpoints. Always profile before optimising — measure, don't guess.
**dotnet-counters:** lightweight, real-time. CPU, GC rates, heap size, thread pool, active requests. No code changes needed.
**dotnet-trace:** captures a trace file (nettrace) for offline analysis. CPU sampling, event pipe. Works in production (low overhead).
**PerfView:** free Microsoft tool for deep GC, CPU, allocation analysis. Steep learning curve but most powerful.
**dotMemory:** JetBrains commercial tool. Memory leak detection, object retention path, generation analysis. Best memory profiler.
**Application Insights:** production APM — request rates, dependencies, failures, distributed traces. Essential for production performance monitoring.

## 💻 Code Example
```csharp
// 1. Live counters — zero code changes
// dotnet-counters monitor --process-id {pid} System.Runtime

// 2. Capture trace (production-safe, low overhead)
// dotnet-trace collect --process-id {pid} --providers Microsoft-DotNETCore-SampleProfiler

// 3. Profiler-guided optimization example
// BEFORE (profiler shows 60% time in LINQ OrderBy):
var sorted = orders.OrderBy(o => o.Total).ToList();

// AFTER (profiler shows 5% time):
orders.Sort((a, b) => a.Total.CompareTo(b.Total));  // in-place sort, faster

// 4. Application Insights custom telemetry
using (var op = _telemetry.StartOperation<RequestTelemetry>("ProcessOrder"))
{
    op.Telemetry.Properties["OrderId"] = orderId.ToString();
    var result = await ProcessAsync(orderId, ct);
    op.Telemetry.Success = result != null;
}

// 5. MiniProfiler (HTTP request-level profiling in dev)
builder.Services.AddMiniProfiler(o => o.RouteBasePath = "/profiler");
app.UseMiniProfiler();
```

## ❓ Follow-Up Questions
- **Q: How do you find memory leaks with dotMemory?** A: Take two heap snapshots separated by time; compare retained objects. Groups that grow = potential leak.
- **Q: What is flame graph?** A: A visual representation of CPU call stacks — width = time spent. Identify hot methods at a glance.
- **Q: What is MiniProfiler?** A: Lightweight per-request profiler showing DB queries, timings, N+1 detection — perfect for development.

## ⚠️ Common Mistakes
❌ Profiling in Debug mode.
✅ JIT optimisations are disabled in Debug; results don't reflect production behavior. Always profile in Release mode with realistic data.

## 🎯 Cheat Sheet
- **dotnet-counters:** live real-time metrics (CPU, GC, threads)
- **dotnet-trace:** trace capture for offline CPU analysis
- **PerfView:** deep GC + CPU + allocation (free, powerful)
- **dotMemory:** memory leaks, heap analysis (JetBrains)
- **AppInsights:** production APM, distributed traces
- **Keywords:** CPU sampling, flame graph, heap snapshot, MiniProfiler

## 🏢 Industry Experience Answer
"Our profiling stack: Application Insights for production APM (catches regressions within minutes of deploy), dotnet-counters for quick live diagnostics on a specific pod, and dotMemory for memory investigations in staging. The rule: never guess where the bottleneck is. Profiler first, every time. The last three performance wins came from profiler-identified hot paths that surprised us — none were in the obvious places."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What tools do you use to profile a .NET application?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q15
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
The .NET thread pool manages a **shared pool of threads** for executing work items, async continuations, and background tasks. It has two components: **worker threads** (for CPU/general work) and **I/O completion port threads** (for async I/O on Windows). The pool starts with min threads (= CPU count) and grows dynamically up to MaxThreads when demand exceeds capacity — but growing is slow (adds one thread per second), so thread pool starvation causes latency spikes.

## 📖 Detailed Explanation
**Thread creation cost:** a new thread takes ~250KB-1MB stack + OS scheduling overhead. The pool amortizes this by reusing threads.
**Min threads:** set with ThreadPool.SetMinThreads(). Pool starts at this size — grows immediately to min without delay.
**Max threads:** hard ceiling. Beyond this, work items queue. Default = 500+ (very high — rarely the limit).
**Starvation:** when work items block (sync over async, long CPU work) the pool's active threads are consumed. New threads are created slowly (one per second by default) → latency spikes until pool grows.
**Solution:** never block thread pool threads. Always use async/await for I/O; use Task.Run for CPU-bound work to explicitly opt in.

## 💻 Code Example
```csharp
// View thread pool state
ThreadPool.GetAvailableThreads(out int workers, out int ports);
ThreadPool.GetMaxThreads(out int maxWorkers, out int maxPorts);
Console.WriteLine("Available workers: " + workers + "/" + maxWorkers);

// Prevent starvation — set adequate min threads for high-throughput APIs
// (allows pool to grow to min instantly without delay)
ThreadPool.SetMinThreads(200, 200);

// CAUSES starvation: blocking on thread pool thread
Task.Run(() =>
{
    Thread.Sleep(5000);            // blocks a thread pool thread for 5 seconds
}).Wait();

// NO starvation: proper async — releases the thread during wait
await Task.Delay(5000);           // no thread consumed during the delay

// Monitor thread pool
// dotnet-counters: threadpool-thread-count, threadpool-queue-length
// Alert on: threadpool-queue-length > 0 sustained (work items waiting)
```

## ❓ Follow-Up Questions
- **Q: What is thread pool starvation?** A: All active threads are blocked (by sync code or long CPU work). New thread requests queue, waiting for the pool to grow (1/sec). Causes latency spikes.
- **Q: How does async/await interact with the thread pool?** A: await releases the thread to the pool during I/O. Continuation is scheduled back to an available pool thread. The pool stays healthy.
- **Q: What is the I/O completion thread pool?** A: A separate pool used for Windows IOCP-based async I/O (file, network). Managed separately from worker threads.

## ⚠️ Common Mistakes
❌ Task.Run(() => { Thread.Sleep(30000); }) — blocking 30 seconds on a pool thread.
✅ Long-running blocking work should use new Thread() with IsBackground=true or BackgroundService, not thread pool threads.

## 🎯 Cheat Sheet
- **Worker threads:** CPU/general work, default min = CPU count
- **Min threads:** grow instantly to min, then slowly after
- **Starvation:** all threads blocked → new requests queue → latency spike
- **Fix:** async/await all I/O; don't block pool threads
- **Keywords:** ThreadPool, SetMinThreads, starvation, IOCP, work item queue

## 🏢 Industry Experience Answer
"Thread pool starvation manifested as mysterious latency spikes at peak load — p99 went from 50ms to 30 seconds periodically. Root cause: one legacy sync library blocking pool threads during third-party API calls. The pool couldn't grow fast enough. Fix: wrapped the sync call in Task.Run (its own dedicated thread outside the pool) and set SetMinThreads(200) to reduce growth latency. Spikes eliminated completely."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is a thread pool and how does .NET manage threads?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- End of Batch 8 — Performance & Scalability COMPLETE (Q1–Q15)

-- ════════════════════════════════════════════════════════════
-- DevReady Seed — Batch 9
-- .NET › 9️⃣ Testing & Tools › Q1–Q13
-- Dollar-quote safe (zero $ inside content). Idempotent upsert.
-- ════════════════════════════════════════════════════════════

-- Q1
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Unit testing verifies that a **single unit of code** (a method, class, or function) works correctly in isolation, with all dependencies replaced by test doubles (mocks/fakes). Tests are fast, deterministic, and independent of external systems (DB, network, file system). They're the foundation of test automation — run in milliseconds, catch regressions immediately.

## 📖 Detailed Explanation
**What a "unit" is:** typically one class or one method. The unit under test is exercised in isolation — its dependencies are replaced with mocks/stubs.
**Benefits:** fast feedback (run on every save), precise failure location (test name tells you exactly what broke), confidence in refactoring, living documentation of behavior.
**Unit test framework:** xUnit, NUnit, or MSTest. All provide test runners, assertions, and lifecycle hooks.
**Good unit test properties (FIRST):**
- **F**ast — milliseconds per test
- **I**ndependent — no shared state between tests
- **R**epeatable — same result every run
- **S**elf-validating — pass or fail, no manual check
- **T**imely — written at the same time as the code

## 💻 Code Example
```csharp
// System under test
public class OrderCalculator
{
    public decimal CalculateTotal(IEnumerable<OrderItem> items, decimal discountPercent)
    {
        var subtotal = items.Sum(i => i.Price * i.Quantity);
        return subtotal * (1 - discountPercent / 100);
    }
}

// Unit test (xUnit)
public class OrderCalculatorTests
{
    private readonly OrderCalculator _sut = new OrderCalculator();

    [Fact]
    public void CalculateTotal_WithDiscount_ReturnsDiscountedAmount()
    {
        // Arrange
        var items = new[] { new OrderItem { Price = 100m, Quantity = 2 } };

        // Act
        var result = _sut.CalculateTotal(items, discountPercent: 10);

        // Assert
        Assert.Equal(180m, result);   // 200 * 0.90 = 180
    }

    [Theory]
    [InlineData(0, 200)]
    [InlineData(50, 100)]
    [InlineData(100, 0)]
    public void CalculateTotal_VariousDiscounts_ReturnsCorrectTotal(
        decimal discount, decimal expected)
    {
        var items = new[] { new OrderItem { Price = 100m, Quantity = 2 } };
        Assert.Equal(expected, _sut.CalculateTotal(items, discount));
    }
}
```

## ❓ Follow-Up Questions
- **Q: Unit test vs integration test?** A: Unit = isolated, one class, mocked dependencies, milliseconds. Integration = multiple real components working together, DB/network, seconds.
- **Q: How many unit tests should you have?** A: Enough to cover all meaningful behaviors, edge cases, and error paths. No fixed number — test behavior, not lines.
- **Q: What is test isolation?** A: Each test must not depend on or affect other tests. Use fresh instances; never share mutable state.

## ⚠️ Common Mistakes
❌ Writing tests that hit the database or file system (those are integration tests).
✅ Mock external dependencies in unit tests. Speed and isolation are the defining properties.

## 🎯 Cheat Sheet
- **Unit test:** one class, mocked deps, fast, isolated
- **FIRST:** Fast, Independent, Repeatable, Self-validating, Timely
- **Framework:** xUnit ([Fact], [Theory]), NUnit ([Test], [TestCase]), MSTest
- **Keywords:** isolation, mock, regression, living documentation

## 🏢 Industry Experience Answer
"Unit tests are our first line of defense. Every command handler, domain method, and calculation has unit tests. When a test fails in CI, the developer knows immediately — not after a 20-minute deployment. The payoff: 3 years of active development, zero production regressions from covered code. Test names follow 'MethodName_Scenario_ExpectedBehavior' so failures read like bug reports."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is unit testing?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q2
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Mocking replaces a **real dependency with a controlled substitute** that you can configure to return specific values or verify was called correctly. Mocks enable unit testing in isolation — your class under test never calls the real database, email service, or HTTP endpoint. In .NET, Moq is the most popular mocking library.

## 📖 Detailed Explanation
**Why mock:** unit tests must be fast and isolated. Real dependencies (DB, network, file system) are slow, have external state, and make tests flaky.
**What you configure:** mock return values (`Returns`), thrown exceptions (`Throws`), callback behavior (`Callback`).
**What you verify:** whether a method was called (`Verify`), how many times (`Times.Once`), with what arguments (`It.Is<T>`).
**Types of test doubles:** Mock (configurable + verifiable), Stub (returns preset values, no verification), Fake (working lightweight implementation), Spy (records calls).

## 💻 Code Example
```csharp
// Interface to mock
public interface IEmailService
{
    Task SendAsync(string to, string subject, string body);
}

// System under test
public class RegistrationService
{
    private readonly IEmailService _email;
    public RegistrationService(IEmailService email) => _email = email;

    public async Task RegisterAsync(string email, string name)
    {
        // Business logic...
        await _email.SendAsync(email, "Welcome!", "Welcome " + name);
    }
}

// Test with Moq
public class RegistrationServiceTests
{
    [Fact]
    public async Task RegisterAsync_SendsWelcomeEmail()
    {
        // Arrange
        var mockEmail = new Mock<IEmailService>();
        mockEmail.Setup(e => e.SendAsync(
            It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
            .Returns(Task.CompletedTask);

        var sut = new RegistrationService(mockEmail.Object);

        // Act
        await sut.RegisterAsync("user@example.com", "Sidhant");

        // Assert — verify the email was sent with correct address
        mockEmail.Verify(
            e => e.SendAsync("user@example.com", "Welcome!", It.IsAny<string>()),
            Times.Once);
    }
}
```

## ❓ Follow-Up Questions
- **Q: Mock vs Stub?** A: Stub = preset return values only; Mock = preset values + verify calls happened. Moq does both.
- **Q: When should you NOT mock?** A: Don't mock the type under test. Don't mock value types. Don't mock everything — complex mocking setup is a sign of poor design.
- **Q: It.IsAny vs It.Is?** A: It.IsAny<T>() matches any value of T. It.Is<T>(predicate) matches values that satisfy the predicate.

## ⚠️ Common Mistakes
❌ Mocking everything including value objects and DTOs.
✅ Mock external services and infrastructure. Use real objects for pure domain types (entities, value objects, calculations).

## 🎯 Cheat Sheet
- **Setup:** configure return value / exception
- **Verify:** assert a method was called with expected args
- **It.IsAny:** match any value; It.Is: match by predicate
- **Times:** Once, Never, Exactly(N), AtLeastOnce
- **Keywords:** Moq, test double, isolation, arrange-act-assert

## 🏢 Industry Experience Answer
"Moq is in every test project we have. The discipline: mock interfaces, not concrete classes — it's a smell if you're mocking a concrete class (should be an interface). We also avoid over-mocking: if a test has 5 mock setups, the class under test is probably doing too much. Simple mocks = clean design."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is mocking?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q3
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
All three are .NET unit testing frameworks. **xUnit** is the modern default — created by the NUnit author to fix design issues; used by Microsoft teams and ASP.NET Core itself. **NUnit** is mature and feature-rich. **MSTest** is Microsoft's built-in framework, tightly integrated with Visual Studio. For new projects, xUnit is the standard choice.

## 📖 Detailed Explanation
| Feature | xUnit | NUnit | MSTest |
|---|---|---|---|
| Test attribute | [Fact] / [Theory] | [Test] / [TestCase] | [TestMethod] / [DataRow] |
| Setup | Constructor / IClassFixture | [SetUp] | [TestInitialize] |
| Teardown | IDisposable | [TearDown] | [TestCleanup] |
| Parallelism | Default: parallel | Opt-in | Limited |
| DI support | IClassFixture, ICollectionFixture | Less native | Less native |
| ASP.NET Core | Official choice | Supported | Supported |

**Key xUnit design philosophy:** no [SetUp]/[TearDown] methods — use constructor/IDisposable instead. Each test gets a fresh instance — enforces isolation. Parallelism by default — faster.

## 💻 Code Example
```csharp
// xUnit (preferred)
public class OrderTests : IDisposable
{
    private readonly OrderService _sut;
    private readonly Mock<IOrderRepository> _repo;

    public OrderTests()      // constructor = setup
    {
        _repo = new Mock<IOrderRepository>();
        _sut = new OrderService(_repo.Object);
    }

    public void Dispose() { /* cleanup */ }  // IDisposable = teardown

    [Fact]
    public void PlaceOrder_WithEmptyItems_ThrowsDomainException()
    {
        var cmd = new PlaceOrderCommand { Items = new List<OrderItem>() };
        Assert.Throws<DomainException>(() => _sut.PlaceOrder(cmd));
    }

    [Theory]
    [InlineData(1, 100.0)]
    [InlineData(2, 50.0)]
    public void CalculatePrice_ReturnsExpected(int quantity, decimal expected)
    {
        Assert.Equal(expected, _sut.CalculateUnitPrice(quantity));
    }
}

// NUnit equivalent
[TestFixture]
public class OrderTestsNUnit
{
    private OrderService _sut;
    [SetUp] public void Setup() => _sut = new OrderService();
    [TearDown] public void Teardown() { }
    [Test] public void Test() { Assert.Pass(); }
    [TestCase(1, 100.0)] public void Parameterized(int qty, double expected) { }
}
```

## ❓ Follow-Up Questions
- **Q: Why does xUnit not have [SetUp]?** A: To force proper isolation — a new class instance per test means each test has a clean state by design, not by hoping [SetUp] ran correctly.
- **Q: Can you mix frameworks in one solution?** A: Yes — different projects can use different frameworks. The test runner (dotnet test) handles all.
- **Q: Which framework does Microsoft use?** A: xUnit — ASP.NET Core, EF Core, and .NET BCL tests use xUnit.

## ⚠️ Common Mistakes
❌ Sharing mutable state between tests via static fields or class-level setup.
✅ xUnit creates a new instance per test — use constructor injection to ensure isolation. Static state breaks parallelism.

## 🎯 Cheat Sheet
- **xUnit:** [Fact], [Theory], constructor setup, IDisposable teardown, parallel by default
- **NUnit:** [Test], [SetUp], [TearDown], [TestFixture]
- **MSTest:** [TestMethod], [TestInitialize], [TestCleanup], [TestClass]
- **Recommendation:** xUnit for new projects

## 🏢 Industry Experience Answer
"All new projects use xUnit. The constructor-setup pattern forces us to think about what each test truly needs — no hidden shared state. [Theory] with [InlineData] or [MemberData] is extremely powerful for parameterized edge-case coverage. The parallel-by-default behavior means our 800-test suite runs in 6 seconds instead of 40."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Differences between xUnit, NUnit, and MSTest?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q4
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
TDD (Test-Driven Development) is a development methodology where you **write the test first, then write the minimum code to make it pass, then refactor**. The cycle: Red (failing test) → Green (minimal code to pass) → Refactor (improve without breaking). TDD drives design — testable code is inherently loosely coupled. The test suite is a safety net for every future refactoring.

## 📖 Detailed Explanation
**The Red-Green-Refactor cycle:**
1. **Red:** write a failing test for the next behavior you want to add. It fails because the code doesn't exist yet.
2. **Green:** write the simplest possible code to make the test pass. No over-engineering.
3. **Refactor:** clean up the implementation and test while keeping all tests green.

**Benefits:**
- Design emerges from what's testable — naturally loose coupling, small classes.
- 100% coverage of the behaviors you write.
- Confidence to refactor — if tests pass, nothing broke.
- Tests document the intended behavior precisely.

**Challenges:** TDD takes practice; it's slow initially; not suitable for spike/prototype code or UI-heavy work.

## 💻 Code Example
```csharp
// Step 1: RED — write failing test first
[Fact]
public void Withdraw_InsufficientFunds_ThrowsException()
{
    var account = new BankAccount(100m);
    Assert.Throws<InsufficientFundsException>(() => account.Withdraw(150m));
}
// Compile error — BankAccount doesn't exist yet. GOOD. Now write the code.

// Step 2: GREEN — minimal implementation
public class BankAccount
{
    private decimal _balance;
    public BankAccount(decimal balance) => _balance = balance;

    public void Withdraw(decimal amount)
    {
        if (amount > _balance) throw new InsufficientFundsException();
        _balance -= amount;
    }
}
// Test passes now.

// Step 3: REFACTOR — clean up
public class BankAccount
{
    public decimal Balance { get; private set; }
    public BankAccount(decimal initialBalance) => Balance = initialBalance;

    public void Withdraw(decimal amount)
    {
        if (amount <= 0) throw new ArgumentException("Amount must be positive");
        if (amount > Balance) throw new InsufficientFundsException(Balance, amount);
        Balance -= amount;
    }
}
// All tests still pass after refactor. Add more tests for new behaviors.
```

## ❓ Follow-Up Questions
- **Q: TDD vs BDD?** A: TDD focuses on unit behavior from a developer perspective. BDD (Behavior-Driven Development) uses business-language scenarios (Given/When/Then) to drive tests — bridges dev and stakeholder.
- **Q: Is TDD always worth it?** A: For core business logic — yes. For exploratory code, UI prototypes, or infrastructure — sometimes not. Apply pragmatically.
- **Q: How does TDD improve design?** A: Code that's hard to test usually has poor design (too many dependencies, too much responsibility). TDD forces you to notice and fix this immediately.

## ⚠️ Common Mistakes
❌ Writing all tests after the code is finished ("TDD" as an afterthought).
✅ True TDD = tests before code. Tests written after don't influence the design — the main benefit is lost.

## 🎯 Cheat Sheet
- **Cycle:** Red → Green → Refactor
- **Red:** write failing test (behavior you want)
- **Green:** minimal code to pass
- **Refactor:** improve without breaking tests
- **Keywords:** red-green-refactor, design influence, safety net, testable design

## 🏢 Industry Experience Answer
"TDD changed how I think about code. I now define what a class should DO before I write it — the test is the specification. The design is cleaner: classes are small, dependencies are explicit, and every edge case is documented in a test. The refactoring confidence is invaluable — I've done large refactors in TDD code knowing the tests would catch any regression."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Test Driven Development (TDD)?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q5
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Integration testing verifies that **multiple components work correctly together** — controllers, services, repositories, and the real database. Unlike unit tests, integration tests use real (or near-real) dependencies. In ASP.NET Core, `WebApplicationFactory` spins up the full application in-process for end-to-end HTTP-level testing without a running server.

## 📖 Detailed Explanation
**What integration tests cover:** HTTP → controller → service → repository → real DB → response. Tests the wiring between layers, SQL queries, middleware, auth, and serialization — things unit tests can't catch.
**Scope:** slower than unit tests (DB involved), but fewer are needed. The test pyramid: many unit, some integration, few E2E.
**Database strategies:** use a real test DB (PostgreSQL/SQLite), reset between tests. Testcontainers library spins up a real Docker DB for each test run.
**Test isolation:** wrap each test in a transaction and roll back; or use a fresh DB per test run; or delete/reseed between tests.

## 💻 Code Example
```csharp
// WebApplicationFactory integration test
public class OrdersApiTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public OrdersApiTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureServices(services =>
            {
                // Replace real DB with SQLite in-memory for tests
                var descriptor = services.Single(d => d.ServiceType == typeof(DbContextOptions<AppDbContext>));
                services.Remove(descriptor);
                services.AddDbContext<AppDbContext>(o => o.UseInMemoryDatabase("TestDb"));

                // Seed test data
                var sp = services.BuildServiceProvider();
                using var scope = sp.CreateScope();
                var ctx = scope.ServiceProvider.GetRequiredService<AppDbContext>();
                ctx.Orders.Add(new Order { Id = 1, CustomerId = "C1", Total = 99m });
                ctx.SaveChanges();
            });
        }).CreateClient();
    }

    [Fact]
    public async Task GetOrder_ExistingId_ReturnsOrder()
    {
        var response = await _client.GetAsync("/api/orders/1");
        response.EnsureSuccessStatusCode();
        var order = await response.Content.ReadFromJsonAsync<OrderDto>();
        Assert.Equal(1, order!.Id);
        Assert.Equal(99m, order.Total);
    }

    [Fact]
    public async Task CreateOrder_ValidRequest_Returns201()
    {
        var request = new CreateOrderRequest { CustomerId = "C2", Total = 50m };
        var response = await _client.PostAsJsonAsync("/api/orders", request);
        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
    }
}
```

## ❓ Follow-Up Questions
- **Q: Unit vs integration tests — which to have more of?** A: Many unit (fast), some integration (moderate), few E2E (slow). The test pyramid.
- **Q: What are Testcontainers?** A: A .NET library that spins up real Docker containers (PostgreSQL, Redis) for tests — your integration tests use the same DB engine as production.
- **Q: How do you isolate integration test data?** A: Transaction rollback per test, per-test DB seeding, or dedicated test database reset between runs.

## ⚠️ Common Mistakes
❌ Using InMemoryDatabase for integration tests.
✅ InMemoryDatabase doesn't support SQL, constraints, or transactions. Use a real PostgreSQL/SQL Server (via Testcontainers) or at minimum SQLite for closer-to-production behavior.

## 🎯 Cheat Sheet
- **Integration test:** multiple real components, real DB, HTTP to response
- **WebApplicationFactory:** in-process ASP.NET Core for HTTP tests
- **Testcontainers:** real Docker DB for tests
- **Keywords:** test pyramid, WebApplicationFactory, HttpClient, Testcontainers, seeding

## 🏢 Industry Experience Answer
"Our integration test suite uses WebApplicationFactory with Testcontainers spinning up a real PostgreSQL container per test run. Tests cover auth middleware, model validation, DB constraints, and JSON serialization — things unit tests can't catch. We run them in CI after unit tests. The test DB is reset before each run; individual tests wrap in transaction rollback for isolation."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is integration testing?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q6
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Dependency injection in testing means **injecting test doubles (mocks, fakes, stubs) instead of real implementations** via the class constructor — the same DI mechanism used in production. Because your code depends on interfaces (DIP), tests substitute implementations without modifying the code under test. This is why interface-based DI is fundamental to testability.

## 📖 Detailed Explanation
**Why it works:** the class under test depends on `IEmailService`, not `SmtpEmailService`. In tests you pass `new Mock<IEmailService>().Object`. In production the container injects `SmtpEmailService`. The class never knows which it has.
**Without DI:** `new SmtpEmailService()` inside the class — untestable without sending real emails.
**ASP.NET Core DI in integration tests:** `WebApplicationFactory` lets you replace real registrations with test fakes via `ConfigureServices`.
**Benefit:** tests run without external dependencies — fast, reliable, no side effects.

## 💻 Code Example
```csharp
// Production code — depends on interface (testable)
public class NotificationService
{
    private readonly IEmailService _email;
    private readonly ISmsService _sms;

    public NotificationService(IEmailService email, ISmsService sms)
        => (_email, _sms) = (email, sms);   // injected — can be mocked

    public async Task NotifyAsync(string userId, string message)
    {
        await _email.SendAsync(userId + "@example.com", "Alert", message);
        await _sms.SendAsync(userId, message);
    }
}

// Test — inject mocks via constructor
public class NotificationServiceTests
{
    [Fact]
    public async Task NotifyAsync_SendsBothEmailAndSms()
    {
        // Inject mock implementations — no real email or SMS sent
        var mockEmail = new Mock<IEmailService>();
        var mockSms = new Mock<ISmsService>();
        mockEmail.Setup(e => e.SendAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
            .Returns(Task.CompletedTask);
        mockSms.Setup(s => s.SendAsync(It.IsAny<string>(), It.IsAny<string>()))
            .Returns(Task.CompletedTask);

        var sut = new NotificationService(mockEmail.Object, mockSms.Object);

        await sut.NotifyAsync("user123", "Order placed");

        mockEmail.Verify(e => e.SendAsync(It.IsAny<string>(), "Alert", "Order placed"), Times.Once);
        mockSms.Verify(s => s.SendAsync("user123", "Order placed"), Times.Once);
    }
}

// Integration test — replace in DI container
factory.WithWebHostBuilder(b => b.ConfigureServices(services =>
{
    services.AddScoped<IEmailService, FakeEmailService>();   // replace with fake
}));
```

## ❓ Follow-Up Questions
- **Q: Why does DI enable testability?** A: The class doesn't create its own dependencies — they're provided externally. Externally provided = externally replaceable = mockable in tests.
- **Q: Fake vs Mock in DI?** A: Fake = a working lightweight implementation (in-memory DB, in-memory email queue). Mock = Moq-generated substitute. Fakes are often better for integration tests.
- **Q: Service locator anti-pattern in tests?** A: Resolving services from IServiceProvider inside tests is fragile. Prefer constructor injection for clarity.

## ⚠️ Common Mistakes
❌ Creating concrete dependencies inside classes with `new` — cannot be mocked.
✅ Always depend on interfaces via constructor injection. This is the single most important enabler of unit testability.

## 🎯 Cheat Sheet
- **DI for testing:** inject mocks/fakes in constructor; same interface, different implementation
- **Unit tests:** inject Moq mocks directly
- **Integration tests:** replace registrations in WebApplicationFactory.ConfigureServices
- **Keywords:** interface, constructor injection, mock, fake, testability

## 🏢 Industry Experience Answer
"When I review a PR and see new HttpClient() or new SqlConnection() inside a service constructor, I know those methods are untestable. The fix is always the same: extract an interface, inject it. This single discipline — DI everywhere — is why we can unit test 90% of our business logic without touching a DB or sending a real email."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is dependency injection in testing?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q7
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Moq is the most popular .NET mocking library. It uses lambda expressions to configure behavior (Setup) and verify interactions (Verify) on mock objects generated from interfaces or abstract classes. Key methods: `Setup` (configure return values), `Returns`/`ReturnsAsync` (what to return), `Throws` (simulate exceptions), `Verify` (assert calls happened), `It.IsAny/Is` (argument matchers).

## 📖 Detailed Explanation
**Creating a mock:** `var mock = new Mock<IService>()`. Access the mock object via `mock.Object`.
**Setup:** `mock.Setup(s => s.Method(args)).Returns(value)` — configures what the method returns.
**Async:** `mock.Setup(s => s.MethodAsync()).ReturnsAsync(value)`.
**Callback:** `mock.Setup(s => s.Method(It.IsAny<string>())).Callback<string>(arg => /* side effect */)`.
**Verify:** `mock.Verify(s => s.Method("specific"), Times.Once)` — asserts the method was called.
**Strict mocks:** `new Mock<IService>(MockBehavior.Strict)` — any unexpected call throws. Loose (default) returns defaults for unconfigured calls.

## 💻 Code Example
```csharp
public class PaymentServiceTests
{
    [Fact]
    public async Task ProcessPayment_Success_UpdatesOrderStatus()
    {
        // Arrange
        var mockPayment = new Mock<IPaymentGateway>();
        var mockOrders = new Mock<IOrderRepository>();
        var order = new Order { Id = 1, Status = "Pending", Total = 99.99m };

        mockOrders.Setup(r => r.GetByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(order);

        mockPayment.Setup(p => p.ChargeAsync(99.99m, "card_token"))
            .ReturnsAsync(new PaymentResult { Success = true, TransactionId = "txn_123" });

        var sut = new PaymentService(mockPayment.Object, mockOrders.Object);

        // Act
        await sut.ProcessAsync(orderId: 1, cardToken: "card_token", CancellationToken.None);

        // Assert — verify interactions
        mockPayment.Verify(p => p.ChargeAsync(99.99m, "card_token"), Times.Once);
        Assert.Equal("Paid", order.Status);
    }

    [Fact]
    public async Task ProcessPayment_GatewayFails_ThrowsException()
    {
        var mockPayment = new Mock<IPaymentGateway>();
        var mockOrders = new Mock<IOrderRepository>();

        mockOrders.Setup(r => r.GetByIdAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(new Order { Id = 1, Total = 50m });

        mockPayment.Setup(p => p.ChargeAsync(It.IsAny<decimal>(), It.IsAny<string>()))
            .ThrowsAsync(new PaymentGatewayException("Card declined"));

        var sut = new PaymentService(mockPayment.Object, mockOrders.Object);

        await Assert.ThrowsAsync<PaymentGatewayException>(
            () => sut.ProcessAsync(1, "bad_token", CancellationToken.None));
    }
}
```

## ❓ Follow-Up Questions
- **Q: MockBehavior.Strict vs Loose?** A: Strict throws on any unconfigured call — makes missed setups visible. Loose returns defaults — more forgiving. Use Strict for critical dependencies.
- **Q: Moq vs NSubstitute vs FakeItEasy?** A: All popular. Moq is lambda-based; NSubstitute uses extension methods; FakeItEasy has fluent API. Moq is the most commonly used.
- **Q: Can you mock concrete classes?** A: Only if the method is virtual. Moq generates a proxy subclass. Avoid — prefer mocking interfaces.

## ⚠️ Common Mistakes
❌ Forgetting `mock.Object` when passing to the constructor — passing the mock wrapper instead.
✅ Always pass `mock.Object` (the generated proxy) to your class constructor, not `mock` itself.

## 🎯 Cheat Sheet
- **Setup + Returns/ReturnsAsync:** configure method behavior
- **Throws/ThrowsAsync:** simulate exceptions
- **Verify + Times:** assert call count and arguments
- **It.IsAny<T>():** match any argument; It.Is<T>(pred): match by condition
- **Keywords:** Mock<T>, mock.Object, Callback, MockBehavior, NSubstitute

## 🏢 Industry Experience Answer
"Moq is our standard. One pattern we follow: never mix Setup and Verify for the same method in the same test — setup in Arrange, verify in Assert. It.Is<T> with a predicate is underused — powerful for verifying complex object arguments without overspecifying. And MockBehavior.Strict on payment/external API mocks catches missed setups immediately."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Moq and how do you use it to mock interfaces?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q8
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
FluentAssertions is a .NET assertion library that replaces terse Assert.Equal() calls with **readable, English-like assertion chains**: `result.Should().Be(42)`, `list.Should().HaveCount(3).And.Contain(item)`. It produces significantly better failure messages (shows expected vs actual with context) and supports rich assertions on collections, exceptions, dates, objects, and async operations.

## 📖 Detailed Explanation
**Why better messages:** standard Assert.Equal(expected, actual) on failure says "Expected: 42 but was: 0." FluentAssertions says "Expected result to be 42 because the discount should be applied, but found 0." — the because() clause explains intent.
**Rich assertions:** .BeEquivalentTo() for object graph comparison, .ContainEquivalentOf(), .Throw<T>(), .BeInAscendingOrder(), .OnlyContain(), .BeNullOrEmpty(), .HaveCountGreaterThan().
**Object equivalence:** Assert.Equal() uses reference equality for objects. .BeEquivalentTo() compares by property values — no need to override Equals for test purposes.
**Install:** FluentAssertions NuGet package.

## 💻 Code Example
```csharp
// Standard assertions (hard to read on failure)
Assert.Equal("Shipped", order.Status);
Assert.Equal(3, items.Count);
Assert.Contains(item, items);

// FluentAssertions — readable and richer failure messages
using FluentAssertions;

order.Status.Should().Be("Shipped");
order.Total.Should().BeGreaterThan(0).And.BeLessThan(10_000);
order.Items.Should().HaveCount(3).And.Contain(i => i.ProductId == 42);

// Object graph comparison (no need for Equals override)
var expected = new OrderDto { Id = 1, Status = "Placed", Total = 99m };
result.Should().BeEquivalentTo(expected,
    options => options.Excluding(o => o.CreatedAt));   // ignore timestamp

// Exception assertion
Action act = () => calculator.Divide(10, 0);
act.Should().Throw<DivideByZeroException>()
    .WithMessage("Cannot divide by zero");

// Async exception
Func<Task> asyncAct = async () => await service.ProcessAsync(invalidId);
await asyncAct.Should().ThrowAsync<NotFoundException>()
    .WithMessage("*not found*");   // * = wildcard

// With because() for failure context
result.Should().NotBeNull(because: "a valid order ID should always return a result");
```

## ❓ Follow-Up Questions
- **Q: Should.BeEquivalentTo vs Assert.Equal?** A: BeEquivalentTo recursively compares all properties; Assert.Equal uses Equals() which for complex types defaults to reference equality — almost never what you want.
- **Q: Does FluentAssertions work with all test frameworks?** A: Yes — xUnit, NUnit, MSTest. It's test-framework-agnostic.
- **Q: What is the because clause?** A: An optional reason string added to the failure message — documents WHY the assertion should hold.

## ⚠️ Common Mistakes
❌ Using Assert.Equal(expectedObject, actualObject) for complex DTOs without Equals override.
✅ Use FluentAssertions .BeEquivalentTo() — compares all properties recursively without any Equals implementation needed.

## 🎯 Cheat Sheet
- **Should().Be():** equality, much better failure message than Assert.Equal
- **BeEquivalentTo():** recursive property comparison
- **Should().Throw<T>():** exception assertion with message check
- **because():** adds context to failure messages
- **Keywords:** readable assertions, failure messages, BeEquivalentTo, Excluding

## 🏢 Industry Experience Answer
"FluentAssertions replaced all our xUnit assertions. The best feature: BeEquivalentTo for API response verification — one line compares the entire response object graph, field by field, with clear failure messages showing exactly which property differs. The because() clause makes test failures self-explanatory — you read the failure message and immediately understand the intent."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is FluentAssertions and how does it improve test readability?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q9
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Arrange-Act-Assert (AAA) is the standard pattern for structuring unit tests: **Arrange** sets up the test data and dependencies; **Act** calls the method under test (single call); **Assert** verifies the outcome. Clear separation of these three sections makes tests readable, maintainable, and reveals the test's intent at a glance.

## 📖 Detailed Explanation
**Arrange:** create the system under test, configure mocks, prepare input data, set up initial state.
**Act:** the single line that exercises the behavior under test. One action per test — multiple actions indicate testing multiple behaviors.
**Assert:** verify the expected outcome. Checks return value, state changes, or mock interactions. Multiple assertions per test are fine if they all verify one logical outcome.
**Why one Act:** a test with multiple Act steps is testing multiple behaviors — split it. If the test fails, you can't tell which Act caused the failure.
**Comments:** explicitly label // Arrange // Act // Assert with blank lines — makes the structure visible even for complex tests.

## 💻 Code Example
```csharp
public class DiscountServiceTests
{
    [Fact]
    public void ApplyDiscount_PremiumCustomer_Gets20PercentOff()
    {
        // Arrange
        var mockCustomerRepo = new Mock<ICustomerRepository>();
        mockCustomerRepo.Setup(r => r.GetByIdAsync("C1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new Customer { Id = "C1", Tier = CustomerTier.Premium });

        var sut = new DiscountService(mockCustomerRepo.Object);
        var order = new Order { CustomerId = "C1", Total = 100m };

        // Act
        var discountedTotal = sut.ApplyDiscount(order);

        // Assert
        discountedTotal.Should().Be(80m);
    }

    [Fact]
    public void ApplyDiscount_StandardCustomer_Gets0PercentOff()
    {
        // Arrange
        var mockCustomerRepo = new Mock<ICustomerRepository>();
        mockCustomerRepo.Setup(r => r.GetByIdAsync("C2", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new Customer { Id = "C2", Tier = CustomerTier.Standard });

        var sut = new DiscountService(mockCustomerRepo.Object);
        var order = new Order { CustomerId = "C2", Total = 100m };

        // Act
        var discountedTotal = sut.ApplyDiscount(order);

        // Assert
        discountedTotal.Should().Be(100m);
    }
}
```

## ❓ Follow-Up Questions
- **Q: What if Assert is complex — is that a problem?** A: Multiple assertions for one logical outcome are fine. Multiple logical outcomes in one test = split the test.
- **Q: AAA vs Given-When-Then?** A: Same concept, different names. Given = Arrange, When = Act, Then = Assert. GWT is used in BDD-style tests.
- **Q: What is a test smell?** A: AAA violations: missing Arrange, multiple Acts, assertions before Act, no Assert. These indicate poorly structured or unclear tests.

## ⚠️ Common Mistakes
❌ Multiple Act calls in one test method.
✅ One Act per test. If you need to verify behavior in multiple scenarios, write multiple tests — they have separate names and separate failure messages.

## 🎯 Cheat Sheet
- **Arrange:** setup — mocks, data, SUT creation
- **Act:** single method call under test
- **Assert:** verify outcome — return value, state, interactions
- **One Act = one behavior = one test name**
- **Keywords:** AAA, Given-When-Then, test structure, single behavior

## 🏢 Industry Experience Answer
"AAA is enforced in our code review checklist. Tests without clear sections are hard to understand and maintain. We name tests 'Method_Scenario_Expected' so the test method name IS the documentation. Combined with FluentAssertions' because() clause, a failing test tells you exactly what broke, what was expected, and why it mattered."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is the Arrange-Act-Assert (AAA) pattern in unit testing?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q10
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Test doubles are objects that stand in for real dependencies in tests. **Stub:** returns preset values, no verification. **Mock:** verifiable stub — can verify it was called. **Fake:** a working lightweight alternative (in-memory DB, in-memory email queue). **Spy:** records interactions for later verification (a mock variant). These distinctions come from Gerard Meszaros' xUnit Test Patterns.

## 📖 Detailed Explanation
**Stub:** a simple test double that returns hardcoded/preset values. No behavioral verification. Example: a stub repository that always returns the same Order object.
**Mock:** a test double that also records interactions and allows you to verify them. "Was SendEmail called with these arguments?" Moq creates mocks.
**Fake:** a real, working lightweight implementation used for testing. Examples: in-memory database (EF Core InMemory), in-memory message queue, FakeEmailService that stores emails in a List<T> instead of sending.
**Spy:** a test double that records calls for later verification (used in some frameworks as the "assert after act" pattern rather than "setup before act"). Moq's VerifyAll() after the fact.
**Dummy:** an object passed as an argument but never actually used (just to satisfy the parameter requirement).

## 💻 Code Example
```csharp
// STUB — returns preset value, no verification
public class StubOrderRepository : IOrderRepository
{
    public Task<Order?> GetByIdAsync(int id, CancellationToken ct) =>
        Task.FromResult<Order?>(new Order { Id = id, Total = 99m });
    public void Add(Order o) { }
}

// FAKE — real working implementation (not production-grade)
public class FakeEmailService : IEmailService
{
    public List<(string To, string Subject)> SentEmails { get; } = new();

    public Task SendAsync(string to, string subject, string body)
    {
        SentEmails.Add((to, subject));   // records instead of sending
        return Task.CompletedTask;
    }
}

// MOCK (Moq) — configurable + verifiable
var mock = new Mock<IEmailService>();
mock.Setup(e => e.SendAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
    .Returns(Task.CompletedTask);
// ... act ...
mock.Verify(e => e.SendAsync("user@example.com", It.IsAny<string>(), It.IsAny<string>()), Times.Once);

// SPY pattern with Fake
var fakeEmail = new FakeEmailService();
var sut = new RegistrationService(fakeEmail);
await sut.RegisterAsync("user@example.com", "Sidhant");
Assert.Single(fakeEmail.SentEmails);
Assert.Equal("user@example.com", fakeEmail.SentEmails[0].To);
```

## ❓ Follow-Up Questions
- **Q: When prefer Fake over Mock?** A: Fakes for integration tests (in-memory DB); Mocks for unit tests verifying specific interactions. Fakes require more code but are more realistic.
- **Q: Is Moq a Mock or Stub?** A: Both — Moq can be used as a stub (Setup without Verify) or a mock (Setup + Verify). The terms describe usage, not the tool.
- **Q: Dummy vs null?** A: Dummy and null both work when the argument is unused, but Dummy is explicitly a placeholder, making intent clear.

## ⚠️ Common Mistakes
❌ Overusing Moq mocks when a simple Fake (in-memory list) would be clearer.
✅ For integration tests and scenarios where you check what was "sent" or "stored," a Fake with inspection is more readable than a Mock with Verify.

## 🎯 Cheat Sheet
- **Stub:** returns preset values, no verification
- **Mock:** stub + verification of interactions
- **Fake:** real lightweight working implementation
- **Spy:** records calls for later assertion
- **Dummy:** placeholder, not used in the test
- **Keywords:** test double, Moq, FakeEmailService, in-memory, xUnit Test Patterns

## 🏢 Industry Experience Answer
"We use all four. Moq for most unit test mocking where we need to verify calls. Fakes for the email service (FakeEmailService stores in a List — easy to inspect in assert) and for the in-memory event bus. Stubs for repositories in read-heavy unit tests where we just need consistent data. The right double depends on what the test is verifying."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between a stub, mock, fake, and spy?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q11
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Code coverage measures what **percentage of production code is executed by your test suite**. It's a useful metric but not a goal in itself — 100% coverage can coexist with bad tests. A practical target: **80% for business logic**, focusing on meaningful coverage of behaviors and edge cases rather than chasing a number. Quality of tests matters more than quantity.

## 📖 Detailed Explanation
**Types of coverage:**
- **Line coverage:** % of lines executed. Easiest to game.
- **Branch coverage:** % of true/false conditions evaluated. More meaningful.
- **Method coverage:** % of methods called.
- **Path coverage:** all combinations of branches — theoretically complete but impractical.

**Tools:** `dotnet-coverage`, Coverlet (free, integrates with CI), ReportGenerator (HTML reports), Visual Studio Coverage.
**Why not 100%:** trivial getters/setters, generated code, unreachable defensive code. Chasing 100% leads to tests without assertions ("test theater").
**Better metric:** mutation testing (Stryker.NET) — makes small changes to production code and checks if tests fail. Reveals tests that execute code but don't actually verify behavior.

## 💻 Code Example
```csharp
// Add Coverlet to test project
// dotnet add package coverlet.msbuild

// Run with coverage
// dotnet test --collect:"XPlat Code Coverage"
// dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover

// Generate HTML report
// dotnet tool install -g dotnet-reportgenerator-globaltool
// reportgenerator -reports:"coverage.xml" -targetdir:"coveragereport" -reporttypes:Html

// What you see:
// OrderService.cs: 94% (30/32 lines covered)
// OrderController.cs: 88% (22/25 lines covered)
// Missing: error handling branches, edge cases

// Stryker.NET — mutation testing
// dotnet stryker  (makes 100+ mutations, checks if tests catch them)
// Mutation score: 78% (78 of 100 mutations killed by tests)
// Reveals: tests that execute but don't assert on outcomes
```

## ❓ Follow-Up Questions
- **Q: What is a reasonable coverage target?** A: 80% for business-critical code; 60-70% for the whole codebase is common in production. Domain + service layers should be higher; infrastructure/generated code lower.
- **Q: What is mutation testing?** A: A tool (Stryker.NET) that modifies your production code (flips conditions, changes values) and runs your tests. If tests don't fail, they're not actually testing that code.
- **Q: Is untested code always bad?** A: Not always — main(), generated code, simple DTOs, framework wrappers. Focus testing effort on business logic.

## ⚠️ Common Mistakes
❌ Treating 80% (or any number) as the definition of a well-tested codebase.
✅ Coverage shows what's executed, not what's verified. A test that calls every line but asserts nothing has 100% coverage and zero value. Combine coverage with mutation testing.

## 🎯 Cheat Sheet
- **Line coverage:** % of lines executed
- **Branch coverage:** % of true/false paths — more meaningful
- **Target:** ~80% for business logic, quality > quantity
- **Coverlet:** free .NET coverage tool; ReportGenerator for HTML
- **Mutation testing:** Stryker.NET — tests for quality of tests
- **Keywords:** Coverlet, Stryker, branch coverage, mutation score

## 🏢 Industry Experience Answer
"We enforce 80% branch coverage in CI as a gate for the Domain and Application projects. Infrastructure and Controllers have lower thresholds. But the real quality signal is Stryker mutation testing — it revealed dozens of tests that covered lines but didn't assert on the critical outcome. After Stryker, our mutation score went from 58% to 82%. Coverage tells you what runs; Stryker tells you what tests."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is code coverage and what percentage should you target?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q12
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A test fixture is the **fixed set of preconditions** shared across a group of tests. In xUnit, shared setup is provided via **constructor** (per-test — fresh instance), **IClassFixture<T>** (once per test class — shared across all tests in the class), and **ICollectionFixture<T>** (once per collection — shared across multiple test classes). Use fixtures for expensive one-time setup like DB connections.

## 📖 Detailed Explanation
**Constructor (per-test):** xUnit creates a new class instance per test — constructor setup runs fresh every test. Best for cheap, isolated setup.
**IClassFixture<T>:** creates T once for the test class, injects it into the constructor. Shared across all tests in the class. Useful for: expensive setup (DB connection, web factory). The fixture is created once, tests may run in parallel — T must be thread-safe for parallel tests.
**ICollectionFixture<T>:** shares a fixture across multiple test classes via [Collection] attribute. Same instance shared — all tests in the collection share the fixture.
**Lifetime order:** ICollectionFixture > IClassFixture > Constructor (fresh each test).

## 💻 Code Example
```csharp
// 1. Fixture class — expensive setup done once
public class DatabaseFixture : IDisposable
{
    public AppDbContext DbContext { get; }

    public DatabaseFixture()
    {
        // Expensive: start DB, run migrations
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseNpgsql("Host=localhost;Database=testdb")
            .Options;
        DbContext = new AppDbContext(options);
        DbContext.Database.EnsureCreated();
        SeedTestData(DbContext);
    }

    public void Dispose() => DbContext.Dispose();
}

// 2. IClassFixture — shared within one test class
public class OrderRepositoryTests : IClassFixture<DatabaseFixture>
{
    private readonly AppDbContext _ctx;

    public OrderRepositoryTests(DatabaseFixture fixture)
        => _ctx = fixture.DbContext;   // shared, don't dispose here!

    [Fact]
    public async Task GetByIdAsync_ExistingOrder_ReturnsOrder()
    {
        var repo = new EfOrderRepository(_ctx);
        var order = await repo.GetByIdAsync(1, CancellationToken.None);
        order.Should().NotBeNull();
    }
}

// 3. ICollectionFixture — share across multiple classes
[CollectionDefinition("DatabaseCollection")]
public class DatabaseCollection : ICollectionFixture<DatabaseFixture> { }

[Collection("DatabaseCollection")]
public class CustomerRepositoryTests
{
    private readonly DatabaseFixture _fixture;
    public CustomerRepositoryTests(DatabaseFixture fixture) => _fixture = fixture;
}
```

## ❓ Follow-Up Questions
- **Q: Constructor vs IClassFixture — when to use each?** A: Constructor for cheap isolated per-test setup; IClassFixture for expensive shared resources (DB, web factory).
- **Q: Is IClassFixture safe for parallel tests?** A: Yes — but the shared fixture's data must be thread-safe. Don't mutate shared state in parallel tests.
- **Q: How does WebApplicationFactory integrate?** A: `public class ApiTests : IClassFixture<WebApplicationFactory<Program>>` — creates the factory once, all tests share it.

## ⚠️ Common Mistakes
❌ Disposing the shared fixture inside a test class using IClassFixture.
✅ xUnit manages the fixture lifecycle — it calls Dispose on the fixture after all tests in the class complete. Don't dispose manually.

## 🎯 Cheat Sheet
- **Constructor:** fresh per test — best for cheap isolated setup
- **IClassFixture<T>:** shared within class — expensive resources
- **ICollectionFixture<T>:** shared across classes — via [Collection]
- **Keywords:** test fixture, IClassFixture, shared state, test lifecycle, parallel

## 🏢 Industry Experience Answer
"IClassFixture with WebApplicationFactory is how we run integration tests efficiently. The factory starts the full ASP.NET Core app once; all tests in the class share it — startup time paid once, not per test. For the DB fixture, we use ICollectionFixture to share a Testcontainers PostgreSQL instance across all repository test classes in the suite."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is a test fixture and how do you share setup across tests in xUnit?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q13
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
`WebApplicationFactory<TEntryPoint>` spins up your **entire ASP.NET Core application in-process** for testing, creating a real `HttpClient` that sends HTTP requests through the full middleware pipeline. You can replace DI registrations, override configuration, and test auth, routing, model binding, and serialization end-to-end without a running server.

## 📖 Detailed Explanation
**How it works:** WebApplicationFactory uses the same `Program.cs` as production but runs in-process using a TestServer. `CreateClient()` returns an HttpClient that routes through the in-process server.
**Customization:** `.WithWebHostBuilder(b => b.ConfigureServices(services => { /* replace registrations */ }))` — swap real services with fakes/in-memory alternatives.
**Auth in tests:** either bypass auth with `AllowAnonymous()` in test builder, or generate a real JWT and include in request headers.
**Database:** replace with SQLite in-memory or Testcontainers PostgreSQL for real DB behavior.
**Inheriting and customizing:** create a custom `CustomWebApplicationFactory<T>` with your standard test setup — reuse across many test classes.

## 💻 Code Example
```csharp
// Custom factory with common test overrides
public class TestApiFactory : WebApplicationFactory<Program>
{
    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.ConfigureServices(services =>
        {
            // Replace real DB with Testcontainers PostgreSQL
            var desc = services.Single(d => d.ServiceType == typeof(DbContextOptions<AppDbContext>));
            services.Remove(desc);
            services.AddDbContext<AppDbContext>(o =>
                o.UseNpgsql(TestDatabase.ConnectionString));

            // Replace real email with fake
            services.AddScoped<IEmailService, FakeEmailService>();
        });

        builder.UseEnvironment("Testing");
    }
}

// Test class
public class OrdersEndpointTests : IClassFixture<TestApiFactory>
{
    private readonly HttpClient _client;
    private readonly TestApiFactory _factory;

    public OrdersEndpointTests(TestApiFactory factory)
    {
        _factory = factory;
        _client = factory.CreateClient();

        // Add auth header (test JWT)
        _client.DefaultRequestHeaders.Authorization =
            new AuthenticationHeaderValue("Bearer", TestTokenGenerator.Generate("user1", "Admin"));
    }

    [Fact]
    public async Task POST_Orders_ValidRequest_Returns201()
    {
        var request = new { CustomerId = "C1", Total = 99.99 };
        var response = await _client.PostAsJsonAsync("/api/orders", request);
        response.StatusCode.Should().Be(HttpStatusCode.Created);
        var dto = await response.Content.ReadFromJsonAsync<OrderDto>();
        dto!.Total.Should().Be(99.99m);
    }

    [Fact]
    public async Task GET_Orders_Unauthorized_Returns401()
    {
        var unauthClient = _factory.CreateClient();  // no auth header
        var response = await unauthClient.GetAsync("/api/orders");
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }
}
```

## ❓ Follow-Up Questions
- **Q: WebApplicationFactory vs actual deployed server testing?** A: Factory = in-process, fast, no network. Deployed testing = real network, real environment, slower. Factory for CI; deployed for smoke tests.
- **Q: How do you test authenticated endpoints?** A: Generate a real JWT using your token generation logic, or configure test auth scheme with `AddAuthentication("Test").AddScheme<TestAuthHandlerOptions, TestAuthHandler>()`.
- **Q: How do you access DI services in tests?** A: `factory.Services.GetRequiredService<T>()` from a created scope — useful for seeding data or inspecting state.

## ⚠️ Common Mistakes
❌ Creating a new WebApplicationFactory per test method.
✅ Use IClassFixture<WebApplicationFactory<Program>> — the factory is expensive to create. Share it across all tests in the class.

## 🎯 Cheat Sheet
- **WebApplicationFactory:** in-process full app for HTTP integration tests
- **ConfigureServices:** swap real deps with fakes
- **IClassFixture:** share factory — create once per class
- **Auth testing:** inject test JWT or test auth scheme
- **Keywords:** TestServer, in-process, HttpClient, ConfigureWebHost

## 🏢 Industry Experience Answer
"WebApplicationFactory is the cornerstone of our integration test suite. Our TestApiFactory encapsulates all standard overrides (Testcontainers DB, FakeEmailService, test auth scheme). Each test class uses IClassFixture to get the shared factory. Integration tests verify: auth flows, model validation 400 responses, DB persistence, and API contract shape. They've caught issues unit tests never could."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'How do you test ASP.NET Core Web API endpoints using WebApplicationFactory?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- End of Batch 9 — Testing & Tools COMPLETE (Q1–Q13)

-- ════════════════════════════════════════════════════════════
-- DevReady Seed — Batch 10
-- .NET › 🏗️ Deployment & DevOps › Q1–Q12
-- Dollar-quote safe (zero $ inside content). Idempotent upsert.
-- ════════════════════════════════════════════════════════════

-- Q1
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
ASP.NET Core uses `ASPNETCORE_ENVIRONMENT` to control which environment it's running in. The three standard values: **Development** (detailed errors, developer exception page, User Secrets loaded), **Staging** (production-like for pre-release testing), and **Production** (optimized, minimal error exposure, secrets from env vars/Key Vault). Code and configuration adapt based on `IWebHostEnvironment.EnvironmentName`.

## 📖 Detailed Explanation
**How it's detected:** `Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT")`. Set in OS, Docker, Kubernetes, or Azure App Service configuration.
**What changes by environment:**
- **Development:** UseDeveloperExceptionPage (full stack traces), User Secrets, verbose logging, Swagger UI.
- **Staging:** production-like but with test data; monitoring; no developer exceptions.
- **Production:** HSTS, compressed responses, structured logging to centralized store, secrets from Key Vault.
**Custom environments:** any string — `Testing` for integration tests, `Preview` for beta features.
**In code:** `env.IsDevelopment()`, `env.IsProduction()`, `env.IsEnvironment("Custom")`.

## 💻 Code Example
```csharp
// Program.cs — environment-aware configuration
var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();    // full stack trace in browser
    app.UseSwagger();
    app.UseSwaggerUI();
}
else
{
    app.UseExceptionHandler("/error"); // generic error page in prod
    app.UseHsts();
}

app.UseHttpsRedirection();

// appsettings per environment
// appsettings.json          — base (all environments)
// appsettings.Development.json — dev overrides (verbose logging, dev DB)
// appsettings.Production.json  — prod overrides (warning+ logging)

// Environment variable setup:
// Docker: -e ASPNETCORE_ENVIRONMENT=Production
// Kubernetes:
// env:
//   - name: ASPNETCORE_ENVIRONMENT
//     value: Production

// Access in service
public class FeatureFlagService
{
    private readonly IWebHostEnvironment _env;
    public FeatureFlagService(IWebHostEnvironment env) => _env = env;
    public bool IsNewCheckoutEnabled() =>
        _env.IsProduction() ? false : true;  // roll out gradually
}
```

## ❓ Follow-Up Questions
- **Q: How do you set the environment in Docker?** A: Set the ASPNETCORE_ENVIRONMENT environment variable in docker run or docker-compose: `environment: - ASPNETCORE_ENVIRONMENT=Production`.
- **Q: What if ASPNETCORE_ENVIRONMENT is not set?** A: Defaults to "Production" — the safest default for security.
- **Q: Can you create custom environments?** A: Yes — any string value. Check with `env.IsEnvironment("MyCustomEnv")`.

## ⚠️ Common Mistakes
❌ Leaving development-specific settings (detailed errors, Swagger) enabled in production.
✅ Always gate developer tools behind `if (env.IsDevelopment())`. Default to the secure production configuration.

## 🎯 Cheat Sheet
- **ASPNETCORE_ENVIRONMENT:** Development / Staging / Production (or custom)
- **IsDevelopment():** detailed errors, User Secrets, Swagger
- **IsProduction():** HSTS, Key Vault secrets, minimal error exposure
- **appsettings.{env}.json:** per-environment overrides
- **Keywords:** IWebHostEnvironment, environment variable, UseDeveloperExceptionPage

## 🏢 Industry Experience Answer
"We have four environments: Development (local), Integration (CI integration tests), Staging (pre-release), Production. Each has its own appsettings.{env}.json for non-secret settings and Kubernetes-injected env vars for secrets. The critical rule: Swagger and developer exceptions are only in Development. Production defaulting from unset ASPNETCORE_ENVIRONMENT is a sensible safety net."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are environments in .NET Core (Development, Staging, Production)?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q2
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
ASP.NET Core apps are deployed to **IIS** (Windows, in-process or out-of-process using the ASP.NET Core Module) or to **Docker containers** (Linux or Windows, self-contained or runtime-dependent). Docker is the modern cloud-native approach — consistent across environments, lighter Linux images, easy Kubernetes deployment. IIS is preferred for Windows-only enterprise environments.

## 📖 Detailed Explanation
**IIS deployment:**
- Install ASP.NET Core Module (ANCM) — ships with .NET hosting bundle.
- Application pool: No Managed Code (ANCM handles the runtime).
- In-process: Kestrel inside IIS (fastest, single process).
- Out-of-process: IIS proxies to Kestrel (separate process, more resilient).

**Docker deployment:**
- `dotnet publish -c Release` produces the published app.
- Multi-stage Dockerfile: build stage (SDK image, larger) → runtime stage (aspnet image, smaller).
- Result: a container image you run anywhere Docker is available.

## 💻 Code Example
```csharp
// Multi-stage Dockerfile for ASP.NET Core
// FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
// WORKDIR /src
// COPY ["MyApi/MyApi.csproj", "MyApi/"]
// RUN dotnet restore "MyApi/MyApi.csproj"
// COPY . .
// WORKDIR "/src/MyApi"
// RUN dotnet build "MyApi.csproj" -c Release -o /app/build
//
// FROM build AS publish
// RUN dotnet publish "MyApi.csproj" -c Release -o /app/publish --no-restore
//
// FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
// WORKDIR /app
// EXPOSE 8080
// COPY --from=publish /app/publish .
// ENTRYPOINT ["dotnet", "MyApi.dll"]

// Build and run:
// docker build -t myapi:latest .
// docker run -p 8080:8080 -e ASPNETCORE_ENVIRONMENT=Production myapi:latest

// IIS web.config (auto-generated by publish)
// <?xml version="1.0" encoding="utf-8"?>
// <configuration>
//   <location path="." inheritInChildApplications="false">
//     <system.webServer>
//       <handlers>
//         <add name="aspNetCore" path="*" verb="*" modules="AspNetCoreModuleV2" />
//       </handlers>
//       <aspNetCore processPath="dotnet" arguments=".\MyApi.dll" stdoutLogEnabled="false" />
//     </system.webServer>
//   </location>
// </configuration>
```

## ❓ Follow-Up Questions
- **Q: Self-contained vs framework-dependent deployment?** A: Self-contained includes the .NET runtime in the output (larger, no runtime needed on host). Framework-dependent is smaller but requires .NET installed on the host.
- **Q: Why multi-stage Docker builds?** A: The SDK image (~700MB) is needed for building but not running. The runtime image (~200MB) is sufficient. Multi-stage produces a small final image.
- **Q: What is the .NET Hosting Bundle?** A: Installer that adds the .NET runtime + ASP.NET Core Module to Windows/IIS. Required for IIS deployment.

## ⚠️ Common Mistakes
❌ Deploying using the full SDK image as the Docker base — results in 700MB+ images.
✅ Multi-stage build: build with SDK image, deploy with runtime image (mcr.microsoft.com/dotnet/aspnet) — typically 100-200MB final image.

## 🎯 Cheat Sheet
- **IIS:** Windows, ANCM, in-process/out-of-process, web.config
- **Docker:** multi-stage build, SDK to build, aspnet image to run
- **dotnet publish:** produces deployable output (-c Release)
- **Keywords:** ANCM, multi-stage Dockerfile, aspnet image, Kestrel, self-contained

## 🏢 Industry Experience Answer
"All our new services deploy to Docker on Kubernetes. The multi-stage Dockerfile reduces image size from 800MB to 160MB and makes CI/CD faster. IIS is reserved for our on-premise Windows clients who can't containerize. The standardization on Docker means every service deploys identically regardless of which Linux node it lands on — no environment drift."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'How do you deploy an ASP.NET Core app to IIS or Docker?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q3
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A CI/CD pipeline automates the path from code commit to production: **Continuous Integration (CI)** automatically builds, tests, and validates code on every push. **Continuous Delivery/Deployment (CD)** automatically deploys validated code to staging and production environments. CI/CD eliminates manual deployment risk, ensures every change is tested, and enables multiple releases per day.

## 📖 Detailed Explanation
**CI stages:** trigger on push/PR → checkout code → restore packages → build → run unit tests → run integration tests → code coverage check → static analysis (SonarQube) → security scan → build Docker image → push to registry.
**CD stages:** pull image → deploy to staging → run smoke tests → (manual approval gate for prod) → deploy to production → post-deployment health checks.
**Key principles:** fail fast (tests run before deployment), immutable artifacts (the Docker image built in CI is exactly what goes to prod), infrastructure as code (no manual changes).
**Tools:** GitHub Actions, Azure DevOps, GitLab CI, Jenkins. Each uses YAML pipeline definitions committed alongside code.

## 💻 Code Example
```yaml
# .github/workflows/ci-cd.yml (GitHub Actions)
name: CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup .NET 8
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: '8.0.x'

      - name: Restore
        run: dotnet restore

      - name: Build
        run: dotnet build --no-restore -c Release

      - name: Test with coverage
        run: dotnet test --no-build -c Release --collect:"XPlat Code Coverage"

      - name: Build Docker image
        run: docker build -t myapi:commit-HASH .

      - name: Push to registry
        if: github.ref == 'refs/heads/main'
        run: docker push myregistry.azurecr.io/myapi:commit-HASH

  deploy-staging:
    needs: build-test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to staging
        run: kubectl set image deployment/myapi myapi=myregistry.azurecr.io/myapi:commit-HASH
```

## ❓ Follow-Up Questions
- **Q: CI vs CD?** A: CI = continuous integration (build + test automatically). CD = continuous delivery (deploy automatically to staging) or deployment (deploy to prod automatically).
- **Q: What is a deployment gate?** A: A manual approval or automated check (test pass rate, error rate threshold) before promotion to the next environment.
- **Q: What is a pipeline artifact?** A: The build output (Docker image, ZIP, NuGet package) stored and used through the pipeline — built once, deployed many times.

## ⚠️ Common Mistakes
❌ Running tests only on main branch but not on pull requests.
✅ Tests must run on every PR — CI catches bugs before they're merged. Main branch = already green; PR = the gate.

## 🎯 Cheat Sheet
- **CI:** commit → build → test → package → validate
- **CD:** deploy to staging → smoke test → (approval) → production
- **Immutable artifact:** build Docker image once, deploy same image everywhere
- **Keywords:** pipeline, YAML, GitHub Actions, fast feedback, deployment gate

## 🏢 Industry Experience Answer
"Our CI/CD runs on every PR: build, unit tests, integration tests (Testcontainers), code coverage gate, Docker image build. Merge to main triggers CD: push to registry, auto-deploy to staging, run smoke tests, manual approval for production. Full pipeline takes 12 minutes. We do 5-10 production deployments per week with zero downtime via rolling deployments."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is CI/CD pipeline?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q4
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Containerization packages an application with all its dependencies into a portable, isolated **container** — it runs identically everywhere Docker is installed. For .NET: no "works on my machine" issues, consistent CI/CD artifacts, easy horizontal scaling on Kubernetes, smaller Linux images than Windows VMs, and faster startup than VMs. Docker is the standard container runtime.

## 📖 Detailed Explanation
**What a container is:** an isolated process running from a Docker image. The image contains: .NET runtime, app binaries, config, OS layer. Multiple containers share the host kernel (unlike VMs which each have their own OS).
**Benefits for .NET:**
- **Consistency:** same image runs in dev, CI, staging, production.
- **Isolation:** each service runs in its own container; no dependency conflicts.
- **Small images:** .NET 8 on Linux alpine images are ~100MB vs Windows Server GBs.
- **Orchestration:** Kubernetes manages container scheduling, scaling, healing.
**Image layers:** Docker images are layered — the base .NET runtime layer is shared, only your app layer changes. Faster CI builds, smaller registry storage.

## 💻 Code Example
```yaml
# Why Docker: consistent environment guaranteed
# Developer runs: docker run myapi:latest
# CI runs:       docker run myapi:latest
# Production runs: docker run myapi:latest  <-- SAME IMAGE, same behavior

# docker-compose for local development with dependencies
version: '3.8'
services:
  api:
    build: .
    ports:
      - "8080:8080"
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - ConnectionStrings__Default=Host=db;Database=myapp;Username=postgres;Password=devpass
    depends_on:
      - db

  db:
    image: postgres:16-alpine
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=devpass
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

## ❓ Follow-Up Questions
- **Q: Docker vs VM?** A: Containers share the host kernel (lightweight, seconds to start); VMs have a full OS (heavy, minutes to start). Containers are not as isolated as VMs but far more efficient.
- **Q: Why prefer Linux containers for .NET?** A: Linux images are smaller (200-400MB vs 4GB+ Windows Server), cheaper to run in cloud, and faster to pull/start.
- **Q: What is a Docker registry?** A: A store for Docker images. Docker Hub (public), Azure Container Registry, AWS ECR, GitHub Container Registry (private).

## ⚠️ Common Mistakes
❌ Running .NET apps in Windows Server Core containers.
✅ Use Linux (mcr.microsoft.com/dotnet/aspnet:8.0) — same .NET 8, 4x smaller image, lower cost, supported on any cloud.

## 🎯 Cheat Sheet
- **Container:** isolated process from an image, shares host kernel
- **Image:** built from Dockerfile, immutable, layered
- **Benefits:** consistency, isolation, small Linux images, Kubernetes-ready
- **Keywords:** Docker, OCI, registry, layers, mcr.microsoft.com/dotnet/aspnet

## 🏢 Industry Experience Answer
"Containerizing .NET eliminated our 'works on my machine' bugs entirely. The image built in CI is exactly what runs in production. We went from 5 hours per deployment (manual, error-prone) to 12 minutes (automated, zero-touch). The Linux image size dropped from 4GB (Windows Server) to 160MB (Linux slim). Cloud cost dropped 40% with more density per node."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is containerization and why use Docker with .NET?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q5
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**Kestrel** is the cross-platform, high-performance HTTP server built into ASP.NET Core — it's the default server that processes HTTP requests. **IIS** (Internet Information Services) is Windows' full-featured web server. When deployed on Windows behind IIS, the **ASP.NET Core Module (ANCM)** acts as a proxy: IIS receives requests and forwards them to Kestrel, or (in-process mode) IIS hosts Kestrel directly.

## 📖 Detailed Explanation
**Kestrel:** lightweight, cross-platform (Linux, macOS, Windows), extremely fast (top TechEmpower benchmarks). Handles HTTPS, HTTP/2, HTTP/3, WebSockets directly. The primary server for Linux/Docker deployments.
**IIS:** Windows-only, full-featured (request filtering, URL rewrite, process management, Windows Auth). Used as a reverse proxy in front of Kestrel on Windows.
**ANCM (ASP.NET Core Module):** a native IIS module that routes requests to the .NET process.
**In-process hosting (default):** Kestrel runs inside the IIS worker process (w3wp.exe) — same process, no inter-process communication. Fastest.
**Out-of-process hosting:** IIS forwards via HTTP to a separate Kestrel process. More isolated; useful if IIS needs to manage the process lifecycle.
**Linux/Docker:** Kestrel only — IIS is not available. Production reverse proxy is Nginx or Kubernetes Ingress.

## 💻 Code Example
```csharp
// Kestrel configuration in Program.cs
builder.WebHost.ConfigureKestrel(options =>
{
    options.ListenAnyIP(8080);                    // HTTP
    options.ListenAnyIP(8443, l => l.UseHttps()); // HTTPS
    options.Limits.MaxRequestBodySize = 50_000_000; // 50MB upload limit
    options.Limits.MaxConcurrentConnections = 10_000;
    options.Limits.RequestHeadersTimeout = TimeSpan.FromSeconds(30);
});

// In-process vs out-of-process (web.config)
// In-process (default, fastest):
// <aspNetCore processPath="dotnet" arguments=".\MyApi.dll" hostingModel="inprocess" />

// Out-of-process (separate Kestrel process):
// <aspNetCore processPath="dotnet" arguments=".\MyApi.dll" hostingModel="outofprocess" />

// Nginx reverse proxy in front of Kestrel (Linux production)
// server {
//     listen 80;
//     location / {
//         proxy_pass http://localhost:5000;
//         proxy_http_version 1.1;
//         proxy_set_header Upgrade HEADER_VALUE;
//         proxy_set_header Host HOST_VALUE;
//     }
// }
```

## ❓ Follow-Up Questions
- **Q: Can you use Kestrel without IIS?** A: Yes — on Linux/macOS/Docker, Kestrel runs standalone. On Windows, you can too, but IIS adds management features.
- **Q: Why use a reverse proxy in front of Kestrel in production?** A: SSL termination, request filtering, static file serving, load balancing, rate limiting — handled at the proxy level, not in your app.
- **Q: HTTP/3 support in Kestrel?** A: Yes — .NET 7+ supports HTTP/3 (QUIC). Enable with `ListenAnyIP(443, o => { o.UseHttps(); o.Protocols = HttpProtocols.Http1AndHttp2AndHttp3; })`.

## ⚠️ Common Mistakes
❌ Exposing Kestrel directly to the internet in production without a reverse proxy.
✅ Use Nginx, Azure Application Gateway, or Kubernetes Ingress in front of Kestrel. The reverse proxy handles SSL, request validation, and load balancing.

## 🎯 Cheat Sheet
- **Kestrel:** built-in, cross-platform, high-performance HTTP server
- **IIS:** Windows-only, full-featured, with ANCM routes to Kestrel
- **In-process:** Kestrel inside w3wp.exe — fastest IIS mode
- **Reverse proxy:** Nginx/AGWY/Ingress in front of Kestrel in production
- **Keywords:** ANCM, in-process, out-of-process, Kestrel limits, HTTP/3

## 🏢 Industry Experience Answer
"On Linux/Kubernetes we use Kestrel directly behind Nginx Ingress — no IIS involved. Kestrel handles 80k req/sec on modest hardware. On our one Windows-based on-premise product, IIS in-process mode gives us Windows Auth and URL rewrite rules while keeping the performance close to direct Kestrel. The ANCM in-process hosting was a significant throughput improvement over the old reverse-proxy model."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are Kestrel and IIS and how do they interact?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q6
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
A Dockerfile is a text script of instructions that builds a Docker image. For .NET, use a **multi-stage build**: Stage 1 (SDK image) restores and builds; Stage 2 (smaller runtime image) copies only the published output. This produces a lean production image (~150-200MB on Linux) without the 700MB SDK.

## 📖 Detailed Explanation
**Key instructions:**
- `FROM`: base image
- `WORKDIR`: working directory in the container
- `COPY`: copy files from host to container
- `RUN`: execute command during build
- `EXPOSE`: document which port the container listens on
- `ENTRYPOINT`/`CMD`: command to run when container starts
**Multi-stage:** the build stage is discarded — only the final runtime stage becomes the image. Keeps images small and secure (no SDK, build tools, or source code in production image).
**Optimizing layer cache:** copy .csproj files and restore before copying source code — NuGet restore layer is cached and not re-run on source-only changes.

## 💻 Code Example
```dockerfile
# syntax=docker/dockerfile:1

# ---- Stage 1: Build ----
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Restore NuGet packages (cached layer -- only re-run when .csproj changes)
COPY ["src/MyApi/MyApi.csproj", "src/MyApi/"]
COPY ["src/MyApi.Domain/MyApi.Domain.csproj", "src/MyApi.Domain/"]
RUN dotnet restore "src/MyApi/MyApi.csproj"

# Build
COPY . .
WORKDIR "/src/src/MyApi"
RUN dotnet build "MyApi.csproj" -c Release -o /app/build

# ---- Stage 2: Publish ----
FROM build AS publish
RUN dotnet publish "MyApi.csproj" -c Release -o /app/publish --no-restore

# ---- Stage 3: Runtime (lean final image) ----
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Security: run as non-root user
RUN adduser --disabled-password --gecos "" appuser
USER appuser

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyApi.dll"]
```

## ❓ Follow-Up Questions
- **Q: Why copy .csproj first before source?** A: Docker layer caching — if only .cs files change, the dotnet restore layer is cached (not re-run). Saves 30-60 seconds per build.
- **Q: Why run as non-root?** A: Security best practice — a compromised container running as root has more privileges on the host. Run as a non-root user to limit blast radius.
- **Q: Alpine vs slim base images?** A: Alpine is smallest (~5MB) but uses musl libc (compatibility issues with some .NET libraries). Debian slim (~80MB) is a safer default for .NET.

## ⚠️ Common Mistakes
❌ Using the SDK image as the final runtime image.
✅ The SDK image includes build tools and source code you don't need at runtime. Multi-stage = build with SDK, run with the smaller aspnet image.

## 🎯 Cheat Sheet
- **Multi-stage:** SDK to build, aspnet to run
- **Layer cache:** COPY .csproj + restore before COPY source
- **Non-root user:** security best practice
- **EXPOSE + ASPNETCORE_URLS:** declare and configure port
- **Keywords:** FROM, WORKDIR, COPY, RUN, ENTRYPOINT, multi-stage, layer cache

## 🏢 Industry Experience Answer
"Our Dockerfile template: multi-stage, non-root user, csproj-first for cache optimization. The csproj-first pattern was the biggest CI speed win — package restore went from 2 minutes to 5 seconds on source-only changes because Docker cached the restore layer. We use the Debian slim runtime image, not Alpine, to avoid musl compatibility issues we hit with some native libraries."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is a Dockerfile and how do you write one for a .NET Core app?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q7
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Docker Compose is a tool for **defining and running multi-container applications** using a `docker-compose.yml` file. With one `docker compose up` command it starts your API, database, Redis, and any other services — each in its own container — with a shared network and configured volumes. Use it for local development and integration testing; Kubernetes for production.

## 📖 Detailed Explanation
**Why Compose:** running a .NET API locally requires PostgreSQL, Redis, maybe RabbitMQ. Without Compose, you'd start each container manually. Compose orchestrates all of them from a single file.
**Key concepts:**
- `services:` defines each container (name, image/build, ports, env vars, depends_on)
- `networks:` containers can communicate by service name (e.g., `Host=db` instead of `Host=localhost`)
- `volumes:` persist DB data between restarts
- `depends_on:` start order (but not readiness — use healthchecks for that)
**Common commands:** `docker compose up` (start all), `docker compose down` (stop + remove), `docker compose build` (rebuild images), `docker compose logs` (view output).

## 💻 Code Example
```yaml
# docker-compose.yml — local development setup
version: '3.8'

services:
  api:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - ConnectionStrings__Default=Host=db;Database=myapp;Username=dev;Password=devpass
      - Redis__Connection=redis:6379
    depends_on:
      db:
        condition: service_healthy   # wait until DB is ready
      redis:
        condition: service_started
    volumes:
      - ./src:/app/src              # hot reload source (optional)

  db:
    image: postgres:16-alpine
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_USER=dev
      - POSTGRES_PASSWORD=devpass
    ports:
      - "5432:5432"                  # expose for local DB client
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U dev"]
      interval: 5s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  pgdata:
```

## ❓ Follow-Up Questions
- **Q: Docker Compose vs Kubernetes?** A: Compose is for local development and simple deployments — single machine. Kubernetes is for production multi-node orchestration with auto-scaling and self-healing.
- **Q: Does depends_on guarantee the service is ready?** A: No — only that the container started. Use healthcheck + `condition: service_healthy` to wait for true readiness.
- **Q: Can Compose be used in production?** A: For very small deployments (single server), yes. But Kubernetes, Swarm, or a managed PaaS is better for resilience and scaling.

## ⚠️ Common Mistakes
❌ Using depends_on without healthchecks — app starts before DB is ready, crashes on first connection.
✅ Add a healthcheck to the DB service and use `condition: service_healthy` in the API's depends_on.

## 🎯 Cheat Sheet
- **Purpose:** multi-container orchestration for local dev/testing
- **docker compose up:** start all services
- **Service discovery:** services reference each other by service name (db, redis)
- **Healthcheck:** condition: service_healthy ensures readiness
- **Keywords:** docker-compose.yml, services, networks, volumes, depends_on

## 🏢 Industry Experience Answer
"Docker Compose is our local development standard. New developer onboarding: clone repo, run 'docker compose up', get a fully running API with PostgreSQL, Redis, and RabbitMQ in under 2 minutes. The healthcheck pattern solved the 'API crashes on startup because DB isn't ready' issue. We also use it in CI for integration tests with a dedicated docker-compose.test.yml."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Docker Compose and when would you use it?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q8
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Kubernetes (K8s) is a **container orchestration platform** that manages deployment, scaling, and operation of containerized applications across a cluster. Core objects: **Pod** (smallest unit — one or more containers), **Deployment** (manages pod replicas and rolling updates), **Service** (stable network endpoint to reach pods), **Ingress** (HTTP routing + SSL termination from outside).

## 📖 Detailed Explanation
**Pod:** one or more tightly coupled containers sharing network and storage. Usually one container per pod for APIs.
**Deployment:** declares desired state (3 replicas of myapi:v1). K8s continuously reconciles — if a pod dies, a new one is created. Rolling updates: new pods start before old ones stop.
**Service:** a stable DNS name and virtual IP that load-balances across pod replicas. Types: ClusterIP (internal), NodePort (external via node IP), LoadBalancer (cloud load balancer).
**Ingress:** HTTP/HTTPS routing rules — route by hostname/path to services. Nginx Ingress is the most common.
**ConfigMap / Secret:** inject config and secrets into pods as env vars or volumes.

## 💻 Code Example
```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapi
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapi
  template:
    metadata:
      labels:
        app: myapi
    spec:
      containers:
      - name: myapi
        image: myregistry.azurecr.io/myapi:v1.2.3
        ports:
        - containerPort: 8080
        env:
        - name: ASPNETCORE_ENVIRONMENT
          value: Production
        - name: ConnectionStrings__Default
          valueFrom:
            secretKeyRef:
              name: myapi-secrets
              key: db-connection-string
        resources:
          requests: { cpu: "100m", memory: "128Mi" }
          limits:   { cpu: "500m", memory: "512Mi" }
        readinessProbe:
          httpGet: { path: /health/ready, port: 8080 }
          initialDelaySeconds: 10
          periodSeconds: 5
        livenessProbe:
          httpGet: { path: /health/live, port: 8080 }
          periodSeconds: 10

---
# service.yaml
apiVersion: v1
kind: Service
metadata:
  name: myapi-svc
spec:
  selector:
    app: myapi
  ports:
  - port: 80
    targetPort: 8080

---
# ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: myapi-ingress
spec:
  rules:
  - host: api.myapp.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: myapi-svc
            port:
              number: 80
```

## ❓ Follow-Up Questions
- **Q: kubectl commands to know?** A: kubectl get pods/deployments/services, kubectl apply -f, kubectl rollout status deployment/myapi, kubectl rollout undo, kubectl logs, kubectl exec.
- **Q: What is a ReplicaSet?** A: Deployment creates and manages ReplicaSets which ensure N pods are always running. You work with Deployments, not ReplicaSets directly.
- **Q: What is HPA?** A: HorizontalPodAutoscaler — automatically scales pod count based on CPU/memory/custom metrics.

## ⚠️ Common Mistakes
❌ Deploying without resource requests and limits.
✅ Pods without limits can starve neighboring pods or crash nodes. Always set requests (scheduling) and limits (runtime cap).

## 🎯 Cheat Sheet
- **Pod:** container(s), smallest deployable unit
- **Deployment:** manages N replicas, rolling updates, self-healing
- **Service:** stable endpoint (DNS + VIP) load-balancing across pods
- **Ingress:** HTTP routing + SSL from external traffic
- **Keywords:** kubectl, replicas, rolling update, HPA, ConfigMap, Secret

## 🏢 Industry Experience Answer
"All our production services run on AKS (Azure Kubernetes Service). Three replicas per deployment, HPA scaling on CPU. The Deployment handles rolling updates transparently — zero downtime on every release. Resource limits protect against rogue pods taking down nodes. The combination of Deployment + Service + Ingress is the standard pattern we replicate for every new microservice."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Kubernetes and what are pods, services, and deployments?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q9
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Kubernetes probes determine **container health** so K8s can route traffic and manage pod lifecycle. **Readiness probe:** is the pod ready to receive traffic? (fails → removed from service endpoints, no traffic). **Liveness probe:** is the pod alive/not stuck? (fails → pod is restarted). Both should point to dedicated health check endpoints in your ASP.NET Core app.

## 📖 Detailed Explanation
**Readiness probe:** checks dependencies (DB connected, cache warm, startup complete). If readiness fails, K8s removes the pod from the Service's endpoint list — it receives no new requests but is not restarted. Use for: startup slowness, DB connection not yet established, circuit breaker open.
**Liveness probe:** checks the process is alive and not deadlocked/hung. If it fails N consecutive times, K8s kills and restarts the container. Use for: infinite loop detection, deadlock, OOM near-crash.
**Startup probe (K8s 1.16+):** disables liveness during startup. Prevents liveness from killing a slow-starting container before it's had a chance to start.
**Probe types:** HTTP (check endpoint returns 2xx), TCP (port is listening), Exec (run a command inside the container).

## 💻 Code Example
```csharp
// ASP.NET Core health check endpoints
builder.Services.AddHealthChecks()
    .AddNpgSql(connectionString, name: "database", tags: new[] { "ready" })
    .AddRedis(redisConnection, name: "redis", tags: new[] { "ready" });

// Liveness: always 200 if app is running (no deps checked)
app.MapHealthChecks("/health/live", new HealthCheckOptions
{
    Predicate = _ => false   // no checks — just "is the process alive?"
});

// Readiness: checks DB, Redis, etc.
app.MapHealthChecks("/health/ready", new HealthCheckOptions
{
    Predicate = check => check.Tags.Contains("ready")
});
```

```yaml
# Kubernetes probe config
containers:
- name: myapi
  readinessProbe:
    httpGet:
      path: /health/ready
      port: 8080
    initialDelaySeconds: 10   # wait before first check
    periodSeconds: 5           # check every 5 seconds
    failureThreshold: 3        # 3 failures before removing from rotation

  livenessProbe:
    httpGet:
      path: /health/live
      port: 8080
    initialDelaySeconds: 30    # wait longer -- don't kill during startup
    periodSeconds: 10
    failureThreshold: 3        # 3 failures before restart

  startupProbe:
    httpGet:
      path: /health/live
      port: 8080
    failureThreshold: 30       # allow 5 min startup (30 * 10s)
    periodSeconds: 10
```

## ❓ Follow-Up Questions
- **Q: What happens if readiness fails?** A: The pod is removed from the Service endpoints — no new traffic. The pod keeps running and can recover.
- **Q: What happens if liveness fails?** A: K8s kills and restarts the container. CrashLoopBackOff occurs if it repeatedly fails.
- **Q: Why separate liveness from readiness?** A: A slow DB query making readiness fail shouldn't restart the pod (liveness action). Separate probes let K8s take the right action for each failure mode.

## ⚠️ Common Mistakes
❌ Using the same endpoint for both liveness and readiness.
✅ Liveness = app is alive (always succeeds if process is running). Readiness = dependencies are up. A DB outage should stop traffic (readiness fail) but NOT restart the pod (liveness).

## 🎯 Cheat Sheet
- **Readiness:** ready for traffic? Fail → remove from Service
- **Liveness:** alive/not hung? Fail → restart container
- **Startup:** disable liveness during slow startup
- **Separate endpoints:** /health/live (no checks), /health/ready (checks deps)
- **Keywords:** readinessProbe, livenessProbe, startupProbe, CrashLoopBackOff

## 🏢 Industry Experience Answer
"Probes saved us from serving errors after a DB failover. Readiness caught the brief connection loss and pulled pods from rotation — users experienced slightly slower retries on the client, not errors. Without the probe separation, a DB blip would have triggered pod restarts (liveness action) just as the DB was recovering — making the outage worse. Readiness for traffic routing, liveness for real crashes."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What are readiness and liveness probes in Kubernetes?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q10
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
GitHub Actions is a **CI/CD platform built into GitHub** — workflows are YAML files in `.github/workflows/` that trigger on events (push, PR, schedule). For .NET: build → test → Docker build → push → deploy. Workflows are version-controlled alongside code and use a marketplace of reusable action components.

## 📖 Detailed Explanation
**Key concepts:**
- **Workflow:** YAML file defining the automation pipeline.
- **Trigger (on:):** push, pull_request, schedule (cron), workflow_dispatch (manual).
- **Job:** a group of steps that run on a runner (ubuntu-latest, windows-latest).
- **Step:** individual task — `uses:` (action from marketplace) or `run:` (shell command).
- **Secrets:** encrypted values stored in GitHub settings, referenced as `secrets.MY_SECRET`.
- **Environment:** GitHub environments with protection rules (require approvals for production).
**Advantages:** no separate CI server, free for public repos, deep GitHub integration (PR checks, deployment status), 2000 free minutes/month for private repos.

## 💻 Code Example
```yaml
# .github/workflows/dotnet.yml
name: Build, Test, Deploy

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: myorg/myapi

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup .NET 8
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: '8.0.x'

      - name: Cache NuGet packages
        uses: actions/cache@v4
        with:
          path: ~/.nuget/packages
          key: nuget-cache-HASH

      - name: Restore, Build, Test
        run: |
          dotnet restore
          dotnet build -c Release --no-restore
          dotnet test -c Release --no-build --logger trx

      - name: Publish test results
        uses: dorny/test-reporter@v1
        if: always()
        with:
          name: .NET Tests
          path: '**/*.trx'
          reporter: dotnet-trx

  docker:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4

      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          push: true
          tags: ghcr.io/myorg/myapi:latest,ghcr.io/myorg/myapi:SHA

  deploy-staging:
    needs: docker
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - name: Deploy to Kubernetes
        run: |
          kubectl set image deployment/myapi myapi=ghcr.io/myorg/myapi:SHA
          kubectl rollout status deployment/myapi
```

## ❓ Follow-Up Questions
- **Q: GitHub Actions vs Azure DevOps?** A: Both are excellent. GitHub Actions is simpler and native to GitHub. Azure DevOps has more enterprise features (board integration, artifact feeds). For GitHub repos, Actions is the natural choice.
- **Q: How do you manage secrets in GitHub Actions?** A: GitHub Settings → Secrets → repository or environment secrets. Referenced as `secrets.SECRET_NAME` in the YAML.
- **Q: What are environments in GitHub Actions?** A: Named deployment targets (staging, production) with protection rules — require approvals, restrict who can deploy.

## ⚠️ Common Mistakes
❌ Storing secrets in the workflow YAML file.
✅ Use GitHub Secrets (encrypted, not visible in logs). Never hard-code API keys, passwords, or tokens in YAML.

## 🎯 Cheat Sheet
- **Trigger:** on: push, pull_request, schedule, workflow_dispatch
- **Jobs:** parallel or sequential (needs:)
- **Secrets:** secrets.MY_SECRET (encrypted in GitHub settings)
- **Environment:** staging/production with approval gates
- **Keywords:** runner, actions marketplace, matrix, cache, OIDC

## 🏢 Industry Experience Answer
"GitHub Actions runs every PR (build + test) and every main push (test + Docker + deploy to staging). Using OIDC for Azure authentication means no stored credentials — the runner gets a short-lived token per run. NuGet package caching reduced our average build from 4 minutes to 90 seconds. The environment approval gate on production means deployments need a second pair of eyes — has caught two bad deploys."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is GitHub Actions and how do you set up a CI/CD workflow for .NET?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q11
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
**Rolling deployment** gradually replaces old pods with new ones — at any moment some run old, some run new code. **Blue-green deployment** runs two complete environments (blue = current, green = new); switch traffic instantly after green is verified healthy. Rolling minimizes downtime with less resources; blue-green enables instant rollback and zero mixed-version traffic.

## 📖 Detailed Explanation
**Rolling deployment:** Kubernetes default. New pods start alongside old ones; old pods terminate as new ones become ready. At peak transition: v1 and v2 pods serve traffic simultaneously. Risk: both versions may handle the same requests during the transition — API must be backward-compatible.
**Blue-green:** two complete environments run in parallel. Traffic (load balancer or DNS) switches from blue to green atomically. Instant rollback: switch back to blue. Double infrastructure cost during deployment window. Zero mixed-version traffic.
**Canary deployment:** route a small percentage (5%) of traffic to the new version, monitor, then gradually increase. Best for risk-managed releases. Requires traffic-splitting ingress (Argo Rollouts, Flagger, AWS ALB weighted routing).

## 💻 Code Example
```yaml
# Rolling deployment (Kubernetes default)
spec:
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 2          # max extra pods above desired during update
      maxUnavailable: 1    # max pods that can be down during update

# Deploy: kubectl set image deployment/myapi myapi=myapi:v2
# K8s creates new pods, waits for readiness, terminates old pods gradually

# Blue-green deployment via Service selector switching
---
# Blue deployment (current production)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapi-blue
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: myapi
        version: blue
    spec:
      containers:
      - name: myapi
        image: myapi:v1

---
# Service -- switch from blue to green by changing selector
apiVersion: v1
kind: Service
metadata:
  name: myapi-svc
spec:
  selector:
    app: myapi
    version: blue    # change to "green" to switch traffic instantly

# To switch: kubectl patch service myapi-svc -p '{"spec":{"selector":{"version":"green"}}}'
# Rollback:  kubectl patch service myapi-svc -p '{"spec":{"selector":{"version":"blue"}}}'
```

## ❓ Follow-Up Questions
- **Q: When would you NOT use rolling deployment?** A: When the new version has breaking DB schema changes — mixed-version traffic can break with incompatible schemas. Use blue-green or expand-contract migrations.
- **Q: What is a canary deployment?** A: Send a small % of traffic to the new version first. Monitor error rates; if healthy, gradually increase to 100%. Argo Rollouts automates this.
- **Q: Expand-contract migrations?** A: Evolve DB schema in two phases: expand (add new column, keep old — both versions compatible) → contract (remove old column after all instances updated). Enables rolling updates with schema changes.

## ⚠️ Common Mistakes
❌ Rolling out breaking API changes without ensuring backward compatibility during the rollout window.
✅ During rolling deployment, v1 and v2 coexist. Either ensure v1 can handle v2 requests or use blue-green to avoid mixed versions.

## 🎯 Cheat Sheet
- **Rolling:** gradual pod replacement, coexisting versions, K8s default
- **Blue-green:** two environments, instant traffic switch, instant rollback
- **Canary:** partial traffic to new, monitor, gradual increase
- **Keywords:** maxSurge, maxUnavailable, traffic switch, rollback, Argo Rollouts

## 🏢 Industry Experience Answer
"We use rolling for routine API deployments (backward-compatible changes) and blue-green for breaking changes or major releases. Blue-green costs twice the pods for the deployment window but the ability to switch back in 5 seconds by flipping the service selector has saved us twice. Canary with Argo Rollouts is our next investment — gradual risk-managed releases at scale."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'Difference between rolling deployment and blue-green deployment?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- Q12
INSERT INTO answers (question_id, content, is_verified)
SELECT q.id, $body$## ⚡ Short Answer
Infrastructure as Code (IaC) manages infrastructure (servers, databases, networks, Kubernetes clusters) through **code and configuration files** instead of manual clicks in a cloud console. Changes go through code review, version control, and CI/CD — infrastructure becomes reproducible, auditable, and consistent. Tools: **Terraform** (multi-cloud, declarative), **Bicep/ARM** (Azure-native), **Pulumi** (real programming languages), **Helm** (Kubernetes packaging).

## 📖 Detailed Explanation
**Why IaC:**
- **Reproducibility:** spin up identical environments (dev/staging/prod) from code.
- **Auditability:** every infrastructure change is a commit with author, reason, and diff.
- **Consistency:** no configuration drift between environments — all defined in code.
- **Disaster recovery:** lose a region, redeploy from IaC in the new one.
- **Code review:** infrastructure changes reviewed like application code.

**Terraform:** declarative HCL, provider ecosystem (AWS, Azure, GCP, Kubernetes), plan/apply workflow shows changes before applying.
**Bicep:** Azure-native declarative language (replacement for ARM JSON), first-class Azure support.
**Helm:** Kubernetes package manager — templates for K8s YAML, versioned, values files per environment.
**Pulumi:** use real languages (C#, Python, TypeScript) instead of DSLs — ideal for .NET teams.

## 💻 Code Example
```hcl
# Terraform example: Azure Kubernetes Service + ACR
resource "azurerm_resource_group" "rg" {
  name     = "myapp-prod-rg"
  location = "East US"
}

resource "azurerm_container_registry" "acr" {
  name                = "myappacr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "myapp-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "myapp"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

# Helm chart values for environment-specific config (values.prod.yaml)
# replicaCount: 3
# image:
#   repository: myappacr.azurecr.io/myapi
#   tag: v1.2.3
# resources:
#   limits:
#     cpu: 500m
#     memory: 512Mi
```

## ❓ Follow-Up Questions
- **Q: Terraform plan vs apply?** A: `terraform plan` shows what WILL change (dry run). `terraform apply` executes the changes. Always review plan output before applying to production.
- **Q: What is Terraform state?** A: Terraform stores the current infrastructure state in a state file (.tfstate). In teams, store it remotely (Azure Blob, S3) with state locking.
- **Q: Helm vs raw Kubernetes YAML?** A: Helm templates K8s YAML with values files — environments share the same chart, different values. Easier versioning and rollback of K8s deployments.

## ⚠️ Common Mistakes
❌ Making manual infrastructure changes in the cloud console after IaC is set up.
✅ Manual changes cause configuration drift — Terraform will detect and may revert them on next apply. All changes must go through IaC, code review, and CI/CD.

## 🎯 Cheat Sheet
- **IaC benefits:** reproducible, auditable, consistent, version-controlled
- **Terraform:** multi-cloud, HCL, plan/apply, state file
- **Bicep:** Azure-native, cleaner than ARM JSON
- **Helm:** K8s package manager, values per environment
- **Pulumi:** IaC in C#/TypeScript — great for .NET teams
- **Keywords:** Terraform, Bicep, Helm, drift, state file, plan/apply

## 🏢 Industry Experience Answer
"All our Azure infrastructure is Terraform — AKS, ACR, PostgreSQL Flexible Server, Key Vault, Redis. Infrastructure changes go through a PR with terraform plan output reviewed by a second engineer. This caught an accidental node pool size reduction that would have caused downtime. The disaster recovery test validated our IaC: we destroyed the staging environment and rebuilt it from scratch in 18 minutes."
$body$, true
FROM questions q JOIN sections s ON q.section_id = s.id JOIN topics t ON s.topic_id = t.id
WHERE t.label = '.NET' AND q.text = 'What is Infrastructure as Code (IaC) and what tools support it?'
ON CONFLICT (question_id) DO UPDATE SET content = EXCLUDED.content, is_verified = true;

-- End of Batch 10 — Deployment & DevOps COMPLETE (Q1–Q12)
-- All 16 .NET sections now done! Next: JavaScript/TypeScript sections (batch11 onwards)
