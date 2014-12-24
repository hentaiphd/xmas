package{
    import org.flixel.*;

    public class MenuState extends FlxState{
        [Embed(source="../assets/new/zaguatica-Bold.otf", fontFamily="zaguatica-Bold", embedAsCFF="false")] public var GameFont:String;
        [Embed(source="../assets/new/TITLE_A.png")] private var ImgBg1:Class;
        [Embed(source="../assets/new/snow.png")] private var ImgSnow:Class;

        public var bg1:FlxSprite;
        public var snow:FlxSprite;
        public var snow2:FlxSprite;
        public var snow_group:FlxGroup;

        override public function create():void{
            FlxG.mouse.hide();

            bg1 = new FlxSprite(0,0);
            bg1.loadGraphic(ImgBg1,false,false,640,480);
            FlxG.state.add(bg1);

            snow_group = new FlxGroup();

            snow = new FlxSprite(0,0);
            snow.loadGraphic(ImgSnow,false,false,573,850);
            FlxG.state.add(snow);
            snow_group.add(snow);

            snow2 = new FlxSprite(0,-850);
            snow2.loadGraphic(ImgSnow,false,false,573,850);
            FlxG.state.add(snow2);
            snow_group.add(snow2);
        }

        override public function update():void{
            super.update();

            for(var i:Number = 0; i < snow_group.length; i++) {
                snow_group.members[i].y += 1;
                if(snow_group.members[i].y >= 480) {
                    snow_group.members[i].y = -850;
                }
            }

            if(FlxG.mouse.pressed()){
                FlxG.switchState(new TextState("Honey, take this confetti\nand stuff the empty Christmas bulbs.", "nope", [new FlxPoint(snow.x,snow.y), new FlxPoint(snow2.x,snow2.y)]));
            }
        }

    }
}
