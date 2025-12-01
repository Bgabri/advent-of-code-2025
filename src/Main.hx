import haxe.Timer;
import haxe.macro.Expr;

import bglib.utils.FilePath;

using bglib.utils.PrimitiveTools;

class Main {
    static var year = 2025;
    static var srcPath:FilePath = "./src";
    static var inputsPath:FilePath = "./inputs";

    var day:String;

    public function new(?day:Int, all:Bool = false) {
        if (day == null) day = Date.now().getDate();
        if (day < 1) day = 1;
        if (day > 25) day = 25;
        this.day = '$day';
        if (day < 10) this.day = '0$day';
        var days:Array<Day> = loadClasses();
        if (all) {
            for (i in 0...days.length) {
                if (days[i] == null) continue;
                var strDay = '${i + 1}';
                if (i < 9) strDay = '0${i + 1}';
                runDay(strDay, days[i]);
                Sys.println("");
            }
        } else {
            if (days[day - 1] == null) {
                Sys.println('\x1b[31mday ($day) does not exist\x1b[0m');
                Sys.println('initializing...');
                initDay(day);
                Sys.exit(1);
            }
            runDay(this.day, days[day - 1]);
        }
    }

    function runDay(day:String, prog:Day) {
        var inputFile:FilePath = inputsPath + '${day}.txt';
        if (!inputFile.exists()) {
            Main.downloadInput(Std.parseInt(day), inputFile);
        }

        Sys.println("─".repeat(15));

        var before = Timer.stamp();
        var part1 = prog.loadFile(inputFile).part1();
        var after = Timer.stamp();

        Sys.println('day ${day} part 1: \x1b[1m\x1b[33m$part1\x1b[0m');
        printTiming(before, after);

        Sys.println("─".repeat(15));

        var before = Timer.stamp();
        var part2 = prog.loadFile(inputFile).part2();
        var after = Timer.stamp();

        Sys.println('day ${day} part 2: \x1b[1m\x1b[33m$part2\x1b[0m');
        printTiming(before, after);

        Sys.println("─".repeat(15));
    }

    function printTiming(before:Float, after:Float) {
        var diff = after - before;
        diff = Math.round(diff * 100) / 100;
        var colour = "\x1b[2m";
        if (diff >= 10) {
            colour = "\x1b[1m\x1b[31m"; // bold red
        } else if (diff >= 1) {
            colour = "\x1b[31m"; // red
        } else if (diff > 0.1) {
            colour = "\x1b[33m"; // yellow
        }
        Sys.println(colour + '[${diff}s]\x1b[0m');
    }

    static macro function loadClasses():haxe.macro.Expr {
        var ret:Array<Expr> = [for (i in 0...25) (macro null)];
        var files = loadFiles();

        for (file in files) {
            var name = file.file;
            var path:haxe.macro.TypePath = {pack: [], name: name};
            var fileday = Std.parseInt(name.substring(3));
            ret[fileday - 1] = macro new $path();
        }
        return macro $a{ret};
    }

    static function loadFiles():Array<FilePath> {
        var todayExists = false;
        var today = Date.now().getDate();
        if (today > 25) today = 25;

        var regex = ~/^.*\/Day(\d{2}).hx$/;
        var classPaths:Array<FilePath> = [];
        for (file in srcPath.readDirectory()) {
            if (file.isDirectory()) continue;
            if (!regex.match(file)) continue;
            var day = Std.parseInt(regex.matched(1));
            classPaths.push(file);
            if (day == today) todayExists = true;
        }
        if (!todayExists) initDay(today);
        return classPaths;
    }

    static function initDay(day:Int) {
        if (day > 25) day = 25;
        var strDay = '${day}';
        if (day < 10) strDay = '0$day';
        var dayPath = srcPath + 'Day$strDay.hx';

        var regex = ~/XX/;
        var template = srcPath + "DayXX.hx";
        var s = template.getContent();
        while (regex.match(s)) {
            s = regex.replace(s, strDay);
        }

        var inputPath:FilePath = inputsPath + '$strDay.txt';
        dayPath.saveContent(s);
        inputPath.saveContent("");
        downloadInput(day, inputPath);
    }

    static function downloadInput(day:Int, file:FilePath) {
        Sys.println('downloading day $day input');
        var userAgent:FilePath = "./user-agent.txt";
        var cookie:FilePath = "./cookie.txt";

        var http = new sys.Http(
            'https://adventofcode.com/$year/day/$day/input'
        );
        trace(http.url);
        http.addHeader("User-Agent", userAgent.getContent());
        http.addHeader("Cookie", cookie.getContent());
        http.onData = data -> {
            data = data.substr(0, data.length - 1); // remove trailing newline
            file.saveContent(data);
        }
        http.onError = error -> throw 'HTTP error: $error';
        http.request();
        Sys.println('\x1b[A\x1b[2Kdownloaded day $day input');
    }

    static function main() {
        var args = Sys.args();
        if (args.length > 0) {
            if (args[0] == "all") new Main(0, true);
            else new Main(Std.parseInt(args[0]));
        } else {
            new Main();
        }
    }
}
