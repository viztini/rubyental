# rubymental

rubymental is a simple command-line interface (CLI) application built with Ruby, designed to help you manage your mental well-being through a combination of todo lists and journaling.

## Features

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
    git clone https://github.com/YOUR_USERNAME/rubymental.git
    cd rubymental
    ```
2.  **Make the script executable:**
    ```bash
    chmod +x todo.rb
    ```

### Usage

Run the application from your terminal:

```bash
./todo.rb
```

Follow the on-screen menu to manage your todo list and journal entries.

## File Structure

*   `todo.rb`: The main Ruby application script.
*   `todo.txt`: Stores your todo list items.
*   `journal.txt`: Stores your journal entries.

## Contributing

Contributions are welcome! If you have suggestions for improvements or new features, please feel free to open an issue or submit a pull request.

## License

This project is open-source and available under the MIT License.
