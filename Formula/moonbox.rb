class Moonbox < Formula
  desc "Cross-CLI session rewind workbench"
  homepage "https://github.com/Gunsio/moonbox"
  license "MIT"

  bottle do
    root_url "https://github.com/Gunsio/moonbox/releases/download/v0.1.8"
    sha256 arm64_sequoia: "e2c4652863f9511cd52e5b2376acb3595327eb85f4fa906957284cfaa72a940c"
  end

  on_macos do
    on_arm do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.8/moonbox-0.1.8-aarch64-apple-darwin.tar.gz"
      sha256 "63877c2c5681b2cec941dd3a145e9d839f0ff778ea98013625af2b69252f8ec4"
    end

    on_intel do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.8/moonbox-0.1.8-source.tar.gz"
      sha256 "b7470c84bab284982c7378f546207d2db9566226c6fe2521f3cd2113005a3cfb"

      depends_on "rust" => :build
    end
  end

  def install
    binary_root = if (buildpath/"bin/moonbox").exist?
      buildpath
    elsif (buildpath/"moonbox-0.1.8-aarch64-apple-darwin/bin/moonbox").exist?
      buildpath/"moonbox-0.1.8-aarch64-apple-darwin"
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
