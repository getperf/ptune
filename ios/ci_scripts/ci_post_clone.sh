#!/bin/sh
set -e

echo "Xcode Cloud post clone script started"
echo "PWD=$(pwd)"

# Flutter SDK を Xcode Cloud 環境に用意
if [ ! -d "$HOME/flutter" ]; then
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$HOME/flutter"
fi

export PATH="$HOME/flutter/bin:$PATH"

flutter --version
flutter doctor -v

# Flutter 生成ファイルを作成
flutter pub get

# CocoaPods 生成ファイルを作成
cd ios
pod install

echo "Xcode Cloud post clone script finished"
