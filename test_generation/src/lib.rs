use rand::rngs::StdRng;
use rand::SeedableRng;
use std::env;
use std::error::Error;
use std::ffi::OsString;
use std::fs::read_dir;
use std::io;
use std::io::ErrorKind;
use std::path::PathBuf;

/// ALU functionality, ALU register-immediate and register-register test vectors
pub mod alu;

/// Instruction type definitions and respective functions
pub mod instruction;

/// Generic test vector definitions
pub mod test_vector;

// Directory where generated test vector files are located
const TEST_DIR: &str = "../tests/"; // relative to crate root

// Test vector files inside TEST_DIR
const ALU_REG_IMM_FILE_NAME: &str = "alu_reg_imm.tv";
const ALU_REG_REG_FILE_NAME: &str = "alu_reg_reg.tv";

// Number of vectors to generate
const NUM_VECTORS: usize = 100;

// Get root directory of crate
// Stolen from https://docs.rs/project-root/latest/project_root/fn.get_project_root.html
fn get_crate_root() -> io::Result<PathBuf> {
    let path = env::current_dir()?;
    let mut path_ancestors = path.as_path().ancestors();

    while let Some(p) = path_ancestors.next() {
        let has_cargo = read_dir(p)?
            .into_iter()
            .any(|p| p.unwrap().file_name() == OsString::from("Cargo.lock"));
        if has_cargo {
            return Ok(PathBuf::from(p));
        }
    }
    Err(io::Error::new(
        ErrorKind::NotFound,
        "Could not determine project root directory.",
    ))
}

/// Execute test vector generation
pub fn run() -> Result<(), Box<dyn Error>> {
    let mut rng = StdRng::seed_from_u64(0);

    let crate_root = get_crate_root()?;
    let test_dir = crate_root.join(TEST_DIR);
    let alu_reg_imm = test_dir.join(ALU_REG_IMM_FILE_NAME);
    let alu_reg_reg = test_dir.join(ALU_REG_REG_FILE_NAME);

    test_vector::generate_vectors::<alu::AluRegImmTestVector>(
        alu_reg_imm,
        NUM_VECTORS,
        &mut rng,
    )?;
    test_vector::generate_vectors::<alu::AluRegRegTestVector>(
        alu_reg_reg,
        NUM_VECTORS,
        &mut rng,
    )?;

    Ok(())
}
