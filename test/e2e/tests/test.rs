#[cfg(test)]
mod tests {
    #[test]
    fn example() {
        let client = reqwest::blocking::Client::new();
        let response = match client.post("http://fastly:3000/").body("{}").send() {
            Ok(response) => response,
            Err(e) => panic!("Failed to call the server: {}", e),
        };

        assert_eq!(response.status(), reqwest::StatusCode::OK);

        if let Some(header) = response.headers().get("my-awesome-header") {
            assert_eq!(header, "my-awesome-value");
        } else {
            panic!("my-awesome-header header has not been found")
        }
    }
}
