package hxunit;

class TestWrapper {
	public var scope : Dynamic;
	public var test  : Dynamic;
	public var name  : String;

	public function new(test, ?scope, ?name : String, ?setup : Void->Void, ?teardown : Void -> Void) {
		this.scope    = scope;
		this.test     = test;
		this.name     = name == null ? Std.string(test) : name;
		this.setup    = setup;
		this.teardown = teardown;
	}

	public var setup    : Void -> Void;
	public var teardown : Void -> Void;
}