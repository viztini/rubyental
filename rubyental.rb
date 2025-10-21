#!/usr/bin/env ruby

require 'io/console'
require 'readline'

TODO_FILE = 'todo.txt'
JOURNAL_FILE = 'journal.txt'

# --- Terminal Colors ---
RED = "\e[31m"
WHITE = "\e[37m"
GREEN = "\e[32m"
YELLOW = "\e[33m"
RESET = "\e[0m"

# --- Helper Methods ---

def clear_screen
  print "\e[H\e[2J"
end

def get_terminal_width
  # Attempt to get terminal width, default to 80 if not available
  if STDOUT.tty?
    begin
      IO.console.winsize[1]
    rescue NoMethodError
      80 # Default if io/console isn't available or fails
    end
  else
    80 # Default for non-tty environments
  end
end

def center_text(text, width)
  padding = (width - text.length) / 2
  " " * padding + text + " " * (width - text.length - padding)
end

def draw_line(width, char = '-')
  puts RED + char * width + RESET
end

def draw_box_content(content_lines, width, color = WHITE)
  side_padding = 2
  content_width = width - (side_padding * 2) - 2 # Account for borders

  puts RED + "+" + char = '-' * (width - 2) + "+" + RESET
  content_lines.each do |line|
    puts RED + "|" + color + line.ljust(content_width) + RESET + RED + "|" + RESET
  end
  puts RED + "+" + char = '-' * (width - 2) + "+" + RESET
end

def load_tasks
  tasks = []
  if File.exist?(TODO_FILE)
    File.foreach(TODO_FILE) do |line|
      tasks << line.chomp
    end
  end
  tasks
end

def save_tasks(tasks)
  File.open(TODO_FILE, 'w') do |file|
    tasks.each do |task|
      file.puts task
    end
  end
end

def load_journal
  journal_entries = []
  if File.exist?(JOURNAL_FILE)
    File.foreach(JOURNAL_FILE) do |line|
      journal_entries << line.chomp
    end
  end
  journal_entries
end

def save_journal(journal_entries)
  File.open(JOURNAL_FILE, 'w') do |file|
    journal_entries.each do |entry|
      file.puts entry
    end
  end
end

def draw_header(width)
  clear_screen
  draw_line(width, '=')
  puts RED + center_text("rubyental - Your Mental Well-being Companion", width) + RESET
  draw_line(width, '=')
end

def display_message(message, width, color = RED)
  draw_header(width)
  puts color + center_text(message, width) + RESET
  puts "\nPress Enter to continue..."
  Readline.readline("", true)
end

def display_tasks(tasks, width)
  draw_header(width)
  content = []
  content << center_text("TODO List", width - 4)
  content << "" # Spacer

  if tasks.empty?
    content << center_text("Your todo list is empty!", width - 4)
  else
    tasks.each_with_index do |task, index|
      status_color = task.start_with?("[x]") ? RED : WHITE
      content << status_color + "#{index + 1}. #{task}".ljust(width - 4) + RESET
    end
  end
  draw_box_content(content, width)
  puts "\nPress Enter to continue..."
  Readline.readline("", true)
end

def display_journal(journal_entries, width)
  draw_header(width)
  content = []
  content << center_text("Journal Entries", width - 4)
  content << "" # Spacer

  if journal_entries.empty?
    content << center_text("Your journal is empty!", width - 4)
  else
    journal_entries.each_with_index do |entry, index|
      content << WHITE + "#{index + 1}. #{entry}".ljust(width - 4) + RESET
    end
  end
  draw_box_content(content, width)
  puts "\nPress Enter to continue..."
  Readline.readline("", true)
end

# --- Todo List Actions ---

def add_task(tasks, width)
  draw_header(width)
  puts WHITE + center_text("Add New Task", width) + RESET
  draw_line(width)
  task = Readline.readline(WHITE + "Enter new task: " + RESET, true)
  tasks << "[ ] #{task}"
  save_tasks(tasks)
  display_message("Task added.", width)
end

def mark_complete(tasks, width)
  draw_header(width)
  display_tasks(tasks, width)
  return if tasks.empty?

  index_str = Readline.readline(WHITE + "Enter the number of the task to mark as complete: " + RESET, true)
  index = index_str.to_i - 1

  if index >= 0 && index < tasks.length
    tasks[index].sub!("[ ]", "[x]")
    save_tasks(tasks)
    display_message("Task marked as complete.", width)
  else
    display_message("Invalid task number.", width)
  end
