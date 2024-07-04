use rand::{SeedableRng, rngs::StdRng};
use std::error::Error;

pub mod alu;
pub mod instruction;
pub mod test_vector;

const ALU_REG_IMM_VECTOR_FILE_PATH: &str = "../tests/alu_reg_imm.tv";
const ALU_REG_REG_VECTOR_FILE_PATH: &str = "../tests/alu_reg_reg.tv";
const NUM_VECTORS: usize = 100;

/// Execute test vector generation
pub fn run() -> Result<(), Box<dyn Error>> {
    let mut rng = StdRng::seed_from_u64(0);
    test_vector::generate_vectors::<alu::AluRegImmTestVector>(
        ALU_REG_IMM_VECTOR_FILE_PATH,
        NUM_VECTORS,
        &mut rng,
    )?;
    test_vector::generate_vectors::<alu::AluRegRegTestVector>(
        ALU_REG_REG_VECTOR_FILE_PATH,
        NUM_VECTORS,
        &mut rng,
    )?;

    Ok(())
}
