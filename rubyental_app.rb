#!/usr/bin/env ruby

TODO_FILE = 'todo.txt'
JOURNAL_FILE = 'journal.txt'

# --- Terminal Colors ---
RED = "\e[31m"
WHITE = "\e[37m"
RESET = "\e[0m"

# --- Helper Methods ---

def clear_screen
  print "\e[H\e[2J"
end

def get_terminal_width
  # Attempt to get terminal width, default to 80 if not available
  if STDOUT.tty?
    begin
      require 'io/console'
      IO.console.winsize[1]
    rescue LoadError, NoMethodError
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

def display_tasks(tasks, width)
  draw_line(width)
  puts WHITE + center_text("TODO List", width) + RESET
  draw_line(width)

  if tasks.empty?
    puts WHITE + center_text("Your todo list is empty!", width) + RESET
  else
    tasks.each_with_index do |task, index|
      status_color = task.start_with?("[x]") ? RED : WHITE
      line = "#{index + 1}. #{task}"
      puts status_color + line.ljust(width) + RESET
    end
  end
  draw_line(width)
  puts "\nPress Enter to continue..."
  gets
end

def display_journal(journal_entries, width)
  draw_line(width)
  puts WHITE + center_text("Journal Entries", width) + RESET
  draw_line(width)

  if journal_entries.empty?
    puts WHITE + center_text("Your journal is empty!", width) + RESET
  else
    journal_entries.each_with_index do |entry, index|
      line = "#{index + 1}. #{entry}"
      puts WHITE + line.ljust(width) + RESET
    end
  end
  draw_line(width)
  puts "\nPress Enter to continue..."
  gets
end

# --- Todo List Actions ---

def add_task(tasks, width)
  draw_header(width)
  puts WHITE + center_text("Add New Task", width) + RESET
  draw_line(width)
  print WHITE + "Enter new task: " + RESET
  task = gets.chomp
  tasks << "[ ] #{task}"
  save_tasks(tasks)
  puts RED + "Task added." + RESET
  puts "\nPress Enter to continue..."
  gets
end

def mark_complete(tasks, width)
  draw_header(width)
  display_tasks(tasks, width)
  return if tasks.empty?

  print WHITE + "Enter the number of the task to mark as complete: " + RESET
  index = gets.chomp.to_i - 1

  if index >= 0 && index < tasks.length
    tasks[index].sub!("[ ]", "[x]")
    save_tasks(tasks)
    puts RED + "Task marked as complete." + RESET
  else
    puts RED + "Invalid task number." + RESET
  end
  puts "\nPress Enter to continue..."
  gets
end

def delete_task(tasks, width)
  draw_header(width)
  display_tasks(tasks, width)
  return if tasks.empty?

  print WHITE + "Enter the number of the task to delete: " + RESET
  index = gets.chomp.to_i - 1

  if index >= 0 && index < tasks.length
    tasks.delete_at(index)
    save_tasks(tasks)
    puts RED + "Task deleted." + RESET
  else
    puts RED + "Invalid task number." + RESET
  end
  puts "\nPress Enter to continue..."
  gets
end

def clear_tasks(tasks, width)
  draw_header(width)
  puts WHITE + center_text("Clear All Tasks", width) + RESET
  draw_line(width)
  print WHITE + "Are you sure you want to clear all tasks? (y/N): " + RESET
  confirm = gets.chomp.downcase
  if confirm == 'y'
    tasks.clear
    save_tasks(tasks)
    puts RED + "All tasks cleared." + RESET
  else
    puts WHITE + "Operation cancelled." + RESET
  end
  puts "\nPress Enter to continue..."
  gets
end

# --- Journal Actions ---

def add_journal_entry(journal_entries, width)
  draw_header(width)
  puts WHITE + center_text("Add New Journal Entry", width) + RESET
  draw_line(width)
  print WHITE + "Enter journal entry: " + RESET
  entry = gets.chomp
  journal_entries << "#{Time.now.strftime("%Y-%m-%d %H:%M")} - #{entry}"
  save_journal(journal_entries)
  puts RED + "Journal entry added." + RESET
  puts "\nPress Enter to continue..."
  gets
end

def clear_journal(journal_entries, width)
  draw_header(width)
  puts WHITE + center_text("Clear All Journal Entries", width) + RESET
  draw_line(width)
  print WHITE + "Are you sure you want to clear all journal entries? (y/N): " + RESET
  confirm = gets.chomp.downcase
  if confirm == 'y'
    journal_entries.clear
    save_journal(journal_entries)
    puts RED + "All journal entries cleared." + RESET
  else
    puts WHITE + "Operation cancelled." + RESET
  end
  puts "\nPress Enter to continue..."
  gets
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
    puts WHITE + "1. View Todo List".ljust(terminal_width) + RESET
    puts WHITE + "2. Add Task".ljust(terminal_width) + RESET
    puts WHITE + "3. Mark Task Complete".ljust(terminal_width) + RESET
    puts WHITE + "4. Delete Task".ljust(terminal_width) + RESET
    puts WHITE + "5. Clear All Tasks".ljust(terminal_width) + RESET
    puts WHITE + "6. View Journal".ljust(terminal_width) + RESET
    puts WHITE + "7. Add Journal Entry".ljust(terminal_width) + RESET
    puts WHITE + "8. Clear All Journal Entries".ljust(terminal_width) + RESET
    puts WHITE + "9. Exit".ljust(terminal_width) + RESET
    draw_line(terminal_width)
    print WHITE + "Choose an option: " + RESET

    choice = gets.chomp.to_i

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
      clear_journal(journal_entries, terminal_width)
    when 9
      clear_screen
      puts RED + center_text("Exiting rubyental. Goodbye!", terminal_width) + RESET
      break
    else
      draw_header(terminal_width)
      puts RED + center_text("Invalid option. Please try again.", terminal_width) + RESET
      puts "\nPress Enter to continue..."
      gets
    end
  end
end

main
