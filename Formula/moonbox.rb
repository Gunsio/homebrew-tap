class Moonbox < Formula
  desc "Cross-CLI session rewind workbench"
  homepage "https://github.com/Gunsio/moonbox"
  license "MIT"

  bottle do
    root_url "https://github.com/Gunsio/moonbox/releases/download/v0.1.12"
    sha256 arm64_sequoia: "e511c6b8f10c062bc8d2df5d7fde41a14b28d4ec4d353ce5771ea7a81aca2954"
  end

  on_macos do
    on_arm do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.12/moonbox-0.1.12-aarch64-apple-darwin.tar.gz"
      sha256 "b3ffefb4ba4ca6dfde627cfcaa89f49b71c356e4ef22cfa02515f1c9ed530b88"
    end

    on_intel do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.12/moonbox-0.1.12-source.tar.gz"
      sha256 "f5a4a1a982a913c683ddbc1def47c9a23267a69da467328bf5fe016d21c9e196"

      depends_on "rust" => :build
    end
  end

  def install
    binary_root = if (buildpath/"bin/moonbox").exist?
      buildpath
    elsif (buildpath/"moonbox-0.1.12-aarch64-apple-darwin/bin/moonbox").exist?
      buildpath/"moonbox-0.1.12-aarch64-apple-darwin"
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
