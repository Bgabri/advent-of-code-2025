using bglib.utils.PrimitiveTools;
using bglib.utils.Utils;

import bglib.utils.FilePath;

import Math.*;

private typedef Vec = {x:Int, y:Int};
private typedef Vec3 = {x:Int, y:Int, z:Int};
private typedef A<V> = Array<V>;
private typedef AA<V> = Array<Array<V>>;

// haxe build.hxml 04
private typedef Input = AA<String>;

class Day04 implements Day {
    var input:Input;

    public function new() {}

    function ns(x, y) {
        var n = 0;
        for (dy in -1...2) {
            for (dx in -1...2) {
                if (input[y + dy] == null) continue;
                if (input[y + dy][x + dx] == '@') n++;
            }
        }
        return n;
    }

    public function part1() {
        var total = 0;
        for (y => line in input) {
            for (x => v in line) {
                if (v == "@") continue;
                if (ns(x, y) < 4 + 1) total++;
            }
        }
        return total;
    }

    public function part2() {
        var tt = 0;
        var total = -1;
        while (total != 0) {
            total = 0;
            for (y => line in input) {
                for (x => v in line) {
                    if (v == "@" && ns(x, y) < 4 + 1) {
                        total++;
                        input[y][x] = '.';
                    }
                }
            }
            tt += total;
        }
        // input.prettyPrint();
        return tt;
    }

    public function loadFile(file:FilePath) {
        var inp = file.getContent();

        input = inp.split("\n").map((line) -> line.split(""));
        input = input.filter(v -> v.length != 0);

        return this;
    }
}
