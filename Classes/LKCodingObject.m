//
//  LKCodingObject.m
//  LKCodingObject
//
//  Created by Hiroshi Hashiguchi on 2014/01/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKCodingObject.h"
#import <objc/runtime.h>

@implementation LKCodingObject

#pragma mark - Privates
- (NSArray*)_propertyNames
{
    NSMutableArray* propertyNames = @[].mutableCopy;
    
    unsigned int count, i;
    objc_property_t *objc_properties = class_copyPropertyList(self.class, &count);
    
    for(i = 0; i < count; i++) {
        objc_property_t objc_property = objc_properties[i];
        propertyNames[i] = [NSString stringWithUTF8String:property_getName(objc_property)];
    }
    free(objc_properties);
    return propertyNames;
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super init];
    if (self) {
        for (NSString* name in self._propertyNames) {
            id value = [decoder decodeObjectForKey:name];
            [self setValue:value forKey:name];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    for (NSString* name in self._propertyNames) {
        id value = [self valueForKey:name];
        if ([value conformsToProtocol:@protocol(NSCoding)]) {
            [coder encodeObject:value forKey:name];
        }
    }
}

@end
