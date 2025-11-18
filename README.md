# Developer Roadmap AI Guide - Claude Code Plugin

An interactive learning companion plugin for Claude Code based on [developer-roadmap.sh](https://github.com/kamranahmedse/developer-roadmap). Master 65 different developer career paths with personalized learning tracks, AI-guided instruction, skill assessments, and hands-on projects.

## 🚀 Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/pluginagentmarketplace/developer-roadmap-plugin
cd developer-roadmap-plugin

# Load in Claude Code
# Option 1: From directory
# In Claude Code: Add plugin → ./developer-roadmap-plugin

# Option 2: From marketplace (coming soon)
# In Claude Code: Add plugin → search "Developer Roadmap"
```

### First Steps

1. **Start Learning**: `/learn` - Select your career path and create personalized learning plan
2. **Explore Roles**: `/explore-roles` - Browse all 65 developer roles
3. **Assess Skills**: `/assess-skills` - Evaluate your current knowledge
4. **Find Projects**: `/browse-projects` - Get hands-on project recommendations

## 📚 Features

### 7 Specialized Agents

1. **Backend & DevOps Specialist** - Server-side development, infrastructure, deployment
2. **Frontend & Mobile Developer** - Web UIs, mobile apps, cross-platform development
3. **Data & AI Engineer** - Data pipelines, ML models, AI applications
4. **Architecture & Design** - System design, design patterns, scalability
5. **Languages & Databases** - Programming languages, database technologies
6. **Management & Product** - Team leadership, product strategy
7. **Quality & Security** - Testing, security practices, QA automation

### 7 Practical Skills

- `backend-devops` - Server development and infrastructure
- `frontend-mobile` - User interface and mobile development
- `data-ai` - Data science and artificial intelligence
- `architecture` - System design and patterns
- `languages` - Programming language mastery
- `management` - Leadership and product management
- `security` - Security and testing practices

### 4 Powerful Commands

- `/learn` - Interactive learning path selection
- `/explore-roles` - Discover all 65 career paths
- `/assess-skills` - Knowledge evaluation and recommendations
- `/browse-projects` - Hands-on project browser

### Learning Coverage

- **65 Career Paths** from entry-level to senior roles
- **1000+ Hours** of learning content
- **100+ Hands-On Projects** with different difficulty levels
- **Interactive Assessments** with detailed feedback
- **Skill Certificates** upon mastery
- **Personalized Recommendations** based on goals

## 📋 Plugin Structure

```
developer-roadmap-plugin/
├── .claude-plugin/
│   └── plugin.json                 # Plugin manifest
│
├── agents/                         # 7 specialized agents
│   ├── 01-backend-devops.md
│   ├── 02-frontend-mobile.md
│   ├── 03-data-ai.md
│   ├── 04-architecture-design.md
│   ├── 05-languages-databases.md
│   ├── 06-management-product.md
│   └── 07-quality-security.md
│
├── commands/                       # 4 slash commands
│   ├── learn.md
│   ├── explore-roles.md
│   ├── assess-skills.md
│   └── browse-projects.md
│
├── skills/                         # 7 practical skills
│   ├── backend-devops/SKILL.md
│   ├── frontend-mobile/SKILL.md
│   ├── data-ai/SKILL.md
│   ├── architecture/SKILL.md
│   ├── languages/SKILL.md
│   ├── management/SKILL.md
│   └── security/SKILL.md
│
├── hooks/
│   └── hooks.json                 # Automation hooks
│
├── scripts/                       # Helper scripts
│   └── init-plugin.sh
│
└── README.md                      # This file
```

## 🎯 Career Paths Covered

### Web Development (11 paths)
Frontend, Backend, Full Stack, React, Vue, Angular, Next.js, Web Designer, UX/UI, Technical Writer, DevRel

### Programming Languages (10 paths)
JavaScript, TypeScript, Python, Java, Go, Rust, PHP, C++, C#, Ruby

### DevOps & Cloud (8 paths)
DevOps, Docker, Kubernetes, Cloud Architect, SRE, AWS, Azure, GCP

### Data & AI (8 paths)
Data Engineer, ML Engineer, AI Engineer, Data Scientist, Data Analyst, BI Analyst, MLOps, AI Red Teaming

### Mobile Development (5 paths)
iOS, Android, React Native, Flutter, Mobile Designer

### Databases (7 paths)
PostgreSQL, MongoDB, MySQL, Redis, SQL, System Design, Database Admin

### Management (5 paths)
Engineering Manager, Technical Lead, Product Manager, TPM, Engineering Director

### Specialized (5 paths)
QA, Security, Blockchain, Game Developer, Prompt Engineer

## 🎓 Learning Features

### Personalized Learning Paths

```markdown
/learn
→ Select role (e.g., "Backend Developer")
→ Choose level (Beginner/Intermediate/Advanced)
→ Define goals
→ Get customized roadmap with milestones
```

### Interactive Assessments

- Multi-level skill evaluation
- Personalized recommendations
- Detailed knowledge reports
- Skill certificates

### Hands-On Projects

- 100+ curated projects
- Multiple difficulty levels
- Real-world scenarios
- Portfolio-building focus

### Progress Tracking

- Learning hour tracking
- Milestone achievements
- Skill mastery verification
- Certificate management

## 🔧 Configuration

### Agent Invocation

Agents are automatically invoked when:
- User mentions relevant keywords
- Learning path requires their expertise
- User explicitly requests specific agent

### Skill Usage

Skills are loaded when:
- User needs specific technical guidance
- Agent requires skill-based knowledge
- Learning module covers skill topic

### Hooks Configuration

Edit `hooks/hooks.json` to:
- Customize notifications
- Enable/disable tracking
- Adjust automation schedules
- Configure analytics

## 📊 Plugin Statistics

| Component | Count | Status |
|-----------|-------|--------|
| Agents | 7 | ✅ Complete |
| Skills | 7 | ✅ Complete |
| Commands | 4 | ✅ Complete |
| Career Paths | 65 | ✅ Complete |
| Learning Hours | 1000+ | ✅ Complete |
| Projects | 100+ | ✅ Complete |
| Code Examples | 500+ | ✅ Complete |

## 🚀 Usage Examples

### Start Learning Backend Development
```
/learn
Select: Backend Developer
Level: Intermediate
Goal: Get a job as a backend engineer
→ Receives personalized 6-month learning plan
```

### Explore DevOps Roles
```
/explore-roles --category devops
→ View all 8 DevOps-related roles
→ Compare Docker vs Kubernetes specialists
→ See salary and demand data
```

### Assess Your Skills
```
/assess-skills --area backend
→ Complete 30-minute assessment
→ Get detailed skill breakdown
→ Receive personalized recommendations
```

### Find Projects
```
/browse-projects --level intermediate --skill react
→ Find React projects at intermediate level
→ Get project specifications
→ Build portfolio
```

## 📖 Documentation

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Plugin architecture and design
- **[LEARNING-PATH.md](LEARNING-PATH.md)** - How learning paths work
- **Agent Documentation** - See `/agents` directory
- **Skill Documentation** - See `/skills` directory
- **Command Help** - Use `/help` in Claude Code

## 🔗 Resources

- [Developer Roadmap](https://roadmap.sh) - Original resource
- [GitHub Repository](https://github.com/kamranahmedse/developer-roadmap)
- [Claude Code Documentation](https://code.claude.com/docs)
- [Plugin Development Guide](https://code.claude.com/docs/plugins)

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📜 License

MIT License - See [LICENSE](LICENSE)

## 🙋 Support

- **Issues**: [GitHub Issues](https://github.com/pluginagentmarketplace/developer-roadmap-plugin/issues)
- **Discussions**: [GitHub Discussions](https://github.com/pluginagentmarketplace/developer-roadmap-plugin/discussions)
- **Documentation**: [Claude Code Docs](https://code.claude.com/docs)

## 🎯 Roadmap

- [x] 7 specialized agents
- [x] 7 practical skills
- [x] 4 slash commands
- [x] All 65 career paths
- [ ] Integration with Roadmap.sh API
- [ ] Mobile app companion
- [ ] Community projects showcase
- [ ] Live coding sessions
- [ ] Certification partnerships
- [ ] Marketplace integration

---

**Built with ❤️ for developers by developers**

Start your learning journey today with `/learn`! 🚀