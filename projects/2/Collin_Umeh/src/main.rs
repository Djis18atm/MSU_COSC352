use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    
    if args.len() != 3 {
        eprintln!("Usage: ./hello <name> <number>");
        return;
    }

    let name = &args[1];

    let num: i32 = match args[2].parse() {
        Ok(n) => n,
        Err(_) => {
            eprintln!("Error: '{}' is not a valid integer. Please enter a valid number.", args[2]);
            return;
        }
    };

    for _ in 0..num {
        println!("Hello, {}", name);
    }
}

