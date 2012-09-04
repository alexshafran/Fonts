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
        
    }
    return self;
}

@end
