//
//  MXMatchDescriptor.m
//  UsernameHashtag
//
//  Created by Jamie Pinkham on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MXMatchDescriptor.h"


@implementation MXMatchDescriptor

@synthesize matchRegex, matchTag, matchColor, matchHighlightColor, matchFont;

- (id)initWithRegularExpression:(NSRegularExpression *)expression matchTag:(NSString *)tag{
    self = [super init];
    if(self){
        self.matchRegex = expression;
        self.matchTag = tag;
        self.matchColor = [UIColor blueColor];
        self.matchHighlightColor = [UIColor lightGrayColor];
    }
    return self;
}

@end
