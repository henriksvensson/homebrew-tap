class BeszelDesktop < Formula
  desc "Monitor remote servers and homelab hosts live in your Linux desktop bar via Beszel"
  homepage "https://github.com/henriksvensson/beszel-desktop"
  version "0.4.0"
  license "MIT"

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/henriksvensson/beszel-desktop/releases/download/v0.4.0/beszel-desktop-v0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5fd5439a1b6b93a71ef0a9ef503fbdb12ef5d87010561023a1d431a5f3aba5d6"
    elsif Hardware::CPU.intel?
      url "https://github.com/henriksvensson/beszel-desktop/releases/download/v0.4.0/beszel-desktop-v0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "15ee01b25fc456b9f69eead19826e79c1e537671503eadf80d3687d19ce1b332"
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
