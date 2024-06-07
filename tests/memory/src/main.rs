#![allow(dead_code, unused_variables)]

use std::{
    fs::File,
    io::{self, Read},
};

use rand::{rngs::StdRng, SeedableRng};

const CODE_START: u32 = 0x8000_000;
const CODE_SIZE: u32 = 65536;
const DATA_START: u32 = 0x8000_000;
const DATA_SIZE: u32 = 65536;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Width {
    Byte = 1,
    Halfword = 2,
    Word = 4,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum MainMemoryState {
    Idle,
    Getting {
        address: u32,
        width: Width,
        position: u32,
    },
    Storing {
        address: u32,
        data: u32,
        width: Width,
        position: u32,
    },
}

enum FetchState {
    Fetched,
    Fetching,
}

struct Memory {
    code: Vec<u32>,
    data: Vec<u8>,
    main_state: MainMemoryState,
    fetch_state: FetchState,
}

struct MemoryInputPins {
    main_addr: u32,
    width: Width,
    read_req_main: bool,
    write_req_main: bool,
    write_data: u32,

    main_data_set: Option<u32>,

    fetch_addr: Option<u32>,
    fetch_req: bool,
}

#[derive(Debug, Default)]
struct MemoryOutputPins {
    main_data_get: Option<u32>,
    main_busy: bool,

    fetch_data: Option<u32>,
    fetch_busy: bool,
}

impl Memory {
    pub fn tick_main(&mut self, inp: MemoryInputPins) -> MemoryOutputPins {
        let mut out = MemoryOutputPins::default();
        out.main_busy = self.main_state != MainMemoryState::Idle;
        match self.main_state {
            MainMemoryState::Idle => {
                if inp.read_req_main {
                    self.main_state = MainMemoryState::Getting {
                        address: inp.main_addr,
                        width: inp.width,
                        position: inp.width as u32,
                    }
                } else if inp.write_req_main {
                    self.main_state = MainMemoryState::Storing {
                        address: inp.main_addr,
                        data: inp.main_data_set.unwrap(),
                        width: inp.width,
                        position: inp.width as u32,
                    }
                }
            }
            MainMemoryState::Getting {
                address,
                width,
                position,
            } => {
                if position == 0 {
                    self.main_state = MainMemoryState::Idle;
                    let b = &self.data
                        [(address - DATA_START) as usize..(address - DATA_START) as usize + 4];
                    let value = match width {
                        Width::Byte => b[0] as u32,
                        Width::Halfword => u16::from_le_bytes([b[0], b[1]]) as u32,
                        Width::Word => u32::from_le_bytes([b[0], b[1], b[2], b[3]]),
                    };
                    out.main_data_get = Some(value);
                } else {
                    self.main_state = MainMemoryState::Getting {
                        address,
                        width,
                        position: position - 1,
                    };
                }
            }
            MainMemoryState::Storing {
                address,
                data,
                width,
                position,
            } => {
                if position == 0 {
                    self.main_state = MainMemoryState::Idle;
                    match width {
                        Width::Byte => {
                            self.data[(address - DATA_START) as usize] = data as u8;
                        }
                        Width::Halfword => {
                            let slice = &mut self.data[(address - DATA_START) as usize
                                ..(address + 2 - DATA_START) as usize];
                            slice.copy_from_slice(&data.to_le_bytes());
                        }
                        Width::Word => {
                            let slice = &mut self.data[(address - DATA_START) as usize
                                ..(address + 4 - DATA_START) as usize];
                            slice.copy_from_slice(&data.to_le_bytes());
                        }
                    }
                } else {
                    self.main_state = MainMemoryState::Storing {
                        address,
                        data,
                        width,
                        position: position - 1,
                    }
                }
            }
        }

        out
    }
}

enum MainAction {
    Nothing,
}

fn main() {
    let mut code = vec![];
    let mut code_file = File::open("code-data.bin").unwrap();
    let mut buf = [0; 4];
    loop {
        match code_file.read_exact(&mut buf) {
            Ok(_) => {}
            Err(_) => break,
        }
        code.push(u32::from_le_bytes(buf));
    }

    let mem = Memory {
        code,
        data: vec![0; DATA_SIZE as usize],
        main_state: MainMemoryState::Idle,
        fetch_state: FetchState::Fetched,
    };

    let mut rng = StdRng::seed_from_u64(0x123456789abcdef0);

    let mut last_output = MemoryOutputPins::default();

    for i in 0..1000 {
        mem.tick_main(inp);
    }
}
