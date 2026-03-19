class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  version "0.16.0-dev.2915+065c6e794"

  on_macos do
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-aarch64-macos-0.16.0-dev.2915+065c6e794.tar.xz"
      sha256 "b28af5aca37c36f65c323961cfa52a8cd3285edf58892d8c6f914a9b29746bad"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
    if Hardware::CPU.intel?
      url "https://ziglang.org/builds/zig-x86_64-macos-0.16.0-dev.2915+065c6e794.tar.xz"
      sha256 "cbf5283f999e78a6f3faa90dd1247a809d07031a2ff4e9a8ebb4acd463831275"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
  end


  on_linux do
    if Hardware::CPU.intel? #Linux intel
      url "https://ziglang.org/builds/zig-x86_64-linux-0.16.0-dev.2915+065c6e794.tar.xz"
      sha256 "ecdbcaf213e33f4117bc75c1b885a7e043450c907627d8b2a35c4e60eb07d0ad"

      def install
        bin.install "zig"
        lib.install Dir["lib/*"]
      end
    end
    if Hardware::CPU.arm? #Linux arm
      url "https://ziglang.org/builds/zig-aarch64-linux-0.16.0-dev.2915+065c6e794.tar.xz"
      sha256 "d4bc35bb844f27bf59e37c6fcea1878c4753a3a236b497515de55f9f60da8ffa"

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