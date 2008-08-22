﻿package hxunit;

class TestCase {
	public function new() { }

	public function setUp() { }
	public function tearDown() { }

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

	public function assertEquals(expected : Dynamic, value : Dynamic) {
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