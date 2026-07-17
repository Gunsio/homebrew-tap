class Moonbox < Formula
  desc "Cross-CLI session rewind workbench"
  homepage "https://github.com/Gunsio/moonbox"
  license "MIT"

  bottle do
    root_url "https://github.com/Gunsio/moonbox/releases/download/v0.1.11"
    sha256 arm64_sequoia: "ff3bc3a6461485b9b70ab69bdc1c2edd8f52b995d34f15eb9f206c8aab5649d8"
  end

  on_macos do
    on_arm do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.11/moonbox-0.1.11-aarch64-apple-darwin.tar.gz"
      sha256 "cff8fff0bcde100b968a9532e564935aa1f72b3342f98fbb2823ae54e5f34227"
    end

    on_intel do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.11/moonbox-0.1.11-source.tar.gz"
      sha256 "2f91b2acde3bbf676aac18aba72c3b6dc36e5b989a8f6f335ef7c87d685adb83"

      depends_on "rust" => :build
    end
  end

  def install
    binary_root = if (buildpath/"bin/moonbox").exist?
      buildpath
    elsif (buildpath/"moonbox-0.1.11-aarch64-apple-darwin/bin/moonbox").exist?
      buildpath/"moonbox-0.1.11-aarch64-apple-darwin"
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
