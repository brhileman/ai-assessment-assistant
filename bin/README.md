# Rails Development Wrapper Scripts

This directory contains wrapper scripts that automatically delegate common Rails commands to the correct nested Rails application directory (`code/ai_assessment_assistant/`).

## 🎯 Purpose

These scripts solve the common issue of trying to run Rails commands from the project root when the actual Rails app is nested in a subdirectory.

## 📜 Available Scripts

### `bin/rails`
Delegates all Rails commands to the nested Rails app.

**Usage:**
```bash
# From project root - these now work automatically!
bin/rails server
bin/rails console  
bin/rails db:migrate
bin/rails generate model User
bin/rails --version
```

### `bin/dev` 
Starts the development server from the correct directory.

**Usage:**
```bash
# From project root
bin/dev
# Server will be available at http://localhost:3000
```

### `bin/bundle`
Delegates bundle commands to the Rails app directory.

**Usage:**
```bash
# From project root  
bin/bundle install
bin/bundle update
bin/bundle exec rspec
```

## 🔧 How It Works

Each wrapper script:
1. ✅ Checks that the Rails app directory exists
2. 📂 Changes to the correct directory (`code/ai_assessment_assistant/`)
3. 🚀 Executes the actual command with all passed arguments
4. 💡 Provides helpful error messages if something is wrong

## 🚫 Problem This Solves

**Before:** 
```bash
$ bin/rails server
zsh: no such file or directory: bin/rails
```

**After:**
```bash
$ bin/rails server  
🚀 Rails Wrapper: Delegating to code/ai_assessment_assistant
📂 Running: cd /path/to/code/ai_assessment_assistant && bin/rails server
=> Booting Puma...
```

## 🎁 Benefits

- 🎯 **No more directory confusion** - Run Rails commands from anywhere in the project
- 🛡️ **Error prevention** - Clear error messages if structure is wrong
- 🚀 **Faster development** - No need to remember to `cd` to the right directory
- 📖 **Self-documenting** - Scripts show exactly what they're doing

---

*These wrapper scripts make development more convenient and prevent common directory-related errors.* 