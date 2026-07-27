class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  version "0.17.0-dev.1465+8b2d0ce21"

  on_macos do
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-aarch64-macos-0.17.0-dev.1465+8b2d0ce21.tar.xz"
      sha256 "215c71456e0cc8994e0c56438d93a4a512d3780a9e6a3a48a8917db7f4cfead9"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
    if Hardware::CPU.intel?
      url "https://ziglang.org/builds/zig-x86_64-macos-0.17.0-dev.1465+8b2d0ce21.tar.xz"
      sha256 "1dd73a374c9a82c795bd57c64c7a3f33375b1801a9256d7b84b34a579236224a"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
  end


  on_linux do
    if Hardware::CPU.intel? #Linux intel
      url "https://ziglang.org/builds/zig-x86_64-linux-0.17.0-dev.1465+8b2d0ce21.tar.xz"
      sha256 "2a196dd43ec51e64b6de3ed0e5f9f217aac88ad187e3ae5db3fe037feddef118"

      def install
        bin.install "zig"
        lib.install Dir["lib/*"]
      end
    end
    if Hardware::CPU.arm? #Linux arm
      url "https://ziglang.org/builds/zig-aarch64-linux-0.17.0-dev.1465+8b2d0ce21.tar.xz"
      sha256 "248715e53cdc6fc0ab20083742748f7e262937989f9a1f27a279c2a5f9b529a0"

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