---
name: architecture
description: Design scalable, maintainable systems. Master architectural patterns, system design, and distributed systems principles.
---

# Architecture & Design Skills

## Quick Start

### Layered Architecture Pattern
```
┌─────────────────────────────────────┐
│      Presentation Layer             │
│    (Controllers, API endpoints)      │
├─────────────────────────────────────┤
│      Business Logic Layer           │
│    (Services, business rules)        │
├─────────────────────────────────────┤
│      Data Access Layer              │
│    (Repositories, database access)   │
├─────────────────────────────────────┤
│      Database Layer                 │
│    (Persistence, queries)            │
└─────────────────────────────────────┘
```

### Design Pattern Example - Singleton
```python
class Database:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

db = Database()  # Same instance always
```

## Core Concepts

### SOLID Principles
- **S**ingle Responsibility: One reason to change
- **O**pen/Closed: Open for extension, closed for modification
- **L**iskov Substitution: Subtypes replaceable
- **I**nterface Segregation: Specific interfaces
- **D**ependency Inversion: Depend on abstractions

### Design Patterns
- **Creational**: Factory, Singleton, Builder
- **Structural**: Adapter, Decorator, Facade
- **Behavioral**: Observer, Strategy, Command

### System Design
- Scalability techniques
- Database sharding
- Caching strategies
- Load balancing
- Rate limiting

## Advanced Topics

### Microservices Architecture
- Service decomposition
- API Gateway pattern
- Service discovery
- Distributed tracing
- Circuit breaker pattern

### Event-Driven Architecture
- Event sourcing
- CQRS (Command Query Responsibility Segregation)
- Message queues (RabbitMQ, Kafka)
- Stream processing

### Distributed Systems
- Consistency models (CAP theorem)
- Consensus algorithms
- Fault tolerance
- Data replication
- Distributed transactions

### Cloud-Native Patterns
- Containerization
- Orchestration (Kubernetes)
- Serverless computing
- Infrastructure as Code

## Resources
- [Software Architect Roadmap - roadmap.sh](https://roadmap.sh/software-architect)
- [System Design Roadmap - roadmap.sh](https://roadmap.sh/system-design)
- [Designing Data-Intensive Applications](https://dataintensive.net/)
- [Patterns of Enterprise Application Architecture](https://martinfowler.com/books/eaa.html)
