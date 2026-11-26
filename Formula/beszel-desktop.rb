class BeszelDesktop < Formula
  desc "Monitor remote servers and homelab hosts live in your Linux desktop bar via Beszel"
  homepage "https://github.com/henriksvensson/beszel-desktop"
  version "0.3.0"
  license "MIT"

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/henriksvensson/beszel-desktop/releases/download/v0.3.0/beszel-desktop-v0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1e19ac5ff608ba86be9bc74b92514aec3fe1b8ea61bff4f5ecc8f47c768c21be"
    elsif Hardware::CPU.intel?
      url "https://github.com/henriksvensson/beszel-desktop/releases/download/v0.3.0/beszel-desktop-v0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "52315abb2e0687656d674ef37a63ee0c373aab92f9b71b3fe6b6453c5c8538a3"
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
