
.PHONY: debug build-release release-linux-musl test clippy clippy-pedantic install install-debug

profile:
	cargo run --features=timing,pprof -- -l

debug:
	cargo run --features=timing -- -l

build-release:
	cargo build --release

release-mac: build-release
	strip target/release/mdbook-dtmo
	mkdir -p release
	tar -C ./target/release/ -czvf ./release/mdbook-dtmo-mac.tar.gz ./mdbook-dtmo
	ls -lisah ./release/mdbook-dtmo-mac.tar.gz

release-win: build-release
	mkdir -p release
	tar -C ./target/release/ -czvf ./release/mdbook-dtmo-win.tar.gz ./mdbook-dtmo.exe

release-linux-musl: 
	cargo build --release --target=x86_64-unknown-linux-musl
	strip target/x86_64-unknown-linux-musl/release/mdbook-dtmo
	mkdir -p release
	tar -C ./target/x86_64-unknown-linux-musl/release/ -czvf ./release/mdbook-dtmo-linux-musl.tar.gz ./mdbook-dtmo

release-linux:
	cargo build --release --target=x86_64-unknown-linux-gnu
	cargo build --release --target=i686-unknown-linux-gnu
	strip target/x86_64-unknown-linux-gnu/release/mdbook-dtmo
	strip target/i686-unknown-linux-gnu/release/mdbook-dtmo
	mkdir -p release
	tar -C ./target/x86_64-unknown-linux-gnu/release -czvf ./release/mdbook-dtmo-linux-x86_64.tar.gz ./mdbook-dtmo
	tar -C ./target/i686-unknown-linux-gnu/release -czvf ./release/mdbook-dtmo-linux-i686.tar.gz ./mdbook-dtmo

test:
	cargo test --workspace

fmt:
	cargo fmt -- --check

clippy:
	cargo clippy

clippy-pedantic:
	cargo clippy --all-features -- -W clippy::pedantic

check: fmt clippy test

install:
	cargo install --path "." --offline

install-timing:
	cargo install --features=timing --path "." --offline
