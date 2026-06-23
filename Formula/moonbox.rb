class Moonbox < Formula
  desc "Cross-CLI session rewind workbench"
  homepage "https://github.com/Gunsio/moonbox"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.5-beta.46/moonbox-0.1.5-beta.46-aarch64-apple-darwin.tar.gz"
      sha256 "a7c90a800bf564d32cb44e1d2d99e839b2ef38d471bca79a389d764ac4c9288d"
    end

    on_intel do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.5-beta.46/moonbox-0.1.5-beta.46-source.tar.gz"
      sha256 "0d4c6ec22892e3117f9944f8e88ba88fa939a6f42cfd96be7e5bad7bd9bf2ac9"

      depends_on "rust" => :build
    end
  end

  def install
    binary_root = if (buildpath/"bin/moonbox").exist?
      buildpath
    elsif (buildpath/"moonbox-0.1.5-beta.46-aarch64-apple-darwin/bin/moonbox").exist?
      buildpath/"moonbox-0.1.5-beta.46-aarch64-apple-darwin"
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
