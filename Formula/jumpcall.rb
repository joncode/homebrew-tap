class Jumpcall < Formula
  desc "Jump to your live video call from the macOS menu bar or a hotkey"
  homepage "https://github.com/joncode/jumpcall"
  url "https://github.com/joncode/jumpcall/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "6295a55ac0ec5f074526d8c19cd0692f78e8a4890f527892768f46bdaef65928"
  license "MIT"
  head "https://github.com/joncode/jumpcall.git", branch: "main"

  depends_on macos: :sonoma

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    app = prefix/"JumpCall.app"
    (app/"Contents/MacOS").mkpath
    cp ".build/release/jumpcall", app/"Contents/MacOS/jumpcall"
    cp "Resources/Info.plist", app/"Contents/Info.plist"
    (app/"Contents/PkgInfo").write "APPL????"
    system "codesign", "--force", "--sign", "-",
           "--identifier", "io.github.joncode.jumpcall", app
    bin.install_symlink app/"Contents/MacOS/jumpcall"
  end

  def caveats
    <<~EOS
      To finish setup (copies the app to ~/Applications, enables
      launch-at-login, and starts the menu-bar icon):
        jumpcall install

      Re-run "jumpcall install" after every "brew upgrade jumpcall".
    EOS
  end

  test do
    assert_match "jumpcall", shell_output("#{bin}/jumpcall version")
  end
end
