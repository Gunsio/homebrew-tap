class Moonbox < Formula
  desc "Cross-CLI session rewind workbench"
  homepage "https://github.com/Gunsio/moonbox"
  license "MIT"

  bottle do
    root_url "https://github.com/Gunsio/moonbox/releases/download/v0.1.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38f9d3b614da561f7848b5fd513619d0dbc208356a81f96a6859a8d27743a2b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38f9d3b614da561f7848b5fd513619d0dbc208356a81f96a6859a8d27743a2b3"
  end

  on_macos do
    on_arm do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.2/moonbox-0.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "df2b8e60bc7a03b8a9c230636751b2de5d2e3ba0ca3f01aa6aba8c40418577be"
    end

    on_intel do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.2/moonbox-0.1.2-source.tar.gz"
      sha256 "505a1d9bd3c74f0bfc921005136b972f1fba475dac0709e82dbd9171c7645aba"

      depends_on "rust" => :build
    end
  end

  def install
    binary_root = if (buildpath/"bin/moonbox").exist?
      buildpath
    elsif (buildpath/"moonbox-0.1.2-aarch64-apple-darwin/bin/moonbox").exist?
      buildpath/"moonbox-0.1.2-aarch64-apple-darwin"
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
