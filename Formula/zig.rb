class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  version "0.14.0-dev.65+5f2bdafa3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-0.14.0-dev.65+5f2bdafa3.tar.xz"
      sha256 "ecc19c0b2647c255f036b809bcfb9ff85d2ee4eff677755eb228c48545f9b373"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
    if Hardware::CPU.intel?
      url "https://ziglang.org/builds/zig-linux-x86_64-0.14.0-dev.65+5f2bdafa3.tar.xz"
      sha256 "9809815e5c5632555c319e04bb125ed0baffef7cba60b5ca70d47ec61612ab38"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
  end


  on_linux do
    if Hardware::CPU.intel?
      url "https://ziglang.org/builds/zig-linux-x86_64-0.14.0-dev.65+5f2bdafa3.tar.xz"
      sha256 "9809815e5c5632555c319e04bb125ed0baffef7cba60b5ca70d47ec61612ab38"

      def install
        bin.install "zig"
        lib.install Dir["lib/*"]
      end
    end
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-0.14.0-dev.65+5f2bdafa3.tar.xz"
      sha256 "ecc19c0b2647c255f036b809bcfb9ff85d2ee4eff677755eb228c48545f9b373"

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