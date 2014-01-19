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


- (void)_propertyNamesForClass:(Class)cls propertyNames:(NSMutableArray*)propertyNames
{
    Class superClass = class_getSuperclass(cls);
    if (superClass != [NSObject class]) {
        [self _propertyNamesForClass:superClass propertyNames:propertyNames];
    }

    unsigned int count, i;
    objc_property_t *objc_properties = class_copyPropertyList(cls, &count);
    
    for(i = 0; i < count; i++) {
        objc_property_t objc_property = objc_properties[i];
        NSString* name = [NSString stringWithUTF8String:property_getName(objc_property)];
        [propertyNames addObject:name];
    }
    free(objc_properties);
    
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super init];
    if (self) {
        NSMutableArray* propertyNames = @[].mutableCopy;
        [self _propertyNamesForClass:self.class propertyNames:propertyNames];
        for (NSString* name in propertyNames) {
            id value = [decoder decodeObjectForKey:name];
            [self setValue:value forKey:name];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    NSMutableArray* propertyNames = @[].mutableCopy;
    [self _propertyNamesForClass:self.class propertyNames:propertyNames];
    for (NSString* name in propertyNames) {
        id value = [self valueForKey:name];
        if ([value conformsToProtocol:@protocol(NSCoding)]) {
            [coder encodeObject:value forKey:name];
        }
    }
}

@end
