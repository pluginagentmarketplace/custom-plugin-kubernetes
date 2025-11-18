---
name: frontend-mobile
description: Build beautiful, responsive user interfaces for web and mobile. Master modern frameworks, state management, and cross-platform development.
---

# Frontend & Mobile Skills

## Quick Start

### Modern React Component
```jsx
import React, { useState } from 'react';

function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>
        Increment
      </button>
    </div>
  );
}

export default Counter;
```

### Responsive CSS Grid
```css
.container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
}

@media (max-width: 768px) {
  .container {
    grid-template-columns: 1fr;
  }
}
```

## Core Concepts

### HTML & CSS Fundamentals
- Semantic HTML5
- CSS Grid and Flexbox
- Responsive design principles
- Accessibility (WCAG)
- CSS preprocessors (SCSS)

### JavaScript Essentials
- ES6+ features
- DOM manipulation
- Event handling
- Async/await and Promises
- Module systems

### Framework Mastery
- **React**: Components, hooks, state management
- **Vue**: Composition API, reactive data
- **Angular**: RxJS, dependency injection
- Framework comparison and selection

### Mobile Development
- React Native / Flutter basics
- Mobile-specific APIs
- Platform-specific UI patterns
- App lifecycle management
- Native module integration

## Advanced Topics

### State Management
- Redux and Redux Toolkit
- Vuex
- Context API
- Zustand, Jotai

### Performance Optimization
- Code splitting
- Lazy loading
- Image optimization
- Memoization and useMemo
- Bundle size analysis

### Testing
- Unit testing (Jest, Vitest)
- Component testing (React Testing Library)
- E2E testing (Cypress, Playwright)
- Accessibility testing

## Resources
- [Frontend Roadmap - roadmap.sh](https://roadmap.sh/frontend)
- [React Roadmap - roadmap.sh](https://roadmap.sh/react)
- [Mobile Development Paths - roadmap.sh](https://roadmap.sh)
- [Web.dev Learning Resources](https://web.dev/learn/)
