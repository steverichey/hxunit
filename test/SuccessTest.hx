/**
* ...
* @author $(DefaultUser)
*/

package test;
import hxunit.TestCase;
import haxe.Timer;

class SuccessTest extends TestCase {

	public function new() {
		super();
	}
	
	override public function teardown() {
		async = null;
	}
	var async:Dynamic;
	public function testSuccess_SucceedsInHandlerCalledInMethod() {
		async = asyncResponder(handler0, 10000);
		async();
	}
	function handler0(value) {
		assertTrue(true);
	}
	
	public function testSuccess_SucceedsInHandlerCalledAfterTimerDelay() {
		async = asyncResponder(handler0, 10000);
		#if(!neko||php)
		Timer.delay(async, 1000);
		#else
		async();
		#end
	}
}