//
//  MatchingLabel.m
//  UsernameHashtag
//
//  Created by Jamie Pinkham on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MXMatchLabel.h"

@interface MXMatchLabel()
- (void)applyMatchDescriptors;
- (CTFrameRef)createCoreTextComponents;
- (void)buildMatchRuns:(CTFrameRef)frameRef;
@end

//NSString * const kMXUsernameAttributeName = @"com.mobelux.username_attribute";
//NSString * const kMXHashtagAttributeName = @"com.mobelux.hashtag_attribute";

@implementation MXMatchLabel

@synthesize text, delegate, textColor, textFont;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        matchDescriptors = [[NSMutableArray array] retain];
        matchDescriptorTagLookup = [[NSMutableDictionary dictionary] retain];
        self.backgroundColor = [UIColor whiteColor];
        self.textFont = [UIFont systemFontOfSize:17.0f];
        self.textColor = [UIColor blackColor];
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //[self applyMatchDescriptors];
    CTFrameRef ctFrame = [self createCoreTextComponents];
    if([matchDescriptors count]){
        if(matchRuns == nil){
            [self buildMatchRuns:ctFrame];
        }
    }
    CGContextSaveGState(UIGraphicsGetCurrentContext());
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, self.bounds.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    CTFrameDraw(ctFrame, UIGraphicsGetCurrentContext());
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
    CFRelease(ctFrame);
}
    
- (CTFrameRef)createCoreTextComponents{

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CTFrameRef ret = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(framesetter);
    CFRelease(path);

    return ret;
}

- (void)dealloc
{
    [text release];
    //[usernameRegex release];
    //[hashtagRegex release];
    [attributedString release];
    [super dealloc];
}

