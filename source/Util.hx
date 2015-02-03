
package ;

class Util 
{

    private function new() { }

    static public inline function sign(i:Float) {
        return (i > 0) ? 1 : ((i < 0) ? -1 : 0);
    }

}
