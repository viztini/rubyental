#!/usr/bin/env ruby

TODO_FILE = 'todo.txt'
JOURNAL_FILE = 'journal.txt'

# --- Helper Methods ---

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

def display_tasks(tasks)
  if tasks.empty?
    puts "Your todo list is empty!"
  else
    puts "\n--- TODO List ---"
    tasks.each_with_index do |task, index|
      puts "#{index + 1}. #{task}"
    end
    puts "-------------------"
  end
end

def display_journal(journal_entries)
  if journal_entries.empty?
    puts "Your journal is empty!"
  else
    puts "\n--- Journal Entries ---"
    journal_entries.each_with_index do |entry, index|
      puts "#{index + 1}. #{entry}"
    end
    puts "-----------------------"
  end
end

# --- Todo List Actions ---

def add_task(tasks)
  print "Enter new task: "
  task = gets.chomp
  tasks << "[ ] #{task}"
  save_tasks(tasks)
  puts "Task added."
end

def mark_complete(tasks)
  display_tasks(tasks)
  return if tasks.empty?

  print "Enter the number of the task to mark as complete: "
  index = gets.chomp.to_i - 1

  if index >= 0 && index < tasks.length
    tasks[index].sub!("[ ]","[x]")
    save_tasks(tasks)
    puts "Task marked as complete."
  else
    puts "Invalid task number."
  end
end

def delete_task(tasks)
  display_tasks(tasks)
  return if tasks.empty?

  print "Enter the number of the task to delete: "
  index = gets.chomp.to_i - 1

  if index >= 0 && index < tasks.length
    tasks.delete_at(index)
    save_tasks(tasks)
    puts "Task deleted."
  else
    puts "Invalid task number."
  end
end

def clear_tasks(tasks)
  print "Are you sure you want to clear all tasks? (y/N): "
  confirm = gets.chomp.downcase
  if confirm == 'y'
    tasks.clear
    save_tasks(tasks)
    puts "All tasks cleared."
  else
    puts "Operation cancelled."
  end
end

# --- Journal Actions ---

def add_journal_entry(journal_entries)
  print "Enter journal entry: "
  entry = gets.chomp
  journal_entries << "#{Time.now.strftime("%Y-%m-%d %H:%M")} - #{entry}"
  save_journal(journal_entries)
  puts "Journal entry added."
end

def clear_journal(journal_entries)
  print "Are you sure you want to clear all journal entries? (y/N): "
  confirm = gets.chomp.downcase
  if confirm == 'y'
    journal_entries.clear
    save_journal(journal_entries)
    puts "All journal entries cleared."
  else
    puts "Operation cancelled."
  end
end

# --- Main Application Loop ---

def main
  tasks = load_tasks
  journal_entries = load_journal

  loop do
    puts "\n--- CLI Todo & Journal App ---"
    puts "1. View Todo List"
    puts "2. Add Task"
    puts "3. Mark Task Complete"
    puts "4. Delete Task"
    puts "5. Clear All Tasks"
    puts "6. View Journal"
    puts "7. Add Journal Entry"
    puts "8. Clear All Journal Entries"
    puts "9. Exit"
    print "Choose an option: "

    choice = gets.chomp.to_i

    case choice
    when 1
      display_tasks(tasks)
    when 2
      add_task(tasks)
    when 3
      mark_complete(tasks)
    when 4
      delete_task(tasks)
    when 5
      clear_tasks(tasks)
    when 6
      display_journal(journal_entries)
    when 7
      add_journal_entry(journal_entries)
    when 8
      clear_journal(journal_entries)
    when 9
      puts "Exiting application. Goodbye!"
      break
    else
      puts "Invalid option. Please try again."
    end
  end
end

main
