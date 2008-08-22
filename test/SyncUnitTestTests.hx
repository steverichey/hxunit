package test;

import hxunit.TestCase;
import hxunit.Assert;
import hxunit.AssertionResult;

class SyncUnitTestTests extends TestCase {
	public function test0SuccessSync() {
		assertTrue(true);
	}

	public function test1FailSync() {
		var status = Assert.runner.status;
		var statusbefore = status.success;
		assertTrue(false);
		var statusafter  = status.success;
		status.reset();
		assertTrue(statusbefore);
		assertFalse(statusafter);
	}

	public function test2SuccessRaiseError() {
		assertTrue(true);
		assertRaises(function() throw("banana"), String);
	}

	public function test3WarnNoAssert() {
		Assert.runner.update(Warning("Test does not make assertion"));
		var status = Assert.runner.status;
		var count  = status.assertations;
		var result = status.iterator().next();
		var type   = Type.enumConstructor(result);

		status.reset();
		assertEquals(1, count);
		assertEquals("Warning", type);
	}
}