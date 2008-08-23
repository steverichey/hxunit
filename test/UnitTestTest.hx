package test;

import hxunit.TestCase;
import haxe.Timer;

class UnitTestTest extends TestCase {
	var blah:String;
	public function new() {
		blah = "one";
		super();
	}

	var async : Void -> Void;
	
	public function handler(value):Void {
	}

	public function testFailAsyncTimeout() {
		async = asyncResponder(handler, 1000);
	}

	public function testAsyncFailInHandlerCalledInMethod() {
		async = asyncResponder(handler2, 1000);
		async();
	}

	function handler2(value):Void {
		assertTrue(false);
	}

	public function testErrorAsyncCalledInHandlerCalledinMethod() {
		async = asyncResponder(handler3, 10000);
		async();
	}

	function handler3(value) {
		throw "arooga";
	}

	public function testFailExplicitInHandlerInMethod() {
		async = asyncResponder(handler4, 10);
		async();
	}

	function handler4(value):Void {
		fail("Explicit Fail in handler");
	}

	function handler5(value):Void {

	}

	public function testFailTimed() {
		async = asyncResponder(handler5, 10000);
		#if (neko || php)
		//no timer here.
		#else
		Timer.delay(async, 100);
		#end
	}

	public function testFailAsyncThenTimeout() {
		async = asyncResponder(handler6, 10000);
		#if (neko || php)
		#else
		Timer.delay(async, 5000);
		#end
	}

	function handler6(value):Void {
		fail("Explicit Fail in Handler");
	}

	public function testFailTimeoutThenAsync() {
		#if (neko||php)
		#else
		Timer.delay(asyncResponder(handler6, 6000), 7000);
		#end
	}

	public function testSucceedValuePassThrough() {
		async = asyncResponder(handler7, 10000, blah);
		async();
	}

	function handler7(value) {
		//fail();
		assertEquals(blah,value);
	}

	public function testFailValuePassThrough() {
		async = asyncResponder(handler8, 10000, 2);
		async();
	}

	function handler8(value) {
		//fail("failed");
		assertEquals(blah,value);
	}

	public function testSucceedAssertInTestAndHandler() {
		assertTrue(true);
		async = asyncResponder(handler9, 1000);
		async();
	}

	function handler9(value) {
		assertTrue(true);
	}
}