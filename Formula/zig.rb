class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  version "0.14.0-dev.56+455899668"

  on_macos do
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-0.14.0-dev.56+455899668.tar.xz"
      sha256 "2780bb8c7548aa36aabb154281c7f7df9dde0efbeecc4db8db43c451c21c5907"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
    if Hardware::CPU.intel?
      url "https://ziglang.org/builds/zig-linux-x86_64-0.14.0-dev.56+455899668.tar.xz"
      sha256 "40d76120a033375b5b043668a847b23232ab0fd33d8d583ae96043647988433e"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
  end


  on_linux do
    if Hardware::CPU.intel?
      url "https://ziglang.org/builds/zig-linux-x86_64-0.14.0-dev.56+455899668.tar.xz"
      sha256 "40d76120a033375b5b043668a847b23232ab0fd33d8d583ae96043647988433e"

      def install
        bin.install "zig"
        lib.install Dir["lib/*"]
      end
    end
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-0.14.0-dev.56+455899668.tar.xz"
      sha256 "2780bb8c7548aa36aabb154281c7f7df9dde0efbeecc4db8db43c451c21c5907"

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