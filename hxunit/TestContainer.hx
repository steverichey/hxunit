package hxunit;

class TestContainer {
	var contents : List<TestWrapper>;
	public var scope(default, null)    : Dynamic;
	public var setup(default, null)    : Void->Void;
	public var teardown(default, null) : Void->Void;

	public function new(scope : Dynamic, ?setup : Void->Void, ?teardown : Void->Void) {
		contents = new List();
		this.scope = scope;
		this.setup = setup;
		this.teardown = teardown;
	}

	public function add(value) {
		contents.push(value);
	}

	public var length(getLength, null) : Int;
	function getLength() {
		return contents.length;
	}

	public function iterator() : Iterator<TestWrapper> {
		return contents.iterator();
	}
}