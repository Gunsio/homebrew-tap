class Moonbox < Formula
  desc "Cross-CLI session rewind workbench"
  homepage "https://github.com/Gunsio/moonbox"
  license "MIT"

  bottle do
    root_url "https://github.com/Gunsio/moonbox/releases/download/v0.1.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "bf8a725dc4bb7bb9f12cf1dbf0c5293a93937105af99269ee6813512f5cbdb3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf8a725dc4bb7bb9f12cf1dbf0c5293a93937105af99269ee6813512f5cbdb3c"
  end

  on_macos do
    on_arm do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.0/moonbox-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "f8cfc1ec90db00835a9bbaa14c1928134a393fa69b3416821b5cd0a4ba2a5380"
    end

    on_intel do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.0/moonbox-0.1.0-source.tar.gz"
      sha256 "22392d6610b31d259e359dbc05c9f32f13371bdee42fab4c075eed34bcbb4a00"

      depends_on "rust" => :build
    end
  end

  def install
    binary_root = if (buildpath/"bin/moonbox").exist?
      buildpath
    elsif (buildpath/"moonbox-0.1.0-aarch64-apple-darwin/bin/moonbox").exist?
      buildpath/"moonbox-0.1.0-aarch64-apple-darwin"
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
