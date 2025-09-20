# Task Manager App

A simple Flutter task manager app using **BLoC** for state management.

## Features
- Add, edit, and delete tasks  
- Track task progress (To Do / In Progress / Done)  
- Filter tasks by status  
- Reorder tasks by drag and drop  
- Swipe left to edit, swipe right to delete  
- Clean and responsive UI  

## Architecture Overview
The app follows a clean and layered architecture with clear separation of concerns:

- **Bloc**  
  - Contains `task_bloc`, `task_event`, and `task_state` for handling all task-related business logic and state management.

- **Data**  
  - `models/` includes the Task model.  
  - `repository/` provides the task data source (in-memory repository for now).

- **Presentation**  
  - `pages/` hold the screens such as task list, add/edit task.  
  - `widgets/` include reusable UI components.

**Data flow:**  
`UI → Event → Bloc → State → UI`

## Project Structure

lib/
├── bloc/ # TaskBloc, TaskEvent, TaskState
├── data/
│ ├── models/ # Task model
│ └── repository/ # Task repository
├── presentation/
│ ├── pages/ # Screens
│ └── widgets/ # Reusable UI widgets
└── main.dart # App entry point

