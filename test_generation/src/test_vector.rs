use rand::rngs::StdRng;
use std::error::Error;
use std::fs::File;
use std::io::Write;

pub trait TestVector {
    fn random(rng: &mut StdRng) -> Self;
    fn to_string(&self) -> String;
}

pub fn generate_vectors<T: TestVector>(
    vector_file_path: &str,
    num_vectors: usize,
    rng: &mut StdRng,
) -> Result<(), Box<dyn Error>> {
    let mut vector_file = match File::create(vector_file_path) {
        Ok(file) => file,
        Err(e) => return Err(format!(
            "Could not create file {}\n{}",
            vector_file_path,
            e,
        ).into()),
    };

    for _ in 0..num_vectors {
        let vector: T = T::random(rng);
        vector_file.write(vector.to_string().as_bytes())?;
    }

    Ok(())
}
