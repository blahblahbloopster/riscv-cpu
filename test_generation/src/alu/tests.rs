use super::{Alu, AluFunct, AluInputs, AluState};

macro_rules! test_add {
    ($num:ident, $expected:expr, $a:expr, $b:expr) => {
        #[test]
        fn $num() {
            let alu = Alu::new();
            let add_inputs = AluInputs::new(
                false,
                AluFunct::ADD.into(),
                false,
                $a,
                $b,
            );
            let result = alu.get_state(add_inputs).result;
            assert_eq!(result, Some($expected));
        }
    };
}

macro_rules! test_sll {
    ($num:ident, $expected:expr, $a:expr, $b:expr) => {
        #[test]
        fn $num() {
            let alu = Alu::new();
            let add_inputs = AluInputs::new(
                false,
                AluFunct::SLL.into(),
                false,
                $a,
                $b,
            );
            let result = alu.get_state(add_inputs).result;
            assert_eq!(result, Some($expected));
        }
    };
}

macro_rules! test_slt {
    ($num:ident, $expected:expr, $a:expr, $b:expr) => {
        #[test]
        fn $num() {
            let alu = Alu::new();
            let add_inputs = AluInputs::new(
                false,
                AluFunct::SLL.into(),
                false,
                $a,
                $b,
            );
            let result = alu.get_state(add_inputs).result;
            assert_eq!(result, Some($expected));
        }
    };
}

macro_rules! test_xor {
    ($num:ident, $expected:expr, $a:expr, $b:expr) => {
        #[test]
        fn $num() {
            let alu = Alu::new();
            let add_inputs = AluInputs::new(
                false,
                AluFunct::XOR.into(),
                false,
                $a,
                $b,
            );
            let result = alu.get_state(add_inputs).result;
            assert_eq!(result, Some($expected));
        }
    };
}

macro_rules! test_srl {
    ($num:ident, $expected:expr, $a:expr, $b:expr) => {
        #[test]
        fn $num() {
            let alu = Alu::new();
            let add_inputs = AluInputs::new(
                false,
                AluFunct::SR.into(),
                false,
                $a,
                $b,
            );
            let result = alu.get_state(add_inputs).result;
            assert_eq!(result, Some($expected));
        }
    };
}

macro_rules! test_sra {
    ($num:ident, $expected:expr, $a:expr, $b:expr) => {
        #[test]
        fn $num() {
            let alu = Alu::new();
            let add_inputs = AluInputs::new(
                false,
                AluFunct::SR.into(),
                true,
                $a,
                $b,
            );
            let result = alu.get_state(add_inputs).result;
            assert_eq!(result, Some($expected));
        }
    };
}

macro_rules! test_or {
    ($num:ident, $expected:expr, $a:expr, $b:expr) => {
        #[test]
        fn $num() {
            let alu = Alu::new();
            let add_inputs = AluInputs::new(
                false,
                AluFunct::OR.into(),
                false,
                $a,
                $b,
            );
            let result = alu.get_state(add_inputs).result;
            assert_eq!(result, Some($expected));
        }
    };
}


macro_rules! test_and {
    ($num:ident, $expected:expr, $a:expr, $b:expr) => {
        #[test]
        fn $num() {
            let alu = Alu::new();
            let add_inputs = AluInputs::new(
                false,
                AluFunct::AND.into(),
                false,
                $a,
                $b,
            );
            let result = alu.get_state(add_inputs).result;
            assert_eq!(result, Some($expected));
        }
    };
}


// ADD

test_add!(add_2,  0x00000000, 0x00000000, 0x00000000);
test_add!(add_3,  0x00000002, 0x00000001, 0x00000001);
test_add!(add_4,  0x0000000a, 0x00000003, 0x00000007);

test_add!(add_5,  0xffff8000, 0x00000000, 0xffff8000);
test_add!(add_6,  0x80000000, 0x80000000, 0x00000000);
test_add!(add_7,  0x7fff8000, 0x80000000, 0xffff8000);

test_add!(add_8,  0x00007fff, 0x00000000, 0x00007fff);
test_add!(add_9,  0x7fffffff, 0x7fffffff, 0x00000000);
test_add!(add_10, 0x80007ffe, 0x7fffffff, 0x00007fff);

test_add!(add_11, 0x80007fff, 0x80000000, 0x00007fff);
test_add!(add_12, 0x7fff7fff, 0x7fffffff, 0xffff8000);

test_add!(add_13, 0xffffffff, 0x00000000, 0xffffffff);
test_add!(add_14, 0x00000000, 0xffffffff, 0x00000001);
test_add!(add_15, 0xfffffffe, 0xffffffff, 0xffffffff);

test_add!(add_16, 0x80000000, 0x00000001, 0x7fffffff);

// SLL

test_sll!(sll_2,  0x00000001, 0x00000001, 00);
test_sll!(sll_3,  0x00000002, 0x00000001, 01);
test_sll!(sll_4,  0x00000080, 0x00000001, 07);
test_sll!(sll_5,  0x00004000, 0x00000001, 14);
test_sll!(sll_6,  0x80000000, 0x00000001, 31);

test_sll!(sll_7,  0xffffffff, 0xffffffff, 00);
test_sll!(sll_8,  0xfffffffe, 0xffffffff, 01);
test_sll!(sll_9,  0xffffff80, 0xffffffff, 07);
test_sll!(sll_10, 0xffffc000, 0xffffffff, 14);
test_sll!(sll_11, 0x80000000, 0xffffffff, 31);

