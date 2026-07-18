class Moonbox < Formula
  desc "Cross-CLI session rewind workbench"
  homepage "https://github.com/Gunsio/moonbox"
  license "MIT"

  bottle do
    root_url "https://github.com/Gunsio/moonbox/releases/download/v0.1.15"
    sha256 arm64_sequoia: "01b3cb8b7283d9e9e14b43fb8bf46b0d869fb0c26894bdf363899972362b29fd"
  end

  on_macos do
    on_arm do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.15/moonbox-0.1.15-aarch64-apple-darwin.tar.gz"
      sha256 "1d53eed21f195c6b2856cedff3d3e852be75ed51be533a6bd4e60684e2fda6d9"
    end

    on_intel do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.15/moonbox-0.1.15-source.tar.gz"
      sha256 "064e5f431fbe40c17983fb90c2374a4df12a76093a5e1c16c0a17a6dc0b42acb"

      depends_on "rust" => :build
    end
  end

  def install
    binary_root = if (buildpath/"bin/moonbox").exist?
      buildpath
    elsif (buildpath/"moonbox-0.1.15-aarch64-apple-darwin/bin/moonbox").exist?
      buildpath/"moonbox-0.1.15-aarch64-apple-darwin"
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
