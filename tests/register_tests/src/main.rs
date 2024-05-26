use std::{fs::File, io::Write};

use itertools::Itertools;
use rand::{rngs::StdRng, Rng, SeedableRng};

#[derive(Clone)]
struct Registers {
    regs: [u32; 31],
}

impl Registers {
    pub fn new() -> Registers {
        Registers { regs: [0; 31] }
    }

    pub fn get(&self, n: u8) -> u32 {
        if n == 0 {
            return 0;
        }
        return self.regs[n as usize - 1];
    }

    pub fn set(&mut self, n: u8, value: u32) {
        if n == 0 {
            return;
        }
        self.regs[n as usize - 1] = value;
    }
}

struct TestOp {
    store: (u8, u32),
    assert: Registers,
}

impl TestOp {
    fn gen_test(&self) -> String {
        let asrt = self
            .assert
            .regs
            .iter()
            .map(|x| format!("{x:08x}"))
            .join("_");
        format!(
            "{:02x}_{:08x}__00000000_{}\n",
            self.store.0, self.store.1, asrt
        )
    }
}

fn main() {
    let mut regs = Registers::new();

    let mut rng = StdRng::seed_from_u64(1234567890123);
    let mut of = File::create("register_tests.sv").unwrap();
    for _ in 0..100 {
        let store_addr = rng.gen_range(0..=31);
        let value = rng.gen();
        regs.set(store_addr, value);
        let op = TestOp {
            store: (store_addr, value),
            assert: regs.clone(),
        };
        of.write_all(op.gen_test().as_bytes()).unwrap();
    }
}
