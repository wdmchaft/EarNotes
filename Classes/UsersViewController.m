//
//  UsersViewController.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/09/23.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "UsersViewController.h"
#import "SharedAppData.h"
#import "User.h"
#import "NewUserViewController.h"
#import "LoginViewController.h"
#import "CustomAlertView.h"

@implementation UsersViewController



enum Sections {
	kAccountsSection = 0,
	NUM_SECTIONS
};

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Utilizadores";
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self.tableView reloadData];
}

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
	if (section == kAccountsSection) {
		return NSLocalizedString(@"Choose or create a new account", @"");
	}
	
	// FIXME: Pode causar erro
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if (section == kAccountsSection) {
		if ([[SharedAppData sharedInstance] numOfUsers] == MAX_USERS) {
			return @"Número máximo de contras atingido.";
		}
	}
	
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return NUM_SECTIONS;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[SharedAppData sharedInstance] numOfUsers] + 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;

    if (indexPath.section == kAccountsSection) {		
		if (indexPath.row == [[SharedAppData sharedInstance] numOfUsers]) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
				cell.textLabel.textAlignment = UITextAlignmentLeft;
				cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			}
			
			cell.textLabel.text = NSLocalizedString(@"New Account", @"");
			
			if ([[SharedAppData sharedInstance] numOfUsers] == MAX_USERS) {
				[cell.contentView setAlpha:0.5f];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
		} else {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
				cell.textLabel.textAlignment = UITextAlignmentLeft;
				cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
				
				if (![[SharedAppData sharedInstance] isIndexCurrentUser:indexPath.row]) {
					UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(160,6,110,30)];
					rightLabel.text = @"Login";
					rightLabel.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
					rightLabel.textAlignment = UITextAlignmentRight;
					rightLabel.font = [UIFont systemFontOfSize:14];
					[cell.contentView addSubview:rightLabel];
					[rightLabel release];

					
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				} else {
					cell.accessoryType = UITableViewCellAccessoryCheckmark;
				}	
			}
			
			cell.textLabel.text = [[[SharedAppData sharedInstance] userAtIndex:indexPath.row] username];
		}
		
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

	if (indexPath.section == kAccountsSection) {
		if (indexPath.row == [[SharedAppData sharedInstance] numOfUsers]) {
			// Apenas se ainda houver slots pra mais users
			if ([[SharedAppData sharedInstance] numOfUsers] < MAX_USERS) {
				UIViewController *viewController = [[NewUserViewController alloc] initWithNibName:@"NewUserViewController" bundle:nil];
				
				[self.navigationController pushViewController:viewController animated:YES];
				
				[viewController release];
			}
		} else {
			if (![[SharedAppData sharedInstance] isIndexCurrentUser:indexPath.row]) {
				UIViewController *viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
				
				[self.navigationController pushViewController:viewController animated:YES];
				
				[viewController release];
			}
		}
	}
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)showCustomAlert
{
	NSString* s =[NSString stringWithFormat:@"Bem-vindo %@", [[[SharedAppData sharedInstance] currentUser] username]];
	NSLog(@"%@", s);
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:s];
    alert.delegate = self;
    [alert show];
    [alert release];
}
- (void) CustomAlertView:(CustomAlertView *)alert wasDismissedWithValue:(NSString *)value
{
    NSLog(@"%@", [NSString stringWithFormat:@"'%@' was entered", value]);
	
	// TODO: Qdo o utilizador carrega num utilizador ja existente...guardar o index para depois 
	// comparar as palavras passes
	/*
	if ([[[SharedAppData sharedInstance] currentUser] isPasswordCorrect:value]) {
		UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Autenticação realizada com sucesso!" 
														   message:nil
														  delegate:self 
												 cancelButtonTitle:@"OK" 
												 otherButtonTitles:nil];
		[newAlert show];
		[newAlert release];
	}
	 */
}
- (void) customAlertViewWasCancelled:(CustomAlertView *)alert
{
	NSLog(@"%@", NSLocalizedString(@"User cancelled alert", @"User cancelled alert"));
    //feedbackLabel.text = NSLocalizedString(@"User cancelled alert", @"User cancelled alert");
	
	UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Alerta" 
													   message:@"Não pode aceder a nenhuma funcionalidade, além do menu de utilizadores, se não estiver autenticado.\rDeseja se autenticar?" 
													  delegate:self 
											 cancelButtonTitle:NSLocalizedString(@"Cancel", @"") 
											 otherButtonTitles:@"Sim", nil];
	[newAlert setTag:1000];
	[newAlert show];
	[newAlert release];
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