- (void)setText:(NSString *)aText{
    if(text != aText){
        [text release];
        text = [aText copy];
        [self applyMatchDescriptors];
        [self setNeedsDisplay];

    }
}
- (void)buildMatchRuns:(CTFrameRef)aFrameRef{
    [matchRuns release];
    matchRuns = [[NSMutableDictionary dictionary] retain];
    NSArray *lines = (NSArray *)CTFrameGetLines(aFrameRef);
    NSInteger linesCount = [lines count];
    CGFloat y = 0.0;
    for(MXMatchDescriptor *descriptor in matchDescriptors){
        for(NSInteger i = 0; i < linesCount; i++){
            CGPoint origins;
            CTFrameGetLineOrigins(aFrameRef, CFRangeMake(i, 1), &origins);
            y = self.bounds.origin.y + self.bounds.size.height - origins.y;
            NSLog(@"y = %f", y);
            CTLineRef line = (CTLineRef)[lines objectAtIndex:i];
            NSArray *runs = (NSArray *)CTLineGetGlyphRuns(line);
            NSInteger runsCount = [runs count];
            for(NSInteger j = 0; j < runsCount; j++){
                CTRunRef run = (CTRunRef)[runs objectAtIndex:j];
                NSDictionary *dict = (NSDictionary *)CTRunGetAttributes(run);
                if([[dict allKeys] containsObject:descriptor.matchTag]){
                    CGRect runBounds = CTRunGetImageBounds(run, UIGraphicsGetCurrentContext(), CFRangeMake(0, 0));
                    CGRect runBoundsInFrame = CGRectMake((runBounds.origin.x), (y-runBounds.size.height-runBounds.origin.y), runBounds.size.width, runBounds.size.height);
                    [matchRuns setObject:(id)run forKey:NSStringFromCGRect(runBoundsInFrame)];
                    
                }
                
            }
        }
    }
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [touch locationInView:self];
	for(NSString *key in [matchRuns allKeys]){
		//NSLog(@"link = %@", [dict valueForKey:@"TKLinkAttributeName"]);
		CGRect linkFrame = CGRectFromString(key);
		if(CGRectContainsPoint(linkFrame, touchLocation)){
            currentRunRect = linkFrame;
			CTRunRef run = (CTRunRef)[matchRuns valueForKey:key];
            UIColor *highlightColor = nil;
            NSDictionary *dict = (NSDictionary *)CTRunGetAttributes(run);
            NSArray *allKeys = [dict allKeys];
            for(NSString *key in allKeys){
                if([matchDescriptorTagLookup objectForKey:key]){
                    highlightColor = [[matchDescriptorTagLookup objectForKey:key] matchHighlightColor];
                }
            }
            //highlightedRun = CFRetain(run);
			//NSDictionary *dict = (NSDictionary *)CTRunGetAttributes(run);
			//NSLog(@"linkFrame = %@, username = %@ hashtag = %@", key, [dict valueForKey:kMXUsernameAttributeName], [dict valueForKey:kMXHashtagAttributeName]);
			//CTRunRef run = (CTRunRef)[linkRuns valueForKey:key];
			CFRange runRange = CTRunGetStringRange(run);
			NSRange range;
			NSMutableDictionary *dictionary = [[attributedString attributesAtIndex:runRange.location effectiveRange:&range] mutableCopy];
			[attributedString beginEditing];
			[dictionary setObject:(id)[highlightColor CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
			[attributedString setAttributes:dictionary range:range];
			[attributedString endEditing];
			//textLayer.string = attrString;
			[dictionary release];
            [self setNeedsDisplay];
			
		}
	}
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(CGRectEqualToRect(currentRunRect, CGRectZero)){
        return;
    }
    UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [touch locationInView:self];
    if(!CGRectContainsPoint(currentRunRect, touchLocation)){
        CTRunRef run = (CTRunRef)[matchRuns valueForKey:NSStringFromCGRect(currentRunRect)];
        NSDictionary *dict = (NSDictionary *)CTRunGetAttributes(run);
        NSArray *allKeys = [dict allKeys];
        UIColor *matchColor = nil;
        for(NSString *key in allKeys){
            if([matchDescriptorTagLookup objectForKey:key]){
                matchColor = [[matchDescriptorTagLookup objectForKey:key] matchColor];
            }
        }
        CFRange runRange = CTRunGetStringRange(run);
        NSRange range;
        NSMutableDictionary *dictionary = [[attributedString attributesAtIndex:runRange.location effectiveRange:&range] mutableCopy];
        [attributedString beginEditing];
        [dictionary setObject:(id)matchColor.CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
		[attributedString setAttributes:dictionary range:range];
		[attributedString endEditing];
        currentRunRect = CGRectZero;
		//textLayer.string = attrString;
		[self setNeedsDisplay];
		[dictionary release];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(CGRectEqualToRect(currentRunRect, CGRectZero)){
        return;
    }
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [touch locationInView:self];
    if(CGRectContainsPoint(currentRunRect, touchLocation)){
        CTRunRef run = (CTRunRef)[matchRuns valueForKey:NSStringFromCGRect(currentRunRect)];
        NSDictionary *dict = (NSDictionary *)CTRunGetAttributes(run);
        NSArray *allKeys = [dict allKeys];
        UIColor *matchColor = nil;
        for(NSString *key in allKeys){
            if([matchDescriptorTagLookup objectForKey:key]){
                CFRange runRange = CTRunGetStringRange(run);
                matchColor = [[matchDescriptorTagLookup objectForKey:key] matchColor];
                if([self.delegate respondsToSelector:@selector(matchingLabel:didTouchMatch:text:)]){
                    [self.delegate matchingLabel:self didTouchMatch:[matchDescriptorTagLookup objectForKey:key] text:[text substringWithRange:NSMakeRange(runRange.location, runRange.length)]];
                }
            }
        }
        CFRange runRange = CTRunGetStringRange(run);
        NSRange range;
        NSMutableDictionary *dictionary = [[attributedString attributesAtIndex:runRange.location effectiveRange:&range] mutableCopy];
        [attributedString beginEditing];
        [dictionary setObject:(id)matchColor.CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
        [attributedString setAttributes:dictionary range:range];
        [attributedString endEditing];
        //textLayer.string = attrString;
        [self setNeedsDisplay];
        [dictionary release];
        currentRunRect = CGRectZero;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void)removeMatchDecscriptor:(MXMatchDescriptor *)descriptor{
    if([matchDescriptorTagLookup objectForKey:[descriptor matchTag]]){
        [matchDescriptors removeObject:descriptor];
        [matchDescriptorTagLookup removeObjectForKey:[descriptor matchTag]];
    }
    [self applyMatchDescriptors];
}

- (void)addMatchDescriptor:(MXMatchDescriptor *)descriptor{
    [matchDescriptors addObject:descriptor];
    [matchDescriptorTagLookup setObject:descriptor forKey:[descriptor matchTag]];
    [self applyMatchDescriptors];
}

- (void)addMatchDescriptors:(NSArray *)descriptors{
    [matchDescriptors addObjectsFromArray:descriptors];
    [descriptors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        if([obj isKindOfClass:[MXMatchDescriptor class]]){
            [matchDescriptorTagLookup setObject:obj forKey:[obj matchTag]];;
        }
    }];
    [self applyMatchDescriptors];
}

- (void)applyMatchDescriptors{
    [matchRuns release];
    attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[self.textColor CGColor] range:NSMakeRange(0, [text length])];
    CTFontRef font = CTFontCreateWithName((CFStringRef) self.textFont.fontName, self.textFont.pointSize, NULL);
    [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)font range:NSMakeRange(0, [text length])];
    CFRelease(font);
    for(MXMatchDescriptor *descriptor in matchDescriptors){
        NSRegularExpression *expression = [descriptor matchRegex];
        NSUInteger numberOfMatches = [expression numberOfMatchesInString:self.text
                                                                 options:expression.options
                                                                   range:NSMakeRange(0, [self.text length])];
        if(numberOfMatches){
            NSArray *matches = [expression matchesInString:self.text options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [self.text length])];
            for(NSTextCheckingResult *result in matches){
                NSRange range = result.range;
                [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[descriptor matchColor] CGColor] range:range];
                if([descriptor matchFont]){
                    UIFont *matchFont = [descriptor matchFont];
                    CTFontRef font = CTFontCreateWithName((CFStringRef)matchFont.fontName, matchFont.pointSize, NULL);
                    [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)font range:range];
                }
                [attributedString addAttribute:[descriptor matchTag] value:[text substringWithRange:range] range:range];
            }
        }
    }
    [self setNeedsDisplay];

}

- (CGFloat)boundingWidthForHeight:(CGFloat)inHeight
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString( (CFMutableAttributedStringRef) self); 
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(CGFLOAT_MAX, inHeight), NULL);
    CFRelease(framesetter);
    return suggestedSize.width;   
}
- (CGFloat)boundingHeightForWidth:(CGFloat)inWidth
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString( (CFMutableAttributedStringRef) self); 
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(inWidth, CGFLOAT_MAX), NULL);
    CFRelease(framesetter);
    return suggestedSize.height;
}


@end
