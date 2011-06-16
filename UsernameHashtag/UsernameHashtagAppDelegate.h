//
//  UsernameHashtagAppDelegate.h
//  UsernameHashtag
//
//  Created by Jamie Pinkham on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UsernameHashtagViewController;

@interface UsernameHashtagAppDelegate : NSObject <UIApplicationDelegate> {
@private

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UsernameHashtagViewController *viewController;

@end
