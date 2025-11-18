---
name: security
description: Secure systems and data. Master testing strategies, cybersecurity practices, and build robust applications protected against threats.
---

# Quality & Security Skills

## Quick Start

### OWASP Top 10 Vulnerabilities
```
1. Broken Access Control
2. Cryptographic Failures
3. Injection (SQL, NoSQL, OS)
4. Insecure Design
5. Security Misconfiguration
6. Vulnerable and Outdated Components
7. Authentication Failures
8. Software and Data Integrity Failures
9. Logging and Monitoring Failures
10. SSRF (Server-Side Request Forgery)
```

### Basic Security Test Example
```python
import unittest

class SecurityTests(unittest.TestCase):
    def test_password_hashing(self):
        password = "test123"
        hashed = hash_password(password)
        self.assertNotEqual(password, hashed)
        self.assertTrue(verify_password(password, hashed))

    def test_sql_injection_prevention(self):
        # Use parameterized queries
        query = "SELECT * FROM users WHERE id = %s"
        result = db.execute(query, (user_id,))
        self.assertIsNotNone(result)
```

## Core Concepts

### Testing Fundamentals
- Test planning and strategy
- Manual vs automated testing
- Test case design
- Test coverage metrics
- Regression testing
- Smoke testing

### Testing Frameworks
- Unit testing (Jest, pytest, JUnit)
- Integration testing
- End-to-end testing (Cypress, Selenium)
- Performance testing
- Load testing (Apache JMeter, Locust)

### Security Fundamentals
- Authentication vs Authorization
- Cryptography basics
- HTTPS and TLS
- Passwords and hashing (bcrypt, argon2)
- OAuth and JWT tokens
- API security

## Advanced Topics

### Secure Coding
- Input validation and sanitization
- Output encoding
- Error handling
- Logging secrets safely
- CORS and CSRF protection
- Rate limiting

### Vulnerability Assessment
- Penetration testing basics
- Vulnerability scanning
- Static code analysis (SonarQube)
- Dependency checking (OWASP Dependency-Check)
- Security headers (CSP, X-Frame-Options)

### DevSecOps
- Security in CI/CD pipelines
- Container security
- Infrastructure security
- Policy as code
- Secrets management
- Security monitoring

### Compliance & Standards
- GDPR compliance
- CCPA requirements
- ISO 27001
- SOC 2 Type II
- PCI DSS
- HIPAA standards

## Resources
- [QA Roadmap - roadmap.sh](https://roadmap.sh/qa)
- [Cyber Security Roadmap - roadmap.sh](https://roadmap.sh/cyber-security)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [PortSwigger Web Security Academy](https://portswigger.net/web-security)
