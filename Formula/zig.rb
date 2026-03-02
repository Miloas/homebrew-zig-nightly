class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  version "0.16.0-dev.2682+02142a54d"

  on_macos do
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-aarch64-macos-0.16.0-dev.2682+02142a54d.tar.xz"
      sha256 "6fb50133a0379bcbca83f7296c2cedc3a4dfdf86dec6bc56d7b3fce8f5c59711"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
    if Hardware::CPU.intel?
      url "https://ziglang.org/builds/zig-x86_64-macos-0.16.0-dev.2682+02142a54d.tar.xz"
      sha256 "571f01bb8690f6dcfa71d5be6283fa26342bee2b59ab91d5dd0b7100c0ddb3ef"

      def install
        bin.install "zig"
        # https://cvo-23052022.fly.dev/unable-to-find-zig-installation-directory-filenotfound/
        bin.install Dir["lib"]
      end
    end
  end


  on_linux do
    if Hardware::CPU.intel? #Linux intel
      url "https://ziglang.org/builds/zig-x86_64-linux-0.16.0-dev.2682+02142a54d.tar.xz"
      sha256 "1d3642914a931395dfb3de0ad8d4659cec9149d5257912b77ad1b1766767566c"

      def install
        bin.install "zig"
        lib.install Dir["lib/*"]
      end
    end
    if Hardware::CPU.arm? #Linux arm
      url "https://ziglang.org/builds/zig-aarch64-linux-0.16.0-dev.2682+02142a54d.tar.xz"
      sha256 "972808424ca938a7e38fd7698f1c2b09e8859b3c118669d026340fdbaf3760da"

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