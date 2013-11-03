module Autoparts
  module Packages
    class Rethinkdb < Package
      name 'rethinkdb'
      version '1.10.1'
      description 'RethinkDB'
      source_url 'http://download.rethinkdb.com/dist/rethinkdb-1.10.1.tgz'
      source_sha1 '8ef081b20f5677d00da68265fe83d09377784eba'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir('rethinkdb-1.10.1') do
          execute './configure'
          execute 'make'
        end
      end

      def install
        Dir.chdir('rethinkdb-1.10.1') do
          prefix_path.mkpath
          execute "mv * #{prefix_path}"
        end
      end

      def post_install
        rethinkdb_var_path.mkpath
        rethinkdb_log_path.mkpath
      end

      def purge
      end

      def rethinkdb_server_path
        bin_path + 'rethinkdb'
      end

      def rethinkdb_conf_path
        Path.etc + 'rethinkdb.conf'
      end

      def rethinkdb_var_path
        Path.var + 'rethinkdb'
      end

      def rethinkdb_pid_file_path
        rethinkdb_var_path + 'rethinkdb.pid'
      end

      def rethinkdb_log_path
        Path.var + 'log' + 'rethinkdb'
      end

      def read_rethinkdb_pid_file
        @rethinkdb_pid ||= File.read(rethinkdb_pid_file_path).strip
      end

      def start
        execute rethinkdb_server_path, rethinkdb_conf_path
      end

      def stop
        pid = read_rethinkdb_pid_file
        execute 'kill', pid
        # wait until process is killed
        sleep 0.2 while system 'kill', '-0', pid, out: '/dev/null', err: '/dev/null'
        rethinkdb_pid_file_path.unlink if rethinkdb_pid_file_path.exist?
      end

      def running?
        if rethinkdb_pid_file_path.exist?
          pid = read_rethinkdb_pid_file
          if pid.length > 0 && `ps -o cmd= #{pid}`.include?(rethinkdb_server_path.basename.to_s)
            return true
          end
        end
        false
      end

      def tips
        <<-EOS.unindent
          To start the server:
            $ parts start rethinkdb

          To stop the server:
            $ parts stop rethinkdb

        EOS
      end
    end
  end
end
