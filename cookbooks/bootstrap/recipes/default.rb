# load chef-base service
# it loads redis and xmldump

service 'hab-sup' do
    reload_command 'systemctl daemon-reload'
    subscribes :reload, 'template[/etc/systemd/system/hab-sup.service]', :delayed
    subscribes :restart, 'template[/etc/systemd/system/hab-sup.service]', :delayed
end

template '/etc/systemd/system/hab-sup.service' do
    mode '0644'
    source 'hab-sup.service.erb'
    hab_sup_opts = ["--topology leader --group dev --strategy rolling"]
    if node["peers"]
        hab_sup_opts.push(node["peers"].map {|p| "--peer #{p}"})
    end
    variables hab_sup_opts: hab_sup_opts.join(' ')
end

