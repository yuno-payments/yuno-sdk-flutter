// swift-tools-version: 5.9

// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import PackageDescription

let package = Package(
  name: "yuno_sdk_foundation",
  platforms: [
    .iOS("14.0"),

  ],
  products: [
    .library(name: "yuno-sdk-foundation", targets: ["yuno_sdk_foundation"])
  ],
  dependencies: [
    .package(url: "https://github.com/yuno-payments/yuno-sdk-ios.git", .upToNextMajor(from: "1.16.0"))
  ],
  targets: [
    .target(
      name: "yuno_sdk_foundation",
      dependencies: [],
      resources: [
       .process("Resources"),
      ]
    )
  ]
)
