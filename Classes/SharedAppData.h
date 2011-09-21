//
//  SharedAppData.h
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/08/28.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

#define MAX_USERS (3)

@interface SharedAppData : NSObject {
	NSMutableArray *users;
	NSInteger currentUserIndex;
	NSString *dataFilePath;
	NSDate *date;
}

@property(copy) NSString *dataFilePath;
@property(retain) NSMutableArray *users;


+(SharedAppData *)sharedInstance;

-(NSInteger)numOfUsers;

-(NSInteger)currentUserIndex;
-(void)setCurrentUserIndex: (NSInteger)userIndex;

-(User *)currentUser;
-(User *)userAtIndex: (NSInteger)userIndex;

-(void)addUser: (User *)aUser;
-(void)removeCurrentUser;

-(BOOL)isIndexCurrentUser: (NSInteger)index;
-(void)saveData;
-(void)loadData;
-(void)deleteData;

@end
