# Issue: Add OpenAI Model Provider and Remove Chinese LLM Vendors

## Summary

Replace the current BaiLian/SiliconFlow-centric setup with an OpenAI-based provider (or other OpenAI-compatible vendor),
so that RAGent can use English-first models and share a similar experience to Cursor's AI. Keep Ollama as an optional
local provider. 

## Background 
Current `application.yaml` is wired to: 
- ai.providers.bailian
- ai.providers.siliconflow
- ai.providers.ollama

ai.chat.candidates and ai.embedding / ai.remark are all bound to these providers. 

We wanna to:
- Stop depending on Chinese LLM vendors
- Use OpenAI (for any OpenAI-compatible endpoint) as the main cloud provider.
- Keep the routing & fallback system (`RoutingLLMService` + `ModelSelector`) unchanged at the architecture level. 

## Proposed Design 
### Config: Add openai provider 
in `bootstrap/src/main/resources/application.yaml`

```yml
ai: providers:
      openai: 
        url: https://api.openai.com
        api-key: ${OPENAI_API_KEY:}
        endpoints:
          chat: /v1/chat/completions
          embedding: /v1/embeddings
```

Optionally add vendor-specific variants later (e.g., DeepSeek, Anthropic) using the same shape. 

### Background: Implement OpenAIChatClient 
- New class under: `infra-ai`:
```
infra-ai/src/main/java/com/nageoffer/ai/ragent/infra/chat/OpenAIChatClient.java
```

Responsibilities: 
- Implement existing `ChatClient` interface. 
- Map internal `ChatRequest` -> OpenAI chat/completions JSON body. 
- Handle both: 
  - Non-streaming: for RoutingLLMService.chat(...)
  - Stream(SSE): for `RoutingLLMService.streamingChat(...)`, using `StreamingCallback` to emit `content`/`thinking` events.
- Read `ai.providers["openai"]` from `AIModelProperties` (URL, API Key, endpoints). 

### Enum & Wiring 
- Extend `ModelProvider` enum to include something like: 
```
OPENAI("openai")
```
- Ensure `OpenAIChatClient.provider()` returns "openai" and is picked up to `RoutingLLMService`'s `clientByProvider` map. 


### Chat / Embedding Model Config 
In `application.yaml`:
```yaml
   ai:
     chat:
       default-model: gpt-4.1-mini
       deep-thinking-model: gpt-4.1
       candidates:
         - id: gpt-4.1-mini
           provider: openai
           model: gpt-4.1-mini
           priority: 1
         - id: gpt-4.1
           provider: openai
           model: gpt-4.1
           supports-thinking: true
           priority: 2

     embedding:
       default-model: text-embedding-3-large
       candidates:
         - id: text-embedding-3-large
           provider: openai
           model: text-embedding-3-large
           dimension: 3072
           priority: 1
```
- Mark existing BaiLian & SiliconFlow candidates as `enabled: false` or remove them for now. 
- Keep `ollama` candidate for local-only dev if desired. 




