class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  version "0.15.0-dev.79+9f235a105"

  on_macos do
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-macos-aarch64-0.15.0-dev.79+9f235a105.tar.xz"
      sha256 "3b8d330a6764236117316269fb86e4e072396aa175b4671aa689132b4504b8e9"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
    if Hardware::CPU.intel?
      url "https://ziglang.org/builds/zig-macos-x86_64-0.15.0-dev.79+9f235a105.tar.xz"
      sha256 "8972343a3be743f5fa715335ae88b345e790a6d5f0a7088cf9b28576cb8da25c"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
  end


  on_linux do
    if Hardware::CPU.intel? #Linux intel
      url "https://ziglang.org/builds/zig-linux-x86_64-0.15.0-dev.79+9f235a105.tar.xz"
      sha256 "538b026619216c1de99d82875a4ae83bdca59229d72e8a12b6850699465978af"

      def install
        bin.install "zig"
        lib.install Dir["lib/*"]
      end
    end
    if Hardware::CPU.arm? #Linux arm
      url "https://ziglang.org/builds/zig-linux-aarch64-0.15.0-dev.79+9f235a105.tar.xz"
      sha256 "5623c2645e4c8d4d90a077daefcffdb2e48c31f29e8e2c00776da686fb311aaf"

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