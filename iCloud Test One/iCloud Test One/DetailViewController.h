//
//  DetailViewController.h
//  iCloud Test One
//
//  Created by Lucien Dupont on 6/21/15.
//  Copyright © 2015 Lucien Dupont. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

