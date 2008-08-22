package hxunit;

class TestWrapper {
	public var scope    : Dynamic;
	public var test     : Void->Void;
	public var setup    : Void -> Void;
	public var teardown : Void -> Void;
	public var name     : String;

	public function new(scope : Dynamic, test : Void->Void, name : String, setup : Void->Void, teardown : Void->Void) {
		this.scope    = scope;
		this.test     = test;
		this.name     = name;
		this.setup    = setup;
		this.teardown = teardown;
	}
}