end

def delete_task(tasks, width)
  draw_header(width)
  display_tasks(tasks, width)
  return if tasks.empty?

  index_str = Readline.readline(WHITE + "Enter the number of the task to delete: " + RESET, true)
  index = index_str.to_i - 1

  if index >= 0 && index < tasks.length
    tasks.delete_at(index)
    save_tasks(tasks)
    display_message("Task deleted.", width)
  else
    display_message("Invalid task number.", width)
  end
end

def clear_tasks(tasks, width)
  draw_header(width)
  puts WHITE + center_text("Clear All Tasks", width) + RESET
  draw_line(width)
  confirm = Readline.readline(WHITE + "Are you sure you want to clear all tasks? (y/N): " + RESET, true).downcase
  if confirm == 'y'
    tasks.clear
    save_tasks(tasks)
    display_message("All tasks cleared.", width)
  else
    display_message("Operation cancelled.", width, WHITE)
  end
end

# --- Journal Actions ---

def add_journal_entry(journal_entries, width)
  draw_header(width)
  puts WHITE + center_text("Add New Journal Entry", width) + RESET
  draw_line(width)
  title = Readline.readline(WHITE + "Enter title for journal entry: " + RESET, true)
  entry = Readline.readline(WHITE + "Enter journal entry: " + RESET, true)
  journal_entries << "[#{title}] #{Time.now.strftime("%Y-%m-%d %H:%M")} - #{entry}"
  save_journal(journal_entries)
  display_message("Journal entry added.", width)
end

def delete_journal_entry(journal_entries, width)
  draw_header(width)
  display_journal(journal_entries, width)
  return if journal_entries.empty?

  index_str = Readline.readline(WHITE + "Enter the number of the journal entry to delete: " + RESET, true)
  index = index_str.to_i - 1

  if index >= 0 && index < journal_entries.length
    journal_entries.delete_at(index)
    save_journal(journal_entries)
    display_message("Journal entry deleted.", width)
  else
    display_message("Invalid journal entry number.", width)
  end
end

def clear_journal(journal_entries, width)
  draw_header(width)
  puts WHITE + center_text("Clear All Journal Entries", width) + RESET
  draw_line(width)
  confirm = Readline.readline(WHITE + "Are you sure you want to clear all journal entries? (y/N): " + RESET, true).downcase
  if confirm == 'y'
    journal_entries.clear
    save_journal(journal_entries)
    display_message("All journal entries cleared.", width)
  else
    display_message("Operation cancelled.", width, WHITE)
  end
end

# --- Main Application Loop ---

def main
  tasks = load_tasks
  journal_entries = load_journal
  terminal_width = get_terminal_width

  loop do
    draw_header(terminal_width)
    draw_line(terminal_width)
    puts WHITE + center_text("Main Menu", terminal_width) + RESET
    draw_line(terminal_width)
    menu_options = [
      "1. View Todo List",
      "2. Add Task",
      "3. Mark Task Complete",
      "4. Delete Task",
      "5. Clear All Tasks",
      "6. View Journal",
      "7. Add Journal Entry",
      "8. Delete Journal Entry",
      "9. Clear All Journal Entries",
      "10. Exit"
    ]
    menu_options.each do |option|
      puts WHITE + option.ljust(terminal_width) + RESET
    end
    draw_line(terminal_width)
    choice_str = Readline.readline(WHITE + "Choose an option: " + RESET, true)
    choice = choice_str.to_i

    case choice
    when 1
      display_tasks(tasks, terminal_width)
    when 2
      add_task(tasks, terminal_width)
    when 3
      mark_complete(tasks, terminal_width)
    when 4
      delete_task(tasks, terminal_width)
    when 5
      clear_tasks(tasks, terminal_width)
    when 6
      display_journal(journal_entries, terminal_width)
    when 7
      add_journal_entry(journal_entries, terminal_width)
    when 8
      delete_journal_entry(journal_entries, terminal_width)
    when 9
      clear_journal(journal_entries, terminal_width)
    when 10
      clear_screen
      puts RED + center_text("Exiting rubyental. Goodbye!", terminal_width) + RESET
      break
    else
      display_message("Invalid option. Please try again.", terminal_width)
    end
  end
end

main
