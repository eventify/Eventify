//
//  Person.h
//  Presence3
//
//  Created by Timothy P Miller on 1/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Person : NSObject {
	NSString *userId;
	NSString *userName;
	NSString *displayName;
	NSString *image;
	NSURL *url;
	NSArray *statusMessages;
	NSArray *twitterStatus;
    NSMutableArray *tweets;
}

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSArray *statusMessages;
@property (nonatomic, retain) NSArray *twitterStatus;
@property (nonatomic, retain) NSMutableArray *tweets;

@end
