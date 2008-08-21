package test;

import hxunit.TestCase;
import hxunit.AssertionError;
import hxunit.Assert;
import hxunit.Result;

class SyncUnitTestTests extends TestCase {
	public function test0SuccessSync() {
		assertTrue(true);
	}

	public function test1FailSync() {
		var status = Assert.runner.status;
		assertTrue(status.success);
		Assert.isTrue(false);
		assertTrue(status.success);
		untyped status.errors = [];
	}

	public function test2SuccessRaiseError() {
		assertTrue(true);
		assertRaises(function() throw("banana"), String);
	}

	public function test3WarnNoAssert() {
		Assert.runner.update(new AssertionError(Cause.Warning, "Test does not make assertion"));
		var status = Assert.runner.status;
		status.called = true;
		status.done = true;
		var result = status.result;
		assertTrue(Type.enumEq(Status.Warning, result.status));
		untyped status.errors = [];
		status.done = false;
		status.called = false;
	}
}