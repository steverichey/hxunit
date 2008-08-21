/**
* ...
* @author $(DefaultUser)
*/

package haxe.xunit;


class TestWrapper {

	public var scope:Dynamic;
	public var test:Dynamic;
	public var name(getName,null):String;
	function getName():String {
		if (name == null) {
			return test;
		}return name;
	}
	public function new(test,?scope, ?name:String,?setup:Void->Void,?teardown:Void->Void) {
		this.scope = scope;
		this.test = test;
		this.name = name;
		this.setup = setup;
		this.teardown  = teardown;
	}
	
	public var setup:Void -> Void;
	public var teardown:Void -> Void;
}