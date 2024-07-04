//! Framework for generating test vectors for a RISC-V 32I CPU implementation

fn main() {
    if let Err(e) = test_generation::run() {
        eprintln!("Error generating test vectors\n{e}");
        std::process::exit(1);
    }
}
