/**
* ...
* @author $(DefaultUser)
*/

package haxe.xunit;

class ObjectUtil {
	
	public static function isIterable(value):Bool {
		return ( Reflect.hasField(value, "iterator" ) );
	}
	public static function getClassNameByObject(value) {
		return (Type.getClassName(Type.getClass(value)));
	}
	
}