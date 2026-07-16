class Moonbox < Formula
  desc "Cross-CLI session rewind workbench"
  homepage "https://github.com/Gunsio/moonbox"
  license "MIT"

  bottle do
    root_url "https://github.com/Gunsio/moonbox/releases/download/v0.1.7"
    sha256 arm64_sequoia: "e4c0f55aebfb5b71cf046099f966f7857b7beb0a94003edb9e217a5a838e67e4"
  end

  on_macos do
    on_arm do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.7/moonbox-0.1.7-aarch64-apple-darwin.tar.gz"
      sha256 "df302f18ed6553d3fc9541ed886e80364ad38588626400fc9228cc830f95cac8"
    end

    on_intel do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.7/moonbox-0.1.7-source.tar.gz"
      sha256 "a89155d9e152cda57c41416f883e5013fd3c51f1226950c4d4e3db8919a2e21e"

      depends_on "rust" => :build
    end
  end

  def install
    binary_root = if (buildpath/"bin/moonbox").exist?
      buildpath
    elsif (buildpath/"moonbox-0.1.7-aarch64-apple-darwin/bin/moonbox").exist?
      buildpath/"moonbox-0.1.7-aarch64-apple-darwin"
    end

    if binary_root
      bin.install binary_root/"bin/moonbox", binary_root/"bin/moon"
    else
      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin/"moonbox", "completions", shells: [:bash, :zsh, :fish, :pwsh])
    generate_completions_from_executable(bin/"moon", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match "moonbox", shell_output("#{bin}/moonbox --version")
    assert_match "moonbox", shell_output("#{bin}/moon --version")
    assert_match "fixture_only", shell_output("#{bin}/moonbox replay-eval --json")
    assert_match "_moonbox", shell_output("#{bin}/moonbox completions bash")
    assert_match "complete -c moon", shell_output("#{bin}/moon completions fish")
    assert_match "Register-ArgumentCompleter", shell_output("#{bin}/moon completions powershell")
  end
end
