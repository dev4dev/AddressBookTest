//
//  AddressBook.m
//  AddressBookTest
//
//  Created by Alex Antonyuk on 11/3/14.
//  Copyright (c) 2014 Alex Antonyuk. All rights reserved.
//

#import "AddressBook.h"
#import "vCardSerialization.h"

@interface AddressBook ()

@property (nonatomic, assign) ABAddressBookRef addressBook;

- (NSArray *)allContacts;
- (ABRecordRef)groupWithName:(NSString *)groupName;

@end

@implementation AddressBook

#pragma mark - Init & Dealloc

- (instancetype)
init
{
	if (self = [super init]) {
		_addressBook = ABAddressBookCreateWithOptions(NULL, nil);
	}

	return self;
}

- (void)
dealloc
{
	CFRelease(self.addressBook);
}

#pragma mark - Lifecycle (Setup/Update)


#pragma mark - Properties Getters

- (BOOL)
isAccessGranted
{
	ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
	return status == kABAuthorizationStatusAuthorized;
}

- (BOOL)
canRequestAccess
{
	ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
	return status == kABAuthorizationStatusNotDetermined;
}

#pragma mark - Properties Setters


#pragma mark - Public Interface

- (void)
requestAccess:(ABAddressBookRequestAccessCompletionHandler)complete
{
	ABAddressBookRequestAccessWithCompletion(self.addressBook, complete);
}

- (NSArray *)
allGroups
{
	NSArray *allGroups = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllGroups(self.addressBook);

	NSMutableArray *groupNames = [NSMutableArray array];
	for (NSInteger i = 0; i < allGroups.count; ++i) {
		@autoreleasepool {
			ABRecordRef record = (__bridge ABRecordRef)allGroups[i];

			NSString *name = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABGroupNameProperty);
			[groupNames addObject:name];
		}
	}
	
	return groupNames;
}

- (NSArray *)
allContacts
{
	NSArray *allContacts = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllPeople(self.addressBook);
	return allContacts;
}

- (NSString *)
vCardForAllContacts
{
	return [self vCardFromContactsArray:[self allContacts]];
}

- (NSString *)
vCardForAllContactsInGroupWithName:(NSString *)groupName
{
	ABRecordRef groupRecord = [self groupWithName:groupName];
	NSArray *contacts = (__bridge_transfer NSArray *) ABGroupCopyArrayOfAllMembers(groupRecord);
	return [self vCardFromContactsArray:contacts];
}

- (NSString *)
vCardForContactRecord:(ABRecordRef)contactRecord
{
	NSArray *contacts = @[(__bridge id) contactRecord];
	return [self vCardFromContactsArray:contacts];
}

#pragma mark - Private methods

- (ABRecordRef)
groupWithName:(NSString *)groupName
{
	NSArray *allGroups = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllGroups(self.addressBook);

	for (NSInteger i = 0; i < allGroups.count; ++i) {
		@autoreleasepool {
			ABRecordRef record = (__bridge ABRecordRef)allGroups[i];

			NSString *name = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABGroupNameProperty);
			if ([name isEqualToString:groupName]) {
				return record;
			}
		}
	}

	return NULL;
}

- (NSString *)
vCardFromContactsArray:(NSArray *)contacts
{
	NSData *vCardData = [vCardSerialization vCardDataWithAddressBookRecords:contacts error:nil];
	return [[NSString alloc] initWithData:vCardData encoding:NSUTF8StringEncoding];
}

@end
