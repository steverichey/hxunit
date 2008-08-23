package hxunit.respond;

import hxunit.AssertionResult;
import haxe.PosInfos;
import hxunit.TestStatus;

class StandardResponder implements Responder{
	var suites  : Hash<{
		counter : Counter,
		classes : Hash<{
			counter : Counter,
			methods : Hash<MethodInfo>
		}>
	}>;
	var info : GlobalInfo;
	var oldTraceFunction : Dynamic;
	var redirectTraces : Bool;
	public function new(redirectTraces = true) {
		this.redirectTraces = redirectTraces;
	}

	function emptyCounter() : Counter {
		return {
			assertations : 0,
			warnings     : 0,
			errors       : 0,
			sucesses     : 0,
			failures     : 0
		}
	}

	function emptyGlobalCounter() : GlobalInfo {
		return {
			counter : emptyCounter(),
			suites  : 0,
			classes : 0,
			methods : 0
		};
	}

	function emptyMethodInfo() : MethodInfo {
		return {
			counter  : emptyCounter(),
			async    : false,
			success  : false,
			messages : []
		};
	}

	var time : Float;
	var processtime : Float;
	public function start() {
		if(redirectTraces) {
			oldTraceFunction = haxe.Log.trace;
			haxe.Log.trace = this.trace;
		}
		suites = new Hash();
		info = emptyGlobalCounter();
		println("TESTING ... ");
		println("");
		processtime = 0.0;
		time = haxe.Timer.stamp();
	}

	public function execute(status : TestStatus) {
		var afterexecution = haxe.Timer.stamp();
		if(!suites.exists(status.suiteName)) {
			suites.set(status.suiteName, {
				counter : emptyCounter(),
				classes : new Hash()
			});
			info.suites++;
		}
		var suite = suites.get(status.suiteName);
		if(!suite.classes.exists(status.className)) {
			suite.classes.set(status.className, {
				counter : emptyCounter(),
				methods : new Hash()
			});
			info.classes++;
		}
		var cls = suite.classes.get(status.className);
		if(!cls.methods.exists(status.methodName)) {
			cls.methods.set(status.methodName, emptyMethodInfo());
			info.methods++;
		}
		var method = cls.methods.get(status.methodName);

		info.counter.assertations += status.assertations;
		method.async   = status.isAsync;
		method.success = status.success;

		for(r in status.iterator()) {
			switch(r) {
				case Success(_):
					suite.counter.sucesses++;
					cls.counter.sucesses++;
					info.counter.sucesses++;
					method.counter.sucesses++;
				case Warning(m):
					suite.counter.warnings++;
					cls.counter.warnings++;
					info.counter.warnings++;
					method.counter.warnings++;
					method.messages.push({
						type    : "W",
						message : m,
						pos     : null
					});
				case Failure(m, p):
					suite.counter.failures++;
					cls.counter.failures++;
					info.counter.failures++;
					method.counter.failures++;
					method.messages.push({
						type    : "F",
						message : m,
						pos     : p
					});
				case Error(m):
					suite.counter.errors++;
					cls.counter.errors++;
					info.counter.errors++;
					method.counter.errors++;
					method.messages.push({
						type    : "E",
						message : m,
						pos     : null
					});
			}
		}
		processtime += haxe.Timer.stamp() - afterexecution;
	}

	function trace(v : Dynamic, ?p : PosInfos) {
		println("# "+(p.className.split('.').pop())+"."+p.methodName+"("+p.lineNumber+") "+Std.string(v));
	}

#if (flash9 || flash10)
	static var tf : flash.text.TextField = null;
	static var format : flash.text.TextFormat = null;
#elseif flash
	static var tf : flash.TextField = null;
	static var format : flash.TextFormat = null;
#end

	public function println(v : String) {
#if php
		php.Lib.println(StringTools.htmlEscape(v));
#elseif flash9
		if( tf == null ) {
			tf = new flash.text.TextField();
			tf.selectable = true;
			tf.width = flash.Lib.current.stage.stageWidth;
			tf.autoSize = flash.text.TextFieldAutoSize.LEFT;
			format = tf.getTextFormat();
			format.font = "Courier New";
			flash.Lib.current.addChild(tf);
		}
		tf.text += v + "\n";
		tf.setTextFormat(format);
#elseif flash
		var root = flash.Lib.current;
		if( tf == null ) {
			root.createTextField("__tf",1048500,0,0,flash.Stage.width,flash.Stage.height+30);
			tf = untyped root.__tf;
			format = tf.getTextFormat();
			format.font = "Courier New";
			tf.selectable = true;
			tf.multiline = true;
		}
		tf.text += v + "\n";
		tf.setTextFormat(format);
#elseif neko
		neko.Lib.println(v);
#elseif js
		var d = js.Lib.document.getElementById("haxe:trace");
		if( d == null )
			js.Lib.alert("haxe:trace element not found")
		else
			d.innerHTML += v + "<br>";
#elseif hllua
		lua.Lib.println(v);
#end
	}

