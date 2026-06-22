class Moonbox < Formula
  desc "Cross-CLI session rewind workbench"
  homepage "https://github.com/Gunsio/moonbox"
  license "MIT"

  bottle do
    root_url "https://github.com/Gunsio/moonbox/releases/download/v0.1.5-beta.45"
    sha256 arm64_sequoia: "31778aa40b14eb3ea34b0179bc4c730a054bf228a5a005a96f371159055c91f9"
    sha256 arm64_tahoe:   "31778aa40b14eb3ea34b0179bc4c730a054bf228a5a005a96f371159055c91f9"
  end

  on_macos do
    on_arm do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.5-beta.45/moonbox-0.1.5-beta.45-aarch64-apple-darwin.tar.gz"
      sha256 "fcc3d46bf20086ffad247f53894b04e9682700567e1f9a6ae3b3711972a0df45"
    end

    on_intel do
      url "https://github.com/Gunsio/moonbox/releases/download/v0.1.5-beta.45/moonbox-0.1.5-beta.45-source.tar.gz"
      sha256 "aeabfa9b7e3b7af4d37b504a50db90c98abce82313a1c470b28a82f5705db85b"

      depends_on "rust" => :build
    end
  end

  def install
    binary_root = if (buildpath/"bin/moonbox").exist?
      buildpath
    elsif (buildpath/"moonbox-0.1.5-beta.45-aarch64-apple-darwin/bin/moonbox").exist?
      buildpath/"moonbox-0.1.5-beta.45-aarch64-apple-darwin"
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
