project('sound', 'vala', 'c')

dependencies = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gtk+-3.0'),
  dependency('libcanberra'),
  meson.get_compiler('c').find_library('m', required: false)
  ]

sources = files('main.vala', 
  'sound.vala'
  )

system = build_machine.system()

if system == 'windows'
  add_global_arguments('-D_WIN32', language: 'c')
  executable('theia', sources, 
	link_args: ['-mwindows'], 
	dependencies: dependencies, 
	gui_app: true)
else
  executable('sound', sources, dependencies: dependencies)
endif


