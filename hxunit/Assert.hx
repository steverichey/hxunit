package hxunit;

import hxunit.AssertionError;
import haxe.PosInfos;

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

	public static function isTrue(value : Bool, msg = "expected true but was false", ?pos : PosInfos) {
		status.hasAssertation = true;
		if (value == false) update(new AssertionError(Cause.Failure, msg, pos));
	}

	public static function isFalse(value : Bool, msg = "expected false but was true", ?pos : PosInfos) {
		isTrue(value == false, msg, pos);
	}

	public static function isNull(value : Dynamic, msg = "expected null but was not null", ?pos : PosInfos) {
		isTrue(value == null, msg, pos);
	}

	public static function notNull(value : Dynamic, msg = "expected not null but was null", ?pos : PosInfos) {
		isTrue(value != null, msg, pos);
	}

	public static function is(value : Dynamic, type : Dynamic, ?msg : String , ?pos : PosInfos) {
		if(msg == null) msg = "expected type " + Std.string(type) + " but was " + Type.typeof(value);
		isTrue(Std.is(value, type), msg, pos);
	}

	public static function equals(value0 : Dynamic, value1 : Dynamic, ?msg : String , ?pos : PosInfos) {
		if(msg == null) msg = "expected " + value0 + " but was " + value1;
		isTrue(value0 == value1, msg, pos);
	}

	public static function floatEquals(value0 : Float, value1 : Float, ?msg : String , ?pos : PosInfos) {
		if(msg == null) msg = "expected " + value0 + " but was " + value1;
		isTrue(Math.abs(value1-value0) < 1e-5, msg, pos);
	}

	public static function raises(method:Void -> Void, type:Class<Dynamic>, ?msg : String , ?pos : PosInfos) {
		status.hasAssertation = true;
		try { method(); } catch (ex : Dynamic) {
			if (!Std.is(ex, type)) {
				if(msg == null) msg = "expected throw of type " + type + " but was "  + ex;
				update(new AssertionError(Cause.Failure, msg, pos));
			}
		}
	}

	public static function fail(msg = "failure expected", ?pos : PosInfos) {
		isTrue(false, msg, pos);
	}

	public static function async(method:Dynamic, timeout:Int , ?passThrough:Dynamic) : Void -> Void {
		/*
		#if (php || neko)
		update(new AssertionError(Cause.Failure, "async not supported in threaded platforms"));
		return function() { };
		#else
		*/
		if (!Reflect.isFunction(method)) {
			throw "parameter method must be a function: Void->Void or Dynamic->Void";
		}

		status.time = timeout;
		status.isAsync = true;

		return function() {
			if (!status.done){
				try { method(passThrough); } catch (e:Dynamic) {
					if (Std.is(e, String)) {
						update(new AssertionError(Cause.Error, e));
					}
					else if (Reflect.hasField(e,"message")) {
						update(new AssertionError(Cause.Error, e.message));
					}else {
						update(new AssertionError(Cause.Error, "test failed"));
					}
				}
				if (status.hasAssertation == false) {
					update(new AssertionError(Cause.Warning, "Test makes no assertion"));
				}
				status.done = true;
				if (status.called) { runner.respond(); }
			}
		}
//		#end
	}
}