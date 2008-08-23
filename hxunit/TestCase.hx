package hxunit;

class TestCase {
	public function new() { }

	public function setup() { }
	public function teardown() { }

	public function assertTrue(value : Bool) {
		Assert.isTrue(value);
	}

	public function assertFalse(value : Bool) {
		Assert.isFalse(value);
	}

	public function assertNull(value : Dynamic) {
		Assert.isNull(value);
	}

	public function assertNotNull(value : Dynamic) {
		Assert.notNull(value);
	}
	
	public function assertIs(value:Dynamic,type:Dynamic){
		Assert.is(value,type);
	}
	public function assertEquals(expected : Dynamic, value : Dynamic) {
		Assert.equals(expected, value);
	}

	public function assertFloatEquals(expected:Float,value:Float){
		Assert.floatEquals(expected,value);
	}
	public function assertRaises(method : Void->Void, type : Class<Dynamic>) {
		Assert.raises(method, type);
	}

	public function fail(msg : String) {
		Assert.fail(msg);
	}

	public function asyncResponder(method : Dynamic, ?timeout : Int, ?passThrough : Dynamic) : Dynamic {
		return Assert.async(method, timeout, passThrough);
	}
}
