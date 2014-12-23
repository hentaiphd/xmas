package{
    import org.flixel.*;

    public class MenuState extends FlxState{
        [Embed(source="../assets/new/zaguatica-Bold.otf", fontFamily="zaguatica-Bold", embedAsCFF="false")] public var GameFont:String;

        override public function create():void{
            FlxG.mouse.hide();

            var t1:FlxText;
            t1 = new FlxText(20,140,FlxG.width/2,"");
            add(t1);

            var t2:FlxText;
            t2 = new FlxText(0,220,FlxG.width,"Click to play.");
            t2.setFormat("zaguatica-Bold",24,0xffffffff,"center");
            add(t2);
        }

        override public function update():void{
            super.update();

            FlxG.collide();

            if(FlxG.mouse.pressed()){
                FlxG.switchState(new TextState("Honey, take this confetti and stuff the empty Christmas bulbs.", "nope"));
            }
        }

    }
}
