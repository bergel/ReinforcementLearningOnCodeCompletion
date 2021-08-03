Class {
	#name : #RLCCTest,
	#superclass : #TestCase,
	#category : #ReinforcementLearningOnCodeCompletion
}

{ #category : #tests }
RLCCTest >> testSimple01 [

	| contexts rl |
	contexts := { #(#a #b) . #(#a #c d) . #(#d #b) }.
	rl := RLCC new.
	rl groundContexts: contexts.
	rl actionMessages: #(#a #b #c #d).
	rl run.
	
]
