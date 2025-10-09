class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  version "0.16.0-dev.683+60a332406"

  on_macos do
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-aarch64-macos-0.16.0-dev.683+60a332406.tar.xz"
      sha256 "f4b8be4ec74373c775318eb564302c5096c56cb21644ea3c2f162fbe5bf19c3a"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
    if Hardware::CPU.intel?
      url "https://ziglang.org/builds/zig-x86_64-macos-0.16.0-dev.683+60a332406.tar.xz"
      sha256 "2ae8cc2a106fd7eea8357942a84f04097603e685eb56f5eb6b135371c6561736"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
  end


  on_linux do
    if Hardware::CPU.intel? #Linux intel
      url "https://ziglang.org/builds/zig-x86_64-linux-0.16.0-dev.683+60a332406.tar.xz"
      sha256 "13ad1b5e31986c12ec107e069c35dfd07d349ffad5c673f862906b0f247a350c"

      def install
        bin.install "zig"
        lib.install Dir["lib/*"]
      end
    end
    if Hardware::CPU.arm? #Linux arm
      url "https://ziglang.org/builds/zig-aarch64-linux-0.16.0-dev.683+60a332406.tar.xz"
      sha256 "e95753c7dc25d3aef49bded67430d9afc0b74f2ba2385c3857cb1b042555d111"

      def install
        bin.install "zig"
        lib.install Dir["lib/*"]
      end
    end
  end

  test do
    (testpath/"hello.zig").write <<~EOS
      const std = @import("std");
      pub fn main() !void {
          const stdout = std.io.getStdOut().writer();
          try stdout.print("Hello, world!", .{});
      }
    EOS
    system "#{bin}/zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output("./hello")

    ENV.delete "CPATH"
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        fprintf(stdout, "Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/zig", "cc", "hello.c", "-o", "hello"
    assert_equal "Hello, world!", shell_output("./hello")
  end
end