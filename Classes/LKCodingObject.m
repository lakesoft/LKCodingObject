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
@property (nonatomic, assign, readonly) BOOL isObject;
@end
@implementation LKCodingObjectProperty
- (BOOL)isObject
{
    return [self.type hasPrefix:@"@"];
}
@end

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
        LKCodingObjectProperty* property = LKCodingObjectProperty.new;
        objc_property_t objc_property = objc_properties[i];
        property.name = [NSString stringWithUTF8String:property_getName(objc_property)];
        
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
        id reference = nil;

        NSMutableArray* properties = @[].mutableCopy;
        [self _propertyNamesForClass:self.class propertyNames:properties];
        for (LKCodingObjectProperty* property in properties) {
            id value = nil;
            if ([decoder containsValueForKey:property.name]) {
                value = [decoder decodeObjectForKey:property.name];
            } else {
                if (reference == nil) {
                    reference = [[super init] init];
                }
                value = [reference valueForKey:property.name];
            }
            if (value == nil) {
                if (!property.isObject) {
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
