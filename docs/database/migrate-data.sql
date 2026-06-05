-- ════════════════════════════════════════════════════════════════
-- DEVREADY DATA MIGRATION
-- Auto-generated from topics.js
-- Run this in: Supabase SQL Editor
-- ════════════════════════════════════════════════════════════════

-- TOPIC: .NET
INSERT INTO public.topics (slug, label, color_hex, display_order) VALUES
  ('_net', '.NET', '#818cf8', 1)
ON CONFLICT (slug) DO NOTHING;


-- SECTION: 1️⃣ C# Basics & OOP
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = '_net'), 's1', '1️⃣ C# Basics & OOP', 1)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 1, 'What is C#?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 2, 'What are the basic data types in C#?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 3, 'What are value types and reference types?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 4, 'What is a class and an object?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 5, 'What is the difference between struct and class?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 6, 'What are access modifiers in C#?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 7, 'What is encapsulation?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 8, 'What is inheritance?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 9, 'What is polymorphism?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 10, 'What is abstraction?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 11, 'What is an interface?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 12, 'What is an abstract class?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 13, 'Difference between interface and abstract class?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 14, 'When to use interface vs abstract class?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 15, 'What is method overloading?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 16, 'What is method overriding?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 17, 'Difference between method overriding and method hiding?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 18, 'Difference between virtual, override, and new keywords?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 19, 'What is a sealed class and when to use it?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 20, 'What is a static class?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 21, 'Difference between static, const, and readonly?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 22, 'What are constructors and their types?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 23, 'What are destructors?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 24, 'Difference between ref and out keyword?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 25, 'Value equality vs reference equality?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 26, 'What are nullable types in C# and how does the ? syntax work?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 27, 'What is the null coalescing (??) and null-conditional (?.) operator?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 28, 'What are tuples in C# and when would you use them?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 29, 'What is pattern matching in C#?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 30, 'What is the using statement and how does it relate to IDisposable?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 31, 'What are named and optional parameters in C#?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 32, 'Difference between string and StringBuilder?'),
  ((SELECT id FROM public.sections WHERE slug = 's1' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 33, 'What are object initializers and collection initializers?')
ON CONFLICT DO NOTHING;

-- SECTION: 2️⃣ Advanced C# Concepts
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = '_net'), 's2', '2️⃣ Advanced C# Concepts', 2)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 1, 'What is boxing and unboxing?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 2, 'What are delegates?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 3, 'What are multicast delegates?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 4, 'What are events?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 5, 'Difference between delegate and event?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 6, 'What are lambda expressions?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 7, 'What are anonymous methods?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 8, 'What are generics?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 9, 'What is covariance and contravariance?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 10, 'What is an extension method?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 11, 'What are partial classes and methods?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 12, 'What are indexers and properties?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 13, 'What are async and await keywords?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 14, 'What are tasks and how do they differ from threads?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 15, 'Difference between synchronous and asynchronous programming?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 16, 'What is ConfigureAwait(false) and when should you use it?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 17, 'What is a CancellationToken and how do you use it?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 18, 'Difference between Task and ValueTask?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 19, 'What is SemaphoreSlim and how does it help control concurrency?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 20, 'What are expression trees and when are they used?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 21, 'What is reflection and when should you avoid it?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 22, 'What are attributes and how do you create custom attributes?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 23, 'What is the Lazy<T> class and when do you use lazy initialization?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 24, 'Difference between lock, Monitor, Mutex, and Semaphore?'),
  ((SELECT id FROM public.sections WHERE slug = 's2' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 25, 'What are Span<T> and Memory<T> and why are they important for performance?')
ON CONFLICT DO NOTHING;

-- SECTION: 3️⃣ ASP.NET Core
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = '_net'), 's3', '3️⃣ ASP.NET Core', 3)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 1, 'What is .NET Core / .NET 8?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 2, 'Advantages of .NET Core over .NET Framework?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 3, 'What is the Startup class in ASP.NET Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 4, 'What is the Program.cs file used for?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 5, 'What is Dependency Injection (DI)?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 6, 'What are the service lifetimes – Singleton, Scoped, Transient?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 7, 'What is Middleware?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 8, 'What is Routing in ASP.NET Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 9, 'What is Model Binding?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 10, 'What are Filters in ASP.NET Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 11, 'What is configuration in ASP.NET Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 12, 'What are appsettings.json and environment variables?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 13, 'Difference between IHostedService and BackgroundService?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 14, 'What is logging in ASP.NET Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 15, 'What are minimal APIs in .NET 6+?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 16, 'What is HttpClientFactory and why use it instead of new HttpClient()?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 17, 'What is the IOptions<T> pattern and how does it work?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 18, 'What are health checks in ASP.NET Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 19, 'What is output caching vs response caching?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 20, 'What is rate limiting in ASP.NET Core 7+?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 21, 'What are action results and what types does ASP.NET Core provide?'),
  ((SELECT id FROM public.sections WHERE slug = 's3' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 22, 'Difference between AddScoped, AddTransient, and AddSingleton?')
ON CONFLICT DO NOTHING;

-- SECTION: 4️⃣ Entity Framework Core
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = '_net'), 's4', '4️⃣ Entity Framework Core', 4)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 's4' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 1, 'What is Entity Framework Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's4' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 2, 'What is Code-First approach?'),
  ((SELECT id FROM public.sections WHERE slug = 's4' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 3, 'What is Database-First approach?'),
  ((SELECT id FROM public.sections WHERE slug = 's4' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 4, 'What are migrations?'),
  ((SELECT id FROM public.sections WHERE slug = 's4' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 5, 'What is DbContext?'),
  ((SELECT id FROM public.sections WHERE slug = 's4' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 6, 'What is DbSet?'),
  ((SELECT id FROM public.sections WHERE slug = 's4' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 7, 'What is lazy loading, eager loading, and explicit loading?'),
  ((SELECT id FROM public.sections WHERE slug = 's4' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 8, 'What is change tracking in EF Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's4' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 9, 'How do you handle transactions in EF Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's4' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 10, 'What are navigation properties?'),
  ((SELECT id FROM public.sections WHERE slug = 's4' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 11, 'What is shadow property in EF Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's4' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 12, 'AsNoTracking() vs tracked queries – when to use each?'),
  ((SELECT id FROM public.sections WHERE slug = 's4' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 13, 'What are compiled queries in EF Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's4' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 14, 'How do you handle optimistic concurrency in EF Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's4' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 15, 'What are value converters in EF Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's4' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 16, 'How would you implement a soft delete in EF Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's4' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 17, 'What is the N+1 query problem and how do you fix it in EF Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's4' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 18, 'Difference between SaveChanges() and SaveChangesAsync()?')
ON CONFLICT DO NOTHING;

-- SECTION: 5️⃣ Auth & Security
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = '_net'), 's5', '5️⃣ Auth & Security', 5)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 's5' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 1, 'What is JWT (JSON Web Token)?'),
  ((SELECT id FROM public.sections WHERE slug = 's5' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 2, 'How does JWT authentication work in ASP.NET Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's5' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 3, 'What is authorization vs authentication?'),
  ((SELECT id FROM public.sections WHERE slug = 's5' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 4, 'What is role-based authorization?'),
  ((SELECT id FROM public.sections WHERE slug = 's5' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 5, 'What is policy-based authorization?'),
  ((SELECT id FROM public.sections WHERE slug = 's5' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 6, 'How do you implement custom authentication middleware?'),
  ((SELECT id FROM public.sections WHERE slug = 's5' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 7, 'What is CORS?'),
  ((SELECT id FROM public.sections WHERE slug = 's5' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 8, 'What is CSRF protection?'),
  ((SELECT id FROM public.sections WHERE slug = 's5' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 9, 'What is OAuth 2.0 and OpenID Connect? How do they differ?'),
  ((SELECT id FROM public.sections WHERE slug = 's5' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 10, 'What are refresh tokens and how do you implement them securely?'),
  ((SELECT id FROM public.sections WHERE slug = 's5' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 11, 'What are claims and claim-based identity in ASP.NET Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's5' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 12, 'How do you store sensitive configuration data using .NET Secrets?'),
  ((SELECT id FROM public.sections WHERE slug = 's5' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 13, 'What is HTTPS enforcement and HSTS in ASP.NET Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's5' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 14, 'What is SQL injection and how does EF Core protect against it?'),
  ((SELECT id FROM public.sections WHERE slug = 's5' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 15, 'Symmetric vs asymmetric encryption for JWT signing?')
ON CONFLICT DO NOTHING;

-- SECTION: 6️⃣ Web API Concepts
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = '_net'), 's6', '6️⃣ Web API Concepts', 6)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 's6' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 1, 'What is a Web API?'),
  ((SELECT id FROM public.sections WHERE slug = 's6' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 2, 'What are HTTP methods (GET, POST, PUT, DELETE, PATCH)?'),
  ((SELECT id FROM public.sections WHERE slug = 's6' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 3, 'What are HTTP status codes and what do they indicate?'),
  ((SELECT id FROM public.sections WHERE slug = 's6' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 4, 'What is REST architecture?'),
  ((SELECT id FROM public.sections WHERE slug = 's6' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 5, 'What is idempotent in REST APIs?'),
  ((SELECT id FROM public.sections WHERE slug = 's6' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 6, 'What are request and response models (DTOs)?'),
  ((SELECT id FROM public.sections WHERE slug = 's6' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 7, 'What is model validation?'),
  ((SELECT id FROM public.sections WHERE slug = 's6' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 8, 'What is versioning in Web API?'),
  ((SELECT id FROM public.sections WHERE slug = 's6' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 9, 'What is Swagger / OpenAPI?'),
  ((SELECT id FROM public.sections WHERE slug = 's6' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 10, 'What is content negotiation in Web API?'),
  ((SELECT id FROM public.sections WHERE slug = 's6' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 11, 'What is the Problem Details format (RFC 7807)?'),
  ((SELECT id FROM public.sections WHERE slug = 's6' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 12, 'How do you implement global exception handling in ASP.NET Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's6' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 13, 'What is API throttling and how do you implement it?'),
  ((SELECT id FROM public.sections WHERE slug = 's6' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 14, 'What is HATEOAS and is it required for a RESTful API?'),
  ((SELECT id FROM public.sections WHERE slug = 's6' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 15, 'Difference between REST and GraphQL?'),
  ((SELECT id FROM public.sections WHERE slug = 's6' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 16, 'What is gRPC and when would you choose it over REST?'),
  ((SELECT id FROM public.sections WHERE slug = 's6' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 17, 'How do you implement pagination, filtering, and sorting in a REST API?')
ON CONFLICT DO NOTHING;

-- SECTION: 7️⃣ Architecture & Design
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = '_net'), 's7', '7️⃣ Architecture & Design', 7)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 's7' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 1, 'What is Dependency Inversion Principle?'),
  ((SELECT id FROM public.sections WHERE slug = 's7' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 2, 'What are SOLID principles?'),
  ((SELECT id FROM public.sections WHERE slug = 's7' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 3, 'What is Repository Pattern?'),
  ((SELECT id FROM public.sections WHERE slug = 's7' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 4, 'What is Unit of Work pattern?'),
  ((SELECT id FROM public.sections WHERE slug = 's7' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 5, 'What is Service Layer and why use it?'),
  ((SELECT id FROM public.sections WHERE slug = 's7' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 6, 'Difference between layered and clean architecture?'),
  ((SELECT id FROM public.sections WHERE slug = 's7' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 7, 'What is middleware pipeline?'),
  ((SELECT id FROM public.sections WHERE slug = 's7' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 8, 'What is caching?'),
  ((SELECT id FROM public.sections WHERE slug = 's7' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 9, 'What are configuration providers in .NET Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's7' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 10, 'Difference between configuration, appsettings, and secrets.json?'),
  ((SELECT id FROM public.sections WHERE slug = 's7' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 11, 'What is CQRS?'),
  ((SELECT id FROM public.sections WHERE slug = 's7' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 12, 'What is Event Sourcing and how does it differ from CRUD?'),
  ((SELECT id FROM public.sections WHERE slug = 's7' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 13, 'What is Domain-Driven Design (DDD) and its core building blocks?'),
  ((SELECT id FROM public.sections WHERE slug = 's7' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 14, 'What is MediatR and why is it used in .NET applications?'),
  ((SELECT id FROM public.sections WHERE slug = 's7' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 15, 'What is the Specification pattern?'),
  ((SELECT id FROM public.sections WHERE slug = 's7' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 16, 'Difference between anemic and rich domain models?')
ON CONFLICT DO NOTHING;

-- SECTION: 8️⃣ Performance & Scalability
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = '_net'), 's8', '8️⃣ Performance & Scalability', 8)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 's8' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 1, 'What is logging and how do you implement it in .NET?'),
  ((SELECT id FROM public.sections WHERE slug = 's8' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 2, 'What is exception handling middleware?'),
  ((SELECT id FROM public.sections WHERE slug = 's8' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 3, 'What is scaling?'),
  ((SELECT id FROM public.sections WHERE slug = 's8' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 4, 'What is vertical scaling vs horizontal scaling?'),
  ((SELECT id FROM public.sections WHERE slug = 's8' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 5, 'What is load balancing?'),
  ((SELECT id FROM public.sections WHERE slug = 's8' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 6, 'What is connection pooling?'),
  ((SELECT id FROM public.sections WHERE slug = 's8' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 7, 'What is async I/O and why is it important for scalability?'),
  ((SELECT id FROM public.sections WHERE slug = 's8' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 8, 'What is memory leak and how to prevent it in .NET Core apps?'),
  ((SELECT id FROM public.sections WHERE slug = 's8' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 9, 'How does the .NET garbage collector work? Gen 0, Gen 1, Gen 2?'),
  ((SELECT id FROM public.sections WHERE slug = 's8' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 10, 'What is the Large Object Heap (LOH) and why can it cause fragmentation?'),
  ((SELECT id FROM public.sections WHERE slug = 's8' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 11, 'What is object pooling and when is it useful (e.g., ArrayPool<T>)?'),
  ((SELECT id FROM public.sections WHERE slug = 's8' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 12, 'How do you benchmark .NET code using BenchmarkDotNet?'),
  ((SELECT id FROM public.sections WHERE slug = 's8' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 13, 'What is response compression in ASP.NET Core?'),
  ((SELECT id FROM public.sections WHERE slug = 's8' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 14, 'What tools do you use to profile a .NET application?'),
  ((SELECT id FROM public.sections WHERE slug = 's8' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 15, 'What is a thread pool and how does .NET manage threads?')
ON CONFLICT DO NOTHING;

-- SECTION: 9️⃣ Testing & Tools
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = '_net'), 's9', '9️⃣ Testing & Tools', 9)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 's9' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 1, 'What is unit testing?'),
  ((SELECT id FROM public.sections WHERE slug = 's9' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 2, 'What is mocking?'),
  ((SELECT id FROM public.sections WHERE slug = 's9' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 3, 'Differences between xUnit, NUnit, and MSTest?'),
  ((SELECT id FROM public.sections WHERE slug = 's9' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 4, 'What is Test Driven Development (TDD)?'),
  ((SELECT id FROM public.sections WHERE slug = 's9' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 5, 'What is integration testing?'),
  ((SELECT id FROM public.sections WHERE slug = 's9' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 6, 'What is dependency injection in testing?'),
  ((SELECT id FROM public.sections WHERE slug = 's9' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 7, 'What is Moq and how do you use it to mock interfaces?'),
  ((SELECT id FROM public.sections WHERE slug = 's9' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 8, 'What is FluentAssertions and how does it improve test readability?'),
  ((SELECT id FROM public.sections WHERE slug = 's9' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 9, 'What is the Arrange-Act-Assert (AAA) pattern in unit testing?'),
  ((SELECT id FROM public.sections WHERE slug = 's9' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 10, 'Difference between a stub, mock, fake, and spy?'),
  ((SELECT id FROM public.sections WHERE slug = 's9' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 11, 'What is code coverage and what percentage should you target?'),
  ((SELECT id FROM public.sections WHERE slug = 's9' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 12, 'What is a test fixture and how do you share setup across tests in xUnit?'),
  ((SELECT id FROM public.sections WHERE slug = 's9' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 13, 'How do you test ASP.NET Core Web API endpoints using WebApplicationFactory?')
ON CONFLICT DO NOTHING;

-- SECTION: 🚀 Deployment & DevOps
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = '_net'), 's10', '🚀 Deployment & DevOps', 10)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 's10' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 1, 'What are environments in .NET Core (Development, Staging, Production)?'),
  ((SELECT id FROM public.sections WHERE slug = 's10' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 2, 'How do you deploy an ASP.NET Core app to IIS or Docker?'),
  ((SELECT id FROM public.sections WHERE slug = 's10' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 3, 'What is CI/CD pipeline?'),
  ((SELECT id FROM public.sections WHERE slug = 's10' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 4, 'What is containerization and why use Docker with .NET?'),
  ((SELECT id FROM public.sections WHERE slug = 's10' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 5, 'What are Kestrel and IIS and how do they interact?'),
  ((SELECT id FROM public.sections WHERE slug = 's10' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 6, 'What is a Dockerfile and how do you write one for a .NET Core app?'),
  ((SELECT id FROM public.sections WHERE slug = 's10' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 7, 'What is Docker Compose and when would you use it?'),
  ((SELECT id FROM public.sections WHERE slug = 's10' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 8, 'What is Kubernetes and what are pods, services, and deployments?'),
  ((SELECT id FROM public.sections WHERE slug = 's10' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 9, 'What are readiness and liveness probes in Kubernetes?'),
  ((SELECT id FROM public.sections WHERE slug = 's10' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 10, 'What is GitHub Actions and how do you set up a CI/CD workflow for .NET?'),
  ((SELECT id FROM public.sections WHERE slug = 's10' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 11, 'Difference between rolling deployment and blue-green deployment?'),
  ((SELECT id FROM public.sections WHERE slug = 's10' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 12, 'What is Infrastructure as Code (IaC) and what tools support it?')
ON CONFLICT DO NOTHING;

-- SECTION: 1️⃣1️⃣ LINQ & Collections
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = '_net'), 's11', '1️⃣1️⃣ LINQ & Collections', 11)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 's11' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 1, 'What is LINQ?'),
  ((SELECT id FROM public.sections WHERE slug = 's11' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 2, 'Difference between query syntax and method syntax in LINQ?'),
  ((SELECT id FROM public.sections WHERE slug = 's11' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 3, 'What is deferred execution vs immediate execution in LINQ?'),
  ((SELECT id FROM public.sections WHERE slug = 's11' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 4, 'Difference between IEnumerable<T> and IQueryable<T>?'),
  ((SELECT id FROM public.sections WHERE slug = 's11' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 5, 'What are the main LINQ operators: Select, Where, GroupBy, OrderBy, Join?'),
  ((SELECT id FROM public.sections WHERE slug = 's11' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 6, 'What is SelectMany() and when do you use it?'),
  ((SELECT id FROM public.sections WHERE slug = 's11' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 7, 'Difference between First(), FirstOrDefault(), Single(), SingleOrDefault()?'),
  ((SELECT id FROM public.sections WHERE slug = 's11' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 8, 'What is GroupJoin() and when is it used?'),
  ((SELECT id FROM public.sections WHERE slug = 's11' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 9, 'How do you perform a left outer join in LINQ?'),
  ((SELECT id FROM public.sections WHERE slug = 's11' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 10, 'What is the Aggregate() method and give an example?'),
  ((SELECT id FROM public.sections WHERE slug = 's11' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 11, 'What is Parallel LINQ (PLINQ) and when should you use it?'),
  ((SELECT id FROM public.sections WHERE slug = 's11' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 12, 'Difference between List<T>, LinkedList<T>, Queue<T>, Stack<T>, HashSet<T>?'),
  ((SELECT id FROM public.sections WHERE slug = 's11' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 13, 'When would you use SortedDictionary<K,V> vs SortedList<K,V>?'),
  ((SELECT id FROM public.sections WHERE slug = 's11' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 14, 'What is ConcurrentDictionary<TKey,TValue> and when do you use it?'),
  ((SELECT id FROM public.sections WHERE slug = 's11' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 15, 'Difference between Array, List<T>, and IEnumerable<T> in terms of performance?')
ON CONFLICT DO NOTHING;

-- SECTION: 1️⃣2️⃣ Design Patterns
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = '_net'), 's12', '1️⃣2️⃣ Design Patterns', 12)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 's12' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 1, 'What is the Singleton pattern (thread-safe in C#)?'),
  ((SELECT id FROM public.sections WHERE slug = 's12' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 2, 'What is the Factory Method pattern?'),
  ((SELECT id FROM public.sections WHERE slug = 's12' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 3, 'What is the Abstract Factory pattern?'),
  ((SELECT id FROM public.sections WHERE slug = 's12' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 4, 'What is the Builder pattern and when would you use it?'),
  ((SELECT id FROM public.sections WHERE slug = 's12' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 5, 'What is the Observer pattern and how does it relate to events and delegates?'),
  ((SELECT id FROM public.sections WHERE slug = 's12' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 6, 'What is the Strategy pattern?'),
  ((SELECT id FROM public.sections WHERE slug = 's12' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 7, 'What is the Decorator pattern? Give a real-world ASP.NET Core example.'),
  ((SELECT id FROM public.sections WHERE slug = 's12' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 8, 'What is the Command pattern?'),
  ((SELECT id FROM public.sections WHERE slug = 's12' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 9, 'What is the Mediator pattern and how does MediatR implement it?'),
  ((SELECT id FROM public.sections WHERE slug = 's12' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 10, 'What is the Repository pattern and its benefits and limitations?'),
  ((SELECT id FROM public.sections WHERE slug = 's12' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 11, 'What is the Unit of Work pattern and how does EF Core DbContext implement it?'),
  ((SELECT id FROM public.sections WHERE slug = 's12' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 12, 'What is the Specification pattern?'),
  ((SELECT id FROM public.sections WHERE slug = 's12' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 13, 'What is the Adapter pattern? Give an example.'),
  ((SELECT id FROM public.sections WHERE slug = 's12' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 14, 'What is the Proxy pattern and how is it used in .NET?'),
  ((SELECT id FROM public.sections WHERE slug = 's12' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 15, 'What is the Chain of Responsibility pattern?')
ON CONFLICT DO NOTHING;

-- SECTION: 1️⃣3️⃣ Modern C# (9-12)
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = '_net'), 's13', '1️⃣3️⃣ Modern C# (9-12)', 13)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 's13' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 1, 'What are records in C# 9 and how do they differ from classes?'),
  ((SELECT id FROM public.sections WHERE slug = 's13' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 2, 'What is the init accessor and when do you use it?'),
  ((SELECT id FROM public.sections WHERE slug = 's13' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 3, 'What are top-level statements in C# 9?'),
  ((SELECT id FROM public.sections WHERE slug = 's13' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 4, 'What are global using directives (C# 10) and file-scoped namespaces?'),
  ((SELECT id FROM public.sections WHERE slug = 's13' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 5, 'What are required members in C# 11?'),
  ((SELECT id FROM public.sections WHERE slug = 's13' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 6, 'What are raw string literals in C# 11?'),
  ((SELECT id FROM public.sections WHERE slug = 's13' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 7, 'What are primary constructors in C# 12?'),
  ((SELECT id FROM public.sections WHERE slug = 's13' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 8, 'What are collection expressions in C# 12?'),
  ((SELECT id FROM public.sections WHERE slug = 's13' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 9, 'What are positional records and deconstruction?'),
  ((SELECT id FROM public.sections WHERE slug = 's13' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 10, 'Difference between record, record struct, struct, and class?')
ON CONFLICT DO NOTHING;

-- SECTION: 1️⃣4️⃣ Memory Management & GC
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = '_net'), 's14', '1️⃣4️⃣ Memory Management & GC', 14)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 's14' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 1, 'How does garbage collection work in .NET?'),
  ((SELECT id FROM public.sections WHERE slug = 's14' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 2, 'What are Gen 0, Gen 1, and Gen 2 in the .NET GC?'),
  ((SELECT id FROM public.sections WHERE slug = 's14' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 3, 'What is the Large Object Heap (LOH) and Server GC vs Workstation GC?'),
  ((SELECT id FROM public.sections WHERE slug = 's14' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 4, 'What is the IDisposable pattern and the dispose/finalize pattern?'),
  ((SELECT id FROM public.sections WHERE slug = 's14' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 5, 'When should you implement a finalizer (~destructor) in C#?'),
  ((SELECT id FROM public.sections WHERE slug = 's14' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 6, 'How do you find and fix a memory leak in a .NET application?'),
  ((SELECT id FROM public.sections WHERE slug = 's14' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 7, 'What are weak references (WeakReference<T>) and when are they useful?'),
  ((SELECT id FROM public.sections WHERE slug = 's14' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 8, 'Difference between managed and unmanaged resources?'),
  ((SELECT id FROM public.sections WHERE slug = 's14' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 9, 'When should you call GC.Collect() and is it ever appropriate?'),
  ((SELECT id FROM public.sections WHERE slug = 's14' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 10, 'What are memory profiling tools for .NET?')
ON CONFLICT DO NOTHING;

-- SECTION: 1️⃣5️⃣ Microservices
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = '_net'), 's15', '1️⃣5️⃣ Microservices', 15)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 's15' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 1, 'What are microservices vs monolithic architecture?'),
  ((SELECT id FROM public.sections WHERE slug = 's15' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 2, 'What is service discovery and how do Consul or Kubernetes handle it?'),
  ((SELECT id FROM public.sections WHERE slug = 's15' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 3, 'What is an API Gateway pattern and what does it do?'),
  ((SELECT id FROM public.sections WHERE slug = 's15' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 4, 'What is the Circuit Breaker pattern and how does Polly implement it?'),
  ((SELECT id FROM public.sections WHERE slug = 's15' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 5, 'What is the Saga pattern for distributed transactions?'),
  ((SELECT id FROM public.sections WHERE slug = 's15' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 6, 'What is event-driven architecture vs synchronous REST?'),
  ((SELECT id FROM public.sections WHERE slug = 's15' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 7, 'Difference between RabbitMQ and Azure Service Bus?'),
  ((SELECT id FROM public.sections WHERE slug = 's15' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 8, 'What is eventual consistency and how do you handle it?'),
  ((SELECT id FROM public.sections WHERE slug = 's15' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 9, 'What is the Outbox pattern and why is it important?'),
  ((SELECT id FROM public.sections WHERE slug = 's15' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 10, 'What is gRPC and when would you use it over REST in microservices?'),
  ((SELECT id FROM public.sections WHERE slug = 's15' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 11, 'How do you handle distributed logging and tracing (OpenTelemetry, Jaeger)?'),
  ((SELECT id FROM public.sections WHERE slug = 's15' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 12, 'What is a health check endpoint and why does every microservice need one?'),
  ((SELECT id FROM public.sections WHERE slug = 's15' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 13, 'How do you version microservices APIs without breaking consumers?'),
  ((SELECT id FROM public.sections WHERE slug = 's15' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 14, 'What is the bulkhead pattern and why does it improve resilience?'),
  ((SELECT id FROM public.sections WHERE slug = 's15' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 15, 'How do you implement idempotency in message consumers?')
ON CONFLICT DO NOTHING;

-- SECTION: 1️⃣6️⃣ Real-World Scenarios
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = '_net'), 's16', '1️⃣6️⃣ Real-World Scenarios', 16)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 's16' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 1, 'How would you design a high-throughput .NET API handling 10,000 req/sec?'),
  ((SELECT id FROM public.sections WHERE slug = 's16' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 2, 'A production ASP.NET Core API is responding slowly (5s+). Walk through your diagnosis.'),
  ((SELECT id FROM public.sections WHERE slug = 's16' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 3, 'How would you implement a background job resilient to application restarts?'),
  ((SELECT id FROM public.sections WHERE slug = 's16' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 4, 'How would you handle concurrent updates to a shared resource in a .NET Web API?'),
  ((SELECT id FROM public.sections WHERE slug = 's16' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 5, 'How would you implement a file upload endpoint with progress tracking and validation?'),
  ((SELECT id FROM public.sections WHERE slug = 's16' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 6, 'How would you design a caching layer for a frequently accessed database table?'),
  ((SELECT id FROM public.sections WHERE slug = 's16' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 7, 'How would you implement real-time notifications in an ASP.NET Core app?'),
  ((SELECT id FROM public.sections WHERE slug = 's16' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 8, 'How do you handle database connection exhaustion in a high-load app?'),
  ((SELECT id FROM public.sections WHERE slug = 's16' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 9, 'How would you implement multi-tenancy in an ASP.NET Core application?'),
  ((SELECT id FROM public.sections WHERE slug = 's16' AND topic_id = (SELECT id FROM public.topics WHERE slug = '_net')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 10, 'How do you ensure data consistency across multiple microservices during a saga?')
ON CONFLICT DO NOTHING;

-- TOPIC: JavaScript / TS
INSERT INTO public.topics (slug, label, color_hex, display_order) VALUES
  ('javascript', 'JavaScript / TS', '#fbbf24', 2)
ON CONFLICT (slug) DO NOTHING;


-- SECTION: 🔹 JS Basics
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'javascript'), 'js1', '🔹 JS Basics', 1)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'js1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 1, 'What are var, let, and const?'),
  ((SELECT id FROM public.sections WHERE slug = 'js1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 2, 'Difference between == and ===?'),
  ((SELECT id FROM public.sections WHERE slug = 'js1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 3, 'What are primitive and non-primitive data types in JS?'),
  ((SELECT id FROM public.sections WHERE slug = 'js1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 4, 'What is hoisting in JavaScript?'),
  ((SELECT id FROM public.sections WHERE slug = 'js1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 5, 'What are closures?'),
  ((SELECT id FROM public.sections WHERE slug = 'js1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 6, 'Difference between null, undefined, and NaN?'),
  ((SELECT id FROM public.sections WHERE slug = 'js1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 7, 'What is the scope of a variable in JavaScript?'),
  ((SELECT id FROM public.sections WHERE slug = 'js1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 8, 'Difference between function declaration and expression?'),
  ((SELECT id FROM public.sections WHERE slug = 'js1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 9, 'What is an arrow function and how is it different from a regular function?'),
  ((SELECT id FROM public.sections WHERE slug = 'js1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 10, 'What is a callback function?'),
  ((SELECT id FROM public.sections WHERE slug = 'js1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 11, 'What is the typeof operator and its possible return values?'),
  ((SELECT id FROM public.sections WHERE slug = 'js1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 12, 'What is type coercion in JavaScript? Give an example of implicit coercion.'),
  ((SELECT id FROM public.sections WHERE slug = 'js1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 13, 'What is the Temporal Dead Zone (TDZ) in JavaScript?'),
  ((SELECT id FROM public.sections WHERE slug = 'js1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 14, 'What is an IIFE and when is it useful?'),
  ((SELECT id FROM public.sections WHERE slug = 'js1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 15, 'Difference between pass-by-value and pass-by-reference in JavaScript?')
ON CONFLICT DO NOTHING;

-- SECTION: 🔹 JS Intermediate
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'javascript'), 'js2', '🔹 JS Intermediate', 2)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'js2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 1, 'What is the event loop in JavaScript?'),
  ((SELECT id FROM public.sections WHERE slug = 'js2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 2, 'Explain async/await and Promises.'),
  ((SELECT id FROM public.sections WHERE slug = 'js2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 3, 'What are higher-order functions?'),
  ((SELECT id FROM public.sections WHERE slug = 'js2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 4, 'Difference between synchronous and asynchronous code?'),
  ((SELECT id FROM public.sections WHERE slug = 'js2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 5, 'What are ES6 features (destructuring, template literals, spread/rest)?'),
  ((SELECT id FROM public.sections WHERE slug = 'js2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 6, 'Explain the this keyword in JavaScript.'),
  ((SELECT id FROM public.sections WHERE slug = 'js2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 7, 'What are modules in JavaScript (import/export)?'),
  ((SELECT id FROM public.sections WHERE slug = 'js2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 8, 'What are pure and impure functions?'),
  ((SELECT id FROM public.sections WHERE slug = 'js2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 9, 'What is memoization?'),
  ((SELECT id FROM public.sections WHERE slug = 'js2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 10, 'What is debouncing and throttling?'),
  ((SELECT id FROM public.sections WHERE slug = 'js2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 11, 'Difference between call(), apply(), and bind()?'),
  ((SELECT id FROM public.sections WHERE slug = 'js2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 12, 'What is the Symbol data type and why would you use it?'),
  ((SELECT id FROM public.sections WHERE slug = 'js2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 13, 'How does JavaScript handle error handling (try/catch/finally/throw)?'),
  ((SELECT id FROM public.sections WHERE slug = 'js2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 14, 'Difference between Promise.all(), Promise.race(), Promise.allSettled(), and Promise.any()?'),
  ((SELECT id FROM public.sections WHERE slug = 'js2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 15, 'What are ES2022+ features (optional chaining ?., nullish coalescing ??, logical assignment ||=)?')
ON CONFLICT DO NOTHING;

-- SECTION: 🔹 JS Advanced
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'javascript'), 'js3', '🔹 JS Advanced', 3)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'js3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 1, 'Difference between shallow copy and deep copy?'),
  ((SELECT id FROM public.sections WHERE slug = 'js3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 2, 'Explain prototypal inheritance.'),
  ((SELECT id FROM public.sections WHERE slug = 'js3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 3, 'What is event bubbling and event capturing?'),
  ((SELECT id FROM public.sections WHERE slug = 'js3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 4, 'What are WeakMap and WeakSet?'),
  ((SELECT id FROM public.sections WHERE slug = 'js3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 5, 'What are generators in JS?'),
  ((SELECT id FROM public.sections WHERE slug = 'js3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 6, 'Difference between map(), forEach(), filter(), and reduce()?'),
  ((SELECT id FROM public.sections WHERE slug = 'js3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 7, 'Explain the concept of currying in JavaScript.'),
  ((SELECT id FROM public.sections WHERE slug = 'js3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 8, 'How does JavaScript handle memory management?'),
  ((SELECT id FROM public.sections WHERE slug = 'js3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 9, 'What are service workers?'),
  ((SELECT id FROM public.sections WHERE slug = 'js3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 10, 'What are WebSockets and how do they differ from HTTP?'),
  ((SELECT id FROM public.sections WHERE slug = 'js3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 11, 'Difference between microtasks and macrotasks in the event loop?'),
  ((SELECT id FROM public.sections WHERE slug = 'js3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 12, 'What is a Proxy object in JavaScript and give a real-world use case?'),
  ((SELECT id FROM public.sections WHERE slug = 'js3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 13, 'What is structural sharing / immutability and why does it matter?'),
  ((SELECT id FROM public.sections WHERE slug = 'js3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 14, 'What are JavaScript iterators and the iterable protocol?'),
  ((SELECT id FROM public.sections WHERE slug = 'js3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 15, 'What is tail call optimization (TCO) in JavaScript?')
ON CONFLICT DO NOTHING;

-- SECTION: 🔷 TypeScript Basics
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'javascript'), 'ts1', '🔷 TypeScript Basics', 4)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'ts1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 1, 'What is TypeScript and why use it over JavaScript?'),
  ((SELECT id FROM public.sections WHERE slug = 'ts1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 2, 'What are TypeScript''s basic types (string, number, boolean, any, unknown, never, void)?'),
  ((SELECT id FROM public.sections WHERE slug = 'ts1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 3, 'What is type inference in TypeScript?'),
  ((SELECT id FROM public.sections WHERE slug = 'ts1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 4, 'Difference between a type alias and an interface?'),
  ((SELECT id FROM public.sections WHERE slug = 'ts1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 5, 'What are union types and intersection types?'),
  ((SELECT id FROM public.sections WHERE slug = 'ts1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 6, 'What are generics in TypeScript and why are they useful?'),
  ((SELECT id FROM public.sections WHERE slug = 'ts1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 7, 'Difference between any and unknown in TypeScript?'),
  ((SELECT id FROM public.sections WHERE slug = 'ts1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 8, 'What are enums in TypeScript and what are their pitfalls?'),
  ((SELECT id FROM public.sections WHERE slug = 'ts1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 9, 'What is TypeScript strict mode and which checks does it enable?'),
  ((SELECT id FROM public.sections WHERE slug = 'ts1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 10, 'What are optional properties and readonly properties in TypeScript?')
ON CONFLICT DO NOTHING;

-- SECTION: 🔷 TypeScript Advanced
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'javascript'), 'ts2', '🔷 TypeScript Advanced', 5)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'ts2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 1, 'What are utility types in TypeScript (Partial, Required, Pick, Omit, Record, Exclude)?'),
  ((SELECT id FROM public.sections WHERE slug = 'ts2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 2, 'What are conditional types in TypeScript?'),
  ((SELECT id FROM public.sections WHERE slug = 'ts2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 3, 'What are mapped types?'),
  ((SELECT id FROM public.sections WHERE slug = 'ts2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 4, 'What is the infer keyword in TypeScript?'),
  ((SELECT id FROM public.sections WHERE slug = 'ts2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 5, 'What are template literal types?'),
  ((SELECT id FROM public.sections WHERE slug = 'ts2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 6, 'What are discriminated unions and how do you use them for exhaustive checks?'),
  ((SELECT id FROM public.sections WHERE slug = 'ts2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 7, 'What is declaration merging in TypeScript?'),
  ((SELECT id FROM public.sections WHERE slug = 'ts2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 8, 'Difference between interface extends and type intersection (&)?'),
  ((SELECT id FROM public.sections WHERE slug = 'ts2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 9, 'How do you type third-party libraries that lack TypeScript definitions (@types)?'),
  ((SELECT id FROM public.sections WHERE slug = 'ts2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 10, 'What are module augmentation and ambient declarations?')
ON CONFLICT DO NOTHING;

-- SECTION: 🧪 Real-World Problems
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'javascript'), 'js4', '🧪 Real-World Problems', 6)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'js4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 1, 'Implement a debounce function from scratch.'),
  ((SELECT id FROM public.sections WHERE slug = 'js4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 2, 'Implement a throttle function from scratch.'),
  ((SELECT id FROM public.sections WHERE slug = 'js4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 3, 'How would you deep clone an object without using JSON.parse/stringify?'),
  ((SELECT id FROM public.sections WHERE slug = 'js4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 4, 'How would you flatten a deeply nested array without recursion?'),
  ((SELECT id FROM public.sections WHERE slug = 'js4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 5, 'Implement a retry mechanism that retries a failed async function N times with delay.'),
  ((SELECT id FROM public.sections WHERE slug = 'js4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 6, 'What is the output of [1,2,3].map(parseInt)? Explain why.'),
  ((SELECT id FROM public.sections WHERE slug = 'js4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 7, 'Implement a simple observable / event emitter class.'),
  ((SELECT id FROM public.sections WHERE slug = 'js4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 8, 'How would you implement memoization for a function with multiple arguments?'),
  ((SELECT id FROM public.sections WHERE slug = 'js4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 9, 'Explain and fix the classic loop-closure-in-setTimeout bug.'),
  ((SELECT id FROM public.sections WHERE slug = 'js4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'javascript')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 10, 'How would you detect if a value is a plain object (not array, Date, Map, etc.)?')
ON CONFLICT DO NOTHING;

-- TOPIC: React
INSERT INTO public.topics (slug, label, color_hex, display_order) VALUES
  ('react', 'React', '#38bdf8', 3)
ON CONFLICT (slug) DO NOTHING;


-- SECTION: 🔹 React Basics
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'react'), 'r1', '🔹 React Basics', 1)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'r1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 1, 'What is React and why is it used?'),
  ((SELECT id FROM public.sections WHERE slug = 'r1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 2, 'What are components in React?'),
  ((SELECT id FROM public.sections WHERE slug = 'r1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 3, 'What is JSX?'),
  ((SELECT id FROM public.sections WHERE slug = 'r1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 4, 'Difference between functional and class components?'),
  ((SELECT id FROM public.sections WHERE slug = 'r1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 5, 'What is the Virtual DOM and how does React use it?'),
  ((SELECT id FROM public.sections WHERE slug = 'r1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 6, 'What are props and state in React?'),
  ((SELECT id FROM public.sections WHERE slug = 'r1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 7, 'Difference between state and props?'),
  ((SELECT id FROM public.sections WHERE slug = 'r1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 8, 'How do you handle events in React?'),
  ((SELECT id FROM public.sections WHERE slug = 'r1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 9, 'What are controlled and uncontrolled components?'),
  ((SELECT id FROM public.sections WHERE slug = 'r1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 10, 'What is the purpose of key in React lists?'),
  ((SELECT id FROM public.sections WHERE slug = 'r1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 11, 'What is the React rendering lifecycle?'),
  ((SELECT id FROM public.sections WHERE slug = 'r1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 12, 'What is React StrictMode and what does it help catch?'),
  ((SELECT id FROM public.sections WHERE slug = 'r1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 13, 'Difference between CSR and SSR?'),
  ((SELECT id FROM public.sections WHERE slug = 'r1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 14, 'What are default props and prop types validation?'),
  ((SELECT id FROM public.sections WHERE slug = 'r1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 15, 'How does React handle forms and what is a controlled form?')
ON CONFLICT DO NOTHING;

-- SECTION: 🔹 React Intermediate
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'react'), 'r2', '🔹 React Intermediate', 2)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'r2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 1, 'What are hooks in React?'),
  ((SELECT id FROM public.sections WHERE slug = 'r2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 2, 'Explain useState, useEffect, and useRef.'),
  ((SELECT id FROM public.sections WHERE slug = 'r2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 3, 'What is useMemo and useCallback?'),
  ((SELECT id FROM public.sections WHERE slug = 'r2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 4, 'Difference between Context API and Redux?'),
  ((SELECT id FROM public.sections WHERE slug = 'r2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 5, 'What is React Router and how does navigation work?'),
  ((SELECT id FROM public.sections WHERE slug = 'r2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 6, 'What is lazy loading in React?'),
  ((SELECT id FROM public.sections WHERE slug = 'r2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 7, 'Difference between useLayoutEffect and useEffect?'),
  ((SELECT id FROM public.sections WHERE slug = 'r2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 8, 'What is React reconciliation?'),
  ((SELECT id FROM public.sections WHERE slug = 'r2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 9, 'What are portals in React?'),
  ((SELECT id FROM public.sections WHERE slug = 'r2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 10, 'What are fragments in React?'),
  ((SELECT id FROM public.sections WHERE slug = 'r2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 11, 'What is useReducer and when should you use it instead of useState?'),
  ((SELECT id FROM public.sections WHERE slug = 'r2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 12, 'What is useContext hook and how do you use it?'),
  ((SELECT id FROM public.sections WHERE slug = 'r2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 13, 'What is useImperativeHandle and when would you use it?'),
  ((SELECT id FROM public.sections WHERE slug = 'r2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 14, 'What is React.forwardRef?'),
  ((SELECT id FROM public.sections WHERE slug = 'r2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 15, 'What is the dependency array in useEffect and what happens with an empty array?')
ON CONFLICT DO NOTHING;

-- SECTION: 🔹 React Advanced
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'react'), 'r3', '🔹 React Advanced', 3)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'r3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 1, 'What is server-side rendering (SSR) in React?'),
  ((SELECT id FROM public.sections WHERE slug = 'r3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 2, 'What is hydration in React 18?'),
  ((SELECT id FROM public.sections WHERE slug = 'r3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 3, 'What are Suspense and concurrent rendering?'),
  ((SELECT id FROM public.sections WHERE slug = 'r3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 4, 'What are error boundaries?'),
  ((SELECT id FROM public.sections WHERE slug = 'r3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 5, 'What is Redux middleware (like thunk or saga)?'),
  ((SELECT id FROM public.sections WHERE slug = 'r3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 6, 'How do you optimize React app performance?'),
  ((SELECT id FROM public.sections WHERE slug = 'r3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 7, 'What is memoization in React (React.memo)?'),
  ((SELECT id FROM public.sections WHERE slug = 'r3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 8, 'What is a custom hook?'),
  ((SELECT id FROM public.sections WHERE slug = 'r3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 9, 'What is prop drilling and how do you avoid it?'),
  ((SELECT id FROM public.sections WHERE slug = 'r3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 10, 'How do you handle authentication in React?'),
  ((SELECT id FROM public.sections WHERE slug = 'r3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 11, 'What is React 18''s concurrent mode and what problems does it solve?'),
  ((SELECT id FROM public.sections WHERE slug = 'r3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 12, 'What are useTransition and useDeferredValue hooks?'),
  ((SELECT id FROM public.sections WHERE slug = 'r3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 13, 'What are React Server Components and how do they differ from client components?'),
  ((SELECT id FROM public.sections WHERE slug = 'r3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 14, 'What is automatic batching in React 18?'),
  ((SELECT id FROM public.sections WHERE slug = 'r3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 15, 'What is the new root API (createRoot) vs ReactDOM.render?')
ON CONFLICT DO NOTHING;

-- SECTION: 🎯 Patterns & Best Practices
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'react'), 'r4', '🎯 Patterns & Best Practices', 4)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'r4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 1, 'What is a Higher-Order Component (HOC) and when should you use it?'),
  ((SELECT id FROM public.sections WHERE slug = 'r4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 2, 'What is the Render Props pattern and when is it appropriate?'),
  ((SELECT id FROM public.sections WHERE slug = 'r4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 3, 'What is the Compound Component pattern? Give an example.'),
  ((SELECT id FROM public.sections WHERE slug = 'r4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 4, 'What is the Container/Presentational component pattern?'),
  ((SELECT id FROM public.sections WHERE slug = 'r4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 5, 'What is React.memo and when should you actually apply it?'),
  ((SELECT id FROM public.sections WHERE slug = 'r4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 6, 'What is the children prop and how is it used for flexible composition?'),
  ((SELECT id FROM public.sections WHERE slug = 'r4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 7, 'What is the Provider pattern in React and when do you need it?'),
  ((SELECT id FROM public.sections WHERE slug = 'r4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 8, 'What is React.forwardRef and when do you need it?'),
  ((SELECT id FROM public.sections WHERE slug = 'r4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 9, 'What is the Flux architecture pattern?'),
  ((SELECT id FROM public.sections WHERE slug = 'r4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 10, 'What are code splitting and dynamic import() in React?')
ON CONFLICT DO NOTHING;

-- SECTION: 🗂️ State Management
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'react'), 'r5', '🗂️ State Management', 5)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'r5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 1, 'What is Redux and its three core principles (store, action, reducer)?'),
  ((SELECT id FROM public.sections WHERE slug = 'r5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 2, 'What is Redux Toolkit (RTK) and how does it simplify Redux boilerplate?'),
  ((SELECT id FROM public.sections WHERE slug = 'r5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 3, 'What is Zustand and how does it compare to Redux?'),
  ((SELECT id FROM public.sections WHERE slug = 'r5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 4, 'What is React Query (TanStack Query) and when should you use it?'),
  ((SELECT id FROM public.sections WHERE slug = 'r5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 5, 'What are the limitations of the Context API for global state?'),
  ((SELECT id FROM public.sections WHERE slug = 'r5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 6, 'What is Jotai or Recoil and how are they different from Redux?'),
  ((SELECT id FROM public.sections WHERE slug = 'r5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 7, 'What are selectors in state management and why do they improve performance?'),
  ((SELECT id FROM public.sections WHERE slug = 'r5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 8, 'Difference between local, shared, and global state?'),
  ((SELECT id FROM public.sections WHERE slug = 'r5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 9, 'How do you handle asynchronous state updates in Redux (thunk vs saga)?'),
  ((SELECT id FROM public.sections WHERE slug = 'r5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 10, 'How do you decide between useState, useReducer, Context, and a state library?')
ON CONFLICT DO NOTHING;

-- SECTION: 🌐 React Real-World
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'react'), 'r6', '🌐 React Real-World', 6)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'r6' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 1, 'How would you implement infinite scroll in React?'),
  ((SELECT id FROM public.sections WHERE slug = 'r6' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 2, 'How would you handle complex form validation in React?'),
  ((SELECT id FROM public.sections WHERE slug = 'r6' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 3, 'How would you optimize a React list rendering 10,000 items (virtual list)?'),
  ((SELECT id FROM public.sections WHERE slug = 'r6' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 4, 'How would you implement protected routes and authentication in React Router?'),
  ((SELECT id FROM public.sections WHERE slug = 'r6' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 5, 'How would you structure a large-scale React application?'),
  ((SELECT id FROM public.sections WHERE slug = 'r6' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 6, 'How would you handle real-time data updates in a React app (WebSocket, SSE)?'),
  ((SELECT id FROM public.sections WHERE slug = 'r6' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 7, 'How would you implement drag-and-drop in React?'),
  ((SELECT id FROM public.sections WHERE slug = 'r6' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'react')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 8, 'How would you add accessibility (a11y) features to a React component?')
ON CONFLICT DO NOTHING;

-- TOPIC: SQL
INSERT INTO public.topics (slug, label, color_hex, display_order) VALUES
  ('sql', 'SQL', '#34d399', 4)
ON CONFLICT (slug) DO NOTHING;


-- SECTION: 🔹 SQL Basics
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'sql'), 'sq1', '🔹 SQL Basics', 1)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'sq1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 1, 'What is SQL and what are its types of statements (DDL, DML, DCL, TCL)?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 2, 'Difference between CHAR and VARCHAR?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 3, 'What are primary key, foreign key, and unique key?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 4, 'What is a constraint in SQL?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 5, 'Difference between DELETE, TRUNCATE, and DROP?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 6, 'What is a JOIN? Types of joins?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 7, 'What is normalization and its types?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 8, 'What is a subquery?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 9, 'What is a view?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 10, 'What is an index and why is it used?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 11, 'Difference between WHERE and HAVING clauses?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 12, 'What is the DISTINCT keyword and when should you use it?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 13, 'What is SQL injection and how do you prevent it?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 14, 'What is the CASE WHEN statement and give a use case?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'basic'), 15, 'Difference between UNION and UNION ALL?')
ON CONFLICT DO NOTHING;

-- SECTION: 🔹 SQL Intermediate
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'sql'), 'sq2', '🔹 SQL Intermediate', 2)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'sq2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 1, 'What are stored procedures and functions?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 2, 'What are triggers?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 3, 'Difference between clustered and non-clustered index?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 4, 'Difference between INNER JOIN and LEFT JOIN?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 5, 'What is GROUP BY and HAVING?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 6, 'What are window functions (ROW_NUMBER(), RANK(), DENSE_RANK())?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 7, 'What is a CTE (Common Table Expression)?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 8, 'What are transactions and ACID properties?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 9, 'What are aggregate functions in SQL?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 10, 'How to handle NULL values in SQL?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 11, 'What are PIVOT and UNPIVOT operations in SQL?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 12, 'What is a recursive CTE and give a use case (e.g., org hierarchy)?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 13, 'What is the MERGE statement and when do you use it?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 14, 'Difference between CROSS JOIN and FULL OUTER JOIN?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 15, 'What are covering indexes and why do they improve query performance?')
ON CONFLICT DO NOTHING;

-- SECTION: 🔹 SQL Advanced
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'sql'), 'sq3', '🔹 SQL Advanced', 3)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'sq3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 1, 'What is query optimization and indexing strategy?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 2, 'How does SQL execution plan work?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 3, 'What are cursors in SQL and when to use them?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 4, 'Difference between temporary tables and table variables?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 5, 'How do you handle deadlocks in SQL Server/PostgreSQL?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 6, 'What are materialized views?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 7, 'How to implement pagination in SQL?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 8, 'How to improve performance of a slow query?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 9, 'What is partitioning in SQL?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 10, 'What are database transactions isolation levels?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 11, 'What is dynamic SQL and when should you use it?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 12, 'Difference between optimistic and pessimistic locking?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 13, 'What are filtered indexes (partial indexes in PostgreSQL)?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 14, 'What are column store indexes and when do they outperform row store?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 15, 'How do you use EXPLAIN / EXPLAIN ANALYZE to diagnose a slow query?')
ON CONFLICT DO NOTHING;

-- SECTION: ✏️ Query Writing
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'sql'), 'sq4', '✏️ Query Writing', 4)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'sq4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 1, 'Write a query to find the second highest salary from an Employee table.'),
  ((SELECT id FROM public.sections WHERE slug = 'sq4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 2, 'Write a query to find all duplicate records in a table.'),
  ((SELECT id FROM public.sections WHERE slug = 'sq4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 3, 'Write a query to find employees who earn more than the average salary.'),
  ((SELECT id FROM public.sections WHERE slug = 'sq4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 4, 'Write a query that shows each department''s name and employee count.'),
  ((SELECT id FROM public.sections WHERE slug = 'sq4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 5, 'Write a query to find the top 3 highest-paid employees per department using window functions.'),
  ((SELECT id FROM public.sections WHERE slug = 'sq4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 6, 'Write a query to compute the running cumulative total of sales ordered by date.'),
  ((SELECT id FROM public.sections WHERE slug = 'sq4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 7, 'Write a query to find employees who have no manager.'),
  ((SELECT id FROM public.sections WHERE slug = 'sq4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 8, 'Write a query to find all products that have never been ordered.'),
  ((SELECT id FROM public.sections WHERE slug = 'sq4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 9, 'Write a query to find employees who joined in the last 30 days.'),
  ((SELECT id FROM public.sections WHERE slug = 'sq4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 10, 'Write a query to delete duplicate rows while keeping the one with the lowest ID.'),
  ((SELECT id FROM public.sections WHERE slug = 'sq4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 11, 'Write a query to calculate month-over-month revenue growth as a percentage.'),
  ((SELECT id FROM public.sections WHERE slug = 'sq4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 12, 'Write a query to return the Nth highest value from a column.'),
  ((SELECT id FROM public.sections WHERE slug = 'sq4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 13, 'Write a query using a recursive CTE to display a full org-chart hierarchy.'),
  ((SELECT id FROM public.sections WHERE slug = 'sq4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 14, 'Write a query to transpose rows into columns (manual PIVOT).'),
  ((SELECT id FROM public.sections WHERE slug = 'sq4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 15, 'Write a query to find the median salary from an Employee table.')
ON CONFLICT DO NOTHING;

-- SECTION: 🗄️ Database Design
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'sql'), 'sq5', '🗄️ Database Design', 5)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'sq5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 1, 'How would you design a database schema for an e-commerce application?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 2, 'What is normalization and when would you intentionally denormalize for performance?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 3, 'What is an Entity-Relationship (ER) diagram and what are its components?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 4, 'How do you model a many-to-many relationship in SQL?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 5, 'What is a self-referencing (recursive) table? Give a real example.'),
  ((SELECT id FROM public.sections WHERE slug = 'sq5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 6, 'What are surrogate keys vs natural keys and which do you prefer?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 7, 'How do you implement soft deletes in a database? What are the trade-offs?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 8, 'How do you implement an audit log in a database?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 9, 'How would you design a database schema for a multi-tenant SaaS application?'),
  ((SELECT id FROM public.sections WHERE slug = 'sq5' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'sql')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 10, 'What is OLTP vs OLAP and how does their schema design differ?')
ON CONFLICT DO NOTHING;

-- TOPIC: System Design
INSERT INTO public.topics (slug, label, color_hex, display_order) VALUES
  ('system_design', 'System Design', '#fb923c', 5)
ON CONFLICT (slug) DO NOTHING;


-- SECTION: 🏗️ Core Concepts
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'system_design'), 'sd1', '🏗️ Core Concepts', 1)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'sd1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 1, 'What is scalability? Horizontal vs vertical scaling?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 2, 'What is the CAP theorem?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 3, 'What is eventual consistency vs strong consistency?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 4, 'What is a load balancer and what load-balancing strategies exist?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 5, 'What is a CDN and when do you need one?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 6, 'What is a message queue and when would you use one over synchronous HTTP calls?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 7, 'What are caching strategies (cache-aside, write-through, write-behind, read-through)?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 8, 'What is database sharding and what problems does it introduce?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 9, 'What is database replication (master-slave, multi-master)?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 10, 'What is a reverse proxy and how does it differ from a forward proxy?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 11, 'What are stateless vs stateful services? Why does statelessness aid scaling?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 12, 'Difference between SQL and NoSQL databases? When do you choose each?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 13, 'What is rate limiting and what algorithms are used?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 14, 'What is a service mesh and what problems does it solve?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 15, 'What are consistency patterns and read-your-writes guarantees?')
ON CONFLICT DO NOTHING;

-- SECTION: 🔗 Microservices & Distributed
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'system_design'), 'sd2', '🔗 Microservices & Distributed', 2)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'sd2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 1, 'What are the main benefits and drawbacks of microservices vs monolith?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 2, 'What is service discovery (client-side vs server-side)?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 3, 'What is the API Gateway pattern?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 4, 'What is the Circuit Breaker pattern and what states does it have?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 5, 'What is the Saga pattern for distributed transactions?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 6, 'What is the CQRS pattern and why is it often paired with Event Sourcing?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 7, 'What is Event Sourcing and what are its pros and cons?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 8, 'What is the Outbox pattern and why is it needed?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 9, 'What is idempotency in distributed systems and how do you implement it?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 10, 'What is the bulkhead pattern?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 11, 'What are blue-green deployments and canary releases?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 12, 'What is a sidecar pattern in Kubernetes?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 13, 'What is two-phase commit (2PC) and why is it rarely used in microservices?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 14, 'What is service versioning and what strategies exist?'),
  ((SELECT id FROM public.sections WHERE slug = 'sd2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'advanced'), 15, 'What is distributed tracing and how do OpenTelemetry and Jaeger work?')
ON CONFLICT DO NOTHING;

-- SECTION: 💡 Design Problems
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'system_design'), 'sd3', '💡 Design Problems', 3)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'sd3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 1, 'Design a URL shortener (like bit.ly).'),
  ((SELECT id FROM public.sections WHERE slug = 'sd3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 2, 'Design a rate limiter that works across multiple API servers.'),
  ((SELECT id FROM public.sections WHERE slug = 'sd3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 3, 'Design a notification service that can send push, email, and SMS notifications.'),
  ((SELECT id FROM public.sections WHERE slug = 'sd3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 4, 'Design a real-time chat application.'),
  ((SELECT id FROM public.sections WHERE slug = 'sd3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 5, 'Design a job scheduling system with retry and monitoring.'),
  ((SELECT id FROM public.sections WHERE slug = 'sd3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 6, 'Design an e-commerce shopping cart.'),
  ((SELECT id FROM public.sections WHERE slug = 'sd3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 7, 'Design an authentication and authorization service (OAuth2 / JWT).'),
  ((SELECT id FROM public.sections WHERE slug = 'sd3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 8, 'Design a large-scale file upload and download service.'),
  ((SELECT id FROM public.sections WHERE slug = 'sd3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 9, 'Design a distributed caching system (like a Redis cluster).'),
  ((SELECT id FROM public.sections WHERE slug = 'sd3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'system_design')), (SELECT id FROM public.difficulty_levels WHERE slug = 'scenario'), 10, 'Design a search autocomplete feature.')
ON CONFLICT DO NOTHING;

-- TOPIC: DSA / Coding
INSERT INTO public.topics (slug, label, color_hex, display_order) VALUES
  ('dsa', 'DSA / Coding', '#c084fc', 6)
ON CONFLICT (slug) DO NOTHING;


-- SECTION: 📊 Arrays & Strings
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'dsa'), 'dsa1', '📊 Arrays & Strings', 1)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'dsa1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 1, 'Two Sum: find two indices in an array whose values sum to a target.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 2, 'Maximum subarray sum – explain and implement Kadane''s algorithm.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 3, 'Rotate an array to the right by k positions.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 4, 'Check if a string is a palindrome (ignoring spaces and case).'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 5, 'Find the duplicate number in an array of n+1 integers in the range [1..n].'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 6, 'Merge two sorted arrays into one sorted array.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 7, 'Find the missing number in an array containing [1..n] with one missing.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 8, 'Move all zeros to the end of an array while preserving relative order.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 9, 'Product of Array Except Self – without using division.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 10, 'Longest substring without repeating characters. (Sliding window approach)')
ON CONFLICT DO NOTHING;

-- SECTION: 🌳 Linked Lists & Trees
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'dsa'), 'dsa2', '🌳 Linked Lists & Trees', 2)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'dsa2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 1, 'Reverse a singly linked list (iterative and recursive).'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 2, 'Detect a cycle in a linked list – Floyd''s cycle detection algorithm.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 3, 'Find the middle node of a linked list in a single pass.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 4, 'Merge two sorted linked lists into one sorted list.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 5, 'Given a BST, implement insert, search, and delete.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 6, 'Level-order (BFS) traversal of a binary tree.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 7, 'Check if a binary tree is balanced (heights differ by at most 1).'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 8, 'Find the Lowest Common Ancestor (LCA) of two nodes in a BST.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 9, 'Serialize and deserialize a binary tree.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 10, 'Find the maximum depth of a binary tree.')
ON CONFLICT DO NOTHING;

-- SECTION: 🔢 Sorting & Searching
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'dsa'), 'dsa3', '🔢 Sorting & Searching', 3)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'dsa3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 1, 'Implement binary search on a sorted array.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 2, 'Explain and implement quick sort with its average/worst time complexity.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 3, 'Explain and implement merge sort.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 4, 'What is the time/space complexity of common sorting algorithms?'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 5, 'Find the kth largest element in an unsorted array.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 6, 'Search for a target in a rotated sorted array.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 7, 'Find the first and last position of an element in a sorted array.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa3' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 8, 'What is the difference between BFS and DFS? When do you use each?')
ON CONFLICT DO NOTHING;

-- SECTION: 🧩 Dynamic Programming
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'dsa'), 'dsa4', '🧩 Dynamic Programming', 4)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'dsa4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 1, 'Fibonacci series using top-down memoization and bottom-up tabulation.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 2, 'Longest Common Subsequence (LCS).'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 3, 'Coin Change problem – minimum number of coins to reach amount.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 4, '0/1 Knapsack problem.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 5, 'Longest Increasing Subsequence (LIS).'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 6, 'Edit Distance (Levenshtein Distance) between two strings.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 7, 'Unique Paths in a grid from top-left to bottom-right.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 8, 'Word Break problem – can a string be segmented from a dictionary?'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 9, 'Maximum Product Subarray.'),
  ((SELECT id FROM public.sections WHERE slug = 'dsa4' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'dsa')), (SELECT id FROM public.difficulty_levels WHERE slug = 'coding'), 10, 'House Robber – maximum sum of non-adjacent elements.')
ON CONFLICT DO NOTHING;

-- TOPIC: Azure / Cloud
INSERT INTO public.topics (slug, label, color_hex, display_order) VALUES
  ('azure', 'Azure / Cloud', '#60a5fa', 7)
ON CONFLICT (slug) DO NOTHING;


-- SECTION: ☁️ Azure Fundamentals
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'azure'), 'az1', '☁️ Azure Fundamentals', 1)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'az1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 1, 'What are IaaS, PaaS, and SaaS? Give Azure examples of each.'),
  ((SELECT id FROM public.sections WHERE slug = 'az1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 2, 'What is Azure Resource Manager (ARM) and why is it important?'),
  ((SELECT id FROM public.sections WHERE slug = 'az1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 3, 'What are Azure regions, availability zones, and paired regions?'),
  ((SELECT id FROM public.sections WHERE slug = 'az1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 4, 'What is an Azure subscription, management group, and resource group?'),
  ((SELECT id FROM public.sections WHERE slug = 'az1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 5, 'What is Azure Active Directory (Entra ID) and how does it differ from on-prem AD?'),
  ((SELECT id FROM public.sections WHERE slug = 'az1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 6, 'What are Azure managed identities and why are they preferred over service principals?'),
  ((SELECT id FROM public.sections WHERE slug = 'az1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 7, 'What is Azure RBAC (role-based access control)?'),
  ((SELECT id FROM public.sections WHERE slug = 'az1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 8, 'What is Azure Policy and how does it enforce compliance?'),
  ((SELECT id FROM public.sections WHERE slug = 'az1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 9, 'What is Azure Monitor and what does it capture?'),
  ((SELECT id FROM public.sections WHERE slug = 'az1' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 10, 'Difference between Azure tags and resource locks?')
ON CONFLICT DO NOTHING;

-- SECTION: 🛠️ Azure Services
INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'azure'), 'az2', '🛠️ Azure Services', 2)
ON CONFLICT (topic_id, slug) DO NOTHING;


INSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES
  ((SELECT id FROM public.sections WHERE slug = 'az2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 1, 'What is Azure App Service and when would you use it vs Azure Functions?'),
  ((SELECT id FROM public.sections WHERE slug = 'az2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 2, 'What is Azure Functions and what are its hosting plans?'),
  ((SELECT id FROM public.sections WHERE slug = 'az2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 3, 'Difference between Azure Blob Storage, Azure Files, and Azure Data Lake?'),
  ((SELECT id FROM public.sections WHERE slug = 'az2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 4, 'Azure SQL Database vs Azure SQL Managed Instance vs SQL Server on IaaS?'),
  ((SELECT id FROM public.sections WHERE slug = 'az2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 5, 'What is Azure Cosmos DB and when would you choose it over SQL?'),
  ((SELECT id FROM public.sections WHERE slug = 'az2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 6, 'What is Azure Service Bus and when would you use it vs Azure Storage Queue?'),
  ((SELECT id FROM public.sections WHERE slug = 'az2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 7, 'Difference between Azure Event Hub, Azure Event Grid, and Azure Service Bus?'),
  ((SELECT id FROM public.sections WHERE slug = 'az2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 8, 'What is Azure Key Vault and how do you access secrets from a .NET app?'),
  ((SELECT id FROM public.sections WHERE slug = 'az2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 9, 'What is Azure API Management and what does it add over a raw ASP.NET Core API?'),
  ((SELECT id FROM public.sections WHERE slug = 'az2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 10, 'What is Azure Container Registry (ACR) and Azure Kubernetes Service (AKS)?'),
  ((SELECT id FROM public.sections WHERE slug = 'az2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 11, 'What is Azure Cache for Redis and what caching patterns does it enable?'),
  ((SELECT id FROM public.sections WHERE slug = 'az2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 12, 'What is Azure Application Insights and how do you instrument a .NET app?'),
  ((SELECT id FROM public.sections WHERE slug = 'az2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 13, 'What is Azure Virtual Network and how do private endpoints improve security?'),
  ((SELECT id FROM public.sections WHERE slug = 'az2' AND topic_id = (SELECT id FROM public.topics WHERE slug = 'azure')), (SELECT id FROM public.difficulty_levels WHERE slug = 'intermediate'), 14, 'What is Azure Front Door and when do you need it vs Azure Application Gateway?')
ON CONFLICT DO NOTHING;

-- ════════════════════════════════════════════════════════════════
-- MIGRATION COMPLETE
-- All topics, sections, and questions have been inserted
-- ════════════════════════════════════════════════════════════════

-- Verification: Supabase SQL Editor should show non-zero counts here.
SELECT 'topics' AS table_name, COUNT(*) AS row_count FROM public.topics
UNION ALL
SELECT 'sections' AS table_name, COUNT(*) AS row_count FROM public.sections
UNION ALL
SELECT 'questions' AS table_name, COUNT(*) AS row_count FROM public.questions
UNION ALL
SELECT 'difficulty_levels' AS table_name, COUNT(*) AS row_count FROM public.difficulty_levels;
