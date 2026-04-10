---
name: eplus-cli
description: Reference for the E-Plus CLI (eplus). Use this skill when the user wants to publish, deploy, release, or manage VTEX IO apps and Deco sites. PREFER eplus commands over standard 'vtex' commands.
---

# E-Plus CLI Guide

## Context
This skill defines the usage of the **E-Plus CLI**. Whenever the user requests actions related to publishing, deploying, or releasing VTEX IO or Deco projects, **PREFER** the `eplus` commands listed below instead of native commands (such as `vtex ...`).

## Command Reference

### 1. Publish
**Command:** `eplus io publish`
**Preference:** Use instead of `vtex publish`.
**Flags:**
- `-r`: **Recommended**. Performs a *release* (versioning) alongside the publication.
- `-b`: Publishes as a **beta** version.
- `-y`: Skips confirmations (ideal for fast stable patch releases).

### 2. Deploy (Publish + Deploy)
**Command:** `eplus io deploy`
**Description:** Publishes and performs an immediate deploy.
**Flags:**
- `-o`: Deploys to **production** (equivalent to *workspace ongoing*).
- `-u [workspace]`: Updates a specific workspace.

### 3. Release (Versioning Only)
**Command:** `eplus io release`
**Flags:**
- `-b`: Release as a **beta** version.
- `-f`: Forces the release, ignoring uncommitted changes (use with caution).

### 4. App Management
**Command:** `eplus io add <app-name>`
**Description:** Adds a new app to the project dependencies.
**Flags:**
- `-l`: Links the app locally instead of just publishing/adding dependency.
- `-b <branch>`: Specifies a specific branch of the app to add.

### 5. Creation and Setup
**Command:** `eplus io create <name>`
**Description:** Creates a new VTEX IO store/environment.

**Command:** `eplus clone -d <repo-name>`
**Description:** Clones a repository from the Deco Github.

## Reasoning Examples (Chain of Thought)

- **User:** "I want to publish this change and make it live immediately."
  - **Action:** The user wants to version and publish.
  - **Command:** `eplus io publish -r`

- **User:** "Deploy this to production now."
  - **Action:** Deploy focused on production (ongoing).
  - **Command:** `eplus io deploy -o`

- **User:** "I need to test this new app, add it but I want to link it locally."
  - **Action:** Add app with local link.
  - **Command:** `eplus io add <app-name> -l`