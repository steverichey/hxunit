package hxunit;

import hxunit.AssertionResult;
import haxe.PosInfos;

class StandardResponder implements Responder{
	var suites  : Hash<Hash<Hash<MethodInfo>>>;
	var counter : GlobalCounter;
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

	function emptyGlobalCounter() : GlobalCounter {
		var d : Dynamic = emptyCounter();
		d.suites  = 0;
		d.classes = 0;
		d.methods = 0;
		return d;
	}

	function emptyMethodInfo() : MethodInfo {
		var d : Dynamic = emptyCounter();
		d.async    = false;
		d.success  = false;
		d.messages = [];
		return d;
	}

	public function start() {
		if(redirectTraces) {
			oldTraceFunction = haxe.Log.trace;
			haxe.Log.trace = this.trace;
		}
		suites = new Hash();
		counter = emptyGlobalCounter();
		println("TESTING ... ");
		println("");
	}

	public function execute(status : TestStatus) {
		if(!suites.exists(status.suiteName)) {
			suites.set(status.suiteName, new Hash());
			counter.suites++;
		}
		var suite = suites.get(status.suiteName);
		if(!suite.exists(status.className)) {
			suite.set(status.className, new Hash());
			counter.classes++;
		}
		var cls = suite.get(status.className);
		if(!cls.exists(status.methodName)) {
			cls.set(status.methodName, emptyMethodInfo());
			counter.methods++;
		}
		var method = cls.get(status.methodName);

		counter.assertations += status.assertations;
		method.async   = status.isAsync;
		method.success = status.success;

		for(r in status.iterator()) {
			switch(r) {
				case Success(_):
					counter.sucesses++;
					method.sucesses++;
				case Warning(m):
					counter.warnings++;
					method.warnings++;
					method.messages.push({
						type    : "W",
						message : m,
						pos     : null
					});
				case Failure(m, p):
					counter.failures++;
					method.failures++;
					method.messages.push({
						type    : "F",
						message : m,
						pos     : p
					});
				case Error(m):
					counter.errors++;
					method.errors++;
					method.messages.push({
						type    : "E",
						message : m,
						pos     : null
					});
			}
		}
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

	public function done() {
		println("GLOBAL INFORMATIONS");
		println("===================");
		println("suites:     " + counter.suites);
		println("classes:    " + counter.classes);
		println("methods:    " + counter.methods);
		println("assertions: " + counter.assertations);
		println("sucesses:   " + counter.sucesses);
		println("failures:   " + counter.failures);
		println("errors:     " + counter.errors);
		println("warnings:   " + counter.warnings);
		println("");

		for(suitename in suites.keys()) {
			println(suitename);
			var suite = suites.get(suitename);
			for(classname in suite.keys()) {
				println("  " + classname);
				var cls = suite.get(classname);
				for(methodname in cls.keys()) {
					var method = cls.get(methodname);
					var m = null;
					if(method.errors > 0) {
						m = "ERROR";
					} else if(method.failures == 1) {
						m = "FAILURE";
					} else if(method.failures > 0) {
						m = "FAILURES " + method.failures;
					} else if(method.warnings == 1) {
						m = "WARNING";
					} else if(method.warnings > 0) {
						m = "WARNINGS " + method.warnings;
					} else {
						m = "OK (asserts " + method.sucesses + ")";
					}
					println("    " + pad(m, 20, '.') + " " + methodname);
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

typedef GlobalCounter = {> Counter,
	suites  : Int,
	classes : Int,
	methods : Int
}

typedef MethodInfo = {> Counter,
	async    : Bool,
	success  : Bool,
	messages : Array<{
		type    : String,
		message : String,
		pos     : PosInfos
	}>
}