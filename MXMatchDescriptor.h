//
//  MXMatchDescriptor.h
//  UsernameHashtag
//
//  Created by Jamie Pinkham on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegexKitLite.h"

@interface MXMatchDescriptor : NSObject {
@private
    
}

@property (nonatomic, copy) NSString *regexPattern;
@property (nonatomic, assign) RKLRegexOptions regexOptions;
@property (nonatomic, copy) NSString *matchTag;
@property (nonatomic, retain) UIColor *matchColor;
@property (nonatomic, retain) UIColor *matchHighlightColor;
@property (nonatomic, retain) UIFont *matchFont;

- (id)initWithRegexPattern:(NSString *)pattern regexOption:(RKLRegexOptions)options matchTag:(NSString *)tag;

@end
