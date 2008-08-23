package hxunit;

class TestWrapper {
	public var scope    : Dynamic;
	public var test     : String;
	public var setup    : String;
	public var teardown : String;
	public var name     : String;

	public function new(scope : Dynamic, test : String, name : String, setup : String, teardown : String) {
		this.scope    = scope;
		this.test     = test;
		this.name     = name;
		this.setup    = setup;
		this.teardown = teardown;
	}
}