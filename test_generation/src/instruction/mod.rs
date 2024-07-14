pub mod decoder;
pub mod i_type;
pub mod r_type;

pub trait InstructionType {
    /// Generate 32 bit instruction from field values
    fn to_u32(&self) -> u32;

    fn decode(instruction: u32) -> Self;
}
