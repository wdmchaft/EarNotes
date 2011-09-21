//
//  StatsViewController.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/10/03.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "StatsViewController.h"
#import "SharedAppData.h"

@implementation StatsViewController

enum Sections {
    kGeneralSection = 0,
    kChordsSection,
    kNotesSection,
    kStrummingSection,
    NUM_SECTIONS
};

static NSInteger sectionRowsNumber[NUM_SECTIONS] = {
	5, 6, 6, 6
};

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Stats", @"");
	[self.tableView setRowHeight:50.0f];
	[self.tableView setSectionFooterHeight:0.0f];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return NUM_SECTIONS;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return sectionRowsNumber[section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == kGeneralSection) {
		return [NSString stringWithString:NSLocalizedString(@"General", @"")];
	} else if (section == kChordsSection) {
		return [NSString stringWithString:NSLocalizedString(@"Chords", @"")];
	} else if (section == kNotesSection) {
		return [NSString stringWithString:NSLocalizedString(@"Notes", @"")];
	} else {
		return [NSString stringWithString:NSLocalizedString(@"Strumming patterns", @"")];
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier10 = @"Cell10";
	static NSString *CellIdentifier20 = @"Cell20";
	static NSString *CellIdentifier30 = @"Cell30";
	static NSString *CellIdentifier40 = @"Cell40";
	static NSString *CellIdentifier50 = @"Cell50";
	
	static NSString *CellIdentifier11 = @"Cell11";
	static NSString *CellIdentifier21 = @"Cell21";
	static NSString *CellIdentifier31 = @"Cell31";
	static NSString *CellIdentifier41 = @"Cell41";
	static NSString *CellIdentifier51 = @"Cell51";
	static NSString *CellIdentifier61 = @"Cell62";
	
	static NSString *CellIdentifier12 = @"Cell12";
	static NSString *CellIdentifier22 = @"Cell22";
	static NSString *CellIdentifier32 = @"Cell32";
	static NSString *CellIdentifier42 = @"Cell42";
	static NSString *CellIdentifier52 = @"Cell52";
	static NSString *CellIdentifier62 = @"Cell62";
	
	static NSString *CellIdentifier13 = @"Cell13";
	static NSString *CellIdentifier23 = @"Cell23";
	static NSString *CellIdentifier33 = @"Cell33";
	static NSString *CellIdentifier43 = @"Cell43";
	static NSString *CellIdentifier53 = @"Cell53";
	static NSString *CellIdentifier63 = @"Cell63";
    
    UITableViewCell *cell = nil;
	
	UILabel *lblName = nil;
	UILabel *lblValue = nil;
	
	NumericStats *stats = [[[SharedAppData sharedInstance] currentUser] numericStats];
	
	if (indexPath.section == kGeneralSection) {
		if (indexPath.row == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier10];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier10] autorelease];
				
				cell.textLabel.textAlignment = UITextAlignmentLeft;
				cell.textLabel.textColor = [UIColor blackColor];
				cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
				cell.textLabel.highlightedTextColor = [UIColor blackColor];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
			}
			
			cell.textLabel.text = [NSString stringWithString:@"Tempo total:"];
			
			int hours, minutes, seconds;
			
			seconds = (int)[stats applicationOverallTimeSpent];
			hours =  seconds / (60 * 60);
			seconds -= hours * (60 * 60);
			minutes = seconds / 60;
			seconds -= minutes * 60;
			
			lblValue.text = [NSString stringWithFormat:@"%3d:%02d:%02d", hours, minutes, seconds];
			
			[cell.contentView addSubview:lblValue];
			
			[lblValue release];
		} else if (indexPath.row == 1) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier20];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier20] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 15];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"Tempo gasto no modo acompanhado:"];
			
			int hours, minutes, seconds;
			
			seconds = (int)[stats guideModeTimeSpent];
			hours =  seconds / (60 * 60);
			seconds -= hours * (60 * 60);
			minutes = seconds / 60;
			seconds -= minutes * 60;
			
			lblValue.text = [NSString stringWithFormat:@"%3d:%02d:%02d", hours, minutes, seconds];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		} else if (indexPath.row == 2) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier30];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier30] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 15];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"Tempo gasto no modo personalizado:"];
			
			int hours, minutes, seconds;
			
			seconds = (int)[stats customModeTimeSpent];
			hours =  seconds / (60 * 60);
			seconds -= hours * (60 * 60);
			minutes = seconds / 60;
			seconds -= minutes * 60;
			
			lblValue.text = [NSString stringWithFormat:@"%3d:%02d:%02d", hours, minutes, seconds];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		} else if (indexPath.row == 3) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier40];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier40] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 13];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}			
			
			lblName.text = [NSString stringWithString:@"# de questões respondidas no modo acompanhado:"];
			
			lblValue.text = [NSString stringWithFormat:@"%4d", [stats guideModeNumberOfQuestionsAnswered]];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		} else if (indexPath.row == 4) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier50];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier50] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 13];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"# de questões respondidas no modo acompanhado:"];
			
			lblValue.text = [NSString stringWithFormat:@"%4d", [stats customModeNumberOfQuestionsAnswered]];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		}
		
		
		// CHORDS SECTION
		
		
	} else if (indexPath.section == kChordsSection) {
		if (indexPath.row == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier11];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier11] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 13];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"Tempo gasto a praticar no modo acompanhado: "];
			
			int hours, minutes, seconds;
			
			seconds = (int)[stats chordsGuideModeTimeSpent];
			hours =  seconds / (60 * 60);
			seconds -= hours * (60 * 60);
			minutes = seconds / 60;
			seconds -= minutes * 60;
			
			lblValue.text = [NSString stringWithFormat:@"%3d:%02d:%02d", hours, minutes, seconds];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		} else if (indexPath.row == 1) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier21];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier21] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 13];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"# de respostas dadas no modo acompanhado:"];
			
			lblValue.text = [NSString stringWithFormat:@"%4d", [stats chordsGuideModeNumberOfQuestionsAnswered]];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		} else if (indexPath.row == 2) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier31];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier31] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 13];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"# de respostas certas no modo acompanhado:"];
			
			lblValue.text = [NSString stringWithFormat:@"%4d", [stats chordsGuideModeNumberOfRightAnswers]];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		} else if (indexPath.row == 3) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier41];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier41] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 13];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"# de respostas erradas no modo acompanhado:"];
			
			lblValue.text = [NSString stringWithFormat:@"%4d", [stats chordsGuideModeNumberOfWrongAnswers]];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		} else if (indexPath.row == 4) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier51];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier51] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 10];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"Recorde de # de respostas certas de seguida no modo acompanhado:"];
			
			lblValue.text = [NSString stringWithFormat:@"%4d", [stats chordsGuideModeNumberOfRightAnswersInRowRecord]];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		} else if (indexPath.row == 5) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier61];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier61] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 10];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"Recorde de # de respostas erradas de seguida no modo acompanhado:"];
			
			lblValue.text = [NSString stringWithFormat:@"%4d", [stats chordsGuideModeNumberOfWrongAnswersInRowRecord]];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		}
		
		
		// NOTES SECTION
		
		
	} else if (indexPath.section == kNotesSection) {
		if (indexPath.row == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier12];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier12] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 13];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"Tempo gasto a praticar no modo acompanhado: "];
			
			int hours, minutes, seconds;
			
			seconds = (int)[stats notesGuideModeTimeSpent];
			hours =  seconds / (60 * 60);
			seconds -= hours * (60 * 60);
			minutes = seconds / 60;
			seconds -= minutes * 60;
			
			lblValue.text = [NSString stringWithFormat:@"%3d:%02d:%02d", hours, minutes, seconds];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		} else if (indexPath.row == 1) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier22];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier22] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 13];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"# de respostas dadas no modo acompanhado:"];
			
			lblValue.text = [NSString stringWithFormat:@"%4d", [stats notesGuideModeNumberOfQuestionsAnswered]];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		} else if (indexPath.row == 2) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier32];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier32] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 13];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"# de respostas certas no modo acompanhado:"];
			
			lblValue.text = [NSString stringWithFormat:@"%4d", [stats notesGuideModeNumberOfRightAnswers]];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		} else if (indexPath.row == 3) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier42];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier42] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 13];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"# de respostas erradas no modo acompanhado:"];
			
			lblValue.text = [NSString stringWithFormat:@"%4d", [stats notesGuideModeNumberOfWrongAnswers]];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		} else if (indexPath.row == 4) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier52];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier52] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 10];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"Recorde de # de respostas certas de seguida no modo acompanhado:"];
			
			lblValue.text = [NSString stringWithFormat:@"%4d", [stats notesGuideModeNumberOfRightAnswersInRowRecord]];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		} else if (indexPath.row == 5) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier62];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier62] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 10];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"Recorde de # de respostas erradas de seguida no modo acompanhado:"];
			
			lblValue.text = [NSString stringWithFormat:@"%4d", [stats notesGuideModeNumberOfWrongAnswersInRowRecord]];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		}
		
		
		// STRUMMING SECTION
		
		
	} else if (indexPath.section == kStrummingSection) {
		if (indexPath.row == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier13];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier13] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 13];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"Tempo gasto a praticar no modo acompanhado: "];
			
			int hours, minutes, seconds;
			
			seconds = (int)[stats strummingGuideModeTimeSpent];
			hours =  seconds / (60 * 60);
			seconds -= hours * (60 * 60);
			minutes = seconds / 60;
			seconds -= minutes * 60;
			
			lblValue.text = [NSString stringWithFormat:@"%3d:%02d:%02d", hours, minutes, seconds];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		} else if (indexPath.row == 1) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier23];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier23] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 13];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"# de respostas dadas no modo acompanhado:"];
			
			lblValue.text = [NSString stringWithFormat:@"%4d", [stats strummingGuideModeNumberOfQuestionsAnswered]];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		} else if (indexPath.row == 2) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier33];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier33] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 13];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"# de respostas certas no modo acompanhado:"];
			
			lblValue.text = [NSString stringWithFormat:@"%4d", [stats strummingGuideModeNumberOfRightAnswers]];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		} else if (indexPath.row == 3) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier43];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier43] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 13];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"# de respostas erradas no modo acompanhado:"];
			
			lblValue.text = [NSString stringWithFormat:@"%4d", [stats strummingGuideModeNumberOfWrongAnswers]];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		} else if (indexPath.row == 4) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier53];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier53] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 10];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"Recorde de # de respostas certas de seguida no modo acompanhado:"];
			
			lblValue.text = [NSString stringWithFormat:@"%4d", [stats strummingGuideModeNumberOfRightAnswersInRowRecord]];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		} else if (indexPath.row == 5) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier63];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier63] autorelease];
				
				lblValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];  
				lblValue.font = [UIFont  boldSystemFontOfSize: 20];   
				lblValue.backgroundColor = [UIColor clearColor];  
				lblValue.textAlignment = UITextAlignmentRight;
				lblValue.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
				
				lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 180, 40)];  
				lblName.font = [UIFont  boldSystemFontOfSize: 10];   
				lblName.backgroundColor = [UIColor clearColor];  
				lblName.lineBreakMode = UILineBreakModeWordWrap; 
				lblName.numberOfLines = 0; 
				lblName.textAlignment = UITextAlignmentLeft;
			}
			
			lblName.text = [NSString stringWithString:@"Recorde de # de respostas erradas de seguida no modo acompanhado:"];
			
			lblValue.text = [NSString stringWithFormat:@"%4d", [stats strummingGuideModeNumberOfWrongAnswersInRowRecord]];
			
			[cell.contentView addSubview:lblName];
			[lblName release];
			
			[cell.contentView addSubview:lblValue];
			[lblValue release];
		}
	}
	
cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

