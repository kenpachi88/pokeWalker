//
//  UIView+customFont.m
//  PokeWalker
//
//  Created by kenny on 8/3/16.
//  Copyright © 2016 kenny. All rights reserved.
//

#import "UIView+customFont.h"

@implementation UILabel (customFont)
- (void)setSubstituteFontName:(NSString *)name UI_APPEARANCE_SELECTOR {
    self.font = [UIFont fontWithName:@"Pokemon GB.tff" size:self.font.pointSize]; }
@end
