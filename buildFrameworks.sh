#!/bin/sh
set -e

# Build libpq.xcframework (macOS + iOS device).
#
# Assembled with `xcodebuild -create-xcframework` rather than hand-moving each
# archive's framework into pre-named slice directories. The old approach
# hard-coded a stale slice name (ios-arm64_armv7) that no longer matches what
# Xcode builds, producing a mislabelled xcframework. -create-xcframework names
# every slice from the real architectures and writes a correct Info.plist
# (ios-arm64 / macos-arm64_x86_64).

rm -rf "./build"

# debug     = -configuration Debug
xcodebuild archive -scheme "libpq-macos" -archivePath "./build/macos.xcarchive" SKIP_INSTALL=NO
xcodebuild archive -scheme "libpq-ios" -archivePath "./build/ios.xcarchive" -sdk iphoneos SKIP_INSTALL=NO

# Remove the nested frameworks folder. They will be added in by the outer app.
rm -rf "build/macos.xcarchive/Products/Library/Frameworks/libpq.framework/Versions/A/Frameworks"
rm -rf "build/ios.xcarchive/Products/Library/Frameworks/libpq.framework/Frameworks"

rm -rf "Frameworks/libpq.xcframework"
xcodebuild -create-xcframework \
  -framework "build/macos.xcarchive/Products/Library/Frameworks/libpq.framework" \
  -framework "build/ios.xcarchive/Products/Library/Frameworks/libpq.framework" \
  -output "Frameworks/libpq.xcframework"

rm -rf "./build"
find . -name ".DS_Store" -delete
