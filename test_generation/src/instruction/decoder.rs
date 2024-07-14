use super::InstructionType;

pub struct InstructionDecoder {}

impl InstructionDecoder {
    pub fn new() -> Self {
        Self {}
    }

    pub fn decode<T: InstructionType>(instruction: u32) -> T {
        T::decode(instruction)
    }
}
