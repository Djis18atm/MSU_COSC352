import gleam/io
import gleam/int
import gleam/string
import gleam/javascript/promise

// JavaScript function to get user input using prompt
@external(javascript, "./input.mjs", "prompt")
pub fn prompt(message: String) -> String

pub fn get_input(prompt_message: String) -> String {
  prompt(prompt_message)
}

pub fn print_n_times(name: String, n: Int) {
  case n {
    t if t > 0 -> {
      io.println("Hello, " <> name <> "!")
      print_n_times(name, t - 1)
    }
    _ -> Nil
  }
}

pub fn main() {
  // Get user's name
  let name = get_input("Enter your name: ")
  
  // Get number of times to print
  let count_input = get_input("How many times do you want to print? ")
  
  // Convert input to integer with fallback to 1 if parsing fails
  let count = 
    case int.parse(string.trim(count_input)) {
      Ok(n) -> n
      Error(_) -> {
        io.println("Invalid number, defaulting to 1")
        1
      }
    }
  
  print_n_times(name, count)
}