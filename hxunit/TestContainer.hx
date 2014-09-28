package hxunit;

class TestContainer {
	var contents : List<TestWrapper>;
	public var scope(default, null)    : Dynamic;
	public var setup(default, null)    : String;
	public var teardown(default, null) : String;

	public function new(scope : Dynamic, ?setup : String, ?teardown : String) {
		contents = new List();
		this.scope = scope;
		this.setup = setup;
		this.teardown = teardown;
	}

	public function add(value) {
		contents.push(value);
	}

	public var length(get, null) : Int;
	function get_length() {
		return contents.length;
	}

	public function iterator() : Iterator<TestWrapper> {
		return contents.iterator();
	}
}