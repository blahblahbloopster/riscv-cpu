//! Framework for generating test vectors for a RISC-V 32I CPU implementation
use rand::{SeedableRng, rngs::StdRng};
use test_generation::cpu::Cpu;

fn main() {
    let rng = StdRng::seed_from_u64(0);
    let cpu = Cpu::new(rng);
    if let Err(e) = test_generation::vector_generation::run(cpu) {
        eprintln!("Error generating test vectors\n{e}");
        std::process::exit(1);
    }
}
