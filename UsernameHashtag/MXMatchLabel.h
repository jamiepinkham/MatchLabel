//
//  MatchingLabel.h
//  UsernameHashtag
//
//  Created by Jamie Pinkham on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "MXMatchDescriptor.h"

@protocol MXMatchLabelDelegate;

@interface MXMatchLabel : UIView {
@private
    NSString *text;
    NSMutableArray *matchDescriptors;
    NSMutableAttributedString *attributedString;
    id<MXMatchLabelDelegate> delegate;
    NSMutableDictionary *matchRuns;
    CGRect currentRunRect;
    NSMutableDictionary *matchDescriptorTagLookup;
}


@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) id<MXMatchLabelDelegate> delegate;
@property (nonatomic, retain) UIFont *textFont;
@property (nonatomic, retain) UIColor *textColor;

- (void)addMatchDescriptors:(NSArray *)descriptors;
- (void)addMatchDescriptor:(MXMatchDescriptor *)descriptor;
- (void)removeMatchDecscriptor:(MXMatchDescriptor *)descriptor;

- (CGFloat)boundingWidthForHeight:(CGFloat)inHeight;
- (CGFloat)boundingHeightForWidth:(CGFloat)inWidth;

@end

@protocol MXMatchLabelDelegate <NSObject>

- (void)matchingLabel:(MXMatchLabel *)matchingLabel didTouchMatch:(MXMatchDescriptor *)descriptor text:(NSString *)text;

@end
