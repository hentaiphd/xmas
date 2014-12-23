package
{
    import org.flixel.*;

    public class TextState extends TimedState{
        [Embed(source="../assets/new/zaguatica-Bold.otf", fontFamily="zaguatica-Bold", embedAsCFF="false")] public var GameFont:String;
        [Embed(source="../assets/glass.mp3")] private var GlassSound:Class;
        [Embed(source="../assets/new/brokenbulb.png")] private var BgImg:Class;
        [Embed(source="../assets/new/auxpuces.mp3")] private var ClockSound:Class;
        [Embed(source="../assets/new/leave.mp3")] private var LeaveSound:Class;

        public var _text:String;
        public var nextState:FlxState;
        public var ending:String;

        public function TextState(_text:String, end:String) {
            super();
            this._text = _text;
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
            }

            var t:FlxText;
            t = new FlxText(0,FlxG.height/2-10,FlxG.width,_text);
            t.setFormat("zaguatica-Bold",24,0xffffffff,"center");
            add(t);
        }

        override public function update():void
        {
            super.update();
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
