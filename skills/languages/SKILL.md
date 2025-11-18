---
name: languages
description: Master programming languages and paradigms. Understand language ecosystems, build polyglot skills, and choose the right tool for every problem.
---

# Programming Languages & Databases Skills

## Quick Start

### Python Fundamentals
```python
# Variables and data types
name = "Developer"
age = 25
is_learning = True

# Functions
def greet(name):
    return f"Hello, {name}!"

# Classes
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def introduce(self):
        return f"I am {self.name}, {self.age} years old"
```

### SQL Fundamentals
```sql
-- Create table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Query data
SELECT * FROM users WHERE age > 18;

-- Join tables
SELECT u.name, o.order_date
FROM users u
JOIN orders o ON u.id = o.user_id;
```

## Core Concepts

### Language Paradigms
- **Imperative**: Step-by-step instructions (Python, Java)
- **Declarative**: Describe desired outcome (SQL, HTML)
- **Functional**: Functions as first-class (Lisp, Haskell)
- **Object-Oriented**: Objects and classes (Python, Java)

### Popular Languages
- **Python**: Versatile, readable, data science
- **JavaScript**: Web, Node.js, full-stack
- **Java**: Enterprise, scalability, strong typing
- **Go**: Systems, cloud-native, performance
- **Rust**: Systems, memory safety, performance

### Database Types
- **Relational**: PostgreSQL, MySQL, Oracle
- **Document**: MongoDB, CouchDB
- **Key-Value**: Redis, Memcached
- **Graph**: Neo4j, ArangoDB
- **Time-Series**: InfluxDB, TimescaleDB

## Advanced Topics

### Database Optimization
- Index design and strategy
- Query execution plans
- Query optimization techniques
- Connection pooling
- Caching strategies

### SQL Advanced
- Window functions
- CTEs (Common Table Expressions)
- Complex joins
- Recursive queries
- Performance tuning

### NoSQL Design
- Document structure optimization
- Sharding and replication
- Consistency trade-offs
- Scaling strategies

### Language Ecosystems
- Package managers (npm, pip, cargo)
- Build tools and compilation
- Testing frameworks
- Performance profiling
- Debugging techniques

## Resources
- [Python Roadmap - roadmap.sh](https://roadmap.sh/python)
- [JavaScript Roadmap - roadmap.sh](https://roadmap.sh/javascript)
- [SQL Roadmap - roadmap.sh](https://roadmap.sh/sql)
- [PostgreSQL Roadmap - roadmap.sh](https://roadmap.sh/postgresql)
- [Official Language Documentation](https://python.org, https://javascript.info)
