class Moonbox < Formula
  desc "Cross-CLI session rewind workbench"
  homepage "https://github.com/Gunsio/moonbox"
  license "MIT"

  bottle do
    root_url "https://github.com/Gunsio/moonbox/releases/download/v0.1.14"
    sha256 arm64_sequoia: "62418c7a8ce02da1d3e97b387ffb59a34aa560589f2d81e1f87743db32e155e8"
  end

  on_macos do
    on_arm do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.14/moonbox-0.1.14-aarch64-apple-darwin.tar.gz"
      sha256 "cd81bd5a7919f693610cacab5b5182f2c06df51db974de3b74305398de3a0583"
    end

    on_intel do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.14/moonbox-0.1.14-source.tar.gz"
      sha256 "fb6b25b04e2624fc24fe387bda88a050d65c1eab7b30eff8df3b63fb018ccd56"

      depends_on "rust" => :build
    end
  end

  def install
    binary_root = if (buildpath/"bin/moonbox").exist?
      buildpath
    elsif (buildpath/"moonbox-0.1.14-aarch64-apple-darwin/bin/moonbox").exist?
      buildpath/"moonbox-0.1.14-aarch64-apple-darwin"
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
