class Moonbox < Formula
  desc "Cross-CLI session rewind workbench"
  homepage "https://github.com/Gunsio/moonbox"
  license "MIT"

  bottle do
    root_url "https://github.com/Gunsio/moonbox/releases/download/v0.1.17"
    sha256 arm64_sequoia: "9ac131199db35deee4dd2c2357c1dd48e6e7272f178f1178318ed1bb3497646b"
  end

  on_macos do
    on_arm do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.17/moonbox-0.1.17-aarch64-apple-darwin.tar.gz"
      sha256 "a89f4ef1b8d4229bdf1ed25db9276eb969234a6de59fc2b9e9017d993b5ffe23"
    end

    on_intel do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.17/moonbox-0.1.17-source.tar.gz"
      sha256 "b6d6e9ecd773699c37c52a12bf22f8cebb2432f2671d2afbe13e6c4d350a142f"

      depends_on "rust" => :build
    end
  end

  def install
    binary_root = if (buildpath/"bin/moonbox").exist?
      buildpath
    elsif (buildpath/"moonbox-0.1.17-aarch64-apple-darwin/bin/moonbox").exist?
      buildpath/"moonbox-0.1.17-aarch64-apple-darwin"
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
    assert_equal "moonbox #{version}\n", shell_output("#{bin}/moonbox --version")
    assert_equal "moonbox #{version}\n", shell_output("#{bin}/moon --version")
    assert_match "fixture_only", shell_output("#{bin}/moonbox replay-eval --json")
    assert_match "_moonbox", shell_output("#{bin}/moonbox completions bash")
    assert_match "complete -c moon", shell_output("#{bin}/moon completions fish")
    assert_match "Register-ArgumentCompleter", shell_output("#{bin}/moon completions powershell")
  end
end
