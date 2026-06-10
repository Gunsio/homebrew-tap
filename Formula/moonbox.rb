class Moonbox < Formula
  desc "Cross-CLI session rewind workbench"
  homepage "https://github.com/Gunsio/moonbox"
  license "MIT"

  bottle do
    root_url "https://github.com/Gunsio/moonbox/releases/download/v0.1.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8546641f712e76548ce21393c6f470cded5d78f0623fe817d6d47b49e6ecd4d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8546641f712e76548ce21393c6f470cded5d78f0623fe817d6d47b49e6ecd4d1"
  end

  on_macos do
    on_arm do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.1/moonbox-0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "712a89949fdd195a10f6fe224231c54193c6437217c7d7a23a6287aa3333d19b"
    end

    on_intel do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.1/moonbox-0.1.1-source.tar.gz"
      sha256 "5257fab814067d220393bff572e4eed142bcd290e0427429c5c9f97c4b57dba6"

      depends_on "rust" => :build
    end
  end

  def install
    binary_root = if (buildpath/"bin/moonbox").exist?
      buildpath
    elsif (buildpath/"moonbox-0.1.1-aarch64-apple-darwin/bin/moonbox").exist?
      buildpath/"moonbox-0.1.1-aarch64-apple-darwin"
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
