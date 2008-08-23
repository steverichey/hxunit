/**
* ...
* @author $(DefaultUser)
*/

package test;
import hxunit.TestSuite;

class FrameworkSuite extends TestSuite {

	public function new() {
		super();
		addCase(new SuccessTest());
		//addCase(new TimeoutTest());
		addCase(new AssertTest());
	}

	
}