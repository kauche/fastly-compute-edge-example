use fastly::{Error, Request, Response};
use regex::Regex;

#[fastly::main]
fn main(mut req: Request) -> Result<Response, Error> {
    // By default, disable caching for all requests.
    req.set_pass(true);

    let path = req.get_url().path();
    let static_path_regex = Regex::new("^/static/.*$")?;

    // Cache static assets.
    if static_path_regex.is_match(path) {
        req.set_pass(false);
    }

    let mut res = req.send("example.kauche.com")?;

    // Add my-awesome-header HTTP header to the response
    res.set_header("my-awesome-header", "my-awesome-value");

    Ok(res)
}
