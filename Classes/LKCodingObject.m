//
//  LKCodingObject.m
//  LKCodingObject
//
//  Created by Hiroshi Hashiguchi on 2014/01/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKCodingObject.h"
#import <objc/runtime.h>

@interface LKCodingObjectProperty : NSObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* type;
@end
@implementation LKCodingObjectProperty
- (NSString*)description
{
    return _name;
}
@end

@implementation LKCodingObject

#pragma mark - Privates

- (NSArray*)_ignoredNames
{
    static NSArray* names = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        names = @[@"hash", @"superclass", @"description", @"debugDescription"];
    });
    return names;
}


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
        
        if ([self._ignoredNames containsObject:name]) {
            continue;
        }

        LKCodingObjectProperty* property = LKCodingObjectProperty.new;
        property.name = name;
        
        char * property_type_attribute = property_copyAttributeValue(objc_property, "T");
        property.type = [NSString stringWithUTF8String:property_type_attribute];
        free(property_type_attribute);

        [propertyNames addObject:property];
    }
    free(objc_properties);
    
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super init];
    if (self) {
        NSMutableArray* properties = @[].mutableCopy;
        [self _propertyNamesForClass:self.class propertyNames:properties];
        for (LKCodingObjectProperty* property in properties) {
            id value = [decoder decodeObjectForKey:property.name];
            if (value == nil) {
                if (![property.type hasPrefix:@"@"]) {
                    value = @(0);
                }
            }
            [self setValue:value forKey:property.name];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    NSMutableArray* properties = @[].mutableCopy;
    [self _propertyNamesForClass:self.class propertyNames:properties];
    for (LKCodingObjectProperty* property in properties) {
        id value = [self valueForKey:property.name];
        if ([value conformsToProtocol:@protocol(NSCoding)]) {
            [coder encodeObject:value forKey:property.name];
        }
    }
}

@end
