package test;

import hxunit.TestCase;

class SyncUnitTestTests extends TestCase {

	public function new() {
		super();
	}

	public function test0SuccessSync() {
		assertTrue(true);
	}

	public function test1FailSync() {
		assertTrue(false);
	}

	public function test2SuccessRaiseError() {
		assertTrue(true);
		assertRaises(function() { throw("banana"); }, String);
	}

	public function test3WarnNoAssert() {

	}
}