//
//  CustomModeViewController.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/10/08.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "CustomModeViewController.h"
#import "CMQuizViewController.h"
#import "CustomQuizCreator.h"
#import "SharedAppData.h"
#import "QuizChord.h"
#import "QuizNote.h"
#import "QuizStrum.h"

@implementation CustomModeViewController

@synthesize objects;

#pragma mark -
#pragma mark View lifecycle

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andQuizObjectType:(NSInteger)aQuizObjectType {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		quizObjectType = aQuizObjectType;
		
		isObjectSelected = NULL;
		
		if (quizObjectType == 0) {
			self.objects = [QuizChord loadDefaultChords];
			isObjectSelected = malloc(sizeof(BOOL) * [self.objects count]);
		} else if (quizObjectType == 1) {
			self.objects = [QuizNote loadDefaultNotes];
			isObjectSelected = malloc(sizeof(BOOL) * [self.objects count]);
		} else {
			self.objects = [QuizStrum loadDefaultStrummingPatterns];
			isObjectSelected = malloc(sizeof(BOOL) * [self.objects count]);
		}
		
		if (isObjectSelected) {
			for (int i = 0; i < [self.objects count]; i++) {
				isObjectSelected[i] = NO;
			}
		}
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	if (quizObjectType == 0) {
		self.title = NSLocalizedString(@"Chords", @"");
	} else if (quizObjectType == 1) {
		self.title = NSLocalizedString(@"Notes", @"");
	} else {
		self.title = @"Padrões de dedilhado";
	}
	
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
	
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0) {
		return [objects count];
	} else {
		return 1;
	}
	
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	static NSString *CellIdentifierCreate = @"CellCreate";
    
    UITableViewCell *cell = nil;
	
	if (indexPath.section == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			
			cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
			cell.textLabel.highlightedTextColor = [UIColor blackColor];
		}
		
		cell.textLabel.textAlignment = UITextAlignmentLeft;
		cell.textLabel.text = [[objects objectAtIndex:indexPath.row] objectId];
		
		if (isObjectSelected) {
			if (isObjectSelected[indexPath.row]) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
		}
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierCreate];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.textLabel.textColor = [UIColor blackColor];
			cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
			cell.textLabel.highlightedTextColor = [UIColor blackColor];
		}
		
		cell.textLabel.text = @"Começar Quiz!";
	}
	
	
	
	/*
	 cell.textLabel.textAlignment = UITextAlignmentLeft;
	 User *currentUser = [[SharedAppData sharedInstance] currentUser];
	 
	 if (currentUser != nil) {
	 if ([[[SharedAppData sharedInstance] currentUser] guitarType] == indexPath.row) {
	 cell.accessoryType = UITableViewCellAccessoryCheckmark;
	 cell.textLabel.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
	 }
	 else {
	 cell.accessoryType = UITableViewCellAccessoryNone;
	 cell.textLabel.textColor = [UIColor blackColor];
	 }
	 }
	 
	 cell.textLabel.text = [User guitarTypeToString: indexPath.row];
	 */
	
    
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
		*detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 0) {
		if (isObjectSelected) {
			isObjectSelected[indexPath.row] = !isObjectSelected[indexPath.row];
		}
	} else if (indexPath.section == 1 && indexPath.row == 0) {
		NSMutableArray *array = [NSMutableArray array];
		
		for (int i = 0; i < [objects count]; i++) {
			if (isObjectSelected[i]) {
				[array addObject:[objects objectAtIndex:i]];
			}
		}
		
		if ([array count] >= 2) {
			
			CustomQuizCreator *quizCreator = [[CustomQuizCreator alloc] initWithArray:array];
			
			UIViewController *viewController = [[CMQuizViewController alloc] initWithNibName:@"CMQuizViewController"
																					  bundle:nil 
																		andCustomQuizCreator:quizCreator];
			[quizCreator release];
			
			[self.navigationController pushViewController:viewController animated:YES];
			
			[viewController release];
		} else {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alerta" 
																message:@"O número mínimo de objectos escolhidos é 2." 
															   delegate:self 
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
			[alertView show];
			
			[alertView release];
		}
	}
	
	[self.tableView reloadData];
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
	[objects release];
	
	if (isObjectSelected) {
		free(isObjectSelected);
	}
	
    [super dealloc];
}


@end

