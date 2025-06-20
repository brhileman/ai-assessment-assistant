# Product Development Workflow for [project_name]

This project utilizes the Nova workflow, a structured approach for AI-assisted product development. This `README.md` (located in `shape/README.md`) provides an overview of the process and project structure.

---

## The Nova Process

The Nova process guides development through clear, sequential phases:

1.  **Big Picture (`shape/1_big-picture/`)**: Define strategic vision, goals, and create the Product Requirements Document (PRD).
    *   `prd_example.md`: Template and example for your PRD.
    *   `flowchart_example.md`: Template for user flows and system diagrams.
2.  **User Stories (`shape/2_user-stories/`)**: Break down the vision into specific user needs and acceptance criteria.
    *   `example.md`: Template for writing user stories.
3.  **Design System (`shape/3_design-system/`)**: Establish the visual language, UI components, and design standards.
    *   `example.md`: Template for documenting design decisions.
4.  **Tasks (`shape/4_tasks/`)**: Create detailed, actionable implementation task lists for each feature, derived from the PRD and user stories. These tasks include file tracking.
    *   `1_example.md`: Canonical template for feature task lists. Name subsequent task files like `2_feature_name.md`, `3_another_feature.md`, etc.
5.  **Coding (`code/`)**: Implement the application based on the defined tasks. AI assistance is guided by Cursor Rules.
6.  **Progress Tracking (`progress.md`)**: Monitor overall project status, task completion, and blockers in the root `progress.md` file.

Each phase has associated Cursor Rules (`.cursor/rules/` and nested within `shape/*/.cursor/rules/`) that provide contextual guidance to the AI assistant.

---

## Generated Project Structure

```
[project_name]/
├── .windsurfrules                # Legacy support, points to modern rules
├── .cursor/                    # Cursor-specific configuration & rules
│   └── rules/
│       ├── nova-project.mdc      # Core Nova workflow guidance (always active)
│       ├── shape-documentation.mdc # Rules for working in the shape/ directory
│       ├── code-development.mdc    # Rules for working in the code/ directory
│       └── tasks.mdc             # Rules for task creation & progress tracking
├── progress.md                   # Overall project progress tracking
├── shape/                        # Product definition & planning documents
│   ├── README.md                 # This overview file
│   ├── 1_big-picture/
│   │   ├── .cursor/rules/big-picture.mdc # Guidance for PRD & vision
│   │   ├── prd_example.md
│   │   └── flowchart_example.md
│   ├── 2_user-stories/
│   │   ├── .cursor/rules/user-stories.mdc # Guidance for user stories
│   │   └── example.md
│   ├── 3_design-system/
│   │   ├── .cursor/rules/design-system.mdc # Guidance for design system
│   │   └── example.md
│   └── 4_tasks/
│       └── 1_example.md          # Template for feature task lists
└── code/                         # Application source code
```

---

## Getting Started with AI Assistance

1.  **Familiarize the AI**: Ensure the AI assistant has read this `shape/README.md` and the main `.cursor/rules/nova-project.mdc` rule.
2.  **Follow the Phases**: Work through the `shape/` subdirectories sequentially.
3.  **Use Cursor Rules**: Cursor rules will automatically activate based on the directory you are working in, providing contextual guidance. Pay attention to these rules.
4.  **PRD First**: Start by fleshing out `shape/1_big-picture/prd_example.md`.
5.  **User Stories Next**: Define user stories in `shape/2_user-stories/example.md` based on the PRD.
6.  **Design System**: Document design decisions in `shape/3_design-system/example.md`.
7.  **Create Tasks**: For each feature, create a new task file in `shape/4_tasks/` (e.g., `shape/4_tasks/2_new_feature.md`) using `1_example.md` as a template. The AI can help generate these tasks based on the PRD and user stories, guided by `.cursor/rules/tasks.mdc`.
8.  **Implement Tasks**: Work through the sub-tasks in your feature task files. Update the checkboxes `[ ]` to `[x]` upon completion.
9.  **Track Files**: Update the "File Tracking" section in each task file as you create or modify files.
10. **Update Progress**: Regularly update `progress.md` to reflect the status of tasks and features.

---

## Best Practices

- **Start with Why**: Always begin by understanding the strategic purpose behind the project from the PRD.
- **Focus on User Value**: Keep the user's needs (from user stories) at the center of all planning and implementation.
- **Task Granularity**: Break down features into small, manageable tasks.
- **Iterate and Refine**: The process is iterative. Revisit and update documents in `shape/` and `progress.md` as you learn and make changes during development.

---

For questions or suggestions, please contact Ryan Francis (ryan@launchpadlab.com).
