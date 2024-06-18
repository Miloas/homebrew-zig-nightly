class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  version "0.14.0-dev.61+04e08ea88"

  on_macos do
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-0.14.0-dev.61+04e08ea88.tar.xz"
      sha256 "4d3d04a6f9b7fa4df48598de57c30eacabd87c717b3ee1f93907d55641ffaa60"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
    if Hardware::CPU.intel?
      url "https://ziglang.org/builds/zig-linux-x86_64-0.14.0-dev.61+04e08ea88.tar.xz"
      sha256 "4065e674352f2cfdeb279e37906a1e6529adfe2acb9604dec239b9102faa1837"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
  end


  on_linux do
    if Hardware::CPU.intel?
      url "https://ziglang.org/builds/zig-linux-x86_64-0.14.0-dev.61+04e08ea88.tar.xz"
      sha256 "4065e674352f2cfdeb279e37906a1e6529adfe2acb9604dec239b9102faa1837"

      def install
        bin.install "zig"
        lib.install Dir["lib/*"]
      end
    end
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-0.14.0-dev.61+04e08ea88.tar.xz"
      sha256 "4d3d04a6f9b7fa4df48598de57c30eacabd87c717b3ee1f93907d55641ffaa60"

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