class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  version "0.14.0-dev.296+bd7b2cc4b"

  on_macos do
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-macos-aarch64-0.14.0-dev.296+bd7b2cc4b.tar.xz"
      sha256 "460e3465f0ce43fdb11e80668645ef5a2fb48a24a1a836c88a8136dc4d815699"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
    if Hardware::CPU.intel?
      url "https://ziglang.org/builds/zig-macos-x86_64-0.14.0-dev.296+bd7b2cc4b.tar.xz"
      sha256 "8c21953f3b1a6b788dad44e9eed541c99bfc8fe3a6ea9fdb88e63f4b27e7ceaa"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
  end


  on_linux do
    if Hardware::CPU.intel? #Linux intel
      url "https://ziglang.org/builds/zig-linux-x86_64-0.14.0-dev.296+bd7b2cc4b.tar.xz"
      sha256 "e74382d61dc0b61edd41e22f17442d774a23d4eec9ca840105b1e0f034100334"

      def install
        bin.install "zig"
        lib.install Dir["lib/*"]
      end
    end
    if Hardware::CPU.arm? #Linux arm
      url "https://ziglang.org/builds/zig-linux-aarch64-0.14.0-dev.296+bd7b2cc4b.tar.xz"
      sha256 "ca91c080c410d56e00f5be8a95282dc1e45c4e9e001917faa4c2f61bd1218561"

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