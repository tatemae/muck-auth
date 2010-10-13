namespace :muck do
  namespace :sync do
    desc "Sync required files from muck auth."
    task :auth do
      path = File.join(File.dirname(__FILE__), *%w[.. ..])
      system "rsync -ruv #{path}/db ."
      #system "rsync -ruv #{path}/public ."
      if !File.exists?('./config/secrets.yml')
        system "rsync -ruv #{path}/config/secrets.yml ./config/secrets.yml"
      end
    end
  end
end