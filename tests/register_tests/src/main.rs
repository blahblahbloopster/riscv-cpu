use std::{fs::File, io::Write};

use rand::{rngs::StdRng, Rng, SeedableRng};

#[derive(Clone)]
struct Registers {
    regs: [u32; 31],
}

impl Registers {
    pub fn new() -> Registers {
        Registers { regs: [0; 31] }
    }

    pub fn reset(&mut self) {
        self.regs = [0; 31];
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

    pub fn gen_assert(&self, rng: &mut StdRng) -> RegisterAssert {
        let addr = rng.gen_range(0..=31);
        let value = self.get(addr);
        RegisterAssert { addr, value }
    }
}

struct RegisterAssert {
    addr: u8,
    value: u32,
}

struct TestOp {
    reset_n: bool,
    store: (u8, u32),
    assert: [RegisterAssert; 2],
}

impl TestOp {
    fn gen_test(&self) -> String {
        format!(
            "{:x}_{:02x}_{:08x}__{:02x}_{:08x}__{:02x}_{:08x}\n",
            if self.reset_n { 1 } else { 0 },
            self.store.0,
            self.store.1,
            self.assert[0].addr,
            self.assert[0].value,
            self.assert[1].addr,
            self.assert[1].value
        )
    }
}

trait Intify {
    fn stringify(&self) -> String;
}

impl Intify for bool {
    fn stringify(&self) -> String {
        if *self { "1" } else { "0" }.to_owned()
    }
}

impl Intify for u32 {
    fn stringify(&self) -> String {
        format!("{self:08x}")
    }
}

impl Intify for Option<u32> {
    fn stringify(&self) -> String {
        match self {
            Some(v) => format!("{v:08x}"),
            None => "zzzzzzzz".to_owned(),
        }
    }
}

fn gen_single_reg_tests() {
    let mut rng = StdRng::seed_from_u64(1234567890123);

    let mut value = 0;

    for _ in 0..500 {
        // rst, data, store, en_a, en_b, a, b
        let rst_n = rng.gen_ratio(80, 100);

        let load_a = rng.gen_ratio(1, 2);

        let load_b = rng.gen_ratio(1, 2);

        let store = rng.gen_ratio(1, 2);
        let store_value: u32 = rng.gen();

        let a = if load_a { Some(value) } else { None };
        let b = if load_b { Some(value) } else { None };

        if store {
            value = store_value;
        }

        if !rst_n {
            value = 0;
        }

        // reset, store enable, load a, load b, store value, a, b
        println!(
            "{}__{}__{}_{}__{}__{}_{}",
            rst_n.stringify(),
            store.stringify(),
            load_a.stringify(),
            load_b.stringify(),
            store_value.stringify(),
            a.stringify(),
            b.stringify()
        )
    }
}

fn main() {
    gen_single_reg_tests();
    return;
    let mut regs = Registers::new();

    let mut rng = StdRng::seed_from_u64(1234567890123);
    let mut of = File::create("register_tests.tv").unwrap();
    for _ in 0..500 {
        let store_addr = rng.gen_range(0..=31);
        let value = rng.gen();

        let reset = rng.gen_ratio(1, 100);

        if reset {
            regs.reset();
        }

        let a0 = regs.gen_assert(&mut rng);
        let a1 = regs.gen_assert(&mut rng);

        if !reset {
            regs.set(store_addr, value);
        }

        let op = TestOp {
            reset_n: !reset,
            store: (store_addr, value),
            assert: [a0, a1],
        };
        of.write_all(op.gen_test().as_bytes()).unwrap();
    }
}
