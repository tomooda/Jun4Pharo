baseline
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec
				project: 'UFFIOpenGL'
				with: [ spec
						baseline: 'UFFIOpenGL';
						repository: 'github://ronsaldo/uffi-opengl/tonel' ].
			spec
				package: 'Jun-Geometry';
				package: 'Jun-Graphics' with: [ spec requires: #('Jun-Geometry') ];
				package: 'Jun-System' with: [ spec requires: #('Jun-Geometry' 'Jun-Graphics') ];
				package: 'Jun-Tests' with: [ spec requires: #('Jun-Geometry' 'Jun-Graphics') ];
				package: 'Jun-Chemistry' with: [ spec requires: #('Jun-Geometry' 'Jun-Graphics') ];
				package: 'Jun-Chemistry-Babel' with: [ spec requires: #(#'Jun-Chemistry' 'OSProcess') ];
				package: 'Jun-UFFIOpenGL' with: [ spec requires: #('UFFIOpenGL') ];
				package: 'Jun-GT' with: [ spec requires: #('Jun-Graphics') ].
			spec
				group: 'Core' with: #('Jun-System' 'Jun-UFFIOpenGL' 'Minimal');
				group: 'Minimal' with: #('Jun-Geometry' 'Jun-Graphics');
				group: 'default' with: #('Jun-Tests' 'Core' 'Chemistry');
				group: 'Chemistry' with: #(#'Jun-Chemistry' 'Core');
				group: 'Chemistry-Full' with: #('Chemistry' 'Jun-Chemistry-Babel') ]