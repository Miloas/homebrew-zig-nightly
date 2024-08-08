class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  version "0.14.0-dev.909+f9f894200"

  on_macos do
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-macos-aarch64-0.14.0-dev.909+f9f894200.tar.xz"
      sha256 "a700e032616e85d4f075faa08c7b852b78450670a9235ebac16d501ad000442e"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
    if Hardware::CPU.intel?
      url "https://ziglang.org/builds/zig-macos-x86_64-0.14.0-dev.909+f9f894200.tar.xz"
      sha256 "f15b5288e1f1823c890c952cb0faaa35486314d3d5b00b233ff3e43e2ed5c173"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
  end


  on_linux do
    if Hardware::CPU.intel? #Linux intel
      url "https://ziglang.org/builds/zig-linux-x86_64-0.14.0-dev.909+f9f894200.tar.xz"
      sha256 "3facd6bbc860f7928f634a7430d154ff8d14f75daf3c14e620ae7021956ca659"

      def install
        bin.install "zig"
        lib.install Dir["lib/*"]
      end
    end
    if Hardware::CPU.arm? #Linux arm
      url "https://ziglang.org/builds/zig-linux-aarch64-0.14.0-dev.909+f9f894200.tar.xz"
      sha256 "7a343aa915b05c5074fc19e6b5e3b2ef875537423c74c20ca01513ef6488ac01"

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