//
//  AKFormattedField.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 06.01.2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import "AKFormattedField.h"

@interface AKFormattedField()<UITextFieldDelegate>

@end

@implementation AKFormattedField {
    __weak id<UITextFieldDelegate> __delegate;
    NSString *__text;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [super setDelegate:self];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [super setDelegate:self];
    }
    return self;
}

- (NSString *)pattern {
    return _pattern ?: @"[*]+";
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    __delegate = delegate;
}

- (id<UITextFieldDelegate>)delegate {
    return __delegate;
}

- (NSString *)text {
    return __text ?: @"";
}

- (void)setText:(NSString *)text {
    NSUInteger fl = self.format.length;
    if (!fl) {
        __text = text;
        super.text = text;
        return ;
    }
    NSUInteger tl = text.length;
    NSString *output = self.format;
    NSUInteger i = 0;
    NSUInteger j = 0;
    while (i < fl && j < tl) {
        NSRange formatrange = NSMakeRange(i, fl - i);
        NSRange foundrange = [self.format rangeOfString:self.pattern options:NSRegularExpressionSearch range:formatrange];
        i = NSMaxRange(foundrange);
        NSRange textmask;
        if (i != NSNotFound) {
            if (j + foundrange.length > tl) {
                textmask = NSMakeRange(j, tl - j);
                i -= foundrange.length - textmask.length;
            } else {
                textmask = NSMakeRange(j, foundrange.length);
            }
            j += textmask.length;
            output = [output stringByReplacingCharactersInRange:foundrange withString:[text substringWithRange:textmask]];
        } else {
            i = fl;
        }
    }
    __text = [text substringWithRange:NSMakeRange(0, j)];
    super.text = [output substringToIndex:i];
}

- (NSString *)formattedText {
    return super.text;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL should = true;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        should = [self.delegate textFieldShouldBeginEditing:textField];
    }
    return should;
}

- (NSRange)uniform:(NSRange)range {
    NSUInteger fl = self.format.length;
    if (!fl) {
        return range;
    }
    NSRange textrange = NSMakeRange(0, self.text.length);
    NSUInteger i = 0;
    NSUInteger j = 0;
    NSUInteger l = 0;
    NSUInteger f = NSMaxRange(range);
    while (i < fl && j < textrange.length) {
        NSRange formatrange = NSMakeRange(i, fl - i);
        NSRange foundrange = [self.format rangeOfString:self.pattern options:NSRegularExpressionSearch range:formatrange];
        i = NSMaxRange(foundrange);
        if (NSLocationInRange(range.location, foundrange)) {
            NSUInteger skip = range.location - foundrange.location;
            j += skip;
            l = foundrange.length - skip;
            if (l >= range.length) {
                l = range.length;
                break;
            }
        } else if (range.location >= i) {
            j += foundrange.length;
        } else {
            if (NSLocationInRange(f, foundrange)) {
                l += f - foundrange.location;
                break;
            } else if (f >= i) {
                l += foundrange.length;
            } else {
                break;
            }
        }
    }
    
    if (j > textrange.length) {
        j = textrange.length;
        range.length = 0;
    }
    NSRange result = NSMakeRange(j, l);
    if (result.length) result = NSIntersectionRange(result, textrange);
    return result;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL should = true;
    range = [self uniform:range];
    if (self.delegate && [self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        should = [self.delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    if (should) {
        NSString *chtext = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.text = chtext;
    }
    return false;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    BOOL should = true;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        should = [self.delegate textFieldShouldClear:textField];
    }
    if (should) {
        self.text = @"";
    }
    return false;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL should = true;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        should = [self.delegate textFieldShouldReturn:textField];
    }
    return should;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    BOOL should = true;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        should = [self.delegate textFieldShouldEndEditing:textField];
    }
    return should;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.delegate textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.delegate textFieldDidEndEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason API_AVAILABLE(ios(10.0)) {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:reason:)]) {
            [self.delegate textFieldDidEndEditing:textField reason:reason];
        } else if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
            [self.delegate textFieldDidEndEditing:textField];
        }        
    }
}

@end
