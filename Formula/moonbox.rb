class Moonbox < Formula
  desc "Cross-CLI session rewind workbench"
  homepage "https://github.com/Gunsio/moonbox"
  license "MIT"

  bottle do
    root_url "https://github.com/Gunsio/moonbox/releases/download/v0.1.9"
    sha256 arm64_sequoia: "a730d5a281df116ddd4befb5c38519516716be3a8cb41b932f9695db00457db9"
  end

  on_macos do
    on_arm do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.9/moonbox-0.1.9-aarch64-apple-darwin.tar.gz"
      sha256 "fe94a59d3feff0009f06f4ee6b25c861eae1cc9e5f867db34e990bd8f2e96d45"
    end

    on_intel do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.9/moonbox-0.1.9-source.tar.gz"
      sha256 "2f9f70287bc79e5b9729359352537055ed51ff7951cdc602eacd6a91904dbf7c"

      depends_on "rust" => :build
    end
  end

  def install
    binary_root = if (buildpath/"bin/moonbox").exist?
      buildpath
    elsif (buildpath/"moonbox-0.1.9-aarch64-apple-darwin/bin/moonbox").exist?
      buildpath/"moonbox-0.1.9-aarch64-apple-darwin"
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
