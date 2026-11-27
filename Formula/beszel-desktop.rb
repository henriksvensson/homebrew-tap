class BeszelDesktop < Formula
  desc "Monitor remote servers and homelab hosts live in your Linux desktop bar via Beszel"
  homepage "https://github.com/henriksvensson/beszel-desktop"
  version "0.5.0"
  license "MIT"

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/henriksvensson/beszel-desktop/releases/download/v0.5.0/beszel-desktop-v0.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "04017ce083dfe8747c6f742860a9605c35913773efa1fda7793e933112728a54"
    elsif Hardware::CPU.intel?
      url "https://github.com/henriksvensson/beszel-desktop/releases/download/v0.5.0/beszel-desktop-v0.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4d0acb2abd3102379dab2b2ed8df05acdedb9e78a1711703f898be3507080ff5"
    end
  end

  def install
    bin.install "beszel-relay"
    bin.install "beszel-ctl"
    pkgshare.install "config.example.toml"
    inreplace "beszel-relay.service", "%h/.local/bin/beszel-relay", opt_bin/"beszel-relay"
    pkgshare.install "beszel-relay.service"
  end

  def caveats
    <<~EOS
      Run the interactive setup wizard to connect your Beszel hub and start the user service:
        beszel-ctl init
    EOS
  end

  test do
    assert_match "beszel-ctl", shell_output("#{bin}/beszel-ctl --help")
    assert_match "beszel-relay", shell_output("#{bin}/beszel-relay --help")
  end
end
