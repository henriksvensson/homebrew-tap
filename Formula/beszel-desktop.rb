class BeszelDesktop < Formula
  desc "Monitor remote servers and homelab hosts live in your Linux desktop bar via Beszel"
  homepage "https://github.com/henriksvensson/beszel-desktop"
  version "0.5.1"
  license "MIT"

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/henriksvensson/beszel-desktop/releases/download/v0.5.1/beszel-desktop-v0.5.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e3c9df405ee5d5bc4b2298c6e073f99808ca8ea3764518926a58247a59527b15"
    elsif Hardware::CPU.intel?
      url "https://github.com/henriksvensson/beszel-desktop/releases/download/v0.5.1/beszel-desktop-v0.5.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "38c4024e02bbb3bbd69f62a22981c706bd06445496e7c313907b8f9a3392a2d8"
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
