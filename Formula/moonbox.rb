class Moonbox < Formula
  desc "Cross-CLI session rewind workbench"
  homepage "https://github.com/Gunsio/moonbox"
  license "MIT"

  bottle do
    root_url "https://github.com/Gunsio/moonbox/releases/download/v0.1.6"
    sha256 arm64_sequoia: "b8fe56a492924bdba6358b188d788613edc2163eb924ee43dc660b2299ffc7cf"
  end

  on_macos do
    on_arm do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.6/moonbox-0.1.6-aarch64-apple-darwin.tar.gz"
      sha256 "7c2ecc3c2ec47e2be12f17c128d274f099fc19882db933aafc11f147e632cc58"
    end

    on_intel do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.6/moonbox-0.1.6-source.tar.gz"
      sha256 "c125e698611279236c559829ab3c84abfb9ea3fc1a8e1174f90d4ed0eef4b84e"

      depends_on "rust" => :build
    end
  end

  def install
    binary_root = if (buildpath/"bin/moonbox").exist?
      buildpath
    elsif (buildpath/"moonbox-0.1.6-aarch64-apple-darwin/bin/moonbox").exist?
      buildpath/"moonbox-0.1.6-aarch64-apple-darwin"
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
