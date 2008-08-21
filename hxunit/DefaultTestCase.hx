package hxunit;

class DefaultTestCase extends TestContainer {
	public function new(scope:Dynamic,?setup:Void->Void,?teardown:Void->Void) {
		super(scope,setup,teardown);
	}
}