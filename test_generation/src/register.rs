use rand::{rngs::StdRng, Rng};
use std::array;

const XLEN: usize = 32;

#[derive(Clone, Copy)]
pub struct Register {
    data: u32,
}

impl Register {
    pub fn uninitialized(rng: &mut StdRng) -> Self {
        Self { data: rng.gen() }
    }

    pub fn new(data: u32) -> Self {
        Self { data }
    }

    pub fn reset(&mut self, rng: &mut StdRng) {
        self.data = rng.gen();
    }

    pub fn load(&self) -> u32 {
        self.data
    }

    pub fn store(&mut self, new_data: u32) {
        self.data = new_data;
    }
}

pub struct RegisterArray {
    registers: [Register; XLEN],
}

impl RegisterArray {
    fn get_register(&self, register: u8) -> Register {
        self.registers[register as usize & 0x1f]
    }

    pub fn uninitialized(rng: &mut StdRng) -> Self {
        Self {
            registers: array::from_fn(|idx| match idx {
                0 => Register::new(0),
                _ => Register::uninitialized(rng),
            }),
        }
    }

    pub fn reset(&mut self, rng: &mut StdRng) {
        self.registers[0].store(0);
        for register in 1..XLEN {
            self.registers[register].reset(rng);
        }
    }

    pub fn load(&self, register: u8) -> u32 {
        self.get_register(register).load()
    }

    pub fn store(&mut self, register: u8, data: u32) {
        self.get_register(register).store(data)
    }
}
