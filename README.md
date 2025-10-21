# rubyental

rubyental is a visually enhanced command-line interface (CLI) application built with Ruby, designed to help you manage your mental well-being through a combination of todo lists and journaling. It features a striking red and white color scheme, utilizes the full terminal width, and provides a GUI-like experience directly in your terminal.

## Features

*   **Visually Engaging Interface:** Full-screen, clear, and structured output with a red and white color scheme.
*   **Todo List Management:**
    *   Add new tasks.
    *   View your current tasks.
    *   Mark tasks as complete.
    *   Delete individual tasks.
    *   Clear all tasks.
*   **Journaling:**
    *   Add dated journal entries.
    *   View all your journal entries.
    *   Clear all journal entries (with confirmation).
*   **Persistence:** All your todo items and journal entries are saved automatically to local files (`todo.txt` and `journal.txt`) and loaded when you restart the application.

## Getting Started

### Prerequisites

You need Ruby installed on your system. You can download it from [ruby-lang.org](https://www.ruby-lang.org/en/downloads/).

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/viztini/rubyental.git
    cd rubyental
    ```
2.  **Run the installation script:**
    ```bash
    ./install.sh
    ```
    This script will copy the `rubyental` application to `~/.local/bin` and make it executable. It will also provide guidance if `~/.local/bin` is not in your system's PATH.

### Usage

After installation, you can run the application from any directory in your terminal by simply typing:

```bash
rubyental
```

Follow the on-screen menu to manage your todo list and journal entries.

## Example Output

```
================================================================================
                  rubyental - Your Mental Well-being Companion
================================================================================
--------------------------------------------------------------------------------
                                   Main Menu
--------------------------------------------------------------------------------
1. View Todo List
2. Add Task
3. Mark Task Complete
4. Delete Task
5. Clear All Tasks
6. View Journal
7. Add Journal Entry
8. Clear All Journal Entries
9. Exit
--------------------------------------------------------------------------------
Choose an option:
```

## File Structure

*   `rubyental_app.rb`: The main Ruby application script with visual enhancements.
*   `install.sh`: The installation script.
*   `todo.rb`: (Older version of the application, kept for reference if needed).
*   `todo.txt`: Stores your todo list items.
*   `journal.txt`: Stores your journal entries.

## Contributing

Contributions are welcome! If you have suggestions for improvements or new features, please feel free to open an issue or submit a pull request.

## License

This project is open-source and available under the MIT License.
