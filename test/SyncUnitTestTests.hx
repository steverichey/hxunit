/**
* ...
* @author $(DefaultUser)
*/

package test;
import hxunit.TestCase;

class SyncUnitTestTests extends TestCase {

	public function new() {
		super();
	}
	
	public function test0SuccessSync() {
		//Log.trace("testSyncSuccess");
		assertTrue(true);
	}
	public function test1FailSync() {
		//Log.trace("testAssertFail");
		assertTrue(false);
	}
	public function test2SuccessRaiseError() {
		//Log.trace("testSyncError");
		assertTrue(true);
		assertRaises(function() { throw("banana"); }, String);
	}
	public function test3WarnNoAssert() {
		//Log.trace("testNoAssert");
	}
	
}