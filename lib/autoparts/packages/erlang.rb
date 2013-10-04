module Autoparts
  module Packages
    class Erlang < Package
      name 'erlang'
      version 'R16B02'
      description 'Erlang OTP: A general-purpose concurrent, garbage-collected programming language and runtime system'
      source_url 'https://packages.erlang-solutions.com/erlang/esl-erlang-src/otp_src_R16B02.tar.gz'
      source_sha1 '16accc21afaebf2bd9507c5a2610aecf8d6f8243'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir("otp_src_#{version}") do
          args = [
            "--prefix=#{prefix_path}"
          ]

          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir("otp_src_#{version}") do
          bin_path.mkpath
          execute 'make', 'install'
        end
      end
    end
  end
end
