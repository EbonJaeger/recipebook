config_data = configuration_data()
config_data.set('install_prefix', get_option('prefix'))
config_data.set('exec_name', meson.project_name())

desktop = configure_file(
    input: meson.project_name() + '.desktop.in',
    output: meson.project_name() + '.desktop',
    configuration: config_data,
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications'),
)

install_data(
    join_paths(meson.current_source_dir(), 'icons', 'scalable', 'com.github.EbonJaeger.recipebook.svg'),
    install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', 'scalable', 'apps')
)
