class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  version "0.14.0-dev.53+fda2458f6"

  on_macos do
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-0.14.0-dev.53+fda2458f6.tar.xz"
      sha256 "0326cfc6a72c6f2ceac6e7260778daf9b69099b99c21561ca20c27eb6f62a462"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
    if Hardware::CPU.intel?
      url "https://ziglang.org/builds/zig-linux-x86_64-0.14.0-dev.53+fda2458f6.tar.xz"
      sha256 "cfc57b9a3dac99f10edfc5f74d4b038ff8f161e733f46025c7d682d5d39258b8"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
  end


  on_linux do
    if Hardware::CPU.intel?
      url "https://ziglang.org/builds/zig-linux-x86_64-0.14.0-dev.53+fda2458f6.tar.xz"
      sha256 "cfc57b9a3dac99f10edfc5f74d4b038ff8f161e733f46025c7d682d5d39258b8"

      def install
        bin.install "zig"
        lib.install Dir["lib/*"]
      end
    end
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-0.14.0-dev.53+fda2458f6.tar.xz"
      sha256 "0326cfc6a72c6f2ceac6e7260778daf9b69099b99c21561ca20c27eb6f62a462"

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