	function pad(s : String, len : Int, char : String) {
		var b = new StringBuf();
		var l = s.length;
		b.add(s);
		for(i in l...len)
			b.add(char);
		return b.toString();
	}

	function suiteKeys() {
		var me = this;
		var keys : Array<String> = Lambda.array({ iterator : function() return me.suites.keys() });
		keys.sort(function(a, b) {
			var ao = me.suites.get(a);
			var bo = me.suites.get(b);
			var c = compareCounters(ao.counter, bo.counter);
			if(c == 0)
				return a < b ? -1 : (a > b ? 1 : 0);
			return c;
		});
		return keys;
	}

	static function compareCounters(a : Counter, b : Counter) {
		if(a.errors > b.errors) return -1;
		if(a.errors < b.errors) return 1;
		if(a.failures > b.failures) return -1;
		if(a.failures < b.failures) return 1;
		if(a.warnings > b.warnings) return -1;
		if(a.warnings < b.warnings) return 1;
		return 0;
	}

	static function sortedKeys(hash : Hash<Dynamic>) {
		var keys : Array<String> = Lambda.array({ iterator : function() return hash.keys() });
		keys.sort(function(a, b) {
			var ao = hash.get(a);
			var bo = hash.get(b);
			var c = compareCounters(ao.counter, bo.counter);
			if(c == 0)
				return a < b ? -1 : (a > b ? 1 : 0);
			return c;
		});
		return keys;
	}

	public function done() {
		var totaltime = haxe.Timer.stamp() - time - processtime;

		println("TESTS RESULT");
		println("==========================");
		println("suites:    " + info.suites);
		println("classes:   " + info.classes);
		println("methods:   " + info.methods);
		println("asserts:   " + info.counter.assertations);
		println("sucesses:  " + info.counter.sucesses);
		println("failures:  " + info.counter.failures);
		println("errors:    " + info.counter.errors);
		println("warnings:  " + info.counter.warnings);
		println("execution: " + Std.int(totaltime * 1000) / 1000 + " sec.");
		println("==========================");
		println("");

		for(suitename in sortedKeys(suites)) {
			println(suitename);
			var suite = suites.get(suitename);

			for(classname in sortedKeys(suite.classes)) {
				println("  " + classname);
				var cls = suite.classes.get(classname);

				for(methodname in sortedKeys(cls.methods)) {
					var method = cls.methods.get(methodname);
					var m = null;
					if(method.counter.errors > 0) {
						m = "ERROR";
					} else if(method.counter.failures == 1) {
						m = "FAILURE";
					} else if(method.counter.failures > 0) {
						m = "FAILURES " + method.counter.failures;
					} else if(method.counter.warnings == 1) {
						m = "WARNING";
					} else if(method.counter.warnings > 0) {
						m = "WARNINGS " + method.counter.warnings;
					} else {
						m = "OK (asserts " + method.counter.sucesses + ")";
					}
					println("    " + pad(m, 20, '.') + " " + methodname + (method.async ? " (async)" : ""));
					for(msg in method.messages) {
						println("      " + msg.type + ": " + msg.message);
						if(msg.pos != null)
							println("         line " + msg.pos.lineNumber);
					}
				}
				println("");
			}
			println("");
		}

		if(redirectTraces) {
			haxe.Log.trace = oldTraceFunction;
		}
	}
}

typedef Counter = {
	assertations : Int,
	warnings     : Int,
	errors       : Int,
	sucesses     : Int,
	failures     : Int
}

typedef GlobalInfo = {
	counter : Counter,
	suites  : Int,
	classes : Int,
	methods : Int
}

typedef MethodInfo = {
	counter  : Counter,
	async    : Bool,
	success  : Bool,
	messages : Array<{
		type    : String,
		message : String,
		pos     : PosInfos
	}>
}