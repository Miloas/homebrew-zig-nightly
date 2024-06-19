class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  version "0.14.0-dev.66+1fdf13a14"

  on_macos do
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-0.14.0-dev.66+1fdf13a14.tar.xz"
      sha256 "14f8865f83be28490e29977a5a31358ac60e3a632089937edcad16148bf71d01"

      def install
        bin.install "zig"
        lib.install Dir["lib/*"]
      end
    end
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-0.14.0-dev.66+1fdf13a14.tar.xz"
      sha256 "14f8865f83be28490e29977a5a31358ac60e3a632089937edcad16148bf71d01"

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