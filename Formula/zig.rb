class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  version "0.16.0-dev.1484+d0ba6642b"

  on_macos do
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-aarch64-macos-0.16.0-dev.1484+d0ba6642b.tar.xz"
      sha256 "b521ed99eecad23575de1c138d9efc2fa4e3c3b9afd454af66c91707e3c89d32"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
    if Hardware::CPU.intel?
      url "https://ziglang.org/builds/zig-x86_64-macos-0.16.0-dev.1484+d0ba6642b.tar.xz"
      sha256 "7055d0af0dd99af4e845a016e25fdd3be26c0e2c331b98902d2510c737e8b50e"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
  end


  on_linux do
    if Hardware::CPU.intel? #Linux intel
      url "https://ziglang.org/builds/zig-x86_64-linux-0.16.0-dev.1484+d0ba6642b.tar.xz"
      sha256 "3f90582cde6e4ea4a9b9b1dd283a6720131dfefbece1c85be2f4c82ab74a2e7b"

      def install
        bin.install "zig"
        lib.install Dir["lib/*"]
      end
    end
    if Hardware::CPU.arm? #Linux arm
      url "https://ziglang.org/builds/zig-aarch64-linux-0.16.0-dev.1484+d0ba6642b.tar.xz"
      sha256 "f8240e9708376f3e808c59dbaf69a2839eb1a14507432ee9f7d6817482346bf9"

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