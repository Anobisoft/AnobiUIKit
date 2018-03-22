//
//  AKViewObserver.h
//  AnobiUIKit_Example
//
//  Created by Stanislav Pletnev on 17.01.2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AnobiUIKit;

typedef NSString * (^Callback)(void);

@interface AKViewObserver : NSObject <AKViewObserver>

@property Callback callback;

@end
