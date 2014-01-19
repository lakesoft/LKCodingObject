# LKUCodingObject

## Usage
Step 1 : Define subclass of LKCodingObject

    #import "LKCodingObject.h"

    @interface UserInfo : LKCodingObject
    @property (strong, nonatomic) NSString* name;
    @property (strong, nonatomic) NSString* email;
    @end

Step 2 :  Archive an instance of the class

    UserInfo* userInfo = UserInfo.new;
    userInfo.name = @"Hoge";
    userInfo.email = @"hoge@xcatsan.com";
    [NSKeyedArchiver archiveRootObject:userInfo toFile:@"user_info.dat"];
      :


Step 3 : Unarchive from the file

    UeserInfo* userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:@"user_info.dat"];


It is not neccesary to implement NSCoding methods.

## Notes

- Properties must be conformed to NSCoding protocol.
- If a property is not conforming to it, the property will be not archived.


## Installation

LKUserDefaults is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "LKCodingObject", :git => 'https://github.com/lakesoft/LKCodingObject.git'


## Author

Hiroshi Hashiguchi, xcatsan@mac.com

## License

LKCodingObject is available under the MIT license. See the LICENSE file for more info.

