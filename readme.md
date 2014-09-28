# hxunit

The original hxunit has been inactive since 2008, so I'm putting this code here to keep it up to date. If you made hxunit or something and you're not cool with it being here, let me know.

hxunit is a standard way of doing asynchronous unit tests in haxe.

# Means and Ends

Information on unit tests in general can be found [here](http://en.wikipedia.org/wiki/Unit_testing).

There are *two* ways to write a TestCase with hxunit.

## Extend TestCase

````
package;

import hxunit.TestCase;

class DefaultTest extends TestCase{
        
        override function setup(){}    // optional
        override function teardown(){} // optional

        function testSomething(){
                assertTrue(true);
                assertFalse(false);
                assertEquals(1,1);
                assertIs("this",String);
                assertNull(null);
                assertNotNull("notNull");
                asssertRaises(function(){throw "banana";},String);
        }
}
````

## Use the Assert class

````
package;

class AnotherDefaultTest{

        function setup(){}    // optional
        function teardown(){} // optional

        function testSomething(){
                Assert.isTrue(true);
                Assert.isFalse(false);
                Assert.equals(1,1);
                Assert.floatEquals(0.345,0.345);
                Assert.is("str",String);
                Assert.isNull(null);
                Assert.notNull("notNull");
                Assert.raises(function(){throw "banana";},String);
                Assert.fail("oh noes");
        }
}
````

These cases must be added to the Runner:

````
var runner = new hxunit.Runner();
runner.addCase(new DefaultTest());
runner.addCase(new AnotherDefaultTest());
````

Or to a TestSuite:

````
var runner = new hxunit.Runner();
var testSuite = new hxunit.TestSuite();
testSuite.addCase(new DefaultTest());
testSuite.addCase(new AnotherDefaultTest());
runner.addSuite(testSuite);
````

Asynchronous tests can be initialized and completed as follows:

````
var timeUntilTimeout = 1000; //in milliseconds
var functionToCall = function(value) { assertTrue(true); };
var method = null;
//Intitialising async conditions.
//extends TestCase
method = asyncResponder(functionToCall,timeUntilTimeout);
//otherwise
method = Assert.async(functionToCall,timeUntilTimeout);

//completes test
method();
````

# License

Shared under an MIT license. See [license.md](https://github.com/steverichey/hxunit/blob/master/license.md) for details.