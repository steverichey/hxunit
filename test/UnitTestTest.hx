package test;

import hxunit.TestCase;
import haxe.Timer;

#if neko
import neko.vm.Thread;
import neko.Sys;
#end

class UnitTestTest extends TestCase{

	var blah:String;
	public function new() {
		blah = "one";
		super();
	}

	var async : Void -> Void;
	public function test4SuccessAsyncCalledInMethod() {
		async = asyncResponder(handler, 1000);
		assertTrue(true);
		async();
	}

	public function handler(value):Void {
	}

	public function test5FailAsyncTimeout() {
		async = asyncResponder(handler, 1000);
	}

	public function test6AsyncFailInHandlerCalledInMethod() {
		async = asyncResponder(handler2, 1000);
		async();
	}

	function handler2(value):Void {
		assertTrue(false);
	}

	public function test7ErrorAsyncCalledInHandlerCalledinMethod() {
		async = asyncResponder(handler3, 10000);
		async();
	}

	function handler3(value) {
		throw "arooga";
	}

	public function test8FailExplicitInHandlerInMethod() {
		async = asyncResponder(handler4, 10);
		async();
	}

	function handler4(value):Void {
		fail("Explicit Fail in handler");
	}

	function handler5(value):Void {

	}

	public function test9FailedTimed() {
		async = asyncResponder(handler5, 10000);
		#if (neko || php)
		//no timer here.
		#else
		Timer.delay(async, 100);
		#end
	}

	public function test10FailAsyncThenTimeout() {
		async = asyncResponder(handler6, 10000);
		#if (neko || php)
		#else
		Timer.delay(async, 5000);
		#end
	}

	function handler6(value):Void {
		fail("Explicit Fail in Handler");
	}

	public function test11FailTimeoutThenAsync() {
		#if (neko||php)
		#else
		Timer.delay(asyncResponder(handler6, 6000), 7000);
		#end
	}

	public function test12SucceedValuePassThrough() {
		async = asyncResponder(handler7, 10000, blah);
		async();
	}

	function handler7(value) {
		//fail();
		assertEquals(blah,value);
	}

	public function test13FailValuePassThrough() {
		async = asyncResponder(handler8, 10000, 2);
		async();
	}

	function handler8(value) {
		fail("failed");
		assertEquals(blah,value);
	}

	public function test14AssertInTestAndHandler() {
		assertTrue(true);
		async = asyncResponder(handler9, 1000);
		async();
	}

	function handler9(value) {
		assertTrue(true);
	}
}