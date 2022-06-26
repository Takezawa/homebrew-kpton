# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class KptonPlay < Formula
  desc ""
  homepage "https://www.playframework.com/"
  url "https://downloads.typesafe.com/play/2.1.5/play-2.1.5.zip"
  sha256 "d9ae9b4b87fa09171cc44e6ff6af30b2523070708c94eeda6ceab0d1c97c39a5"
  license ""

  # depends_on "cmake" => :build

  def install
    rm Dir['*.bat'] # remove windows bat files
    libexec.install Dir['*']
    inreplace libexec+"play" do |s|
      s.gsub! "$dir/", "$dir/../libexec/"
      s.gsub! "dir=`dirname $PRG`", "dir=`dirname $0` && dir=$dir/`dirname $PRG`"
    end
    bin.install_symlink libexec+'play'
  end
end