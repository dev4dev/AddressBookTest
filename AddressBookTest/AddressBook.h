//
//  AddressBook.h
//  AddressBookTest
//
//  Created by Alex Antonyuk on 11/3/14.
//  Copyright (c) 2014 Alex Antonyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AddressBook;

@interface AddressBook : NSObject

@property (nonatomic, assign, readonly, getter=isAccessGranted) BOOL accessGranted;
@property (nonatomic, assign, readonly) BOOL canRequestAccess;

- (void)requestAccess:(ABAddressBookRequestAccessCompletionHandler)complete;

- (NSArray *)allGroups;

- (NSString *)vCardForAllContacts;
- (NSString *)vCardForAllContactsInGroupWithName:(NSString *)groupName;
- (NSString *)vCardForContactRecord:(ABRecordRef)contactRecord;

@end
