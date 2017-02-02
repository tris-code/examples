FROM trisdocker/universe

COPY ./Sources /example/Sources
COPY Package.swift /example

WORKDIR /example
RUN ["swift", "build"]

ENTRYPOINT [".build/debug/reflection"]
