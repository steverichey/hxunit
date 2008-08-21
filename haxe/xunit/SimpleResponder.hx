/**
* ...
* @author $(DefaultUser)
*/

package haxe.xunit;
import haxe.Log;

class SimpleResponder implements Responder{

	public function new() {
		
	}
	
	public function execute(value:Result):Void {
		trace(value);
	}
}