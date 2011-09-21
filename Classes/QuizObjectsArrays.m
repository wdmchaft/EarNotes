//
//  QuizObjectsArrays.m
//  iEarNotesTFC
//
//  Created by Tiago Bras on 10/08/22.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "QuizObjectsArrays.h"
#import "NSMutableArray+Random.h"

@implementation QuizObjectsArrays

@synthesize mastered, known, learning, unknown;

-(id)init {
	if (self = [super init]) {
		NSMutableArray *array1 = [[NSMutableArray alloc] init];
		NSMutableArray *array2 = [[NSMutableArray alloc] init];
		NSMutableArray *array3 = [[NSMutableArray alloc] init];
		NSMutableArray *array4 = [[NSMutableArray alloc] init];
		
		self.mastered = array1;
		self.known = array2;
		self.learning = array3;
		self.unknown = array4;
		
		[array1 release];
		[array2 release];
		[array3 release];
		[array4 release];
	}
	
	return self;
}

-(id)initWithCoder: (NSCoder *)coder {
	mastered = [[coder decodeObjectForKey: @"mastered"] retain];
	known = [[coder decodeObjectForKey: @"known"] retain];
	learning = [[coder decodeObjectForKey: @"learning"] retain];
	unknown = [[coder decodeObjectForKey: @"unknown"] retain];
	
	return self;
}

-(void)encodeWithCoder: (NSCoder *)coder {
	[coder encodeObject:mastered forKey:@"mastered"];
	[coder encodeObject:known forKey:@"known"];
	[coder encodeObject:learning forKey:@"learning"];	
	[coder encodeObject:unknown forKey:@"unknown"];
}

-(NSInteger)numberOfMasteredObjects {
	if (mastered != nil) {
		return [mastered count];
	} else {
		return 0;
	}
}

-(NSInteger)numberOfKnownObjects {
	if (known != nil) {
		return [known count];
	} else {
		return 0;
	}
}

-(NSInteger)numberOfLeaningObjects {
	if (learning != nil) {
		return [learning count];
	} else {
		return 0;
	}
}

-(NSInteger)numberOfUnknownObjects {
	if (unknown != nil) {
		return [unknown count];
	} else {
		return 0;
	}
}

-(void)upgradeObject: (id)object {
	for (int i = 0; i < [unknown count]; i++) {
		if ([[unknown objectAtIndex:i] isEqual:object]) {
			id obj = [object retain];
			
			[unknown removeObjectAtIndex:i];
			
			[learning enqueue:object];
			
			[obj release];
			
			return;		// since downgrade is done, exit method
		}
	}
	
	for (int i = 0; i < [learning count]; i++) {
		if ([[learning objectAtIndex:i] isEqual:object]) {
			id obj = [object retain];
			
			[learning removeObjectAtIndex:i];
			
			[known enqueue:object];
			
			[obj release];
			
			return;		// since downgrade is done, exit method
		}
	}
	
	for (int i = 0; i < [known count]; i++) {
		if ([[known objectAtIndex:i] isEqual:object]) {
			id obj = [object retain];
			
			[known removeObjectAtIndex:i];
			
			[mastered enqueue:object];
			
			[obj release];
			
			return;		// since downgrade is done, exit method
		}
	}
}

-(void)downgradeObject: (id)object {	
	for (int i = 0; i < [learning count]; i++) {
		if ([[learning objectAtIndex:i] isEqual:object]) {
			id obj = [object retain];
			
			[learning removeObjectAtIndex:i];
			
			[unknown enqueue:object];
			
			[obj release];
			
			return;		// since downgrade is done, exit method
		}
	}
	
	for (int i = 0; i < [known count]; i++) {
		if ([[known objectAtIndex:i] isEqual:object]) {
			id obj = [object retain];
			
			[known removeObjectAtIndex:i];
			
			[learning enqueue:object];
			
			[obj release];
			
			return;		// since downgrade is done, exit method
		}
	}
	
	for (int i = 0; i < [mastered count]; i++) {
		if ([[mastered objectAtIndex:i] isEqual:object]) {
			id obj = [object retain];
			
			[mastered removeObjectAtIndex:i];
			
			[known enqueue:object];
			
			[obj release];
			
			return;		// since downgrade is done, exit method
		}
	}
}

-(ArrayName)getObjectArrayName: (id)object {
	if ([self isFromMasteredArray: object]) {
		return ArrayNameMastered;
	} else if ([self isFromKnownArray: object]) {
		return ArrayNameKnown;
	} else if ([self isFromLearningArray: object]) {
		return ArrayNameLearning;
	} else if ([self isFromUnknownArray: object]) {
		return ArrayNameUnknown;
	}
	
	return ArrayNameInvalid;
}

-(BOOL)isFromMasteredArray: (id)object {
	for (id obj in mastered) {
		if ([obj isEqual:object]) {
			return YES;
		}
	}
	
	return NO;
}

-(BOOL)isFromKnownArray: (id)object {
	for (id obj in known) {
		if ([obj isEqual:object]) {
			return YES;
		}
	}
	
	return NO;
}

-(BOOL)isFromLearningArray: (id)object {
	for (id obj in learning) {
		if ([obj isEqual:object]) {
			return YES;
		}
	}
	
	return NO;
}

-(BOOL)isFromUnknownArray: (id)object {
	for (id obj in unknown) {
		if ([obj isEqual:object]) {
			return YES;
		}
	}
	
	return NO;
}

-(void)dealloc {
	[mastered release];
	[known release];
	[learning release];
	[unknown release];
	[super dealloc];
}

@end
