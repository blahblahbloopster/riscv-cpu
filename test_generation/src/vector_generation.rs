use crate::alu::reg_imm_test::AluRegImmTestVector;
use crate::alu::reg_reg_test::AluRegRegTestVector;
use crate::cpu::Cpu;
use crate::test_vector;
use std::env;
use std::error::Error;
use std::ffi::OsString;
use std::fs::read_dir;
use std::io;
use std::io::ErrorKind;
use std::path::PathBuf;

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
pub fn run(mut cpu: Cpu) -> Result<(), Box<dyn Error>> {
    let crate_root = get_crate_root()?;
    let test_dir = crate_root.join(TEST_DIR);
    let alu_reg_imm_vector_file = test_dir.join(ALU_REG_IMM_FILE_NAME);
    let alu_reg_reg_vector_file = test_dir.join(ALU_REG_REG_FILE_NAME);

    test_vector::generate_vectors::<AluRegImmTestVector>(
        alu_reg_imm_vector_file,
        NUM_VECTORS,
        &mut cpu,
    )?;
    test_vector::generate_vectors::<AluRegRegTestVector>(
        alu_reg_reg_vector_file,
        NUM_VECTORS,
        &mut cpu,
    )?;

    Ok(())
}
