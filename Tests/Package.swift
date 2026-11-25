// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "MailTests",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "t_mail",
            targets: ["MailTests"]
        ),
        .executable(
            name: "t_mail_live",
            targets: ["MailLiveTests"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/leviouwendijk/Errors.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/Writers.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/Milieu.git", branch: "master"),
        .package(url: "https://github.com/lco-langs/Frame.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/IO.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/Primitives.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/Testing.git", branch: "master"),
        .package(path: ".."),
    ],
    targets: [

        .executableTarget(
            name: "MailTests",
            dependencies: [
                .product(name: "Mail", package: "Mail"),
                .product(name: "Errors", package: "Errors"),
                .product(name: "MailConnection", package: "Mail"),
                .product(name: "SMTP", package: "Mail"),
                .product(name: "IMAP", package: "Mail"),
                .product(name: "MailIndex", package: "Mail"),
                .product(name: "MailFrame", package: "Mail"),
                .product(name: "Milieu", package: "Milieu"),
                .product(name: "Roots", package: "Frame"),
                .product(name: "Writers", package: "Writers"),
                .product(name: "IO", package: "IO"),
                .product(name: "Primitives", package: "Primitives"),
                .product(name: "Testing", package: "Testing"),
            ]
        ),

        // probes real servers without credentials; needs network
        .executableTarget(
            name: "MailLiveTests",
            dependencies: [
                .product(name: "MailConnection", package: "Mail"),
                .product(name: "SMTP", package: "Mail"),
                .product(name: "IMAP", package: "Mail"),
                .product(name: "Testing", package: "Testing"),
            ]
        ),
    ]
)
