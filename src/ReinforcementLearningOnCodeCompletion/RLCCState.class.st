Class {
	#name : #RLCCState,
	#superclass : #Object,
	#instVars : [
		'methods'
	],
	#category : #ReinforcementLearningOnCodeCompletion
}

{ #category : #'as yet unclassified' }
RLCCState >> = anotherState [
	anotherState class == self class ifFalse: [ ^ false ].
	^ methods = anotherState methods
]

{ #category : #'as yet unclassified' }
RLCCState >> hash [
	^ methods hash
]

{ #category : #initialization }
RLCCState >> initialize [
	super initialize.
	methods := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
RLCCState >> printOn: str [
	str nextPutAll: 'S<'.
	str nextPutAll: self hash asString.
	str nextPutAll: '>'.	
]
