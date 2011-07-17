//
//  Person.m
//  Presence3
//
//  Created by Timothy P Miller on 1/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Person.h"


@implementation Person

@synthesize userId;
@synthesize userName;
@synthesize displayName;
@synthesize image;
@synthesize url;
@synthesize statusMessages;
@synthesize twitterStatus;
@synthesize tweets;

- (id)init {
	self = [super init];
	return self;
}

@end
