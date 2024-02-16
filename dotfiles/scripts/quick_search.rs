use std::env;
use std::process::Command;
// URls that can be run 
const YOUTUBE: &str = "www.youtube.com/results?search_query=";
const GOOGLE: &str = "www.google.com/search?q=";
const REDDIT: &str = "www.reddit.com/search?q=";
const CHAT: &str = "https://chat.openai.com/";
const NIX: &str = "search.nixos.org/packages?query=";
const SPOTYFIE:&str = "https://open.spotify.com/";
const BROWSER: &str = "brave";

fn main() {
    // Collects args and chec are there correcte 
    let args: Vec<String> = env::args().collect();
    if args.len() == 1 {
        help();
        std::process::exit(1);
    } else {
        let query = search(&args);
        let mut run = Command::new("sh");
        run.arg(BROWSER).arg(query);
        run.status().expect("Process failed to execute");
    }
}

fn search(cargs: &Vec<String>) -> String {
    // match weteher option is valid
    // Appedn the url correctly 
    let mut url = String::new();
    if let Some(command) = cargs.get(1) {
        match command.as_str() {
            "-yt" => url += YOUTUBE,
            "-go" => url += GOOGLE,
            "-re" => url += REDDIT,
            "-nx" => url += NIX,
            "-gt" => url += CHAT,
            "-sp" => url += SPOTYFIE,
            _ => {
                println!("That's not a valid option");
                help();
                std::process::exit(1);
            }
        }
    }
    //join the quey of the usere 
    let query = cargs[2..].join(" ");
    url = format!("{}{}", url, query);

    url
}
// Just user guide 
fn help() {
    println!(
        "Usage:
  quicksearch <command> [options]
Commands:
    -yt  search in YouTube
    -go  search in Google
    -re  search in Reddit
    -nx  search in Nix packages
    -gt  search in Chat GPT
    -sp  open spotyfie  
"

    
    );
}
