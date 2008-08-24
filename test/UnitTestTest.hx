package test;

import hxunit.TestCase;
import haxe.Timer;

class UnitTestTest extends TestCase {
	var blah:String;
	public function new() {
		blah = "one";
		super();
	}
	//placeholder for asynchronous handler.
	var async : Void -> Void;

	
	//the asynchronous handler is setup but never called
	//FAIL: TIMEOUT
	public function testTimeout() {
		async = asyncResponder(handler, 1000);
	}
	public function handler(value):Void {
	}
	
	//No assertions made, either in the method, or handler
	//???? Platform dependent, I think.
	public function testHandlerCalledWithNoAssertions() {
		async = asyncResponder(function(){}, 10000);
		#if (neko || php)
		//no timer here.
		#else
		Timer.delay(async, 100);
		#end
	}
	
	//no assertion in method, and a failed assertion in handler2
	//FAIL: ASSERTION FAILED
	public function testAssertionFailinHandler() {
		async = asyncResponder(handler2, 1000);
		async();
	}

	function handler2(value):Void {
		assertTrue(false);
	}

	//asnchronous called synchronously, error thrown in handler3
	// ERROR: "arooga"
	public function testErrorThrownInHandler() {
		async = asyncResponder(handler3, 10000);
		async();
	}

	function handler3(value) {
		throw "arooga";
	}

	//asynchronous called synchronously, fail() called in failHandler
	// FAIL: "Explicit Fail In Handler"
	public function testFailinHandler() {
		async = asyncResponder(failHandler, 10);
		async();
	}
	
	//asynchronous called after delay, fail() called in failHandler()
	// FAIL: "Explicit Fail in Handler"
	public function testHandlerFailsExplicitlyAfterDelay() {
		async = asyncResponder(failHandler, 10000);
		#if (neko || php)
		async();
		#else
		Timer.delay(async, 5000);
		#end
	}
	function failHandler(value):Void {
		fail("Explicit Fail in handler");
	}

	function handler5(value):Void {

	}

	//Does anything unexpected happen if the handler is called after the test has timed out?
	// TIMEOUT
	public function testTimeoutThenHandler() {
		#if (neko||php)
		#else
		Timer.delay(asyncResponder(function() { trace("putting a spanner in the works");} , 6000), 7000);
		#end
	}

	//passing a variable from the method to the handler
	// SUCCESS
	public function testValuePassedToHandler() {
		async = asyncResponder(handler7, 10000, blah);
		async();
	}

	function handler7(value) {
		assertEquals(blah,value);
	}

	//Testing successful assertions in both method and handler9
	// SUCCESS
	public function testAssertInBothMethodAndHandler() {
		assertTrue(true);
		async = asyncResponder(handler9, 1000);
		async();
	}

	function handler9(value) {
		assertTrue(true);
	}
}