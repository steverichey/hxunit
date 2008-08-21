/**
* ...
* @author $(DefaultUser)
*/

package haxe.xunit;

class TestCase {

	public function new() {
		
	}
	
	public function setUp() {
		
	}
	public function tearDown() {
		
	}
	
	public function assertTrue(value) {
		Assert.True(value);
	}
	public function assertFalse(value) {
		Assert.False(value);
	}
	public function assertNull(value) {
		Assert.Null(value);
	}
	public function assertNotNull(value) {
		Assert.notNull(value);
	}
	public function assertEquals(value0, value1) {
		Assert.Equals(value0, value1);
	}
	public function assertRaises(method:Void -> Void, type:Class < Dynamic > ) {
		Assert.Raises(method, type);
	}
	public function fail(msg:String) {
		Assert.fail(msg);
	}
	public function asyncResponder(method:Dynamic,?timeout:Int,?passThrough:Dynamic):Dynamic {
		return Assert.Async(method, timeout, passThrough);
	}
}