class Moonbox < Formula
  desc "Cross-CLI session rewind workbench"
  homepage "https://github.com/Gunsio/moonbox"
  license "MIT"

  bottle do
    root_url "https://github.com/Gunsio/moonbox/releases/download/v0.1.16"
    sha256 arm64_sequoia: "47bef76cd775da2e3a86a1a0dbe0a73479bf2821f9d0f2d17ec99e8296d65cd4"
  end

  on_macos do
    on_arm do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.16/moonbox-0.1.16-aarch64-apple-darwin.tar.gz"
      sha256 "e80d0eabc8cb61b9f356a6789cacce0a9dbd35725df99523ac8cd4a409f9c07c"
    end

    on_intel do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.16/moonbox-0.1.16-source.tar.gz"
      sha256 "1f4f5c7febad02a44b97940f343e90d208967131c4c3b1b07e0c92b8f2651e0e"

      depends_on "rust" => :build
    end
  end

  def install
    binary_root = if (buildpath/"bin/moonbox").exist?
      buildpath
    elsif (buildpath/"moonbox-0.1.16-aarch64-apple-darwin/bin/moonbox").exist?
      buildpath/"moonbox-0.1.16-aarch64-apple-darwin"
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
