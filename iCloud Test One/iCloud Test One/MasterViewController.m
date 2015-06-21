//
//  MasterViewController.m
//  iCloud Test One
//
//  Created by Lucien Dupont on 6/21/15.
//  Copyright © 2015 Lucien Dupont. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import <CloudKit/CloudKit.h>


@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.navigationItem.leftBarButtonItem = self.editButtonItem;

	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
	self.navigationItem.rightBarButtonItem = addButton;
	self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewWillAppear:(BOOL)animated {
	self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
	if (!self.objects) {
	    self.objects = [[NSMutableArray alloc] init];
	}
	
	NSDate *dateToSave = [NSDate date];
	
	[self.objects insertObject:dateToSave atIndex:0];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	
	
	[self saveRecordToCloudKit:dateToSave];
}


- (void) saveRecordToCloudKit: (NSDate *) inDateToSave
{
	// let's save the date we just created to the public database
	
	
	// first create the record to save
	
		// creating a UUID string as our unique record ID
	NSString *uuid = [[NSUUID UUID] UUIDString];
	CKRecordID *dateRecordID = [[CKRecordID alloc] initWithRecordName:uuid];
	
	
		// create the record to save
	CKRecord *timeEntryRecord = [[CKRecord alloc] initWithRecordType:@"TimeEntries" recordID:dateRecordID];
	timeEntryRecord[@"date"] = inDateToSave;
	timeEntryRecord[@"userName"] = @"Lucien";
	
	
	// second get access to the public database
	CKContainer *myContainer = [CKContainer defaultContainer];
	CKDatabase *publicDatabase = [myContainer publicCloudDatabase];
	
	
	// third save the record to the cloud
	[publicDatabase saveRecord:timeEntryRecord completionHandler:^(CKRecord * __nullable record, NSError * __nullable error) {
		
		if (!error) {
			NSLog(@"Saved record: %@", record);
		}
		else
		{
			NSLog(@"Got an error: %@", error);
		}
	}];
	
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:@"showDetail"]) {
	    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	    NSDate *object = self.objects[indexPath.row];
	    DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
	    [controller setDetailItem:object];
	    controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
	    controller.navigationItem.leftItemsSupplementBackButton = YES;
	}
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

	NSDate *object = self.objects[indexPath.row];
	cell.textLabel.text = [object description];
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
	    [self.objects removeObjectAtIndex:indexPath.row];
	    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	} else if (editingStyle == UITableViewCellEditingStyleInsert) {
	    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
	}
}

@end
