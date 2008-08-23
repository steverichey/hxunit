package hxunit;

import hxunit.AssertionResult;
import haxe.PosInfos;

class Assert {
	public static var runner : Runner;

	static var status(getStatus, null):TestStatus;

	static function getStatus(){
		return runner.status;
	}

	public static function isTrue(value : Bool, msg = "expected true but was false", ?pos : PosInfos) {
		if(value)
			runner.update(Success(pos));
		else
			runner.update(Failure(msg, pos));
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

	public static function equals(expected : Dynamic, value : Dynamic, ?msg : String , ?pos : PosInfos) {
		if(msg == null) msg = "expected " + expected + " but was " + value;
		isTrue(expected == value, msg, pos);
	}

	public static function floatEquals(expected : Float, value : Float, ?msg : String , ?pos : PosInfos) {
		if(msg == null) msg = "expected " + expected + " but was " + value;
		isTrue(Math.abs(value-expected) < 1e-5, msg, pos);
	}

	public static function raises(method:Void -> Void, type:Class<Dynamic>, ?msg : String , ?pos : PosInfos) {
		try { method(); } catch (ex : Dynamic) {
			if (Std.is(ex, type)) {
				runner.update(Success(pos));
			} else {
				if(msg == null) msg = "expected throw of type " + type + " but was "  + ex;
				runner.update(Failure(msg, pos));
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
					runner.update(Error(e));
				}
				if (status.hasAssertation == false) {
					runner.update(Warning("Test makes no assertion"));
				}
				status.done = true;
				if (status.called) { runner.respond(); }
			}
		}
//		#end
	}
}