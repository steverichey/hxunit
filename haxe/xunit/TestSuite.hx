/**
* ...
* @author $(DefaultUser)
*/

package haxe.xunit;

import haxe.Log;

typedef Case = {
	var name :String;
	var content : TestContainer;
}
class TestSuite{

	var tests:Dynamic;
	
	var defaultCase:TestContainer;
	var cases:Array<Case>;
	
	public var current(default, null):Case;
	var index:Int;
	
	public var length(getLength, null):Int;
	
	public function getLength():Int {
		return Lambda.count(cases);
	}
	public function new() {
		unspecifiedNameCount = 0;
		cases = new Array();
		index = 0;
	}
	public function addCase(value:Dynamic):Void {
		Log.trace("addCase: ");
		
		
		var cl = Type.getClass(value);
		var fields:Array<Dynamic> = Type.getInstanceFields(cl);
		
		var setup:Dynamic = null;
		var teardown:Dynamic = null;
		//for flash9
		try {
			setup = Reflect.field(value, "setup");
		}catch (e:Dynamic){
			
		}
		try {
			teardown = Reflect.field(value, "teardown");
		}catch (e:Dynamic) {
			
		}
		var tests:TestContainer = new TestContainer(value, setup , teardown);
		//var tests:TestArray = new TestArray();
		//var tests:Array<TestWrapper> = new Array();
		
		for ( val in fields ) {
			if ( StringTools.startsWith(val, "test") && Reflect.isFunction(Reflect.field(value, val) )) {
				var wrap:TestWrapper = new TestWrapper(Reflect.field(value, val),null,val);
				tests.add( wrap );
			}
		}
		
		var c:Case = { name : ObjectUtil.getClassNameByObject(value) , content : tests };
		cases.push(c);
		
		//Log.trace(cases.length);
		
	}
	public function addTest(scope:Dynamic, method:Dynamic, ?testName:String, ?setup:Void->Void,?teardown:Void->Void):Void {
		
		testName = testName == null ? getNextDefaultTestName() : testName;
		
		if (defaultCase == null) {
			defaultCase = new DefaultTestCase(null,setup,teardown);
			
			var c:Case = { name : "DefaultTestCase", content : defaultCase };
			
			cases.push(c);
		}
		
		defaultCase.add(new TestWrapper(scope, method , testName));
		
	}
	var unspecifiedNameCount:Int;
	function getNextDefaultTestName():String {
		unspecifiedNameCount++;
		return "test#" + unspecifiedNameCount;
	}
	
	public function step(){
		current = cases.pop();
		index++;
	}
	public function hasNext() {
		return (cases.length > 0);
	}
}