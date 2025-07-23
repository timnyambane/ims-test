# Task Manager Application

A task management system built with **Flutter** for the frontend and **Laravel** (PHP) for the backend. Designed for individuals to efficiently create, assign, and manage tasks with features like priority sorting, due date tracking, and worker assignment—all presented in a clean, intuitive UI.

---

## ✨ Features

- **✅ Task Management (CRUD):** Create, view, edit, and delete tasks.
- **👷 Worker Assignment:** Assign each task to a specific worker.
- **📌 Task Status:** Track progress via `pending`, `active`, and `completed`.
- **⚠️ Importance Levels:** Categorize tasks as `low`, `mid`, or `high` importance.
- **📅 Due Dates:** Pick future due dates via a user-friendly date picker.
- **🧠 Smart Sorting:**
  - Priority: High → Mid → Low
  - Within each priority: Soonest due date first
- **🎨 Visual Highlighting:**
  - **High Importance:** Bold borders, distinct icons/colors
  - **Urgent:** High priority + due today/tomorrow → extra highlight
  - **Critical:** High priority + overdue → strong visual alert
- **🧼 Swipe-to-Delete with Undo:** Delete by swipe with a temporary undo option.

# Setup

The backend url is set to `http://127.0.0.1:8000/api` in the `lib/services/api_service.dart` file. You can change it to your backend URL once you run the server.
The backend is on SQLite and `php 8.2.4`, so all you need to do is run `php artisan migrate --seed` for the 5 workers.
