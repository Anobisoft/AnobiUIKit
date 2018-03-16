//
//  AKTableViewController.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 15.03.2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import "AKTableViewController.h"
#import <AnobiKit/AnobiKit.h>

@implementation AKTableViewController {
    dispatch_semaphore_t scroll_sema;
}

- (UITextField *)findSubviewTextField:(UIView *)view {
    UITextField *result = nil;
    for (UIView *sv in view.subviews) {
        if ([sv isKindOfClass:UITextField.class]) {
            return (UITextField *)sv;
        } else {
            result = [self findSubviewTextField:sv];
            if (result) return result;
        }
    }
    return nil;
}

- (void)becomeFirstResponderIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UITextField *tf = [self findSubviewTextField:cell];
    [tf becomeFirstResponder];
}

- (void)scrollToIndexPath:(NSIndexPath *)ip completion:(dispatch_block_t)completion {
    BOOL willScroll = false;
    if (![self.tableView.indexPathsForVisibleRows containsObject:ip]) {
        willScroll = true;
        [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionNone animated:true];
        
    } else {
        if (!CGRectContainsRect(self.tableView.bounds, [self.tableView rectForRowAtIndexPath:ip])) {
            willScroll = true;
            [self.tableView scrollRectToVisible:[self.tableView rectForRowAtIndexPath:ip] animated:true];
        }
    }
    if (willScroll && completion) {
        scroll_sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
            dispatch_semaphore_wait(self->scroll_sema, DISPATCH_TIME_FOREVER);
            self->scroll_sema = nil;
            dispatch_asyncmain(completion);
        });
    } else {
        completion();
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scroll_sema) dispatch_semaphore_signal(scroll_sema);
}

@end
