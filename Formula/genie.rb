class Genie < Formula
  desc "A command line shell for using LLMs tools in the command line"
  homepage "https://github.com/grahambrooks/genie"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/grahambrooks/genie/releases/download/0.1.5/genie-aarch64-apple-darwin.tar.xz"
      sha256 "66ef9a02887910f1629e2b1e57a2c3cafdd4d48bfb12e998649dab55c187c362"
    end
    if Hardware::CPU.intel?
      url "https://github.com/grahambrooks/genie/releases/download/0.1.5/genie-x86_64-apple-darwin.tar.xz"
      sha256 "061af2a5e7de939316f87eb552177d39e92ba5d0c99f4a16bfd19f63e3446242"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/grahambrooks/genie/releases/download/0.1.5/genie-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "2bb083514cc75a018a5004336212ac35b92270432572aa6d3b0d60c30dc0b70a"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "genie" if OS.mac? && Hardware::CPU.arm?
    bin.install "genie" if OS.mac? && Hardware::CPU.intel?
    bin.install "genie" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
