#!/bin/bash

# Clone flutter if not present
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable
fi

# Add flutter to PATH
export PATH="$PATH:$(pwd)/flutter/bin"

# Optional: doctor check
flutter doctor

# Build for web
flutter build web --release
