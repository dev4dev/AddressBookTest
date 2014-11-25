//
//  Helpers.m
//  AddressBookTest
//
//  Created by Alex Antonyuk on 11/25/14.
//  Copyright (c) 2014 Alex Antonyuk. All rights reserved.
//

#import "Helpers.h"

NSString * dataToString(NSData *data) {
	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

