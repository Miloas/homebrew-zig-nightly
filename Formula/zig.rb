class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  version "0.14.0-dev.184+bf588f67d"

  on_macos do
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-macos-aarch64-0.14.0-dev.184+bf588f67d.tar.xz"
      sha256 "924d90290689380f802212bf9a775fcc9ad0de0886d2bf945ed560016aea0db7"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
    if Hardware::CPU.intel?
      url "https://ziglang.org/builds/zig-macos-x86_64-0.14.0-dev.184+bf588f67d.tar.xz"
      sha256 "acca95f9d81dc107d5bd3af96af9765546454c00aae3d566b1752579dc9a2ee6"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
  end


  on_linux do
    if Hardware::CPU.intel? #Linux intel
      url "https://ziglang.org/builds/zig-linux-x86_64-0.14.0-dev.184+bf588f67d.tar.xz"
      sha256 "5576440040a54f2931a22a26089d5675ea3b1bec007f387da2aff57ce2463c46"

      def install
        bin.install "zig"
        lib.install Dir["lib/*"]
      end
    end
    if Hardware::CPU.arm? #Linux arm
      url "https://ziglang.org/builds/zig-linux-aarch64-0.14.0-dev.184+bf588f67d.tar.xz"
      sha256 "5149420547fe0e6da0a8e81a8a24506d140ea8b2cfeeef3c02758eead127613b"

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