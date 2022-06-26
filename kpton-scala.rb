class KptonScala < Formula
  homepage "https://scala-lang.org/"
  url "https://www.scala-lang.org/files/archive/scala-2.10.5.tgz"
  sha256 "918daf7de186305ff3c47bd0e6b03e74d6648c5239c050687b57b8fac2f87eb2"

  keg_only "Conflicts with scala in main repository."

  option "with-docs", "Also install library documentation"

  resource "docs" do
    url "https://www.scala-lang.org/files/archive/scala-docs-2.10.5.zip"
    sha256 "49263fc3b64f8d08bca906bb0c3f196eb6f3e699f810105a2b6d1d3d9cf030ca"
  end

  resource "completion" do
    url "https://raw.github.com/scala/scala-dist/27bc0c25145a83691e3678c7dda602e765e13413/completion.d/2.9.1/scala"
    sha256 "95aeba51165ce2c0e36e9bf006f2904a90031470ab8d10b456e7611413d7d3fd"
  end

  def install
    rm_f Dir["bin/*.bat"]
    doc.install Dir["doc/*"]
    man1.install Dir["man/man1/*"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
    bash_completion.install resource("completion")
    doc.install resource("docs") if build.with? "docs"

    # Set up an IntelliJ compatible symlink farm in "idea"
    idea = prefix/"idea"
    idea.install_symlink libexec/"src", libexec/"lib", libexec/"fsc", libexec/"scala", libexec/"scalac", libexec/"scaladoc",  libexec/"scalap"
    (idea/"doc/scala-devel-docs").install_symlink doc => "api"
  end

  def caveats; <<-EOS.undent
    To use with IntelliJ, set the Scala home to:
      #{opt_prefix}/idea
    EOS
  end

  test do
    file = testpath/"hello.scala"
    file.write <<-EOS.undent
      object Computer {
        def main(args: Array[String]) {
          println(2 + 2)
        }
      }
    EOS
    output = `'#{bin}/scala' #{file}`
    assert_equal "4", output.strip
    assert $?.success?
  end
end
