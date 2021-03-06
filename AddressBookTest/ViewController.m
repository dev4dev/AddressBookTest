//
//  ViewController.m
//  AddressBookTest
//
//  Created by Alex Antonyuk on 11/3/14.
//  Copyright (c) 2014 Alex Antonyuk. All rights reserved.
//

#import "ViewController.h"
#import "AddressBook.h"
#import "Helpers.h"

@import AddressBookUI;

@interface ViewController ()
	<ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, strong) AddressBook *addressBook;

@property (nonatomic, weak) IBOutlet UILabel *status;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	self.addressBook = [AddressBook new];
    
	[self updateAccessStatusLabel];
}

- (void)
updateAccessStatusLabel
{
	self.status.text = [self.addressBook isAccessGranted] ? @"Granted" : @"Nope";
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)requestAccess:(id)sender
{
	if (![self.addressBook canRequestAccess]) {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
																	   message:@"You cant request access\nCheck your phone settings"
																preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

		}]];
		[self presentViewController:alert animated:YES completion:nil];
		return;
	}

	[self.addressBook requestAccess:^(bool granted, CFErrorRef error) {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Ok" preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[self updateAccessStatusLabel];
		}]];
		[self presentViewController:alert animated:YES completion:nil];
	}];
}

- (IBAction)getAllGroups:(id)sender
{
	NSArray *groups = [self.addressBook allGroups];

	NSLog(@"Groups %@", groups);
}

- (IBAction)getVCardForContactsFromFirstGroup:(id)sender
{
	NSArray *groups = [self.addressBook allGroups];

	if (groups.count > 0) {
		NSString *group = [groups firstObject];
		NSString *vCard = dataToString([self.addressBook vCardForAllContactsInGroupWithName:group]);

		NSLog(@"%@", vCard);
	}
}

- (IBAction)getVCardForAllContacts:(id)sender
{
	NSString *vCard = dataToString([self.addressBook vCardForAllContacts]);

	NSLog(@"%@", vCard);
}

- (IBAction)pickPersonForVCard:(id)sender
{
	ABPeoplePickerNavigationController *vc = [ABPeoplePickerNavigationController new];
	vc.peoplePickerDelegate = self;
	[self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)getVCardForContactsUpdatedHourAgo:(id)sender
{
	NSArray *contacts = [self.addressBook contactsModifiedAfter:[NSDate dateWithTimeIntervalSinceNow:-3600]];
	NSString *vCard = dataToString([self.addressBook vCardForContactsInArray:contacts]);
	
	NSLog(@"%@", vCard);
}

- (void)
peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
	NSString *vCard = dataToString([self.addressBook vCardForContactRecord:person]);

	NSLog(@"%@", vCard);
}

@end
