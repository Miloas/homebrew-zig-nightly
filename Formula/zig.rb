class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  version "0.14.0-dev.105+f7d72ce88"

  on_macos do
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-macos-aarch64-0.14.0-dev.105+f7d72ce88.tar.xz"
      sha256 "eb8af7e693c3baca91f124f2de78bcafef396f7722774e8f330886a8fb1554aa"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
    if Hardware::CPU.intel?
      url "https://ziglang.org/builds/zig-macos-x86_64-0.14.0-dev.105+f7d72ce88.tar.xz"
      sha256 "9d905cc915e2f0047b770316ce73dbd723a44e2dd83501b0dbcf8f8f4bbee69a"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
  end


  on_linux do
    if Hardware::CPU.intel? #Linux intel
      url "https://ziglang.org/builds/zig-linux-x86_64-0.14.0-dev.105+f7d72ce88.tar.xz"
      sha256 "20795004e65b9ce2d8ddda517df0d1028ec3ce595410bdfae393f7c6bb77534e"

      def install
        bin.install "zig"
        lib.install Dir["lib/*"]
      end
    end
    if Hardware::CPU.arm? #Linux arm
      url "https://ziglang.org/builds/zig-linux-aarch64-0.14.0-dev.105+f7d72ce88.tar.xz"
      sha256 "b98681dde013dcae8e6bfe7524ccee4f4ef2eb8d31337394a8601bf1c69d9706"

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