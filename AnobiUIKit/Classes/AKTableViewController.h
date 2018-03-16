//
//  AKTableViewController.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 15.03.2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKTableViewController : UITableViewController

- (void)becomeFirstResponderIndexPath:(NSIndexPath *)indexPath;
- (void)scrollToIndexPath:(NSIndexPath *)ip completion:(dispatch_block_t)completion;

@end
