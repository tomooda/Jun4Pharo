tests
testRounded
	"round of all components"

	| x y |
	x := 1.1.
	y := -2.1.
	self assert: (x _, y) rounded equals: x rounded _, y rounded