class Moonbox < Formula
  desc "Cross-CLI session rewind workbench"
  homepage "https://github.com/Gunsio/moonbox"
  license "MIT"

  bottle do
    root_url "https://github.com/Gunsio/moonbox/releases/download/v0.1.13"
    sha256 arm64_sequoia: "6062e823aa793fffc6beccadbf21f7628e5674817e8da853b4b8f5349a0d20bd"
  end

  on_macos do
    on_arm do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.13/moonbox-0.1.13-aarch64-apple-darwin.tar.gz"
      sha256 "c092a5bd598aeb715cf8012cdf4ebb6247beb41efd0c63b32a0d96693a13c757"
    end

    on_intel do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.13/moonbox-0.1.13-source.tar.gz"
      sha256 "3a95a317419355df9718685dc3ecbdc8c9c8ee5c8d9225e24a215783af17daa1"

      depends_on "rust" => :build
    end
  end

  def install
    binary_root = if (buildpath/"bin/moonbox").exist?
      buildpath
    elsif (buildpath/"moonbox-0.1.13-aarch64-apple-darwin/bin/moonbox").exist?
      buildpath/"moonbox-0.1.13-aarch64-apple-darwin"
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
