package{
    import org.flixel.*;

    public class MenuState extends FlxState{
        [Embed(source="../assets/new/zaguatica-Bold.otf", fontFamily="zaguatica-Bold", embedAsCFF="false")] public var GameFont:String;
        [Embed(source="../assets/new/TITLE_A.png")] private var ImgBg1:Class;

        public var bg1:FlxSprite;

        override public function create():void{
            FlxG.mouse.hide();

            bg1 = new FlxSprite(0,0);
            bg1.loadGraphic(ImgBg1,false,false,640,480);
            FlxG.state.add(bg1);
        }

        override public function update():void{
            super.update();

            if(FlxG.mouse.pressed()){
                FlxG.switchState(new TextState("Honey, take this confetti\nand stuff the empty Christmas bulbs.", "nope"));
            }
        }

    }
}
