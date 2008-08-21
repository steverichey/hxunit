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
		var buf = "";
		var suiteArray = suiteName.split(".");
		buf += suiteArray.pop();
		buf += " ";
		var classArray = className.split(".");
		buf += classArray.pop();
		buf += ".";
		buf += methodName;
		buf += " ";

		if (hasErrors()) {
			buf += errors.toString();
		}else {
			buf += "S";
		}
		return buf;
	}

}