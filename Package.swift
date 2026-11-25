// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Mail",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "Mail",
            targets: ["Mail"]
        ),
        .library(
            name: "MailConnection",
            targets: ["MailConnection"]
        ),
        .library(
            name: "SMTP",
            targets: ["SMTP"]
        ),
        .library(
            name: "IMAP",
            targets: ["IMAP"]
        ),
        .library(
            name: "MailIndex",
            targets: ["MailIndex"]
        ),
        .library(
            name: "MailFrame",
            targets: ["MailFrame"]
        ),
        .executable(
            name: "email",
            targets: ["email"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-lco/Primitives.git", branch: "master"),
        .package(url: "https://github.com/swift-lco/Errors.git", branch: "master"),
        .package(url: "https://github.com/swift-lco/Readers.git", branch: "master"),
        .package(url: "https://github.com/swift-lco/Writers.git", branch: "master"),
        .package(url: "https://github.com/swift-langs/Parsing.git", branch: "master"),
        .package(url: "https://github.com/swift-lco/Milieu.git", branch: "master"),
        .package(url: "https://github.com/lco-langs/Frame.git", branch: "master"),
        .package(url: "https://github.com/swift-lco/IO.git", branch: "master"),
        .package(url: "https://github.com/swift-lco/Path.git", branch: "master"),
        .package(url: "https://github.com/swift-lco/Arguments.git", branch: "master"),
        .package(url: "https://github.com/swift-dsl/SQLite.git", branch: "master"),
    ],
    targets: [
        // message model, MIME rendering and parsing; no networking
        .target(
            name: "Mail",
            dependencies: [
                .product(name: "Primitives", package: "Primitives"),
                .product(name: "Errors", package: "Errors"),
                .product(name: "Readers", package: "Readers"),
                .product(name: "Writers", package: "Writers"),
                .product(name: "IO", package: "IO"),
                .product(name: "Parsing", package: "Parsing"),
            ]
        ),

        // TLS transport, server configuration and SASL shared by SMTP and IMAP
        .target(
            name: "MailConnection",
            dependencies: [
                "Mail",
                .product(name: "Errors", package: "Errors"),
                .product(name: "Milieu", package: "Milieu"),
            ]
        ),

        .target(
            name: "SMTP",
            dependencies: [
                "Mail",
                .product(name: "Errors", package: "Errors"),
                "MailConnection",
                .product(name: "Milieu", package: "Milieu"),
                .product(name: "Parsing", package: "Parsing"),
            ]
        ),

        .target(
            name: "IMAP",
            dependencies: [
                "Mail",
                .product(name: "Errors", package: "Errors"),
                "MailConnection",
                .product(name: "Milieu", package: "Milieu"),
                .product(name: "Parsing", package: "Parsing"),
            ]
        ),

        // local SQLite index of envelopes, flags and attachments for counting and selecting
        .target(
            name: "MailIndex",
            dependencies: [
                "Mail",
                "IMAP",
                .product(name: "IO", package: "IO"),
                .product(name: "SQLite", package: "SQLite"),
            ]
        ),

        // the `Mail` Frame module: accounts, identities and secrets declared in mail.frame
        .target(
            name: "MailFrame",
            dependencies: [
                "Mail",
                .product(name: "Errors", package: "Errors"),
                "MailConnection",
                "SMTP",
                "IMAP",
                .product(name: "Frame", package: "Frame"),
                .product(name: "Roots", package: "Frame"),
                .product(name: "Milieu", package: "Milieu"),
                .product(name: "Readers", package: "Readers"),
                .product(name: "IO", package: "IO"),
                .product(name: "Path", package: "Path"),
            ]
        ),

        // the `email` command line
        .executableTarget(
            name: "email",
            dependencies: [
                "Mail",
                .product(name: "Errors", package: "Errors"),
                "MailConnection",
                "SMTP",
                "IMAP",
                "MailIndex",
                "MailFrame",
                .product(name: "Frame", package: "Frame"),
                .product(name: "Roots", package: "Frame"),
                .product(name: "Arguments", package: "Arguments"),
                .product(name: "Readers", package: "Readers"),
                .product(name: "IO", package: "IO"),
            ],
            path: "Sources/MailCLI"
        ),
    ]
)
