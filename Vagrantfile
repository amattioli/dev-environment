Vagrant.configure(2) do |config|
  config.vm.box = "hashicorp/precise32"
  config.berkshelf.enabled = true

  config.vm.define "svn_repository" do |svn_repository|
    svn_repository.vm.network "public_network", ip: "192.168.0.50"

    svn_repository.vm.provision "chef_solo" do |chef|
      chef.add_recipe "svn_server"
    end
  end
  
  config.vm.define "app_server" do |app_server|
    app_server.vm.network "public_network", ip: "192.168.0.51"

    app_server.vm.provision "chef_solo" do |chef|
      chef.add_recipe "tomcat_server"
    end
  end

  config.vm.define "artifacts_repository" do |artifacts_repository|
    artifacts_repository.vm.network "public_network", ip: "192.168.0.52"

    artifacts_repository.vm.provision "chef_solo" do |chef|
      chef.add_recipe "artifactory_server"
    end
  end

  config.vm.define "jenkins_server" do |jenkins_server|
    jenkins_server.vm.network "public_network", ip: "192.168.0.53"

    jenkins_server.vm.provision "chef_solo" do |chef|
      chef.add_recipe "jenkins_server"
    end
  end

end
