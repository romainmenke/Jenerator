
import PackageDescription

let package = Package(
	name: "Jenerator",
	targets: [],
	exclude: ["Tests"],
	dependencies: [
        .Package(url: "https://github.com/czechboy0/Jay.git", majorVersion: 0)
    ]
)
