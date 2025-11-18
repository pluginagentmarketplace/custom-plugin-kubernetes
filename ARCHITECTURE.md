# Plugin Architecture

## Overview

Developer Roadmap AI Guide is built as a comprehensive learning companion plugin with a modular architecture designed for scalability and extensibility.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    Claude Code Core                         │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│            Developer Roadmap Plugin                          │
│  ┌────────────────────────────────────────────────────────┐ │
│  │          Plugin Manifest (plugin.json)                │ │
│  └────────────────────────────────────────────────────────┘ │
├──────────────┬──────────────┬──────────────┬──────────────┤
│              │              │              │              │
│  Commands    │  Agents      │  Skills      │  Hooks       │
│  (4)         │  (7)         │  (7)         │              │
│              │              │              │              │
│  /learn      │  Backend &   │  backend-    │  Event-      │
│  /explore    │  DevOps      │  devops      │  driven      │
│  /assess     │              │              │  automation  │
│  /browse     │  Frontend &  │  frontend-   │              │
│              │  Mobile      │  mobile      │  Progress    │
│              │              │              │  tracking    │
│              │  Data & AI   │  data-ai     │              │
│              │              │              │  Achievement │
│              │  Architecture│  architecture│  badges      │
│              │              │              │              │
│              │  Languages & │  languages   │  Analytics   │
│              │  Databases   │              │              │
│              │              │  management  │              │
│              │  Management &│              │              │
│              │  Product     │  security    │              │
│              │              │              │              │
│              │  Quality &   │              │              │
│              │  Security    │              │              │
└──────────────┴──────────────┴──────────────┴──────────────┘
                            ↑
┌─────────────────────────────────────────────────────────────┐
│                 Learning Resources                           │
│  - 65 Career Paths  - 100+ Projects  - 1000+ Hours         │
└─────────────────────────────────────────────────────────────┘
```

## Component Details

### 1. Commands Layer (4 Slash Commands)

Entry points for user interaction:

```
/learn              → Interactive learning path selection
/explore-roles      → Career path discovery
/assess-skills      → Skill evaluation
/browse-projects    → Project recommendations
```

**Responsibilities:**
- User interaction handling
- Input validation
- Response formatting
- Navigation between features

### 2. Agents Layer (7 Specialized Agents)

Domain-expert agents for different specializations:

```
Agent 1: Backend & DevOps        → Server-side expertise
Agent 2: Frontend & Mobile       → UI/UX expertise
Agent 3: Data & AI               → Data science expertise
Agent 4: Architecture & Design   → System design expertise
Agent 5: Languages & Databases   → Language expertise
Agent 6: Management & Product    → Leadership expertise
Agent 7: Quality & Security      → Testing & security expertise
```

**Agent Responsibilities:**
- Content delivery for specialization
- Technical guidance
- Best practices sharing
- Resource recommendations

### 3. Skills Layer (7 Invokable Skills)

Practical skills referenced by agents:

```
backend-devops/         → Backend and DevOps implementations
frontend-mobile/        → Frontend and mobile development
data-ai/               → Data and AI/ML topics
architecture/          → Architectural patterns
languages/             → Programming language guides
management/            → Leadership and management
security/              → Security and testing
```

**Each Skill File Contains:**
- YAML frontmatter (metadata)
- Quick start examples
- Core concepts
- Advanced topics
- Resource references

### 4. Hooks Layer (Event-Driven Automation)

Automated actions triggered by events:

```
onPluginLoaded          → Initialize plugin state
onCommandExecuted       → Track command usage
onSkillInvoked          → Log skill invocation
onLearningComplete      → Update progress
onProjectStarted        → Engagement tracking
onAssessmentComplete    → Result processing
onWeeklyReview          → Progress summaries
onMilestoneReached      → Achievement recognition
```

**Hooks Capabilities:**
- Event handling
- Analytics logging
- Notification sending
- Progress tracking
- Resource suggestions

## Data Flow

### Learning Path Flow

```
User Input (/learn)
        ↓
