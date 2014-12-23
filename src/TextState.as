package
{
    import org.flixel.*;

    public class TextState extends TimedState{
        [Embed(source="../assets/new/zaguatica-Bold.otf", fontFamily="zaguatica-Bold", embedAsCFF="false")] public var GameFont:String;
        [Embed(source="../assets/glass.mp3")] private var GlassSound:Class;
        [Embed(source="../assets/new/brokenbulb.png")] private var BgImg:Class;
        [Embed(source="../assets/new/auxpuces.mp3")] private var ClockSound:Class;
        [Embed(source="../assets/new/leave.mp3")] private var LeaveSound:Class;

        public var nextState:FlxState;
        public var ending:String;
        public var end_text:FlxText;

        public function TextState(e_text:String, end:String) {
            super();
            end_text = new FlxText(0,FlxG.height/2-10,FlxG.width,e_text);
            end_text.setFormat("zaguatica-Bold",24,0xffffffff,"center");
            add(end_text);
            //this.nextState = next;
            ending = end;
            FlxG.bgColor = 0xff000000;
        }

        override public function create():void
        {
            endTime = 4;

            if(ending == "end 1"){
                FlxG.music.stop();
                FlxG.play(GlassSound);
            } else if(ending == "end 2") {
                var bg:FlxSprite = new FlxSprite(0,0);
                bg.loadGraphic(BgImg,false,false,640,480);
                FlxG.state.add(bg);
            } else if(ending == "nope") {
                if(FlxG.music == null){
                FlxG.playMusic(ClockSound);
                } else {
                    FlxG.music.resume();
                    if(!FlxG.music.active){
                        FlxG.playMusic(ClockSound);
                    }
                }
            } else if(ending == "end 3") {
                FlxG.play(LeaveSound);
                endTime = 8;
                if(timeSec == 4) {
                    end_text.visible = false;
                }
            }
        }

        override public function update():void
        {
            super.update();
            if(ending == "end 3") {
                if(timeSec == 4) {
                    end_text.visible = false;
                }
            }
        }

        override public function endCallback():void {
            if(ending == "end 1"){
                FlxG.switchState(new TextState("","end 2"));
            } else if (ending == "end 2"){
                FlxG.switchState(new TextState("We're leaving. Get in the car, honey.", "end 3"));
            } else if(ending == "end 3") {
                FlxG.switchState(new MenuState());
            } else if(ending == "nope"){
                FlxG.switchState(new PlayState());
            }

        }
    }
}
