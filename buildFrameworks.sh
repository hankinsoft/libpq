rm -rf "./build"
rm -rf "Frameworks/macos/*"
rm -rf "./Frameworks/libpq.xcframework/ios-arm64_armv7/*"
rm -rf "Frameworks/iphonesimulator/*"

# debug     = -configuration Debug

xcodebuild archive -scheme "libpq-macos" -archivePath "./build/macos.xarchive" SKIP_INSTALL=NO
xcodebuild archive -scheme "libpq-ios" -archivePath "./build/ios.xarchive" -sdk iphoneos SKIP_INSTALL=NO
#xcodebuild archive -scheme "libpq-ios" -archivePath "./build/ios_sim.xarchive" -sdk iphonesimulator SKIP_INSTALL=NO

# Remove the nested frameworks folder. They will be added in by the outer app.
rm -rf "build/macos.xarchive.xcarchive/Products/Library/Frameworks/libpq.framework/Frameworks"
rm -rf "build/ios.xarchive.xcarchive/Products/Library/Frameworks/libpq.framework/Frameworks"
#rm -rf "build/ios_sim.xarchive.xcarchive/Products/Library/Frameworks/libpq.framework/Frameworks"

mv build/macos.xarchive.xcarchive/Products/Library/Frameworks/libpq.framework "Frameworks/libpq.xcframework/macos-arm64_x86_64"
mv build/ios.xarchive.xcarchive/Products/Library/Frameworks/libpq.framework "Frameworks/libpq.xcframework/ios-arm64_armv7"
#mv build/ios_sim.xarchive.xcarchive/Products/Library/Frameworks/libpq.framework "Frameworks/libpq.xcframework/ios-arm64_i386_x86_64-simulator"

rm -rf "./build"
find . -name ".DS_Store" -delete
