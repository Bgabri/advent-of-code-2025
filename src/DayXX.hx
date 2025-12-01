using bglib.utils.PrimitiveTools;
using bglib.utils.Utils;

import bglib.utils.FilePath;

import Math.*;

private typedef Vec = {x:Int, y:Int};
private typedef Vec3 = {x:Int, y:Int, z:Int};
private typedef A<V> = Array<V>;
private typedef AA<V> = Array<Array<V>>;

// haxe build.hxml XX
private typedef Input = AA<Int>;

class DayXX implements Day {
    var input:Input;

    public function new() {}

    public function part1() {
        var total = 0;
        input.prettyPrint();
        return total;
    }

    public function part2() {
        var total = 0;
        return total;
    }

    public function loadFile(file:FilePath) {
        var inp = file.getContent();

        // input = inp.split("\n").map((line) -> line.split(""));
        input = inp.split("\n").map((line) -> line.split("").map(Std.parseInt));
        input = input.filter(v -> v.length != 0);

        return this;
    }
}
