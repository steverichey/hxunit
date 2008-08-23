/**
* ...
* @author $(DefaultUser)
*/

package test;
import hxunit.Assert;

class TeardownTest {

	public function new() {
		
	}

	public function testFailTeardown() {
		Assert.isTrue(true);
	}
	public function teardown() {
		throw "fail";
	}
	
	var async:Dynamic;
	public function testFailAsyncTeardown() {
		async = Assert.async(function() { Assert.isTrue(true); }, 1000);
		async();
	}
}