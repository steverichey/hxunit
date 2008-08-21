package hxunit;

class TestCase {
	public function new() { }

	public function setUp() { }
	public function tearDown() { }

	public function assertTrue(value) {
		Assert.isTrue(value);
	}

	public function assertFalse(value) {
		Assert.isFalse(value);
	}

	public function assertNull(value) {
		Assert.isNull(value);
	}

	public function assertNotNull(value) {
		Assert.notNull(value);
	}

	public function assertEquals(expected, value) {
		Assert.equals(expected, value);
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