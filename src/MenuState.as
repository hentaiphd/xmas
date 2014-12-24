package{
    import org.flixel.*;

    public class MenuState extends FlxState{
        [Embed(source="../assets/new/zaguatica-Bold.otf", fontFamily="zaguatica-Bold", embedAsCFF="false")] public var GameFont:String;
        [Embed(source="../assets/new/TITLE_A.png")] private var ImgBg1:Class;
        [Embed(source="../assets/new/snow.png")] private var ImgSnow:Class;
        [Embed(source="../assets/new/finale.png")] private var ImgEnd:Class;

        public var bg1:FlxSprite;
        public var snow:FlxSprite;
        public var snow2:FlxSprite;
        public var snow_group:FlxGroup;
        public var snow_pos:Array;

        public var end_bg:FlxSprite = null;

        public function MenuState(from_end:Boolean = false, snowpos:Array=null):void {
            FlxG.music = null;
            if(from_end) {
                end_bg = new FlxSprite(0,0);
                end_bg.loadGraphic(ImgEnd,false,false,640,767);
            }
            if(snowpos != null) {
                snow_pos = snowpos;
            }
        }

        override public function create():void{
            FlxG.mouse.hide();

            bg1 = new FlxSprite(0,0);
            bg1.loadGraphic(ImgBg1,false,false,640,480);
            FlxG.state.add(bg1);

            var s1pos:FlxPoint;
            var s2pos:FlxPoint;
            if(end_bg != null && snow_pos != null) {
                FlxG.state.add(end_bg);
                end_bg.y = end_bg.y - 287;
                s1pos = new FlxPoint(snow_pos[0].x,snow_pos[0].y);
                s2pos = new FlxPoint(snow_pos[1].x,snow_pos[1].y);
            } else {
                s1pos = new FlxPoint(0,0);
                s2pos = new FlxPoint(0,-850);
            }

            snow_group = new FlxGroup();

            snow = new FlxSprite(s1pos.x,s1pos.y);
            snow.loadGraphic(ImgSnow,false,false,573,850);
            FlxG.state.add(snow);
            snow_group.add(snow);

            snow2 = new FlxSprite(s2pos.x,s2pos.y);
            snow2.loadGraphic(ImgSnow,false,false,573,850);
            FlxG.state.add(snow2);
            snow_group.add(snow2);
        }

        override public function update():void{
            super.update();

            if(end_bg != null && end_bg.visible) {
                end_bg.alpha -= .01;
                if(end_bg.alpha <= 0) {
                    end_bg.visible = false;
                }
            }

            for(var i:Number = 0; i < snow_group.length; i++) {
                snow_group.members[i].y += 1;
                if(snow_group.members[i].y >= 480) {
                    snow_group.members[i].y = -850;
                }
            }

            if(FlxG.mouse.pressed()){
                FlxG.switchState(new OpeningState("Honey, take this confetti\nand stuff the empty Christmas bulbs.", [new FlxPoint(snow.x,snow.y), new FlxPoint(snow2.x,snow2.y)]));
            }
        }

    }
}
