class Libp11AT11 < Formula
  desc "PKCS#11 wrapper library in C"
  homepage "https://github.com/OpenSC/libp11/wiki"
  url "https://github.com/OpenSC/libp11/releases/download/libp11-0.4.12/libp11-0.4.12.tar.gz"
  sha256 "1e1a2533b3fcc45fde4da64c9c00261b1047f14c3f911377ebd1b147b3321cfd"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libp11[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  head do
    url "https://github.com/OpenSC/libp11.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "openssl@1.1"

  keg_only :versioned_formula

  def install
    system "./bootstrap" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-enginesdir=#{lib}/engines-1.1"
    system "make", "install"
    pkgshare.install "examples/auth.c"
  end

  test do
    system ENV.cc, pkgshare/"auth.c", "-I#{Formula["openssl@1.1"].include}",
                   "-L#{lib}", "-L#{Formula["openssl@1.1"].lib}",
                   "-lp11", "-lcrypto", "-o", "test"
  end
end
