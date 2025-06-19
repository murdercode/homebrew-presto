cask "presto" do
  version "0.2.11"
  sha256 :no_check  # Will be updated with actual SHA256 when you have a release

  on_arm do
    url "https://github.com/murdercode/presto/releases/download/v#{version}/presto_#{version}_aarch64.app.tar.gz"
  end

  on_intel do
    url "https://github.com/murdercode/presto/releases/download/v#{version}/presto_#{version}_x64.app.tar.gz"
  end

  name "Presto"
  desc "A modern Pomodoro timer application built with Tauri"
  homepage "https://github.com/murdercode/presto"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "presto.app"

  zap trash: [
    "~/Library/Application Support/com.presto.app",
    "~/Library/Caches/com.presto.app",
    "~/Library/Preferences/com.presto.app.plist",
    "~/Library/Saved Application State/com.presto.app.savedState",
    "~/Library/WebKit/com.presto.app"
  ]
end
