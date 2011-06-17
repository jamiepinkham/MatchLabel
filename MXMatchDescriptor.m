//
//  MXMatchDescriptor.m
//  UsernameHashtag
//
//  Created by Jamie Pinkham on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MXMatchDescriptor.h"


@implementation MXMatchDescriptor

@synthesize regexPattern, regexOptions,  matchTag, matchColor, matchHighlightColor, matchFont;

- (id)initWithRegexPattern:(NSString *)pattern regexOption:(RKLRegexOptions)options matchTag:(NSString *)tag{
    self = [super init];
    if(self){
        self.regexPattern = pattern;
        self.regexOptions = options;
        self.matchTag = tag;
        self.matchColor = [UIColor blueColor];
        self.matchHighlightColor = [UIColor lightGrayColor];
    }
    return self;
}

@end
