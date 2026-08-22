/// Returns a greeting for the given name.
pub fn greet(name: &str) -> String {
    format!("Hello, {name}!")
}

#[cfg(test)]
mod tests {
    use super::greet;

    #[test]
    fn greets_the_given_name() {
        assert_eq!(greet("template"), "Hello, template!");
    }
}
