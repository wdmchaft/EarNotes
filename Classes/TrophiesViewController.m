//
//  TrophiesViewController.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/09/24.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "TrophiesViewController.h"
#import "SharedAppData.h"

@implementation TrophiesViewController

@synthesize trophies;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.title = NSLocalizedString(@"Trophies", @"");
	[self.tableView setRowHeight:50.0f];
	[self.tableView setSectionFooterHeight:0.0f];
	self.trophies = [[[SharedAppData sharedInstance] currentUser] trophies];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return [NSString stringWithString:NSLocalizedString(@"General", @"")];
	} else if (section == 11) {
		return [NSString stringWithString:NSLocalizedString(@"Chords", @"")];
	} else if (section == 37) {
		return [NSString stringWithString:NSLocalizedString(@"Notes", @"")];
	} else if (section == 63) {
		return [NSString stringWithString:NSLocalizedString(@"Strumming patterns", @"")];
	}
	
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [trophies count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
	
	cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%d", indexPath.section]];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"Cell%d", indexPath.section]] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		
		cell.textLabel.textAlignment = UITextAlignmentLeft;
		cell.textLabel.textColor = [UIColor blackColor];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
		cell.textLabel.highlightedTextColor = [UIColor blackColor];
		
		UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 20)];  
		lblName.font = [UIFont  boldSystemFontOfSize: 16];   
		lblName.backgroundColor = [UIColor clearColor];  
		lblName.text = [[trophies objectAtIndex:indexPath.section] name];  
		[cell.contentView addSubview:lblName];
		[lblName release];
		
		UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(50, 3,180,60)];  
		lblDesc.font = [UIFont  systemFontOfSize: 12];  
		lblDesc.lineBreakMode = UILineBreakModeWordWrap; 
		lblDesc.textColor = [UIColor grayColor];
		lblDesc.numberOfLines = 0;  
		lblDesc.backgroundColor = [UIColor clearColor];  
		lblDesc.text = [[trophies objectAtIndex:indexPath.section] description];  
		[cell.contentView addSubview:lblDesc];
		[lblDesc release];
		
		UILabel *lblPoints = [[UILabel alloc] initWithFrame:CGRectMake(230, 15, 80, 20)];  
		lblPoints.font = [UIFont  boldSystemFontOfSize: 20];   
		lblPoints.backgroundColor = [UIColor clearColor];  
		lblPoints.textAlignment = UITextAlignmentLeft;
		lblPoints.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
		lblPoints.text = [NSString stringWithFormat:@"%2d pts", [[trophies objectAtIndex:indexPath.section] points]];  
		[cell.contentView addSubview:lblPoints];
		[lblPoints release];
		
		cell.imageView.image = [UIImage imageNamed:@"trophyImage.png"];
	}
	
	if (indexPath.section == 3) {
		
	}
	
	// Modificar a opacidade dos troféus que o utilizador nao tem
	if (![[trophies objectAtIndex:indexPath.section] ownsTrophy]) {
		[cell.contentView setAlpha:0.65f];
		
		cell.imageView.alpha = 0.2;
		// TODO: Talvez por a vermelho/verde/azul claro
	}

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
	[trophies release];
    [super dealloc];
}


@end

