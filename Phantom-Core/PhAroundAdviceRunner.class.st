Class {
	#name : #PhAroundAdviceRunner,
	#superclass : #PhAdviceRunner,
	#category : 'Phantom-Core'
}

{ #category : #'as yet unclassified' }
PhAroundAdviceRunner >> changeAdvice: anAdviceCollection continueAt:  anIndex [
	super changeAdvice: anAdviceCollection continueAt: anIndex.
	self adviceGroup aroundAdvice: anAdviceCollection.
]

{ #category : #'as yet unclassified' }
PhAroundAdviceRunner >> runAdvice [
	| needToRunOriginalMethod |
	needToRunOriginalMethod := true.
	self advice notEmpty
		ifTrue: [ 
			[ self index <= self advice size ]
				whileTrue: [ 
					| currentAdvice context |
					currentAdvice := self advice at: self index.
					self addMembranesOf: currentAdvice.
					context := self buildContextFor: currentAdvice.
					"self halt."
					(currentAdvice pointcut 
						isActiveOnContext: context 
						receiver: (self adviceGroup wrapper wrappedClass) 
						selector: self selector)
						ifTrue: [
							needToRunOriginalMethod := false.
							^ currentAdvice runWithin: context].
					self index: self index + 1].
				needToRunOriginalMethod ifTrue: [ ^ self adviceGroup oldMethod valueWithReceiver: self receiver arguments: self arguments] ]
		ifFalse: [
			self addMembranes. 
			^ self adviceGroup oldMethod valueWithReceiver: self receiver arguments: self arguments ].
]

{ #category : #'as yet unclassified' }
PhAroundAdviceRunner >> type [
	^#around
]
