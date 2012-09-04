//
//  FontSelectionViewController.h
//  Fonts
//
//  Created by Alex Shafran on 9/3/12.
//  Copyright (c) 2012 Alex Shafran. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FontSelectionDelegate <NSObject>

- (void)fontSelectionViewControllerDidExitWithFontName:(NSString*)font;

@end

@interface FontSelectionViewController : UITableViewController {
    
    id <FontSelectionDelegate> _delegate;
}

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) NSString *familyName;

@end
