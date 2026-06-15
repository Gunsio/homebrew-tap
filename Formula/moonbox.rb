class Moonbox < Formula
  desc "Cross-CLI session rewind workbench"
  homepage "https://github.com/Gunsio/moonbox"
  version "0.1.4"
  license "MIT"

  bottle do
    root_url "https://github.com/Gunsio/moonbox/releases/download/v0.1.4"
    rebuild 1
    sha256 arm64_sequoia: "5ad956c3e321a22e703dfe2db91165de62f225c64c0ee8a647942541f447098e"
    sha256 arm64_tahoe: "5ad956c3e321a22e703dfe2db91165de62f225c64c0ee8a647942541f447098e"
  end

  on_macos do
    on_arm do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.4/moonbox-0.1.4-aarch64-apple-darwin.tar.gz"
      sha256 "ec788b98823006947a226429b16d8f8aebe8b68fef73a79e1839cef245444bd8"
    end

    on_intel do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.4/moonbox-0.1.4-source.tar.gz"
      sha256 "c3a72fcdf9785d1538fb7956ffbc66d528b1f829ee9d52ed67708c9e671f9a08"

      depends_on "rust" => :build
    end
  end

  def install
    binary_root = if (buildpath/"bin/moonbox").exist?
      buildpath
    elsif (buildpath/"moonbox-0.1.4-aarch64-apple-darwin/bin/moonbox").exist?
      buildpath/"moonbox-0.1.4-aarch64-apple-darwin"
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
