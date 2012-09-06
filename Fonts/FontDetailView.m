//
//  FontDetailView.m
//  Fonts
//
//  Created by Alex Shafran on 9/2/12.
//  Copyright (c) 2012 Alex Shafran. All rights reserved.
//

#import "FontDetailView.h"
#import <QuartzCore/QuartzCore.h>

@implementation FontDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -10, self.frame.size.width, 44)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.minimumFontSize = 15;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLabel];
        
        _editTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 45, frame.size.width - 20, 200)];
        _editTextView.layer.cornerRadius = 5;
        [self addSubview:_editTextView];
        
        _fontSizeSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 300, 220, 20)];
        _fontSizeSlider.minimumTrackTintColor = [UIColor orangeColor];
        [self addSubview:_fontSizeSlider];
        
//        _previewTextControl = [[UISegmentedControl alloc] initWithItems:@[@"A-Za-z0-9", @"Sample", @"0-9", @"Sym"]];
        _previewTextControl = [[UISegmentedControl alloc] initWithItems:@[@"ABC", @"Sample", @"#", @"Sym"]];
        _previewTextControl.segmentedControlStyle = UISegmentedControlStyleBar;
        UIBarButtonItem *segmentedControlButton = [[UIBarButtonItem alloc] initWithCustomView:_previewTextControl];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIToolbar *bottomBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 44 - 20 - 44, self.frame.size.width, 44)];
        [bottomBar setItems:@[flexibleSpace, segmentedControlButton, flexibleSpace] animated:YES];
        [self addSubview:bottomBar];
        
    }
    return self;
}

@end
