using bglib.utils.PrimitiveTools;
using bglib.utils.Utils;

import bglib.utils.FilePath;

import Math.*;

private typedef Vec = {x:Int, y:Int};
private typedef Vec3 = {x:Int, y:Int, z:Int};
private typedef A<V> = Array<V>;
private typedef AA<V> = Array<Array<V>>;

// haxe build.hxml 01
private typedef Input = A<String>;

class Day01 implements Day {
    var input:Input;

    public function new() {}

    public function part1() {
        var total = 0;
        var rot = 50;
        for (line in input) {
            var n = Std.parseInt(line.substr(1));

            if (line.startsWith("L")) {
                rot -= n;
            } else {
                rot += n;
            }
            rot %= 100;
            if (rot == 0) total++;
        }
        return total;
    }

    public function part2() {
        var total = 0;
        var rot = 50;
        for (line in input) {
            var n = Std.parseInt(line.substr(1));
            if (line.startsWith("L")) {
                rot -= n;
                if (rot + n == 0) total += n.div(100);
                else if (rot <= 0) total += -rot.div(100) + 1;
            } else {
                rot += n;
                total += rot.div(100);
            }

            rot %= 100;
            rot = (rot + 100) % 100;
        }
        return total;
    }

    public function loadFile(file:FilePath) {
        var inp = file.getContent();

        input = inp.split("\n");
        input = input.filter(v -> v.length != 0);

        return this;
    }
}
