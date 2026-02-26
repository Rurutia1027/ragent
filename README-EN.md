# Ragent

![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)
![Java](https://img.shields.io/badge/Java-17-ff7f2a.svg)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.x-6db33f.svg)
![React](https://img.shields.io/badge/React-18-61dafb.svg)
![Milvus](https://img.shields.io/badge/Milvus-2.6.x-00b3ff.svg)

> Enterprise RAG Agent Platform (Ragent)
>
> Knowledge-base retrieval, multi-channel recall, MCP tool invocation, conversation memory, streaming output, request
> tracing, and ingestion pipelines-all in one codebase.

## Table of Contents

- [Why Learn an AI Project](#why-learn-an-ai-project)
- [Common RAG Misconceptions](#common-rag-misconceptions)
- [What is Ragent](#what-is-ragent)
- [Ragent Core Desing](#ragent-core-design)
- [Project Quality](#project-quality)
- [FAQ](#faq)

Ragent is our first enterprise-grade AI RAG release.

As the first AI proejct from the nage offer (Nageoffer) community, every line of code has been refined to match the
quality bar of earlier projects like 12306 and short-line we stand behind the quality.

## Why Learn an AI Project

The AI wave is something Java developers can no longer ignore.

Whether you work on business systems or middleware, you will be asked about AI in interviews. What is RAG? How do you
implement an Agent? Have you used MCP? These questions are increasingly common. **AI has moved from a nice-to-have to a
must-answer topic.**

For most application developers, however, deep-diving into model fine-tuning, distillation, or Transformer internals has
limited payoff. What is practical is mastering RAG and Agent at the application layer-something you can ship,
demonstrate, and discuss in interviews.

### 1. Campus Recruitment

Resumes full of CRUD projects—e-commerce, food delivery, blogs—are a dime a dozen. When others are still writing “XX
management system based on Spring Boot,” having a complete AI project on your resume sets you apart. Top companies
increasingly value familiarity with new tech; an AI project shows learning ability and technical breadth.

### 2. Industry Recruitment

Since 2024, almost every tech team has been moving toward AI. Many job descriptions now explicitly ask for AI-related
experience. You may be strong in Java or Go, but interviewers will ask: How much do you know about LLMs? Have you built
RAG? How did you implement vector search? Not having answers weakens your negotiating position.

**In short, there are three main reasons to learn an AI project:**

1. **Resume differentiation.** Among backend developers, resumes with AI project experience get noticeably higher pass
   rates—not because AI is magic, but because it shows you are not just repeating the same patterns.
2. **Something substantial to discuss in interviews.** AI projects touch a deep stack: embedding, vector DBs, prompt
   engineering, model invocation, retrieval strategies. Each topic can be expanded; it is more interesting than “I used
   Redis for caching.”
3. **Directly useful at work.** AI is not a lab toy; enterprises are deploying it at scale. Learning now prepares you
   for the next three to five years of your career.

### 3. The Real Question: How to Learn?

Many people follow a Bilibili series or a GitHub repo and think they understand. Then one deep interview question leaves
them stuck. The reason is simple: the gap between demo-style projects and what companies actually need is large.

Others join bootcamps and find everything is in Python. Unfamiliar language and ecosystem make the payoff limited, and
they still do not know how to apply it in the Java world. Even with Spring AI or LangChain4j, versions change fast—older
versions lack features, upgrading often feels like a rewrite.

With these issues in mind, we built a hands-on RAG project called **Ragent**.

It covers mainstream RAG techniques and touches MCP, Agent, and related scenarios. More importantly, it is not a toy
assembled from a few blog posts—**we have deployed RAG systems in production**, solving real problems: information
silos, knowledge retrieval, and efficiency. So Ragent’s complexity is the kind you would see in an enterprise project.

After going through it, you can confidently tell interviewers: **this is how it’s done in the industry.**

## Common RAG Misconceptions

Many projects fly the RAG flag, but a lot are either toy demos or concept packaging. Before diving in, clear up these
misconceptions to avoid wasted effort.
![](https://oss.open8gu.com/image-20260213144311586.png)

### 1. Calling an API Means You "Know RAG"

A common tutorial pattern: call OpenAI's embedding API, push some data into a vector store, then use a LLM to generate
an answer-done. That is at most a working demo; it is far from "knowing RAG."

A real RAG system has to address many more issues: How should documents be chunked for best effect? What if recall is
too low? How do you fuse and rank multiple retrieval channels? How do you control hallucination? These are the points
interviews will drill into.

The gap between a running demo and a system that can go to production is not lines of code; it is depth of understanding
at each step.

### 2. RAG Is Just "Retrieve + Generate"

The name **Retrieval-Augmented Generation** does suggest a two-step process. In practice, a usable RAG system involves
at least:

- **Data processing** PDF, Word, PPT, web pages-many formats. Turning them into clean text is already a lot of work.
  Tables in PDFs, scanned content, multi-column layout-each is a pitfall.
- **Chunking strategy** Too large and retrieval is imprecise; too small and context is lost. Chunk by paragraph by fixed
  length, or by semantics; different documents may need different strategies.
- **Query rewriting**: A user asks "how do I get reimbursed?" - retrieving on those few words will not work well. In
  multi-turn dialogue, "how do I apply?" is meaningless without context.
- **Intent recognition**: Dose the user want to query the knowledge base or call a business system? Small talke or a
  real question? Wrong path means wrong answer.
- **Retrieval strategy**: Pure vector search is weak for exact match (e.g., an order ID). How to combine hybrid
  retrieval, what top-k to use, whether to rerank-all are tradeoffs.
- **Conversation memory**: Sending 20 turns to the model? Token cost is prohibitive. Only the last few? You may lose
  critical context. Compression, summarization, and persistence of memory are a separate mechanism.

Every step has pitfalls and is worth understanding. Explanation these clearly in an interview is more valuable than
reciting definitions.

### 3. Wrapping OpenAI/LangChain Does Not Make It "Enterprise"

OpenAI and LangChain are useful, but using them as a thin wrapper is not enterprise-grade. In real deployments you face:

- Incremental updates over large document sets; you cannot rebuild the full index every time.
- Multi-tenant isolation and access control; different departments see different knowledge bases.
- Retrieval performance under load; cost control and fault tolerance for model calls.
- Request throttling and abuse prevention.
- Model load balancing, multi-vector failover and fallback.
- Observability, effect monitoring, and user feedback.

QuickStarts for OpenAI/LangChain do not cover these; interviews and real systems will.

### 4. Focusing Only on Models, Ignoring Engineering

The real differentiator of a RAG project is not which model you use, but engineering. With the same model, different
retrieval strategies, prompt design, or chunk sizes can yield very different results.

Example: the user asks “how do I replace the printer cartridge?” and the doc says “cartridge replacement steps.” Keyword
search may not match; vector search can capture the equivalence. That depends on embedding choice, vector DB tuning, and
reranking—each step is an engineering decision, not something a more expensive model alone fixes.

In interviews, people who can explain these engineering details are far more convincing than those who only say “I used
GPT-4.”

## What is Ragent?

Ragent is an enterprise RAG agent platform built with Java 17, Spring Boot 3, and React 18.

Ragent is an enterprise RAG agent platform built with Java 17, Spring Boot 3, and React 18.

It is not a one-off demo. It implements the full path from document ingestion to intelligent Q&A. The issues you will
meet in production—document parsing, chunking, multi-channel retrieval, intent recognition, query rewriting,
conversation memory, model resilience, MCP tool calls, tracing—Ragent addresses with concrete solutions.

![](https://oss.open8gu.com/ragent-architecture.svg)

Core capabilities:

- **Multi-channel retrieval:** Intent-directed retrieval and global vector retrieval run in parallel; results go through
  deduplication, reranking, and other post-processing, balancing precision and recall.
- **Intent recognition and guidance:** Tree-shaped intent taxonomy (domain → category → topic). When confidence is low,
  the system asks the user to clarify instead of guessing.
- **Query rewriting and splitting:** Context is completed in multi-turn dialogue; complex questions are split into
  sub-questions and retrieved separately, addressing the “user said X but meant Y” problem.
- **Conversation memory:** Keeps the last N turns; beyond a threshold, automatic summarization compresses history,
  controlling token cost without losing key context.
- **Model routing and resilience:** Multiple model candidates, priority scheduling, first-packet probing, health checks,
  automatic failover—one model down does not take the service down.
- **MCP tool integration:** When the user intent is to call a business system rather than query the knowledge base,
  parameters are extracted and the corresponding tool is invoked; knowledge retrieval and tool calls are unified in one
  flow.
- **Document ingestion pipeline:** Node-based pipeline from fetch, parse, enrich, chunk, embed, to writing into
  Milvus—each step configurable, extensible, and logged.
- **End-to-end tracing:** Every step of each request (rewrite, intent, retrieval, generation) is traced for debugging
  and optimization.
- **Admin console:** Full React admin UI: knowledge base management, intent tree editing, ingestion monitoring, trace
  viewer, system settings.

In one sentence: **Ragent is a project you can use to learn how enterprise RAG systems are designed and deployed.**

## Ragent Core Design

### 1. Technical Architecture

Ragent uses a front-end/back-end separated monolith. The backend is split into four Maven modules by responsibility:

<img src="https://oss.open8gu.com/image-20260223130413104.png" width="50%" />

This layering addresses real needs: the `framework` layer provides business-agnostic capabilities, `infra-ai` abstracts
model providers, and `bootstrap` focuses on business logic. Changing providers does not require changing business code;
changing business logic does not require touching infrastructure.

Tech stack:

| Layer              | Choices                                                              |
|--------------------|----------------------------------------------------------------------|
| Backend            | Java 17, Spring Boot 3.5.7, MyBatis Plus                             |
| Frontend           | React 18, Vite, TypeScript                                           |
| Relational DB      | MySQL (20+ business tables)                                          |
| Vector DB          | Milvus 2.6                                                           |
| Cache / rate limit | Redis + Redisson                                                     |
| Object storage     | S3-compatible (RustFS)                                               |
| Message queue      | RocketMQ 5.x                                                         |
| Document parsing   | Apache Tika 3.2                                                      |
| Model providers    | Bailian (Alibaba Cloud), SiliconFlow, Ollama (local), vLLM (planned) |
| Auth               | Sa-Token                                                             |
| Code style         | Spotless (auto-format)                                               |

### 2. RAG Core Flow

#### 2.1 Ragent Request Flow

A single user question goes through this path in Ragent:

![](https://oss.open8gu.com/image-20260223124143406.png)

#### 2.2 Multi-Channel Retrieval

Retrieval is at the heart of RAG. Ragent uses multiple channels in parallel plus a post-processing pipeline:

![](https://oss.open8gu.com/image-20260223124413871.png)

Each channel runs independently; a thread pool runs them in parallel. Post-processors are chained in order, refining
results step by step.

#### 2.3 Model Routing and Resilience

Production cannot depend on a single provider. Ragent’s model routing addresses this:

![](https://oss.open8gu.com/image-20260223124613370.png)

Important: during first-packet probing, events are buffered so that when the model is switched, the client does not
receive partial or corrupted data.

### 3. Document Ingestion Pipeline

Documents move from upload to searchable via a node-based pipeline:

<img src="https://oss.open8gu.com/image-20260223124821415.png" width="25%" />

Node configuration is stored in the database; conditional execution and chained outputs are supported. Each task and
node has its own execution log for precise debugging.

### 4. Key Design Patterns

Patterns in Ragent are used to solve concrete problems:

| Pattern                 | Where it’s used                               | What it solves                                                       |
|-------------------------|-----------------------------------------------|----------------------------------------------------------------------|
| Strategy                | SearchChannel, PostProcessor, MCPToolExecutor | Pluggable retrieval channels, post-processors, MCP tools             |
| Factory                 | IntentTreeFactory, StreamCallbackFactory      | Centralized creation of complex objects                              |
| Registry                | MCPToolRegistry, IntentNodeRegistry           | Auto-discovery and registration; new tools need no config            |
| Template method         | IngestionNode base class                      | Unified pipeline for ingestion nodes; subclasses focus on core logic |
| Decorator               | ProbeBufferingCallback                        | First-packet probing without changing original callbacks             |
| Chain of responsibility | Post-processor chain, model fallback chain    | Multiple steps in sequence, flexibly composed                        |
| Observer                | StreamCallback                                | Async notification of stream events                                  |
| AOP                     | @RagTraceNode, @ChatRateLimit                 | Tracing and rate limiting decoupled from business code               |

## Project Quality

Calling a project “enterprise-grade” has to be backed by real quality. Here is how Ragent stacks up.

### 1. Code Size

- Backend Java: ~40,000 lines across 400+ source files
- Frontend TypeScript/React: ~18,000 lines
- Database: 20 business tables (sessions, messages, knowledge bases, documents, chunks, intent tree, ingestion
  pipelines, traces, users)
- Frontend: 22 pages/components, including chat UI and admin (dashboard, knowledge base, intent tree, ingestion
  monitoring, tracing, user management, settings)

This is not a weekend demo; it is a system with a complete business loop.

### 2. Engineering Standards

- **Layered architecture:** framework / infra-ai / bootstrap with clear boundaries; no mixing of infrastructure and
  business code.
- **Framework layer:** Separate Maven module, 23 classes across 10 cross-cutting concerns—three-level exception
  hierarchy and unified handling, idempotency, Snowflake IDs, user and trace context across threads, thread-safe
  `SseEmitterSender`, unified response and error codes. Business modules only add dependencies and annotations; no
  boilerplate.
- **Queue-based rate limiting:** Redis plus ordered sets (ZSET) and Pub/Sub for distributed queuing. Requests enter the
  ZSET; a Lua script atomically decides if they are in the head window before dequeue; a semaphore limits concurrency
  with automatic lease expiry (no deadlock). Pub/Sub notifies across instances; local coalescing avoids thundering herd.
  Timeouts remove stale entries; SSE pushes queue status.
- **8 dedicated thread pools + TTL propagation:** Eight pools (MCP batch, RAG context assembly, multi-channel retrieval,
  internal retrieval, intent classification, memory summarization, model streaming, conversation entry) with different
  queue types and rejection policies. All wrapped with `TtlExecutors` so user and trace context are preserved in async
  threads.
- **Three-state circuit breaker:** CLOSED → OPEN → HALF_OPEN per model. After a failure threshold, the circuit opens;
  after a cooldown, half-open allows probe requests; success closes it again, failure keeps it open. Together with
  priority-based fallback, one model down automatically switches to the next without the business layer noticing.
- **Design patterns in practice:** Strategy, factory, observer, decorator, template method, chain of responsibility,
  facade—each used to solve real extensibility or coupling issues.

> The project uses concurrency heavily; consider pairing it with the
> community’s [oneThread dynamic thread-pool framework](https://nageoffer.com/onethread) for deeper learning.

### 3. Extensibility

This is a key indicator of enterprise readiness. Ragent’s core modules have clear extension points:

- **New retrieval channel:** Implement `SearchChannel`, register as a Spring Bean—it is used automatically.
- **New post-processor:** Implement `SearchResultPostProcessor`—it joins the chain.
- **New MCP tool:** Implement `MCPToolExecutor`—discovered by `DefaultMCPToolRegistry`.
- **New ingestion node:** Implement `IngestionNode`—insert anywhere in the pipeline.
- **New model provider:** Implement `ChatClient` in `infra-ai`, add to the candidate list in config.

No framework changes, no hardcoded lists in config—add an implementation and you are done. That is programming to
interfaces done right.

### 4. Production-Ready Features

Many open-source projects stop at “it runs.” Ragent also addresses:

- **Rate limiting:** Global and per-user limits to protect model calls.
- **Circuit breaking:** Health checks and failure counts; unhealthy models are isolated to avoid repeated timeouts.
- **Observability:** AOP-based end-to-end traces; duration, inputs, outputs, and errors for each step.
- **Streaming:** SSE with first-packet probing so model switches are invisible to the user.
- **Session management:** Memory compression, summary persistence, TTL—no OOM or token explosion as conversation length
  grows.
- **Auth:** Sa-Token–based authentication; no naked APIs.

### 5. Admin Console

Ragent provides a full console for **end users and administrators**, with a clean, modern UI.

The interface was refined over multiple iterations with AI-assisted design, balancing completeness and usability.

#### 5.1 User Q&A

From the Ragent home page, users type questions in the input box. **Deep thinking mode** is available for higher-quality
answers.

Example questions are shown below the input; clicking one fills the box for quick tryouts.

- Natural language input
- Example-question quick fill
- Deep thinking mode

Example Q&A screen:

![](https://oss.open8gu.com/iShot_2026-02-04_22.08.50.png)

Answers are streamed and rendered for easy reading:

- Markdown rendering
- Inline images
- Code highlighting
- Feedback (like / dislike)

Example answer:

![](https://oss.open8gu.com/iShot_2026-02-04_22.08.51.png)

#### 5.2 Admin Backend

The admin backend supports configuration and operations: model management, system settings, and data management.

Example admin screens:

![](https://oss.open8gu.com/iShot_2026-02-08_21.46.13.png)

![](https://oss.open8gu.com/iShot_2026-02-04_22.03.41.png)

![](https://oss.open8gu.com/iShot_2026-02-04_22.03.58.png)

![](https://oss.open8gu.com/iShot_2026-02-04_22.04.06.png)

![](https://oss.open8gu.com/iShot_2026-02-04_22.04.06.png)

![](https://oss.open8gu.com/iShot_2026-02-04_22.04.34.png)

![](https://oss.open8gu.com/iShot_2026-02-04_22.04.44.png)

Ragent’s console was iterated multiple times to avoid the usual “rough UI” feel and to deliver a simple, clear, and
practical interface.

![](https://oss.open8gu.com/iShot_2026-02-04_22.06.50.png)

### 6. How Ragent Differs From Typical Demos

| Dimension      | Typical demo              | Ragent                                     |
|----------------|---------------------------|--------------------------------------------|
| Retrieval      | Single vector channel     | Multi-channel parallel + post-processing   |
| Intent         | None                      | Tree-shaped intent + disambiguation        |
| Query handling | Raw query to retrieval    | Rewrite + split + context completion       |
| Model calls    | Single model, no fallback | Multi-candidate routing + probe + failover |
| Memory         | Dump all turns to model   | Sliding window + auto summarization        |
| Ingestion      | Manual scripts            | Orchestrated pipeline + per-node logs      |
| Observability  | None                      | End-to-end traces                          |
| Tools          | None                      | MCP integration                            |
| Admin          | None                      | Full React admin UI                        |

**Summary:** Ragent’s size, architecture, engineering practices, extension points, and production features justify the
“enterprise-grade” label. It is not for memorizing buzzwords—it is for understanding what a real RAG system looks like
and why each design choice was made.

## FAQ

### 1. What Will I Learn?

Ragent is not just “call this API.” It walks you through taking a RAG system from zero to one. You will get:

- **End-to-end RAG engineering:** Document parsing, chunking, embedding, multi-channel retrieval, reranking, prompt
  assembly, streaming generation—what to do at each step and why.
- **AI application architecture:** Intent systems, query rewriting and splitting, conversation memory, MCP tool
  calls—the capabilities that distinguish AI apps from traditional CRUD.
- **Model engineering:** Multi-model routing, priority scheduling, first-packet probing, circuit breaking and
  fallback—how to handle unstable models in production.
- **Solid Java engineering:** Layered design, design patterns in practice, distributed rate limiting, thread-pool
  management and context propagation, end-to-end tracing—skills that apply beyond AI.
- **Full-stack experience:** Spring Boot 3 backend + React 18 frontend, from API design to UI.

In short: after Ragent, you can discuss RAG in depth and demonstrate Java engineering level.

### 2. Who Is It For?

**Campus / new grads:**

- **Java backend students** who already have typical projects (e-commerce, delivery, blog) and want something that
  stands out. Ragent lets you talk about AI and engineering instead of yet another CRUD story.
- **Those moving toward AI applications** who are interested in LLMs but do not want to start from Python and
  algorithms. Ragent is on the Java stack; the learning curve is smooth.
- **Internship / fall / spring recruitment** candidates. Companies increasingly value awareness of new tech; an AI
  project on your resume shows learning ability and breadth.

**Industry hires:**

- **1–3 years Java:** You write business code and want to move toward AI but do not know where to start. Ragent uses a
  stack you know and focuses on the application layer—quick to pick up and applicable.
- **3–5 years backend:** Strong technically but weak on AI questions in interviews. Ragent fills in RAG, Agent, MCP so
  you can discuss them in depth.
- **Targeting AI teams:** More and more job descriptions ask for AI experience. Ragent gives you a clear picture of how
  RAG systems work so you are not only talking theory.

## Repository

The first business system from the 拿个 offer community, 12306, was open-sourced and gained 15k+ stars. Ragent, as the
first AI project from the community, is also open-sourced—the code can speak for itself.

> GitHub: [https://github.com/nageoffer/ragent](https://github.com/nageoffer/ragent)

We open-source because **we are confident in the quality.** Architecture, implementation, and practices are there to be
reviewed. Clone it and see—structure, history, comments—everything is visible.

Many projects only share screenshots and concepts; few put the full code out. Ragent does, because the capabilities
described—multi-channel retrieval, intent recognition, model resilience, tracing—are not slides; they are code you can
run, debug, and read line by line.

What open-source gives you:

- **Code as documentation:** To see how a module works, read the code; it is accurate and up to date.
- **Local debugging:** Set breakpoints anywhere and follow a request through the full RAG path; you will understand it
  far better than from diagrams.
- **Contribute:** Report bugs via issues, propose improvements via PRs. Contributing to an enterprise-style AI project
  is a resume asset.
- **Ongoing updates:** The project will evolve; Star and Watch to stay in the loop.

If you find the project useful, a GitHub Star is the best way to show support.



