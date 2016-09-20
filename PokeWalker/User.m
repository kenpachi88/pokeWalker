//
//  user.m
//  PokeWalker
//
//  Created by kenny on 8/23/16.
//  Copyright © 2016 kenny. All rights reserved.
//

#import "User.h"

@implementation User
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.weight forKey:@"weight"];
    [encoder encodeObject:self.height forKey:@"height"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if( self != nil )
    {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.weight = [decoder decodeObjectForKey:@"weight"];
        self.height = [decoder decodeObjectForKey:@"height"];
    }
    return self;
}
@end
