use crate::alu::Alu;
use crate::instruction::decoder::InstructionDecoder;
use crate::program_counter::ProgramCounter;
use crate::register::RegisterArray;
use rand::rngs::StdRng;

pub struct Cpu {
    alu: Alu,
    instruction_decoder: InstructionDecoder,
    registers: RegisterArray,
    program_counter: ProgramCounter,
    rng: StdRng,
}

impl Cpu {
    pub fn new(mut rng: StdRng) -> Self {
        Cpu {
            alu: Alu::new(),
            instruction_decoder: InstructionDecoder::new(),
            registers: RegisterArray::uninitialized(&mut rng),
            program_counter: ProgramCounter::new(),
            rng,
        }
    }

    pub fn alu(&self) -> &Alu {
        &self.alu
    }

    pub fn instruction_decoder(&self) -> &InstructionDecoder {
        &self.instruction_decoder
    }

    pub fn registers(&self) -> &RegisterArray {
        &self.registers
    }

    pub fn program_counter(&self) -> &ProgramCounter {
        &self.program_counter
    }

    pub fn rng(&mut self) -> &mut StdRng {
        &mut self.rng
    }
}
