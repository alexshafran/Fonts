//
//  FontDetailView.h
//  Fonts
//
//  Created by Alex Shafran on 9/2/12.
//  Copyright (c) 2012 Alex Shafran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontDetailView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *editTextView;
@property (nonatomic, strong) UISlider *fontSizeSlider;
@property (nonatomic, strong) UISegmentedControl *previewTextControl;
@end