Command Handler
        ↓
Agent Selection (7 agents available)
        ↓
Skill Invocation (7 skills available)
        ↓
Content Delivery
        ↓
Progress Tracking (hooks)
        ↓
Next Recommendation
```

### Assessment Flow

```
User Input (/assess-skills)
        ↓
Assessment Selection
        ↓
Quiz Execution
        ↓
Score Calculation
        ↓
Results Processing (hooks)
        ↓
Personalized Recommendations
        ↓
Skill Certificate (if earned)
```

### Project Discovery Flow

```
User Input (/browse-projects)
        ↓
Filter Selection
        ↓
Project Recommendation Engine
        ↓
Project Details Display
        ↓
Project Start (hooks)
        ↓
Progress Tracking
        ↓
Completion & Certificate
```

## Module Dependencies

```
plugin.json
    ├── agents/
    │   ├── 01-backend-devops.md
    │   │   └── references: backend-devops skill
    │   ├── 02-frontend-mobile.md
    │   │   └── references: frontend-mobile skill
    │   ├── 03-data-ai.md
    │   │   └── references: data-ai skill
    │   ├── 04-architecture-design.md
    │   │   └── references: architecture skill
    │   ├── 05-languages-databases.md
    │   │   └── references: languages skill
    │   ├── 06-management-product.md
    │   │   └── references: management skill
    │   └── 07-quality-security.md
    │       └── references: security skill
    │
    ├── commands/
    │   ├── learn.md
    │   │   └── invokes: multiple agents
    │   ├── explore-roles.md
    │   │   └── references: all agents/skills
    │   ├── assess-skills.md
    │   │   └── triggers: assessment hooks
    │   └── browse-projects.md
    │       └── triggers: project hooks
    │
    ├── skills/
    │   ├── backend-devops/SKILL.md
    │   ├── frontend-mobile/SKILL.md
    │   ├── data-ai/SKILL.md
    │   ├── architecture/SKILL.md
    │   ├── languages/SKILL.md
    │   ├── management/SKILL.md
    │   └── security/SKILL.md
    │
    └── hooks/
        └── hooks.json
            ├── analytics logging
            ├── progress tracking
            ├── notification triggers
            └── achievement awards
```

## Agent-Skill Mapping

| Agent | Primary Skill | Secondary Skills |
|-------|---------------|-----------------|
| Backend & DevOps | backend-devops | architecture |
| Frontend & Mobile | frontend-mobile | architecture |
| Data & AI | data-ai | languages |
| Architecture & Design | architecture | backend-devops, frontend-mobile |
| Languages & Databases | languages | architecture |
| Management & Product | management | - |
| Quality & Security | security | backend-devops |

## Extension Points

### Adding New Career Paths

1. Update plugin.json agents list
2. Create new agent markdown file (agents/XX-[name].md)
3. Link to relevant skills
4. Update explore-roles command

### Adding New Skills

1. Create new skill directory (skills/[skill-name]/)
2. Create SKILL.md with proper frontmatter
3. Update plugin.json skills section
4. Link from relevant agents

### Adding New Commands

1. Create command markdown file (commands/[name].md)
2. Update plugin.json commands section
3. Implement command logic
4. Add relevant hooks if needed

### Adding New Hooks

1. Define hook event type
2. Add hook configuration to hooks.json
3. Specify trigger conditions
4. Define actions and responses

## Performance Considerations

### Lazy Loading

- Skills loaded on-demand
- Agents invoked based on context
- Large content loaded asynchronously

### Caching

- Career path data cached
- Assessment results cached
- Project recommendations cached

### Scalability

- Modular component design
- Independent agent operation
- Parallel command execution

## Security

- No sensitive data stored locally
- Privacy-focused analytics
- User consent for tracking
- Data encryption in transit
- No external API keys required

## Quality Assurance

- Plugin validation on load
- Manifest schema verification
- Skill frontmatter validation
- Command syntax checking
- Hook event validation

---

**Architecture Version**: 1.0.0
**Last Updated**: November 2024
