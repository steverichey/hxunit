package hxunit;

enum Status {
	success;
	warning;
	error;
	failure;
}

class Result {

	public var status:Status;
	public var suiteName:String;
	public var className:String;
	public var methodName:String;
	public var errors(default, null):Array<TestError>;

	public function new() {
		errors = new Array();
	}

	public function addError(value:TestError) {
		errors.push(value);
	}
	public function hasErrors() {
		return ( errors.length > 0 );
	}

	public function toString() {
		var buf = new StringBuf();
		var suiteArray = suiteName.split(".");
		buf.add(suiteArray.pop());
		buf.add(" ");
		var classArray = className.split(".");
		buf.add(classArray.pop());
		buf.add(".");
		buf.add(methodName);
		buf.add(" ");

		if (hasErrors()) {
			for(error in errors)
				buf.add(error.toString());
		}else {
			buf.add("S");
		}
		return buf.toString();
	}

}