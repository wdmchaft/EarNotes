//
//  NSMutableArray+Random.h
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/08/30.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (Random)

-(void)enqueue: (id)anObject;
-(id)dequeue;
-(id)objectAtRandomIndex;
-(void)insertObjectAtRandomIndex: (id)anObject;
-(id)removeObjectAtRandomIndex;
-(void)shuffle;
-(BOOL)containsAnyObject: (NSMutableArray *)array;
-(id)randomObjectExceptAnyObjectFrom: (NSMutableArray *)array;
-(id)randomObjectExceptObject: (id)object;

@end
