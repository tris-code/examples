FROM trisdocker/universe:dev

COPY ./Sources /example/Sources
COPY Package.swift /example

WORKDIR /example
RUN ["swift", "build", "-c", "release"]

ENTRYPOINT [".build/release/main"]
