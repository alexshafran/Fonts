//
//  FontDetailViewController.h
//  Fonts
//
//  Created by Alex Shafran on 8/31/12.
//  Copyright (c) 2012 Alex Shafran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontSelectionViewController.h"

typedef enum {
    kEditingStatePreview,
    kEditingStateCustom
} EditingState;

@interface FontDetailViewController : UIViewController <FontSelectionDelegate>

@property (nonatomic, strong) NSString *font;

@end
