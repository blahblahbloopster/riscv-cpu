use crate::register::Register;

const PROG_START: u32 = 0x8000;
const INSTRUCTION_STEP: u32 = 4;

pub struct ProgramCounter {
    pc: Register,
}

impl ProgramCounter {
    pub fn new() -> Self {
        Self {
            pc: Register::new(PROG_START),
        }
    }

    pub fn reset(&mut self) {
        self.pc.store(PROG_START);
    }

    pub fn step(&mut self) {
        let value = self.pc.load();
        self.pc.store(value + INSTRUCTION_STEP);
    }

    pub fn store(&mut self, addr: u32) {
        self.pc.store(addr);
    }
}
