examples
exampleRotatingBouncingBalls
	| lines random balls velocities colors perspective rotation omega form offset morph process |
	lines := OrderedCollection new.
	lines add: (Array with: 0 _, 0 _, 0 with: 10 _, 0 _, 0).
	lines add: (Array with: 10 _, 0 _, 0 with: 10 _, 10 _, 0).
	lines add: (Array with: 10 _, 10 _, 0 with: 0 _, 10 _, 0).
	lines add: (Array with: 0 _, 10 _, 0 with: 0 _, 0 _, 0).
	lines add: (Array with: 0 _, 0 _, 0 with: 0 _, 0 _, 10).
	lines add: (Array with: 10 _, 0 _, 0 with: 10 _, 0 _, 10).
	lines add: (Array with: 10 _, 10 _, 0 with: 10 _, 10 _, 10).
	lines add: (Array with: 0 _, 10 _, 0 with: 0 _, 10 _, 10).
	lines add: (Array with: 0 _, 0 _, 10 with: 10 _, 0 _, 10).
	lines add: (Array with: 10 _, 0 _, 10 with: 10 _, 10 _, 10).
	lines add: (Array with: 10 _, 10 _, 10 with: 0 _, 10 _, 10).
	lines add: (Array with: 0 _, 10 _, 10 with: 0 _, 0 _, 10).
	random := Random new.
	balls := (1 to: 100) collect: [ :i | (random next _, random next _, random next) * 10.0 ].
	velocities := balls collect: [ :p | (random next _, random next _, random next) * 0.1 ].
	colors := balls collect: [ :p | Color random ].
	perspective := ((Jun3dTransformation perspective: 5_, 5_, 40) product: (Jun3dTransformation translate: -5_, -5_, 0))  product: (Jun3dTransformation scale:  2).
	rotation := Jun3dTransformation unity.
	omega := (((Jun3dTransformation translate: -5_, -5_, -5) product: (Jun3dTransformation rotateX: 1 asDegrees))  product: (Jun3dTransformation rotateY: 2 asDegrees)) product: (Jun3dTransformation translate: 5_, 5_, 5).
	form := Form extent: 400 @ 400 depth: 32.
	offset := form extent // 2.
	morph := form asMorph.
	morph borderColor: Color gray.
	morph borderWidth: 3.
	morph center: World center.
	morph openInWorld.
	process := [ 
	form getCanvas
		in: [ :canvas | 
			[ 
			| t ps inds |
			t := rotation product: perspective.
			rotation := rotation product: omega.
			canvas fillColor: Color white.
			lines
				do: [ :line | 
					canvas
						line: (line first transform: t) asPoint * 10 + offset
						to: (line last transform: t) asPoint * 10 + offset
						color: Color black ].
			ps := balls collect: [ :p | p transform: t ].
			inds := (1 to: ps size) asSortedCollection: [ :i1 :i2 | (ps at: i1) z <= (ps at: i2) z ].
			inds
				do: [ :i | 
					| p z |
					p := ps at: i.
					z := p z abs * 5.
					canvas fillOval: (p asPoint * 10 - z + offset extent: (z * 2) asPoint) color: (colors at: i).
					balls at: i put: (balls at: i) + (velocities at: i).
					((balls at: i) x between: 0 and: 10)
						ifFalse: [ velocities at: i put: (velocities at: i) * (-1 _, 1 _, 1) ].
					((balls at: i) y between: 0 and: 10)
						ifFalse: [ velocities at: i put: (velocities at: i) * (1 _, -1 _, 1) ].
					((balls at: i) z between: 0 and: 10)
						ifFalse: [ velocities at: i put: (velocities at: i) * (1 _, 1 _, -1) ] ].
			canvas flush.
			morph changed.
			10 milliSecond wait ] repeat ] ] forkAt: Processor userBackgroundPriority.
	morph
		on: #click
		send: #value
		to: [ 
			process terminate.
			morph delete ]