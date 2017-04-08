FROM trisdocker/universe

COPY ./Sources /example/Sources
COPY Package.swift /example

WORKDIR /example
RUN ["swift", "build", "-c", "release"]

ENTRYPOINT [".build/release/example"]
