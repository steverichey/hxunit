package hxunit;

import hxunit.AssertionError;

class Assert {

	public static var runner(getRunner, null):Runner;

	static function getRunner():Runner {
		if (runner == null) {
			runner = new Runner();
		}
		return runner;
	}
	static function update(value:AssertionError) {
		runner.update(value);
	}
	static var status(getStatus, null):TestStatus;

	static function getStatus(){
		return runner.status;
	}
	public static function True(value:Bool):Void {
		status.hasAssertation = true;
		if (value == false) {
			update(new AssertionError(Cause.failure,"expected true but was false"));
		}
	}
	public static function False(value):Void  {
		status.hasAssertation = true;
		if (value == true) {
			update(new AssertionError(Cause.failure, "expected false but was true"));
		}
	}
	public static function Null(value):Void  {
		status.hasAssertation = true;
		if (value != null) {
			update(new AssertionError(Cause.failure,"expected null but was not null"));
		}
	}
	public static function notNull(value):Void  {
		status.hasAssertation = true;
		if (value == null) {
			update(new AssertionError(Cause.failure,"expected not null but was null"));
		}
	}
	public static function Equals(value0:Dynamic, value1:Dynamic):Void  {
		status.hasAssertation = true;
		if (value0 != value1) {
			update(new AssertionError(Cause.failure,"expected " + value0 + " but was " + value1));
		}
	}
	public static function Raises(method:Void -> Void, type:Class < Dynamic > ):Void  {
		status.hasAssertation = true;
		try { method(); } catch (e:Dynamic) {
			if (!Std.is(e, type)) {
				update(new AssertionError(Cause.failure,"expected throw of type " + type + " but was "  + e ));
			}
		}
	}
	public static function fail(msg:String):Void {
		status.hasAssertation = true;
		update(new AssertionError(Cause.failure,msg));
	}
	public static function Async(method:Dynamic, timeout:Int , ?passThrough:Dynamic):Void -> Void {
		#if (php || neko)
		update(new AssertionError(Cause.failure, "Async not supported in threaded platforms"));
		return function() { };
		#else
		if (!Reflect.isFunction(method)) {
			throw "parameter method must be a function: Void->Void or Dynamic->Void";
		}
		status.time = timeout;
		status.isAsync = true;

		return function():Void {
			if (!status.done){
				try { method(passThrough); } catch (e:Dynamic) {
					if (Std.is(e, String)) {
						update(new AssertionError(Cause.error, e));
					}
					else if (Reflect.hasField(e,"message")) {
						update(new AssertionError(Cause.error, e.message));
					}else {
						update(new AssertionError(Cause.error, "test failed"));
					}
				}
				if (status.hasAssertation == false) {
					update(new AssertionError(Cause.warning, "Test makes no assertion"));
				}
				status.done = true;
				if (status.called) { runner.respond(); }
			}
		}
		#end
	}
}