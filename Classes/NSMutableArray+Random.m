//
//  NSMutableArray+Random.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/08/30.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "NSMutableArray+Random.h"


@implementation NSMutableArray (Random)

-(void)enqueue: (id)anObject {
	if (self != nil) {
		[self addObject:anObject];
	}
}

-(id)dequeue {
	id object = nil;
	
	if ([self count] > 0) {
		object = [[[self objectAtIndex:0] retain] autorelease];
		[self removeObjectAtIndex:0];
	}
	
	return object;
}

-(id)objectAtRandomIndex {
	id object = nil;
	
	if ([self count] > 0) {
		object =  [self objectAtIndex:arc4random() % [self count]];
	}
	
	return object;
}

-(void)insertObjectAtRandomIndex: (id)anObject {
	if ([self count] > 0) {
		[self insertObject:anObject atIndex:arc4random() % [self count]];
	}
}

-(id)removeObjectAtRandomIndex {
	id object = nil;
	uint32_t randNumber = arc4random() % [self count];
	
	if ([self count] > 0) {
		object = [[[self objectAtIndex:randNumber] retain] autorelease];
		[self removeObjectAtIndex:randNumber];
	}
	
	return object;
}

-(void)shuffle
{
    NSUInteger count = [self count];
	
	// Não baralhar se houver menos de 2 elementos
	if (count < 2) {
		return;
	}
	
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

-(BOOL)containsAnyObject: (NSMutableArray *)array {
	for (id obj in array) {
		if ([self containsObject:obj]) {
			return TRUE;
		}
	}
	
	return FALSE;
}

-(id)randomObjectExceptAnyObjectFrom: (NSMutableArray *)array {
	if (self == nil) {
		return nil;
	}
	// Nao devolver nenhum objecto se nao houver nenhum
	if ([self count] <= 0) {
		return nil;
	}
	
	if (array == nil) {
		return [self objectAtRandomIndex];
	}
	
	NSMutableArray *tmp = [[NSMutableArray alloc] init];
	
	// Nao devolver nenhum object se já conter todos os objectos de array
	for (id obj in self) {
		// Adicionar os objectos não tem
		if ([array containsObject:obj] == FALSE) {
			[tmp addObject:obj];
		}
	}

	// Se ja tiver todos os objectos devolve nil
	if ([tmp count] <= 0) {
		[tmp release];
		
		return nil;
	}
	
	// Escolher um objecto aleatorio
	id randomObj = [tmp objectAtRandomIndex];
	
	[tmp release];
	
	return randomObj;
}

-(id)randomObjectExceptObject: (id)object {
	if (self == nil) {
		return nil;
	}
	// Nao devolver nenhum objecto se nao houver nenhum
	if ([self count] <= 0) {
		return nil;
	}
	
	if (object == nil) {
		return [self objectAtRandomIndex];
	}
	
	NSMutableArray *tmp = [[NSMutableArray alloc] init];
	
	for (id obj in self) {
		// Adicionar os objectos que não são iguais a object
		if ([object isEqual:obj] == FALSE) {
			[tmp addObject:obj];
		}
	}
	
	// Se não houver objectos devolve nil
	if ([tmp count] <= 0) {
		[tmp release];
		
		return nil;
	}
	
	// Escolher um objecto aleatorio
	id randomObj = [tmp objectAtRandomIndex];
	
	[tmp release];
	
	return randomObj;
}

-(void)dealloc {
	[super dealloc];
}

@end
