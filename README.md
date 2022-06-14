# An example project for Fastly Compute@Edge

This repository just demonstrates how to serve and test a Fastly Compute@Edge package locally with the Rust SDK.

## Packages

### `/service`

This is a Fastly Compute@Edge package which adds a `my-awesome-header: my-awesome-value` HTTP header to the response.

### `/test/e2e`

This is a package implements the end-to-end testing for the `/service` Fastly Compute@Edge package. During the tests, this package will send a HTTP request to the Fastly Compute@Edge local server and assert the HTTP response.

## Usage

```console
$ make test
```

This make target runs a Fastly Compute@Edge server locally by using `docker compose` and then executes end-to-end tests described in the `Packages` section. In order to deep dive into how to serve and test the Fastly Compute@Edge package, please read the instruction of this make target and related files like `/docker-compose.yml`.
