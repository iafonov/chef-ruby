ruby_version        = node["ruby"]["version"]                        # ruby-1.9.3-p194
ruby_version_number = ruby_version.split("-")[1]                     # 1.9.3
ruby_major          = ruby_version_number.split(".")[0..1].join(".") # 1.9
ruby_patchlevel     = ruby_version.split("-")[2][1..-1]              # 194

dep_packages = ["build-essential",
                "zlib1g-dev",
                "libssl-dev",
                "libreadline-dev",
                "libyaml-dev",
                "libcurl4-openssl-dev",
                "curl",
                "git-core",
                "wget"]

dep_packages.each { |dep_package| package dep_package }

script "build and install ruby" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  not_if do 
    `ruby -v` =~ /^ruby #{ruby_version_number}.*patchlevel #{ruby_patchlevel}/ || # 1.8 version output scheme
    `ruby -v` =~ /^ruby #{ruby_version_number}*p#{ruby_patchlevel}/               # 1.9 version output scheme
  end
  code <<-EOH
    wget ftp://ftp.ruby-lang.org/pub/ruby/#{ruby_major}/#{ruby_version}.tar.gz
    tar -zxf #{ruby_version}.tar.gz
    cd #{ruby_version}
    ./configure
    make
    make install
  EOH
end

gem_package "bundler"