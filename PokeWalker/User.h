//
//  user.h
//  PokeWalker
//
//  Created by kenny on 8/23/16.
//  Copyright © 2016 kenny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *weight;
@property (strong, nonatomic) NSNumber *height;
@property (strong, nonatomic) NSNumber *age;
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

@end
