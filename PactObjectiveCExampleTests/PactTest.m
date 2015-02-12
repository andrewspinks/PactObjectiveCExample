
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#include "HelloClient.h"
@import PactConsumerSwift;
@import UIKit;

@interface PactTest : XCTestCase
@property (strong, nonatomic) MockService *mockService;
@property (strong, nonatomic) HelloClient *helloClient;
@end

@implementation PactTest

- (void)setUp {
  [super setUp];
  self.mockService = [[MockService alloc] initWithProvider:@"Provider" consumer:@"consumer"];
  self.helloClient = [[HelloClient alloc] initWithBaseUrl:self.mockService.baseUrl];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testPact {
  typedef void (^CompleteBlock)();
  XCTestExpectation *exp = [self expectationWithDescription:@"Responds with hello"];
  
  [[[self.mockService uponReceiving:@"a request for hello"]
                 withRequest:1 path:@"/sayHello" query:nil headers:nil body: nil]
                 willRespondWith:200 headers:@{@"Content-Type": @"application/json"} body: @"Hello" ];
  
  [[self.mockService run:^(CompleteBlock testComplete) {
      NSString *requestReply = [self.helloClient sayHello];
      XCTAssertEqualObjects(requestReply, @"Hello");
      testComplete();
    }
  ] onComplete:^(PactVerificationResult result) {
     XCTAssert(result == PactVerificationResultPassed);
     [exp fulfill];
    }
  ];
  
  [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testWithQueryParams {
  typedef void (^CompleteBlock)();
  XCTestExpectation *exp = [self expectationWithDescription:@"Responds with matching friends"];
  
  [[[self.mockService uponReceiving:@"a request friends"]
    withRequest:1 path:@"/friends" query: @{ @"age" : @"30", @"child" : @"Mary" } headers:nil body: nil]
   willRespondWith:200 headers:@{@"Content-Type": @"application/json"} body: @{ @"friends": @[ @"Sue" ] } ];
  
  [[self.mockService run:^(CompleteBlock testComplete) {
      NSString *response = [self.helloClient findFriendsByAgeAndChild];
      XCTAssertEqualObjects(response, @"{\"friends\":[\"Sue\"]}");
      testComplete();
    }
  ] onComplete:^(PactVerificationResult result) {
      XCTAssert(result == PactVerificationResultPassed);
      [exp fulfill];
    }
  ];
  
  [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testExpectedError {
  typedef void (^CompleteBlock)();
  XCTestExpectation *exp = [self expectationWithDescription:@"Respons with successful unfriending"];
  
  [[[[self.mockService
      given: @"I have no friends" ]
     uponReceiving:@"a request to unfriend"]
    withRequest:PactHTTPMethodPut path:@"/unfriendMe" query: nil headers:nil body: nil]
   willRespondWith:404 headers:nil body: nil ];
  
  [[self.mockService run:^(CompleteBlock testComplete) {
      [self.helloClient unfriend:^(NSString *response) {
                          XCTAssertFalse(true);
                        } failure:^(NSInteger errorCode) {
                          XCTAssertEqual(errorCode, 404);
                        }];
      testComplete();
    }
  ] onComplete:^(PactVerificationResult result) {
      XCTAssert(result == PactVerificationResultPassed);
      [exp fulfill];
    }
  ];
  
  [self waitForExpectationsWithTimeout:5 handler:nil];
}

@end