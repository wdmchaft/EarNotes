//
//  SharedAppData.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/08/28.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "SharedAppData.h"

static SharedAppData *sharedAppData = nil;

@implementation SharedAppData

@synthesize dataFilePath, users;

-(id)init {
	if (self = [super init]) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		
		self.users = array;
		
		[array release];
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *path = [documentsDirectory stringByAppendingPathComponent:@"appData.dat"];
		[self setDataFilePath:path];
	}
	
	return self;
}

+(SharedAppData *)sharedInstance {
	if (sharedAppData == nil) {
		sharedAppData = [[super alloc] init];
	}
	
	return sharedAppData;
}

-(NSInteger)currentUserIndex {
	return currentUserIndex;
}

-(void)setCurrentUserIndex: (NSInteger)userIndex {
	if (userIndex < 0 || userIndex >= [self numOfUsers]) {
		currentUserIndex = userIndex;
	} 
}

-(NSInteger)numOfUsers {
	return [self.users count];
}

-(void)addUser: (User *)aUser {
	if (self.users != nil) {
		[self.users addObject:aUser];
		
		// O novo utilizador passa a ser o utilizador actual
		currentUserIndex = [self.users count] - 1;
	}
}

-(void)removeCurrentUser {
	if (currentUserIndex < [self.users count]) {
		[users removeObjectAtIndex:currentUserIndex];
		// TODO: garantir ke nao apaga quando ha apenas 1 user, ou entao criar um
		currentUserIndex = 0;
	}
}

// TODO: Criar um user default se nao houver current user. Ter em atençao o inicio do programa
-(User *)currentUser {
	if (currentUserIndex >= [self.users count]) {
		return nil;
	}
	
	return [self.users objectAtIndex:currentUserIndex];
}

-(User *)userAtIndex: (NSInteger)userIndex {
	if (userIndex >= [self.users count]) {
		return nil;
	}
	
	return [self.users objectAtIndex:userIndex];
}

-(BOOL)isIndexCurrentUser: (NSInteger)index {
	if (self.currentUserIndex >= [self.users count]) {
		return FALSE;
	}
	
	if (index == self.currentUserIndex) {
		return TRUE;
	} else {
		return FALSE;
	}

}

- (void)saveData {
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	if (self != nil) {
		theData = [NSMutableData data];
		encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
		
		[encoder encodeObject:self.users forKey:@"users"];
		[encoder encodeInt:self.currentUserIndex forKey:@"currentUserIndex"];
		[encoder finishEncoding];
		
		[theData writeToFile:dataFilePath atomically:YES];
		[encoder release];
	}
}

- (void)loadData {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if([fileManager fileExistsAtPath:dataFilePath]) {
		NSLog(@"Data file found. Reading into memory.");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		

			theData = [NSData dataWithContentsOfFile:dataFilePath];
			decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
			users = [[decoder decodeObjectForKey:@"users"] retain];
			currentUserIndex = [decoder decodeIntForKey:@"currentUserIndex"];
			
			[decoder finishDecoding];
			[decoder release];
			
			for (User *u in users) {
				NSLog(@"User loaded. Username = %@, Password = %@", u.username, u.password);
			}

			//NSLog(@"No data file found. Creating empty array.");
		

	}
	else {
		NSLog(@"No data file found. Creating empty array.");
		
		//TODO: default
		if ([[SharedAppData sharedInstance] numOfUsers] < 1) {
			[self addUser:[User createDefaultUser]];
		}		
	}
	
}

-(void)deleteData {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:self.dataFilePath error:NULL];
}

-(id)retain {
	return self;
}

-(void)release {
	// Do nothing
}

-(id)autorelease {
	return self;
}

@end
