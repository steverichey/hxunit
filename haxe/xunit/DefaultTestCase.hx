/**
* ...
* @author $(DefaultUser)
*/

package haxe.xunit;

class DefaultTestCase extends TestContainer {
	public function new(scope:Dynamic,?setup:Void->Void,?teardown:Void->Void) {
		super(scope,setup,teardown);
	}
}