test_sll!(sll_12, 0x21212121, 0x21212121, 00);
test_sll!(sll_13, 0x42424242, 0x21212121, 01);
test_sll!(sll_14, 0x90909080, 0x21212121, 07);
test_sll!(sll_15, 0x48484000, 0x21212121, 14);
test_sll!(sll_16, 0x80000000, 0x21212121, 31);

test_sll!(sll_17, 0x21212121, 0x21212121, 0xffffffe0);
test_sll!(sll_18, 0x42424242, 0x21212121, 0xffffffe1);
test_sll!(sll_19, 0x90909080, 0x21212121, 0xffffffe7);
test_sll!(sll_20, 0x48484000, 0x21212121, 0xffffffee);
test_sll!(sll_21, 0x00000000, 0x21212120, 0xffffffff);

// SLT

test_slt!(slt_2,  0, 0x00000000, 0x00000000);
test_slt!(slt_3,  0, 0x00000001, 0x00000001);
test_slt!(slt_4,  1, 0x00000003, 0x00000007);
test_slt!(slt_5,  0, 0x00000007, 0x00000003);

test_slt!(slt_6,  0, 0x00000000, 0xffff8000);
test_slt!(slt_7,  1, 0x80000000, 0x00000000);
test_slt!(slt_8,  1, 0x80000000, 0xffff8000);

test_slt!(slt_9,  1, 0x00000000, 0x00007fff);
test_slt!(slt_10, 0, 0x7fffffff, 0x00000000);
test_slt!(slt_11, 0, 0x7fffffff, 0x00007fff);

test_slt!(slt_12, 1, 0x80000000, 0x00007fff);
test_slt!(slt_13, 0, 0x7fffffff, 0xffff8000);

test_slt!(slt_14, 0, 0x00000000, 0xffffffff);
test_slt!(slt_15, 1, 0xffffffff, 0x00000001);
test_slt!(slt_16, 0, 0xffffffff, 0xffffffff);

// XOR

test_xor!(xor_2, 0xf00ff00f, 0xff00ff00, 0x0f0f0f0f);
test_xor!(xor_3, 0xff00ff00, 0x0ff00ff0, 0xf0f0f0f0);
test_xor!(xor_4, 0x0ff00ff0, 0x00ff00ff, 0x0f0f0f0f);
test_xor!(xor_5, 0x00ff00ff, 0xf00ff00f, 0xf0f0f0f0);

// SRL

test_srl!(srl_2,  0x80000000, 0x80000000, 0 );
test_srl!(srl_3,  0xc0000000, 0x80000000, 1 );
test_srl!(srl_4,  0xff000000, 0x80000000, 7 );
test_srl!(srl_5,  0xfffe0000, 0x80000000, 14);
test_srl!(srl_6,  0xffffffff, 0x80000001, 31);

test_srl!(srl_7,  0xffffffff, 0xffffffff, 0 );
test_srl!(srl_8,  0xffffffff, 0xffffffff, 1 );
test_srl!(srl_9,  0xffffffff, 0xffffffff, 7 );
test_srl!(srl_10, 0xffffffff, 0xffffffff, 14);
test_srl!(srl_11, 0xffffffff, 0xffffffff, 31);

test_srl!(srl_12, 0x21212121, 0x21212121, 0 );
test_srl!(srl_13, 0x10909090, 0x21212121, 1 );
test_srl!(srl_14, 0x00424242, 0x21212121, 7 );
test_srl!(srl_15, 0x00008484, 0x21212121, 14);
test_srl!(srl_16, 0x00000000, 0x21212121, 31);

// SRA

test_sra!(sra_2,  0x80000000, 0x80000000, 0 );
test_sra!(sra_3,  0xc0000000, 0x80000000, 1 );
test_sra!(sra_4,  0xff000000, 0x80000000, 7 );
test_sra!(sra_5,  0xfffe0000, 0x80000000, 14);
test_sra!(sra_6,  0xffffffff, 0x80000001, 31);

test_sra!(sra_7,  0x7fffffff, 0x7fffffff, 0 );
test_sra!(sra_8,  0x3fffffff, 0x7fffffff, 1 );
test_sra!(sra_9,  0x00ffffff, 0x7fffffff, 7 );
test_sra!(sra_10, 0x0001ffff, 0x7fffffff, 14);
test_sra!(sra_11, 0x00000000, 0x7fffffff, 31);

test_sra!(sra_12, 0x81818181, 0x81818181, 0 );
test_sra!(sra_13, 0xc0c0c0c0, 0x81818181, 1 );
test_sra!(sra_14, 0xff030303, 0x81818181, 7 );
test_sra!(sra_15, 0xfffe0606, 0x81818181, 14);
test_sra!(sra_16, 0xffffffff, 0x81818181, 31);

// OR

test_or!(or_2, 0xff0fff0f, 0xff00ff00, 0x0f0f0f0f);
test_or!(or_3, 0xfff0fff0, 0x0ff00ff0, 0xf0f0f0f0);
test_or!(or_4, 0x0fff0fff, 0x00ff00ff, 0x0f0f0f0f);
test_or!(or_5, 0xf0fff0ff, 0xf00ff00f, 0xf0f0f0f0);

// AND

test_and!(and_2, 0x0f000f00, 0xff00ff00, 0x0f0f0f0f);
test_and!(and_3, 0x00f000f0, 0x0ff00ff0, 0xf0f0f0f0);
test_and!(and_4, 0x000f000f, 0x00ff00ff, 0x0f0f0f0f);
test_and!(and_5, 0xf000f000, 0xf00ff00f, 0xf0f0f0f0);
