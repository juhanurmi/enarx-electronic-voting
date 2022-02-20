use std::io;

fn main() {
    println!("Elections Alice is the option 1 and Bob is the option 2.");
    let mut elections: String = "".to_owned();
    for index in 1..10 {
      let mut choice = String::new();
      println!("Enter a vote: 1 or 2.");
      io::stdin().read_line(&mut choice).expect("string");
      let vote: &str = &format!("Vote {:?}={}", index, choice);
      elections.push_str(vote);
      println!("{}", elections);
    }
    let candiate1 = elections.matches("=1").count();
    let candiate2 = elections.matches("=2").count();
    println!("Counting the election results:");
    println!("Alice got {:?} votes.", candiate1);
    println!("Bob got {:?} votes.", candiate2);
    if candiate1 > candiate2 {
        println!("Result: Alice is the new president.");
    } else {
        println!("Result: Bob is the new president.");
    }
}
